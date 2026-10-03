import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static ElevatedButtonThemeData _baseTheme({
    required Color defaultTextColor,
    required Color disabledTextColor,
    required Color defaultBackgroundColor,
    required Color disabledBackgroundColor,
    required Color borderColor,
  }) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled)
              ? disabledTextColor
              : defaultTextColor,
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled)
              ? disabledBackgroundColor
              : defaultBackgroundColor,
        ),
        side: WidgetStateProperty.all(BorderSide(color: borderColor)),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 18)),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static final ElevatedButtonThemeData lightElevatedButtonTheme = _baseTheme(
    defaultTextColor: AppColors.black,
    disabledTextColor: AppColors.black54,
    defaultBackgroundColor: AppColors.primaryColor,
    disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.45),
    borderColor: AppColors.primaryColor,
  );

  static final ElevatedButtonThemeData darkElevatedButtonTheme = _baseTheme(
    defaultTextColor: AppColors.black,
    disabledTextColor: AppColors.black54,
    defaultBackgroundColor: AppColors.primaryColor,
    disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.45),
    borderColor: AppColors.primaryColor,
  );
}