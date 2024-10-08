import 'dart:async';
import 'dart:io';

import 'package:bai_system/api/model/bai_model/bai_model.dart';
import 'package:bai_system/api/service/bai_be/bai_service.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/representation/login.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/api_response.dart';
import '../component/app_bar_component.dart';
import '../component/dialog.dart';
import '../component/internet_connection_wrapper.dart';
import '../component/response_handler.dart';
import '../component/shadow_button.dart';
import '../component/snackbar.dart';
import '../core/const/frontend/message.dart';
import '../core/const/utilities/regex.dart';
import '../core/helper/loading_overlay_helper.dart';

class AddBai extends StatefulWidget {
  static const String routeName = '/addBai';

  const AddBai({super.key});

  @override
  State<AddBai> createState() => _AddBaiState();
}

class _AddBaiState extends State<AddBai> with ApiResponseHandler {
  final Logger _log = Logger();
  String? _imageUrl;
  String? _selectedVehicleTypeId;
  final TextEditingController _plateNumberController = TextEditingController();
  final _overlayHelper = LoadingOverlayHelper();
  final CallBikeApi _api = CallBikeApi();
  List<VehicleTypeModel> _vehicleTypes = [];
  String? _errorMessage;

  final FocusNode _focusNode = FocusNode();

  late Color _backgroundColor;
  late Color _onSuccessful;

  @override
  void initState() {
    super.initState();
    _log.i('AddBai widget initialized');
    _fetchVehicleType();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backgroundColor = Theme.of(context).colorScheme.surface;
    _onSuccessful = Theme.of(context).colorScheme.onError;
  }

