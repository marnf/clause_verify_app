import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  final double size;

  const AppLoader({
    super.key,
    this.color = AppColors.textBlue,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color,
        size: size,
      ),
    );
  }
}
