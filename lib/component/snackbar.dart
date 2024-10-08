import 'package:flutter/material.dart';

class MySnackBar extends StatelessWidget {
  final Widget? prefix;
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  const MySnackBar({
    super.key,
    this.prefix,
    required this.message,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // return a custom snackbar with prefix widget (icon, image, etc)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // prefix widget
          if (prefix != null) prefix!,

          // space between prefix and message
          if (prefix != null) const SizedBox(width: 10),

          // message
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: textColor ?? Theme.of(context).colorScheme.surface,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