  Future<void> _fetchVehicleType() async {
    try {
      APIResponse<List<VehicleTypeModel>> vehicleTypes =
          await _api.getVehicleType();

      if (vehicleTypes.data == null && vehicleTypes.message != null) {
        _showErrorDialog(
            vehicleTypes.message ?? ErrorMessage.somethingWentWrong);

        return;
      }

      if (mounted) {
        setState(() {
          _vehicleTypes = vehicleTypes.data!;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to load vehicle types. Please try again.');
      _log.e('Error fetching vehicle type: $e');
    }
  }

  Future<void> _selectImage({String? subTitle}) async {
    try {
      setState(() {
        _errorMessage = null;
      });

      final ImageSource? source = await _showSourceDialog(subTitle: subTitle);
      if (source == null) return;

      final XFile? imageFile = await ImagePicker().pickImage(source: source);
      if (imageFile == null) return;

      final String imagePath = imageFile.path;
      if (mounted) {
        setState(() {
          _imageUrl = imagePath;
          _plateNumberController.clear();
        });
      }

      _log.i('Image successfully picked: $_imageUrl');

      await _detectPlateNumber(File(imagePath));
    } catch (e) {
      _log.e('Error picking image: $e');
      _showErrorDialog('Failed to select image. Please try again.');
    }
  }

  Future<void> _detectPlateNumber(File imageFile) async {
    try {
      _overlayHelper.show(context);

      final PlateNumberResponse? plateNumberResponse =
          await _api.detectPlateNumber(imageFile);

      _overlayHelper.hide();

      if (plateNumberResponse?.data?.plateNumber != null) {
        if (mounted) {
          setState(() {
            _plateNumberController.text =
                plateNumberResponse!.data!.plateNumber;

            _focusNode.unfocus();
            _onTextFieldDone();
          });
        }
      } else {
        _log.e('Failed to detect plate number');
        setState(() {
          _errorMessage =
              'Failed to detect plate number from image, please enter manually!';
        });
      }
    } catch (e) {
      _overlayHelper.hide();
      _log.e('Error detecting plate number: $e');
      setState(() {
        _errorMessage =
            'Failed to detect plate number from image, please enter manually!';
      });
    }
  }

  Future<void> _saveVehicleRegistration() async {
    if (_imageUrl == null ||
        _selectedVehicleTypeId == null ||
        _plateNumberController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all required fields';
      });

      return;
    }

    try {
      final addBaiModel = AddBaiModel(
        plateNumber: _plateNumberController.text,
        plateImage: File(_imageUrl!),
        vehicleTypeId: _selectedVehicleTypeId!,
      );

      _log.d('Saving vehicle registration: $addBaiModel');
      _overlayHelper.show(context);
      final APIResponse<AddBaiRespModel> result =
          await _api.createBai(addBaiModel);
      _overlayHelper.hide();

      if (result.statusCode == 409) {
        _clearAllInputFields();
      }

      if (!mounted) return;
      final String? errorMessage = await handleApiResponse(
        context: context,
        response: result,
      );

      if (errorMessage != null) {
        if (errorMessage == ApiResponseHandler.invalidToken) {
          _goToPage(LoginScreen.routeName);
          _showSnackBar(
            message: ErrorMessage.tokenInvalid,
            isSuccessful: false,
          );
        }

        setState(() {
          _errorMessage = errorMessage;
        });

        return;
      }

      _showSuccessSnackBar(Message.actionSuccessfully(
          action: LabelMessage.add(message: ListName.bai)));

      _goToPage(MyNavigationBar.routeName, index: 1);
    } catch (e) {
      _showErrorDialog(ErrorMessage.somethingWentWrong);

      _log.e('Error saving vehicle registration: $e');
    }
  }

  void _clearAllInputFields() {
    if (mounted) {
      setState(() {
        _imageUrl = null;
        _selectedVehicleTypeId = null;
        _plateNumberController.clear();
      });
    }
  }

  Future<ImageSource?> _showSourceDialog({String? subTitle}) async {
    return showDialog<ImageSource?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text('Choose image source'),
              if (subTitle != null) const SizedBox(height: 10),
              if (subTitle != null)
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
            ],
          ),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera,
                  color: Theme.of(context).colorScheme.outline,
                ),
                title: Text(
                  'Camera',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_album,
                  color: Theme.of(context).colorScheme.outline,
                ),
                title: Text(
                  'Gallery',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    _showCustomSnackBar(
      MySnackBar(
        prefix: Icon(
          Icons.check_circle_rounded,
          color: _backgroundColor,
        ),
        message: message,
        backgroundColor: _onSuccessful,
      ),
    );
  }

  void _showCustomSnackBar(MySnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: ErrorMessage.error,
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }

  void _goToPage(String routeName, {int? index}) {
    Navigator.of(context).pushReplacementNamed(
      routeName,
      arguments: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: const MyAppBar(
          automaticallyImplyLeading: true,
          title: 'Add Bike',
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 25),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePicker(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    _buildVehicleTypeDropdown(),
                    const SizedBox(height: 20),
                    _buildPlateNumberInput(),
                    const SizedBox(height: 20),
                    _buildAddButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _selectImage,
      child: ShadowContainer(
        padding: const EdgeInsets.all(0),
        color: Theme.of(context).colorScheme.outlineVariant,
        height: MediaQuery.of(context).size.height * 0.35,
        child: _imageUrl == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 50,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Upload your vehicle image\nrequired*',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  File(_imageUrl!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
      ),
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type*',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 5),
        ShadowContainer(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.065,
          child: DropdownButton<String>(
            hint: Text(
              'Select vehicle type',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: _selectedVehicleTypeId,
            items: _vehicleTypes.map((VehicleTypeModel vehicleType) {
              return DropdownMenuItem<String>(
                value: vehicleType.id,
                child: Text(
                  vehicleType.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (mounted) {
                setState(() {
                  _selectedVehicleTypeId = newValue;
                });
              }
              _log.i('Selected vehicle type: $newValue');
            },
            isExpanded: true,
            underline: Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlateNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plate Number*',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 5),
        ShadowContainer(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.065,
          child: TextField(
            controller: _plateNumberController,
            focusNode: _focusNode,
            readOnly: _imageUrl == null,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autofocus: false,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              // FilteringTextInputFormatter.allow(Regex.plateRegExp),
              UpperCaseTextFormatter(),
            ],
            onTap: _imageUrl == null
                ? () => setState(() {
                      _errorMessage = 'Please select image first';
                    })
                : null,
            onSubmitted: (String value) {
              _onTextFieldDone();
            },
            onChanged: (value) {
              if (!_focusNode.hasFocus) {
                Timer(const Duration(milliseconds: 100), () {
                  _onTextFieldDone();
                });
              }
            },
            style: Theme.of(context).textTheme.bodyMedium,
            maxLength: 10,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.edit_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              hintText: 'ex: 37A012345',
              counterText: '', // disable character counter
            ),
          ),
        )
      ],
    );
  }

  void _onTextFieldDone() {
    {
      String currentValue = _plateNumberController.text
          .trim()
          .replaceAll('-', '')
          .replaceAll('.', '')
          .replaceAll(' ', '');

      _log.i('Plate number: $currentValue');

      if (mounted) {
        setState(() {
          _plateNumberController.text = currentValue;
          _errorMessage = Regex.plateRegExp.hasMatch(currentValue)
              ? null
              : 'Invalid plate number';
        });
        FocusScope.of(context).unfocus();
      }
    }
  }

  Widget _buildAddButton() {
    return Column(
      children: [
        Visibility(
          visible: _errorMessage != null,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              _errorMessage ?? '',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              'By tapping ADD you agree to submit request new bike to your account.',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        GestureDetector(
          onTap: _saveVehicleRegistration,
          child: const ShadowButton(
            buttonTitle: 'ADD',
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 0),
            height: 50,
            width: 100,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _overlayHelper.dispose();
    super.dispose();
  }

  void _showSnackBar({required String message, required bool isSuccessful}) {
    Color background = Theme.of(context).colorScheme.surface;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          prefix: isSuccessful
              ? Icon(
                  Icons.check_circle_rounded,
                  color: background,
                )
              : Icon(
                  Icons.cancel_rounded,
                  color: background,
                ),
          message: message,
          backgroundColor: isSuccessful
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.error,
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toUpperCase();

    int selectionOffset = newValue.selection.baseOffset;

    if (newText.length < oldValue.text.length) {
      selectionOffset = newValue.selection.baseOffset;
    } else {
      int oldLength = oldValue.text.length;
      int addedLength = newText.length - oldLength;
      selectionOffset = oldValue.selection.baseOffset + addedLength;
    }

    selectionOffset = selectionOffset.clamp(0, newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }
}
