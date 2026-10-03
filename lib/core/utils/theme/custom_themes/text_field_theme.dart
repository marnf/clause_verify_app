import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static InputDecorationTheme _baseInputDecorationTheme({
    required Color labelColor,
    required Color hintColor,
    required Color errorColor,
    required Color focusedErrorColor,
    required Color prefixIconColor,
    required Color suffixIconColor,
    required Color borderColor,
    required Color enabledBorderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
    required Color focusedErrorBorderColor,
  }) {
    return InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: prefixIconColor,
      suffixIconColor: suffixIconColor,
      labelStyle: TextStyle(fontSize: 14, color: labelColor),
      hintStyle: TextStyle(fontSize: 14, color: hintColor),
      errorStyle: TextStyle(fontSize: 12, color: errorColor),
      floatingLabelStyle: TextStyle(color: labelColor.withValues(alpha: 0.8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: enabledBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusedBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusedErrorBorderColor),
      ),
    );
  }

  static final InputDecorationTheme lightInputDecorationTheme =
      _baseInputDecorationTheme(
    labelColor: AppColors.white,
    hintColor: AppColors.textMuted,
    errorColor: AppColors.error,
    focusedErrorColor: AppColors.error,
    prefixIconColor: AppColors.textMuted,
    suffixIconColor: AppColors.textMuted,
    borderColor: AppColors.cardBorder,
    enabledBorderColor: AppColors.cardBorder,
    focusedBorderColor: AppColors.primaryColor,
    errorBorderColor: AppColors.error,
    focusedErrorBorderColor: AppColors.error,
  );

  static final InputDecorationTheme darkInputDecorationTheme =
      _baseInputDecorationTheme(
    labelColor: AppColors.white,
    hintColor: AppColors.textMuted,
    errorColor: AppColors.error,
    focusedErrorColor: AppColors.error,
    prefixIconColor: AppColors.textMuted,
    suffixIconColor: AppColors.textMuted,
    borderColor: AppColors.cardBorder,
    enabledBorderColor: AppColors.cardBorder,
    focusedBorderColor: AppColors.primaryColor,
    errorBorderColor: AppColors.error,
    focusedErrorBorderColor: AppColors.error,
  );
}