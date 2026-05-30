import 'package:flutter/material.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final IconData icon;
  final VoidCallback? onIconTap;
  final bool centerTitle;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.icon = Icons.arrow_back_rounded,
    this.onIconTap,
    this.centerTitle = false,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 0.w),
        padding: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 10.w, right: 0.w),
        child: SizedBox(
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Back button ──
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A1A1A),
                    border: Border.all(
                      color: const Color(0xFF2E2E2E),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      icon,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed:
                        onIconTap ?? () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),

              // ── Title ──
              if (title != null)
                Align(
                  alignment:
                      centerTitle ? Alignment.center : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: centerTitle ? 0 : 52.w,
                    ),
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

              // ── Right suffix icon ──
              if (suffixIcon != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(
                        color: const Color(0xFF2E2E2E),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: suffixIcon!,
                      onPressed: onSuffixTap,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}