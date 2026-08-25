import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:share_plus/share_plus.dart';

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
    } catch (e) {
      hasError.value = true;
      isDownloadingFile.value = false;
    }
  }

  Future<void> _saveToDevice() async {
    if (localPath.value.isEmpty || isSavingToDevice.value) return;
    try {
      isSavingToDevice.value = true;
      
      // Try saving to Downloads folder
      try {
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final newFilePath = '${directory.path}/ClauseVerify_Report_$timestamp.pdf';
          await File(localPath.value).copy(newFilePath);
          
          _showPremiumNotification(
            title: 'downloaded'.tr, 
            message: 'reportSavedToDownloads'.tr,
            isSuccess: true,
          );
          return; // Exit if successful
        }
      } catch (e) {
        print('❌ Android Download folder failed: $e');
      }

      // Fallback for Android 11+ or if Downloads folder fails
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newFilePath = '${externalDir.path}/ClauseVerify_Report_$timestamp.pdf';
        await File(localPath.value).copy(newFilePath);
        
        _showPremiumNotification(
          title: 'saved'.tr, 
          message: 'reportSavedToAppStorage'.tr,
          isSuccess: true,
        );
      } else {
         _showPremiumNotification(
          title: 'error'.tr, 
          message: 'couldNotSaveFile'.tr,
          isSuccess: false,
        );
      }
    } catch (e) {
       _showPremiumNotification(
        title: 'error'.tr, 
        message: 'somethingWentWrong'.tr,
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
  //  ✨ প্রিমিয়াম অ্যানিমেটেড নোটিফিকেশন ✨
  // ══════════════════════════════════════
  void _showPremiumNotification({required String title, required String message, required bool isSuccess}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: Colors.white,
      borderRadius: 14,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      borderWidth: 1,
      borderColor: isSuccess ? const Color(0xFF4CAF50).withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      icon: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Icon(
          isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
          color: isSuccess ? const Color(0xFF4CAF50) : Colors.redAccent,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: const Color(0xFFB8860B), size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          if (isDownloadingFile.value) return Text('fetchingReport'.tr, style: TextStyle(color: Colors.white, fontSize: 16.sp));
          if (isPdfRendering.value) return Text('renderingPdf'.tr, style: TextStyle(color: Colors.white, fontSize: 16.sp));
          return Text('${currentPage + 1} / $totalPages', style: TextStyle(color: Colors.white, fontSize: 16.sp));
        }),
      ),
      body: Column(
        children: [
          // ✅ পুরো স্ক্রিনের ম্যাক্সিমাম জায়গা জুড়ে PDF শো করবে
          Expanded(
            child: Obx(() {
              if (isDownloadingFile.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFB8860B)));
              }
              if (hasError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48.sp),
                      SizedBox(height: 16.h),
                      Text('failedToLoadPdf'.tr, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
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
                      backgroundColor: Colors.black,
                      onRender: (_pages) {
                        setState(() => totalPages = _pages ?? 0);
                        isPdfRendering.value = false;
                      },
                      onError: (error) {
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
                      const Center(child: CircularProgressIndicator(color: const Color(0xFFB8860B))),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ),
          
          // ✅ নিচে কমপ্যাক্ট বাটন বার
          Obx(() {
            if (isDownloadingFile.value || hasError.value || localPath.value.isEmpty) return const SizedBox.shrink();
            return Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0A),
                border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _saveToDevice,
                      child: Obx(() => Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSavingToDevice.value ? const Color(0xFFB8860B).withOpacity(0.5) : const Color(0xFFB8860B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: isSavingToDevice.value
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.download_rounded, color: Colors.black, size: 16.sp),
                                    SizedBox(width: 6.w),
                                    Text('download'.tr, style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                        ),
                      )),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: _sharePdf,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFB8860B).withOpacity(0.5), width: 1.5),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.share_rounded, color: const Color(0xFFB8860B), size: 16.sp),
                              SizedBox(width: 6.w),
                              Text('share'.tr, style:  TextStyle(color: Color(0xFFB8860B), fontSize: 13.sp, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}