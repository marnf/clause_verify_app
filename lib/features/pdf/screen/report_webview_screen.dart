

import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/pdf/controller/report_web_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

class ReportWebViewScreen extends StatelessWidget {
  final controller = Get.put(ReportWebViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('aiPreExpertiseReport'.tr),
        backgroundColor: AppColors.surfaceLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out, color: AppColors.white),
            onPressed: controller.zoomOut,
            tooltip: 'zoomOut'.tr,
          ),
          Obx(() => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${(controller.zoomLevel.value * 100).toInt()}%',
                    style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                  ),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: AppColors.white),
            onPressed: controller.zoomIn,
            tooltip: 'zoomIn'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: controller.resetZoom,
            tooltip: 'resetZoom'.tr,
          ),
          Obx(() => controller.isDownloading.value
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  ),
                )
              : PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.white),
                  onSelected: (value) {
                    if (value == 'download') {
                      controller.downloadAsPDF();
                    } else if (value == 'print') {
                      controller.printPDF();
                    } else if (value == 'refresh') {
                      controller.refreshData();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download, size: 20.sp),
                          SizedBox(width: 12.w),
                          Text('downloadPdf'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'print',
                      child: Row(
                        children: [
                          Icon(Icons.print, size: 20.sp),
                          SizedBox(width: 12.w),
                          Text('printPdf'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 20.sp),
                          SizedBox(width: 12.w),
                          Text('reloadReport'.tr),
                        ],
                      ),
                    ),
                  ],
                )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
                SizedBox(height: 16.h),
                Text(
                  'loadingReportData'.tr,
                  style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                ),
                SizedBox(height: 8.h),
                Text(
                  'thisMayTakeAFewMoments'.tr,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSubtle),
                ),
              ],
            ),
          );
        }

        if (controller.reportData.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description, size: 64.sp, color: AppColors.textMuted),
                SizedBox(height: 16.h),
                Text('noReportDataAvailable'.tr,
                    style: TextStyle(fontSize: 16.sp, color: AppColors.white)),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshData(),
                  icon: const Icon(Icons.refresh),
                  label: Text('reloadReport'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        if (!controller.isPdfReady.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
                SizedBox(height: 16.h),
                Text(
                  'preparingPdf'.tr,
                  style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                ),
                SizedBox(height: 8.h),
                Text(
                  'loadingImagesAndAssets'.tr,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSubtle),
                ),
              ],
            ),
          );
        }

        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          boundaryMargin: const EdgeInsets.all(20),
          child: Obx(
            () => Transform.scale(
              scale: controller.zoomLevel.value,
              child: PdfPreview(
                build: (format) async {
                  try {
                    final pdfDoc = await controller.generatePdfDocument();
                    return pdfDoc.save();
                  } catch (e) {
                    print('❌ PDF Preview error: $e');
                    rethrow;
                  }
                },
                allowPrinting: false,
                allowSharing: false,
                canChangePageFormat: false,
                canDebug: false,
                canChangeOrientation: false,
                pdfFileName:
                    'ClauseVerify_Report_${controller.reportData.value?.reportId ?? 'UNKNOWN'}.pdf',
                scrollViewDecoration: const BoxDecoration(
                  color: AppColors.background,
                ),
                loadingWidget: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'generatingPdfPreview'.tr,
                        style: TextStyle(fontSize: 14.sp, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.isLoading.value ||
            controller.reportData.value == null ||
            !controller.isPdfReady.value) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'download',
              backgroundColor: AppColors.primaryColor,
              child: controller.isDownloading.value
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.black),
                      ),
                    )
                  : const Icon(Icons.download, color: AppColors.black),
              onPressed: controller.isDownloading.value
                  ? null
                  : controller.downloadAsPDF,
              tooltip: 'downloadPdf'.tr,
            ),
            SizedBox(height: 12.h),
            FloatingActionButton(
              heroTag: 'print',
              backgroundColor: AppColors.surfaceLight,
              child: const Icon(Icons.print, color: AppColors.white),
              onPressed:
                  controller.isDownloading.value ? null : controller.printPDF,
              tooltip: 'printPdf'.tr,
            ),
          ],
        );
      }),
    );
  }
}