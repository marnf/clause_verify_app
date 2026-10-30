// // import 'dart:ui';
// // import 'package:clause_verify/core/utils/constants/app_colors.dart';
// // import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // /// Analysis চলাকালীন backend-এর live status message screen-এর মাঝখানে
// // /// modal আকারে দেখায়। পেছনের screen সামান্য blur হয়ে থাকে।
// // ///
// // /// ব্যবহার:
// // ///   ScanLiveStatus.show(liveMessage);  // upload শুরুতে
// // ///   ScanLiveStatus.close();            // response এলে
// // class ScanLiveStatus {
// //   ScanLiveStatus._();

// //   static bool _isOpen = false;

// //   static void show(RxString message) {
// //     if (_isOpen) return;
// //     _isOpen = true;

// //     Get.dialog(
// //       PopScope(
// //         canPop: false, // back চাপলে বা বাইরে ট্যাপ করলে বন্ধ হবে না
// //         child: BackdropFilter(
// //           filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // একদম সামান্য blur
// //           child: Center(
// //             child: Material(
// //               color: Colors.transparent,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 24.w),
// //                 child: _ScanLiveStatusCard(message: message),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //       barrierDismissible: false,
// //       barrierColor: Colors.black.withOpacity(0.25),
// //     );
// //   }

// //   static void close() {
// //     if (!_isOpen) return;
// //     _isOpen = false;
// //     if (Get.isDialogOpen == true) Get.back();
// //   }
// // }

// // class _ScanLiveStatusCard extends StatefulWidget {
// //   const _ScanLiveStatusCard({required this.message});

// //   final RxString message;

// //   @override
// //   State<_ScanLiveStatusCard> createState() => _ScanLiveStatusCardState();
// // }

// // class _ScanLiveStatusCardState extends State<_ScanLiveStatusCard>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _pulse = AnimationController(
// //     vsync: this,
// //     duration: const Duration(milliseconds: 2400),
// //   )..repeat();

// //   @override
// //   void dispose() {
// //     _pulse.dispose();
// //     super.dispose();
// //   }

// //   /// একটা expanding + fading glow ring। phase দিয়ে দুটো ring-কে আলাদা সময়ে চালাই।
// //   Widget _ring(double phase, double size) {
// //     final t = (_pulse.value + phase) % 1.0;
// //     return Opacity(
// //       opacity: (1 - t) * 0.45,
// //       child: Transform.scale(
// //         scale: 0.55 + 0.45 * t,
// //         child: Container(
// //           width: size,
// //           height: size,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             border: Border.all(color: AppColors.primaryColor, width: 1.5),
// //             color: AppColors.primaryColor.withOpacity(0.06),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   /// Pulse ring + মাঝখানে ছোট breathing icon (spinner নেই)
// //   Widget _buildAnimation() {
// //     final box = 128.w;

// //     return SizedBox(
// //       width: box,
// //       height: box,
// //       child: AnimatedBuilder(
// //         animation: _pulse,
// //         builder: (context, _) {
// //           // icon হালকা breathing effect (ছোট-বড়)
// //           final breathe = 1 + 0.08 * (1 - (2 * _pulse.value - 1).abs());

