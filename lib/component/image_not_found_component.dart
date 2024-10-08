import 'package:bai_system/core/const/frontend/message.dart';
import 'package:flutter/material.dart';

class ImageNotFound extends StatelessWidget {
  const ImageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.outlineVariant,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_rounded,
              size: 60,
              color: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              ErrorMessage.imageNotFound,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
