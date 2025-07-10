import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/colors.dart';

class CustomButton extends StatelessWidget {
  final String? text; // Static text (optional)
  final String? textKey; // Translation key for button text
  final VoidCallback? onPressed;
  final String? semanticsLabelKey; // Translation key for semantics
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isEnabled;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.text,
    this.textKey,
    this.onPressed,
    this.semanticsLabelKey,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use translation key if provided, otherwise fall back to static text
    final String buttonText = textKey != null ? textKey!.tr : text ?? '';
    final String? semantics = semanticsLabelKey != null ? semanticsLabelKey!.tr : null;

    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? backgroundColor ?? AppColors.orange
            : disabledColor ?? AppColors.olive.withOpacity(0.3),
        foregroundColor: textColor ?? AppColors.dark,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: isEnabled
                ? backgroundColor ?? AppColors.brown
                : AppColors.olive.withOpacity(0.3),
            width: borderWidth,
          ),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  buttonText,
                  style: textStyle ??
                      TextStyle(
                        color: textColor ?? AppColors.dark,
                        fontWeight: FontWeight.bold,
                      ),
                  semanticsLabel: semantics,
                ),
                if (suffixIcon != null) ...[
                  const SizedBox(width: 8),
                  suffixIcon!,
                ],
              ],
            ),
    );
  }
}