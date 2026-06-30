import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';

import '../../utils/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final dynamic backgroundColor; // Can be Color or Gradient
  final Color? textColor;
  final bool isOutline;
  final Color? borderColor;
  final TextStyle? customTextStyle;
  final double? width;
  final double? height;
  final bool isUpperCase;
  final double? elevation;
  final bool enableShadow;
  final Color? shadowColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.isOutline = false,
    this.borderColor,
    this.customTextStyle,
    this.width,
    this.height,
    this.isUpperCase = true,
    this.elevation,
    this.enableShadow = false,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final bool hasGradient = backgroundColor is Gradient;
    final Color effectiveTextColor = isOutline
        ? (textColor ?? Theme.of(context).primaryColor)
        : (textColor ?? Colors.black);

    return Material(
      color: Colors.transparent,
      borderRadius: effectiveBorderRadius,
      elevation: elevation ?? 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        splashColor: Colors.white,
        child: Container(
          width: width ?? double.infinity,
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            gradient: hasGradient ? backgroundColor : null,
            color: !hasGradient
                ? (backgroundColor ?? AppColors.primaryColor)
                : null,
            borderRadius: effectiveBorderRadius,
            border: isOutline
                ? Border.all(color: borderColor ?? Theme.of(context).primaryColor)
                : null,
            boxShadow: enableShadow
                ? [
              BoxShadow(
                color: shadowColor ?? Colors.black,
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ]
                : [],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                 SizedBox(width: 8.w),
              ],
              if (child == null)
                Flexible(
                  child: Text(
                    isUpperCase ? text.toUpperCase() : text,
                    textAlign: TextAlign.center,
                    style: customTextStyle ??
                        GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: effectiveTextColor,
                        ),
                  ),
                ),
              if (child != null) child!,
              if (suffixIcon != null) ...[
                 SizedBox(width: 8.w),
                suffixIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
