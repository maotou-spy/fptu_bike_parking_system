import 'package:flutter/material.dart';

class ShadowButton extends StatelessWidget {
  final String buttonTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final AlignmentGeometry? alignment;

  const ShadowButton({
    /// A button widget that wraps a child with a shadow effect.
    /// made by [3mallrice] with ❤️.
    super.key,

    ///title for button
    required this.buttonTitle,

    ///color for title
    this.titleColor,
    this.textStyle,

    ///background color for button
    this.backgroundColor,

    ///size, padding, margin and borderRadius for button
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.center,
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 5),
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        buttonTitle,
        style: textStyle ??
            Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: titleColor ?? Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.bold,
                ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
