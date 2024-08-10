import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/history_model.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

import '../../../core/const/frondend/message.dart';
import 'api_root.dart';

class CallHistoryAPI {
  static const apiName = '/session';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // GET: /api/session/history
  // Get all user's history
  Future<APIResponse<List<HistoryModel>>> getCustomerHistories() async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: 'Token is empty',
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse('$api/history'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        APIResponse<List<HistoryModel>> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => (json as List)
              .map(
                  (item) => HistoryModel.fromJson(item as Map<String, dynamic>))
              .toList(),
        );

        return apiResponse;
      } else {
        log.e('Failed to get customer histories: ${response.statusCode}');
        return APIResponse(
          message: '${ErrorMessage.somethingWentWrong}: ${response.statusCode}',
        );
      }
    } catch (e) {
      log.e('Error during get customer histories: $e');
    }
    return APIResponse(
      message: 'Error during get customer histories',
    );
  }
}
