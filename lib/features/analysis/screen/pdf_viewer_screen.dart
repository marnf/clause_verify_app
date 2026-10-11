




// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:file_picker/file_picker.dart'; // ✅ flutter_file_dialog এর বদলে file_picker ব্যবহার করা হচ্ছে

// class PdfViewerScreen extends StatefulWidget {
//   const PdfViewerScreen({Key? key}) : super(key: key);

//   @override
//   State<PdfViewerScreen> createState() => _PdfViewerScreenState();
// }

// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   String pdfUrl = '';
//   final RxString localPath = ''.obs;
//   final RxBool isDownloadingFile = true.obs;
//   final RxBool isPdfRendering = true.obs;
//   final RxBool hasError = false.obs;
//   final RxBool isSavingToDevice = false.obs;

//   int totalPages = 0;
//   int currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     pdfUrl = Get.arguments as String? ?? '';
//     _downloadAndSavePdf();
//   }

//   Future<void> _downloadAndSavePdf() async {
//     try {
//       isDownloadingFile.value = true;
//       hasError.value = false;

//       final headers = {'ngrok-skip-browser-warning': 'true'};
//       final response = await http.get(Uri.parse(pdfUrl), headers: headers);

//       bool isPdf = response.headers['content-type']?.contains('pdf') ?? false;
//       if (!isPdf && response.bodyBytes.length > 5) {
//         isPdf = String.fromCharCodes(response.bodyBytes.sublist(0, 5)) == '%PDF-';
//       }

//       if (response.statusCode == 200 && isPdf) {
//         final dir = await getTemporaryDirectory();
//         final file = File('${dir.path}/downloaded_report.pdf');
//         await file.writeAsBytes(response.bodyBytes);

//         localPath.value = file.path;
//         isDownloadingFile.value = false;
//       } else {
//         throw Exception('Invalid file received.');
//       }
//     } catch (e, stack) {
//       debugPrint('Download error: $e');
//       debugPrint('$stack');
//       hasError.value = true;
//       isDownloadingFile.value = false;
//     }
//   }

//   // ══════════════════════════════════════
//   //  ✅ FIXED: file_picker দিয়ে cross-platform save
//   //  (flutter_file_dialog এর বদলে — Android + iOS দুটোতেই কাজ করে)
//   // ══════════════════════════════════════
//   Future<void> _saveToDevice() async {
//     if (localPath.value.isEmpty || isSavingToDevice.value) return;
//     try {
//       isSavingToDevice.value = true;

//       final file = File(localPath.value);
//       final bytes = await file.readAsBytes();
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final fileName = 'ClauseVerify_Report_$timestamp.pdf';

//       // bytes পাস করা must — এটা ছাড়া মোবাইল প্ল্যাটফর্মে ফাইল আসলে write হয় না,
//       // শুধু dialog খুলে কিন্তু কিছু save হয় না
//       final String? outputPath = await FilePicker.platform.saveFile(
//         dialogTitle: 'saveReport'.tr,
//         fileName: fileName,
//         bytes: bytes,
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//       );

//       if (outputPath != null) {
//         _showPremiumNotification(
//           title: 'downloaded'.tr,
//           message: 'reportSavedToDownloads'.tr,
//           isSuccess: true,
//         );
//       }
//       // outputPath == null মানে সাধারণত user নিজে cancel করেছে,
//       // এটাকে error হিসেবে না দেখানোই ভালো
//     } catch (e, stack) {
//       debugPrint('Save error: $e');
//       debugPrint('$stack');
//       _showPremiumNotification(
//         title: 'error'.tr,
//         // 👇 ডিবাগ করার জন্য আপাতত raw error দেখাচ্ছি, exact কারণ বের করতে সাহায্য করবে।
//         // প্রোডাকশনে release দেওয়ার আগে এটা আবার 'somethingWentWrong'.tr করে দিন।
//         message: 'Something went wrong: $e',
//         isSuccess: false,
//       );
//     } finally {
//       isSavingToDevice.value = false;
//     }
//   }

//   Future<void> _sharePdf() async {
//     if (localPath.value.isEmpty) return;
//     try {
//       await Share.shareXFiles([XFile(localPath.value)], text: 'clauseverifyAnalysisReport'.tr);
//     } catch (e) {
//       _showPremiumNotification(
//         title: 'error'.tr,
//         message: 'couldNotShareFile'.tr,
//         isSuccess: false,
//       );
//     }
//   }

