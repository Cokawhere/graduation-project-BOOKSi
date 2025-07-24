import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText; // Static text (optional)
  final String? hintTextKey; // Translation key for hint
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? semanticsLabelKey; // Translation key for semantics
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isEnabled;
  final String? errorText; // Static error text (optional)
  final String? errorTextKey; // Translation key for error
  final TextInputType? keyboardType;
  final bool obscureText;

  const CustomTextField({
    super.key,
    this.hintText,
    this.hintTextKey,
    required this.controller,
    this.onChanged,
    this.validator,
    this.semanticsLabelKey,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.hintColor,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.margin,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.isEnabled = true,
    this.errorText,
    this.errorTextKey,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use translation key if provided, otherwise fall back to static text
    final String hint = hintTextKey != null ? hintTextKey!.tr : hintText ?? '';
    final String? error = errorTextKey != null ? errorTextKey!.tr : errorText;
    final String? semantics = semanticsLabelKey?.tr;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: Semantics(
        label: semantics, // Use Semantics for accessibility
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator != null
              ? (value) => validator!(value)?.tr
              : null,
          enabled: isEnabled,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: textStyle ?? TextStyle(color: textColor ?? AppColors.dark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: hintColor ?? AppColors.teaMilk),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: error != null
                    ? Colors.red
                    : borderColor ?? AppColors.brown,
                width: borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: error != null
                    ? Colors.red
                    : borderColor ?? AppColors.brown,
                width: borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.brown,
                width: borderWidth + 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: AppColors.olive.withOpacity(0.5),
                width: borderWidth,
              ),
            ),
            filled: true,
            fillColor: isEnabled
                ? backgroundColor ?? AppColors.background
                : AppColors.olive.withOpacity(0.3),
            contentPadding: padding,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: error,
            errorStyle: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