// //           return Stack(
// //             alignment: Alignment.center,
// //             children: [
// //               _ring(0.0, box),
// //               _ring(0.5, box),
// //               Transform.scale(
// //                 scale: breathe,
// //                 child: Container(
// //                   width: 52.w,
// //                   height: 52.w,
// //                   decoration: BoxDecoration(
// //                     color: AppColors.primaryColor.withOpacity(0.14),
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Icon(
// //                     Icons.auto_awesome,
// //                     color: AppColors.primaryColor,
// //                     size: 24.sp,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx(() {
// //       // Backend-এর প্রথম message না আসা পর্যন্ত default "analysing" দেখাবে
// //       final text =
// //           widget.message.value.isEmpty ? 'analysing'.tr : widget.message.value;

// //       return Container(
// //         width: double.infinity,
// //         padding: EdgeInsets.fromLTRB(20.w, 36.h, 20.w, 32.h),
// //         decoration: BoxDecoration(
// //           color: AppColors.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           border: Border.all(
// //             color: AppColors.primaryColor.withOpacity(0.4),
// //             width: 1,
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             // ── Animation (pulse rings + breathing icon) ──
// //             _buildAnimation(),
// //             SizedBox(height: 28.h),

// //             // ── LIVE STATUS label ──
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.auto_awesome,
// //                     color: AppColors.primaryColor, size: 14.sp),
// //                 SizedBox(width: 6.w),
// //                 Text(
// //                   'LIVE STATUS',
// //                   style: TextStyle(
// //                     color: AppColors.primaryColor,
// //                     fontSize: 10.sp,
// //                     fontWeight: FontWeight.w700,
// //                     letterSpacing: 1.2,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 12.h),

// //             // ── Live message (বদলালে fade + slide) ──
// //             ConstrainedBox(
// //               constraints: BoxConstraints(minHeight: 44.h),
// //               child: AnimatedSwitcher(
// //                 duration: const Duration(milliseconds: 350),
// //                 transitionBuilder: (child, animation) => FadeTransition(
// //                   opacity: animation,
// //                   child: SlideTransition(
// //                     position: Tween<Offset>(
// //                       begin: const Offset(0, 0.25),
// //                       end: Offset.zero,
// //                     ).animate(animation),
// //                     child: child,
// //                   ),
// //                 ),
// //                 child: SizedBox(
// //                   key: ValueKey(text),
// //                   width: double.infinity,
// //                   child: Text(
// //                     text,
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(
// //                       color: AppColors.textWhite,
// //                       fontSize: 14.sp,
// //                       fontWeight: FontWeight.w600,
// //                       height: 1.45,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }









// // lib/core/common/widgets/scan_live_status.dart  (MODIFIED)
// //
// // শুধু দুটো জায়গায় পরিবর্তন:
// //   1. "LIVE STATUS" hardcoded লেখাটা 'liveStatus'.tr দিয়ে replace করা হয়েছে।
// //   2. Backend message এখন ScanJobPoller-এই translate হয়ে আসে, তাই widget-এ
// //      শুধু সেটা display করা হয়। (কোনো extra translate logic লাগে না)

// import 'dart:ui';
// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// /// Analysis চলাকালীন backend-এর live status message screen-এর মাঝখানে
// /// modal আকারে দেখায়। পেছনের screen সামান্য blur হয়ে থাকে।
// ///
// /// ব্যবহার:
// ///   ScanLiveStatus.show(liveMessage);  // upload শুরুতে
// ///   ScanLiveStatus.close();            // response এলে
// class ScanLiveStatus {
//   ScanLiveStatus._();

//   static bool _isOpen = false;

//   static void show(RxString message) {
//     if (_isOpen) return;
//     _isOpen = true;

//     Get.dialog(
//       PopScope(
//         canPop: false, // back চাপলে বা বাইরে ট্যাপ করলে বন্ধ হবে না
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // একদম সামান্য blur
//           child: Center(
//             child: Material(
//               color: Colors.transparent,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24.w),
//                 child: _ScanLiveStatusCard(message: message),
//               ),
//             ),
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//       barrierColor: Colors.black.withOpacity(0.25),
//     );
//   }

//   static void close() {
//     if (!_isOpen) return;
//     _isOpen = false;
//     if (Get.isDialogOpen == true) Get.back();
//   }
// }

// class _ScanLiveStatusCard extends StatefulWidget {
//   const _ScanLiveStatusCard({required this.message});

//   final RxString message;

//   @override
//   State<_ScanLiveStatusCard> createState() => _ScanLiveStatusCardState();
// }

// class _ScanLiveStatusCardState extends State<_ScanLiveStatusCard>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _pulse = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 2400),
//   )..repeat();

//   @override
//   void dispose() {
//     _pulse.dispose();
//     super.dispose();
//   }

//   /// একটা expanding + fading glow ring। phase দিয়ে দুটো ring-কে আলাদা সময়ে চালাই।
//   Widget _ring(double phase, double size) {
//     final t = (_pulse.value + phase) % 1.0;
//     return Opacity(
//       opacity: (1 - t) * 0.45,
//       child: Transform.scale(
//         scale: 0.55 + 0.45 * t,
//         child: Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: AppColors.primaryColor, width: 1.5),
//             color: AppColors.primaryColor.withOpacity(0.06),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Pulse ring + মাঝখানে ছোট breathing icon (spinner নেই)
//   Widget _buildAnimation() {
//     final box = 128.w;

//     return SizedBox(
//       width: box,
//       height: box,
//       child: AnimatedBuilder(
//         animation: _pulse,
//         builder: (context, _) {
//           // icon হালকা breathing effect (ছোট-বড়)
//           final breathe = 1 + 0.08 * (1 - (2 * _pulse.value - 1).abs());

//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               _ring(0.0, box),
//               _ring(0.5, box),
//               Transform.scale(
//                 scale: breathe,
//                 child: Container(
//                   width: 52.w,
//                   height: 52.w,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryColor.withOpacity(0.14),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.auto_awesome,
//                     color: AppColors.primaryColor,
//                     size: 24.sp,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Backend-এর প্রথম message না আসা পর্যন্ত default "analysing" দেখাবে।
//       // message এখন ScanJobPoller থেকেই translated আসে, তাই সরাসরি display করা যায়।
//       final text =
//           widget.message.value.isEmpty ? 'analysing'.tr : widget.message.value;

//       return Container(
//         width: double.infinity,
//         padding: EdgeInsets.fromLTRB(20.w, 36.h, 20.w, 32.h),
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: AppColors.primaryColor.withOpacity(0.4),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ── Animation (pulse rings + breathing icon) ──
//             _buildAnimation(),
//             SizedBox(height: 28.h),

//             // ── LIVE STATUS label ──
//             // ✅ আগে hardcoded "LIVE STATUS" ছিল, এখন translatable।
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.auto_awesome,
//                     color: AppColors.primaryColor, size: 14.sp),
//                 SizedBox(width: 6.w),
//                 Text(
//                   'liveStatus'.tr,
//                   style: TextStyle(
//                     color: AppColors.primaryColor,
//                     fontSize: 10.sp,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12.h),

//             // ── Live message (বদলালে fade + slide) ──
//             ConstrainedBox(
//               constraints: BoxConstraints(minHeight: 44.h),
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 350),
//                 transitionBuilder: (child, animation) => FadeTransition(
//                   opacity: animation,
//                   child: SlideTransition(
//                     position: Tween<Offset>(
//                       begin: const Offset(0, 0.25),
//                       end: Offset.zero,
//                     ).animate(animation),
//                     child: child,
//                   ),
//                 ),
//                 child: SizedBox(
//                   key: ValueKey(text),
//                   width: double.infinity,
//                   child: Text(
//                     text,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColors.textWhite,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       height: 1.45,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }






// lib/core/common/widgets/scan_live_status.dart  (MODIFIED)
//
// পরিবর্তন:
//   1. "LIVE STATUS" hardcoded লেখাটা 'liveStatus'.tr দিয়ে replace করা হয়েছে।
//   2. Backend message এখন ScanJobPoller-এই translate হয়ে আসে।
//   3. ❌ BackdropFilter (blur) সরানো হয়েছে — এখন শুধু dark overlay
//      থাকবে যাতে modal ভেসে ওঠে (blur ছাড়াই)।

import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Analysis চলাকালীন backend-এর live status message screen-এর মাঝখানে
/// modal আকারে দেখায়। পেছনের screen সামান্য dark shadow হয়ে থাকে (blur নেই)।
///
/// ব্যবহার:
///   ScanLiveStatus.show(liveMessage);  // upload শুরুতে
///   ScanLiveStatus.close();            // response এলে
class ScanLiveStatus {
  ScanLiveStatus._();

  static bool _isOpen = false;

  static void show(RxString message) {
    if (_isOpen) return;
    _isOpen = true;

    Get.dialog(
      PopScope(
        canPop: false, // back চাপলে বা বাইরে ট্যাপ করলে বন্ধ হবে না
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _ScanLiveStatusCard(message: message),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      // ❌ Blur সরানো হয়েছে — এখন শুধু dark overlay দিয়ে modal ভেসে ওঠে।
      // 0.45 = একটু বেশি dark, যাতে modal pop করে চোখে পড়ে।
      barrierColor: Colors.black.withOpacity(0.45),
    );
  }

  static void close() {
    if (!_isOpen) return;
    _isOpen = false;
    if (Get.isDialogOpen == true) Get.back();
  }
}

class _ScanLiveStatusCard extends StatefulWidget {
  const _ScanLiveStatusCard({required this.message});

  final RxString message;

  @override
  State<_ScanLiveStatusCard> createState() => _ScanLiveStatusCardState();
}

class _ScanLiveStatusCardState extends State<_ScanLiveStatusCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  /// একটা expanding + fading glow ring। phase দিয়ে দুটো ring-কে আলাদা সময়ে চালাই।
  Widget _ring(double phase, double size) {
    final t = (_pulse.value + phase) % 1.0;
    return Opacity(
      opacity: (1 - t) * 0.45,
      child: Transform.scale(
        scale: 0.55 + 0.45 * t,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryColor, width: 1.5),
            color: AppColors.primaryColor.withOpacity(0.06),
          ),
        ),
      ),
    );
  }

  /// Pulse ring + মাঝখানে ছোট breathing icon (spinner নেই)
  Widget _buildAnimation() {
    final box = 128.w;

    return SizedBox(
      width: box,
      height: box,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          // icon হালকা breathing effect (ছোট-বড়)
          final breathe = 1 + 0.08 * (1 - (2 * _pulse.value - 1).abs());

          return Stack(
            alignment: Alignment.center,
            children: [
              _ring(0.0, box),
              _ring(0.5, box),
              Transform.scale(
                scale: breathe,
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Backend-এর প্রথম message না আসা পর্যন্ত default "analysing" দেখাবে।
      // message এখন ScanJobPoller থেকেই translated আসে, তাই সরাসরি display করা যায়।
      final text =
          widget.message.value.isEmpty ? 'analysing'.tr : widget.message.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 36.h, 20.w, 32.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Animation (pulse rings + breathing icon) ──
            _buildAnimation(),
            SizedBox(height: 28.h),

            // ── LIVE STATUS label ──
            // ✅ আগে hardcoded "LIVE STATUS" ছিল, এখন translatable।
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome,
                    color: AppColors.primaryColor, size: 14.sp),
                SizedBox(width: 6.w),
                Text(
                  'liveStatus'.tr,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ── Live message (বদলালে fade + slide) ──
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 44.h),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.25),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: SizedBox(
                  key: ValueKey(text),
                  width: double.infinity,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