//   // ══════════════════════════════════════
//   //  ✨ প্রিমিয়াম অ্যানিমেটেড নোটিফিকেশন ✨
//   // ══════════════════════════════════════
//   void _showPremiumNotification({required String title, required String message, required bool isSuccess}) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: AppColors.surfaceLight,
//       colorText: AppColors.white,
//       borderRadius: 14,
//       margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//       borderWidth: 1,
//       borderColor: isSuccess ? AppColors.success.withOpacity(0.5) : AppColors.error.withOpacity(0.5),
//       boxShadows: [
//         BoxShadow(
//           color: AppColors.black.withOpacity(0.5),
//           blurRadius: 20,
//           offset: const Offset(0, 10),
//         ),
//       ],
//       icon: Padding(
//         padding: EdgeInsets.only(left: 4.w),
//         child: Icon(
//           isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
//           color: isSuccess ? AppColors.success : AppColors.error,
//           size: 28.sp,
//         ),
//       ),
//       shouldIconPulse: false, // আইকন জাম্প করবে না, ক্লাসি লুক
//       duration: const Duration(seconds: 3),
//       isDismissible: true,
//       dismissDirection: DismissDirection.horizontal,
//       animationDuration: const Duration(milliseconds: 600), // স্মুথ স্লাইড অ্যানিমেশন
//       forwardAnimationCurve: Curves.easeOutCubic,
//       reverseAnimationCurve: Curves.easeInCubic,
//       snackStyle: SnackStyle.FLOATING,
//       overlayBlur: 0, // ব্যাকগ্রাউন্ড ব্লার হবে না
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryColor, size: 20.sp),
//           onPressed: () => Get.back(),
//         ),
//         title: Obx(() {
//           if (isDownloadingFile.value) return Text('fetchingReport'.tr, style: TextStyle(color: AppColors.white, fontSize: 16.sp));
//           if (isPdfRendering.value) return Text('renderingPdf'.tr, style: TextStyle(color: AppColors.white, fontSize: 16.sp));
//           return Text('${currentPage + 1} / $totalPages', style: TextStyle(color: AppColors.white, fontSize: 16.sp));
//         }),
//       ),
//       body: Column(
//         children: [
//           // ✅ পুরো স্ক্রিনের ম্যাক্সিমাম জায়গা জুড়ে PDF শো করবে
//           Expanded(
//             child: Obx(() {
//               if (isDownloadingFile.value) {
//                 return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
//               }
//               if (hasError.value) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48.sp),
//                       SizedBox(height: 16.h),
//                       Text('failedToLoadPdf'.tr, style: TextStyle(color: AppColors.white, fontSize: 16.sp)),
//                     ],
//                   ),
//                 );
//               }
//               if (localPath.value.isNotEmpty) {
//                 return Stack(
//                   children: [
//                     PDFView(
//                       filePath: localPath.value,
//                       enableSwipe: true,
//                       autoSpacing: true,
//                       pageFling: true,
//                       backgroundColor: AppColors.background,
//                       onRender: (_pages) {
//                         setState(() => totalPages = _pages ?? 0);
//                         isPdfRendering.value = false;
//                       },
//                       onError: (error) {
//                         debugPrint('PDFView render error: $error');
//                         hasError.value = true;
//                         isDownloadingFile.value = false;
//                       },
//                       onPageChanged: (page, total) {
//                         setState(() {
//                           currentPage = page ?? 0;
//                           totalPages = total ?? 0;
//                         });
//                       },
//                     ),
//                     if (isPdfRendering.value)
//                       const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
//                   ],
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//           ),

//           // ✅ নিচে কমপ্যাক্ট বাটন বার
//           Obx(() {
//             if (isDownloadingFile.value || hasError.value || localPath.value.isEmpty) return const SizedBox.shrink();
//             return Container(
//               padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: _saveToDevice,
//                       child: Obx(() => Container(
//                         padding: EdgeInsets.symmetric(vertical: 12.h),
//                         decoration: BoxDecoration(
//                           color: isSavingToDevice.value ? AppColors.primaryColor.withOpacity(0.5) : AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: isSavingToDevice.value
//                               ? SizedBox(width: 16.w, height: 16.h, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black))
//                               : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.download_rounded, color: AppColors.black, size: 16.sp),
//                                     SizedBox(width: 6.w),
//                                     Text('download'.tr, style: TextStyle(color: AppColors.black, fontSize: 13.sp, fontWeight: FontWeight.w700)),
//                                   ],
//                                 ),
//                         ),
//                       )),
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: _sharePdf,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 12.h),
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: AppColors.primaryColor.withOpacity(0.5), width: 1.5),
//                         ),
//                         child: Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.share_rounded, color: AppColors.primaryColor, size: 16.sp),
//                               SizedBox(width: 6.w),
//                               Text('share'.tr, style: TextStyle(color: AppColors.primaryColor, fontSize: 13.sp, fontWeight: FontWeight.w700)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           })
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:clause_verify/features/nav_bar/controllers/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart'; // ✅ flutter_file_dialog এর বদলে file_picker ব্যবহার করা হচ্ছে

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String pdfUrl = '';
  final RxString localPath = ''.obs;
  final RxBool isDownloadingFile = true.obs;
  final RxBool isPdfRendering = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isSavingToDevice = false.obs;

  int totalPages = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pdfUrl = Get.arguments as String? ?? '';
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      isDownloadingFile.value = true;
      hasError.value = false;

      final headers = {'ngrok-skip-browser-warning': 'true'};
      final response = await http.get(Uri.parse(pdfUrl), headers: headers);

      bool isPdf = response.headers['content-type']?.contains('pdf') ?? false;
      if (!isPdf && response.bodyBytes.length > 5) {
        isPdf = String.fromCharCodes(response.bodyBytes.sublist(0, 5)) == '%PDF-';
      }

      if (response.statusCode == 200 && isPdf) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/downloaded_report.pdf');
        await file.writeAsBytes(response.bodyBytes);

        localPath.value = file.path;
        isDownloadingFile.value = false;
      } else {
        throw Exception('Invalid file received.');
      }
    } catch (e, stack) {
      debugPrint('Download error: $e');
      debugPrint('$stack');
      hasError.value = true;
      isDownloadingFile.value = false;
    }
  }

  // ══════════════════════════════════════
  //  ✅ FIXED: file_picker দিয়ে cross-platform save
  //  (flutter_file_dialog এর বদলে — Android + iOS দুটোতেই কাজ করে)
  // ══════════════════════════════════════
  Future<void> _saveToDevice() async {
    if (localPath.value.isEmpty || isSavingToDevice.value) return;
    try {
      isSavingToDevice.value = true;

      final file = File(localPath.value);
      final bytes = await file.readAsBytes();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'ClauseVerify_Report_$timestamp.pdf';

      // bytes পাস করা must — এটা ছাড়া মোবাইল প্ল্যাটফর্মে ফাইল আসলে write হয় না,
      // শুধু dialog খুলে কিন্তু কিছু save হয় না
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'saveReport'.tr,
        fileName: fileName,
        bytes: bytes,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (outputPath != null) {
        _showPremiumNotification(
          title: 'downloaded'.tr,
          message: 'reportSavedToDownloads'.tr,
          isSuccess: true,
        );
      }
      // outputPath == null মানে সাধারণত user নিজে cancel করেছে,
      // এটাকে error হিসেবে না দেখানোই ভালো
    } catch (e, stack) {
      debugPrint('Save error: $e');
      debugPrint('$stack');
      _showPremiumNotification(
        title: 'error'.tr,
        // 👇 ডিবাগ করার জন্য আপাতত raw error দেখাচ্ছি, exact কারণ বের করতে সাহায্য করবে।
        // প্রোডাকশনে release দেওয়ার আগে এটা আবার 'somethingWentWrong'.tr করে দিন।
        message: 'Something went wrong: $e',
        isSuccess: false,
      );
    } finally {
      isSavingToDevice.value = false;
    }
  }

  Future<void> _sharePdf() async {
    if (localPath.value.isEmpty) return;
    try {
      await Share.shareXFiles([XFile(localPath.value)], text: 'clauseverifyAnalysisReport'.tr);
    } catch (e) {
      _showPremiumNotification(
        title: 'error'.tr,
        message: 'couldNotShareFile'.tr,
        isSuccess: false,
      );
    }
  }

  // ══════════════════════════════════════
  //  🔄 Scan Again: সব page বন্ধ করে navbar-এর Home tab-এ যাও
  //  Home থেকে back করলে আর এই page-এ ফিরবে না
  // ══════════════════════════════════════
  void _scanAgain() {
    // PDF viewer + result + upload/camera — সব route pop করে root (navbar) পর্যন্ত যাও
    Get.until((route) => route.isFirst);

    try {
      final nav = Get.find<NavBarController>();
      if (nav.currentIndex == 0) {
        // আগে থেকেই Home tab-এ থাকলে tab বদলাবে না, তাই scan count refresh করে নাও
        Get.find<HomeController>().refreshData();
      } else {
        // অন্য tab-এ থাকলে Home-এ নিয়ে যাও (এটা নিজেই refresh করে)
        nav.backToHome();
      }
    } catch (e) {
      debugPrint('⚠️ scanAgain: navbar/home controller not found: $e');
    }
  }

  // ══════════════════════════════════════
  //  ✨ প্রিমিয়াম অ্যানিমেটেড নোটিফিকেশন ✨
  // ══════════════════════════════════════
  void _showPremiumNotification({required String title, required String message, required bool isSuccess}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.surfaceLight,
      colorText: AppColors.white,
      borderRadius: 14,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      borderWidth: 1,
      borderColor: isSuccess ? AppColors.success.withOpacity(0.5) : AppColors.error.withOpacity(0.5),
      boxShadows: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.5),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      icon: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Icon(
          isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
          color: isSuccess ? AppColors.success : AppColors.error,
          size: 28.sp,
        ),
      ),
      shouldIconPulse: false, // আইকন জাম্প করবে না, ক্লাসি লুক
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      animationDuration: const Duration(milliseconds: 600), // স্মুথ স্লাইড অ্যানিমেশন
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      snackStyle: SnackStyle.FLOATING,
      overlayBlur: 0, // ব্যাকগ্রাউন্ড ব্লার হবে না
    );
  }

  // ══════════════════════════════════════
  //  ⭕ AppBar-এর গোল বাটন (Back / Download / Share — সব একই size)
  // ══════════════════════════════════════
  static const double _circleSize = 40;

  Widget _circleButton({
    required IconData icon,
    required VoidCallback? onTap,
    bool isBusy = false,
    bool enabled = true,
  }) {
    final double size = _circleSize.w;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (enabled && !isBusy) ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.navy,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Center(
            child: isBusy
                ? SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor),
                  )
                : Icon(icon, color: AppColors.primaryColor, size: 18.sp),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: 16.w + _circleSize.w + 8.w,
        // ⬅️ বাঁয়ে: Back (গোল)
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: _circleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Get.back(),
            ),
          ),
        ),
        title: Obx(() {
          if (isDownloadingFile.value) return Text('fetchingReport'.tr, style: TextStyle(color: AppColors.white, fontSize: 16.sp));
          if (isPdfRendering.value) return Text('renderingPdf'.tr, style: TextStyle(color: AppColors.white, fontSize: 16.sp));
          return Text('${currentPage + 1} / $totalPages', style: TextStyle(color: AppColors.white, fontSize: 16.sp));
        }),
        // ➡️ ডানে: Download + Share (গোল, Back-এর same size)
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Obx(() {
                // PDF লোড না হওয়া পর্যন্ত বাটন দুটো ঝাপসা ও নিষ্ক্রিয় থাকবে
                final bool ready = !isDownloadingFile.value && !hasError.value && localPath.value.isNotEmpty;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _circleButton(
                      icon: Icons.download_rounded,
                      onTap: _saveToDevice,
                      enabled: ready,
                      isBusy: isSavingToDevice.value,
                    ),
                    SizedBox(width: 8.w),
                    _circleButton(
                      icon: Icons.share_rounded,
                      onTap: _sharePdf,
                      enabled: ready,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
      // ✅ FIX: SafeArea দিয়ে নিচের বাটন phone-এর navigation bar-এর ওপরে থাকবে
      body: SafeArea(
        top: false, // উপরের অংশ AppBar নিজেই সামলায়
        bottom: true, // navigation bar-এর নিচে কিছু দেখাবে না
        child: Column(
          children: [
            // ✅ পুরো স্ক্রিনের ম্যাক্সিমাম জায়গা জুড়ে PDF শো করবে
            Expanded(
              child: Obx(() {
                if (isDownloadingFile.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                }
                if (hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48.sp),
                        SizedBox(height: 16.h),
                        Text('failedToLoadPdf'.tr, style: TextStyle(color: AppColors.white, fontSize: 16.sp)),
                      ],
                    ),
                  );
                }
                if (localPath.value.isNotEmpty) {
                  return Stack(
                    children: [
                      PDFView(
                        filePath: localPath.value,
                        enableSwipe: true,
                        autoSpacing: true,
                        pageFling: true,
                        backgroundColor: AppColors.background,
                        onRender: (_pages) {
                          setState(() => totalPages = _pages ?? 0);
                          isPdfRendering.value = false;
                        },
                        onError: (error) {
                          debugPrint('PDFView render error: $error');
                          hasError.value = true;
                          isDownloadingFile.value = false;
                        },
                        onPageChanged: (page, total) {
                          setState(() {
                            currentPage = page ?? 0;
                            totalPages = total ?? 0;
                          });
                        },
                      ),
                      if (isPdfRendering.value)
                        const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ),

            // ✅ নিচে শুধু Scan Again বাটন (সবসময় দেখা যাবে)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
              ),
              child: GestureDetector(
                onTap: _scanAgain,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.document_scanner_rounded, color: AppColors.black, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text('scanAgain'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}