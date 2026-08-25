import 'package:clause_verify/features/pdf/controller/report_web_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

class ReportWebViewScreen extends StatelessWidget {
  final controller = Get.put(ReportWebViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('aiPreExpertiseReport'.tr),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          // Zoom Controls
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: controller.zoomOut,
            tooltip: 'zoomOut'.tr,
          ),
          Obx(() => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${(controller.zoomLevel.value * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: controller.zoomIn,
            tooltip: 'zoomIn'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.resetZoom,
            tooltip: 'resetZoom'.tr,
          ),

          // Download/Print Menu
          Obx(() => controller.isDownloading.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
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
                          const Icon(Icons.download, size: 20),
                          const SizedBox(width: 12),
                          Text('downloadPdf'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'print',
                      child: Row(
                        children: [
                          const Icon(Icons.print, size: 20),
                          const SizedBox(width: 12),
                          Text('printPdf'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          const Icon(Icons.refresh, size: 20),
                          const SizedBox(width: 12),
                          Text('reloadReport'.tr),
                        ],
                      ),
                    ),
                  ],
                )),
        ],
      ),
      body: Obx(() {
        // ✅ Show loading while fetching data
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)),
                ),
                const SizedBox(height: 16),
                Text(
                  'loadingReportData'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'thisMayTakeAFewMoments'.tr,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        // ✅ Show error if no data
        if (controller.reportData.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.description, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('noReportDataAvailable'.tr,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshData(),
                  icon: const Icon(Icons.refresh),
                  label: Text('reloadReport'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A961),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        // ✅ Show loading while PDF is being prepared (images loading, etc.)
        if (!controller.isPdfReady.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)),
                ),
                const SizedBox(height: 16),
                Text(
                  'preparingPdf'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'loadingImagesAndAssets'.tr,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        // ✅ PDF Preview - only show when data is ready
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
                    'clauseverify_Report_${controller.reportData.value?.reportId ?? 'UNKNOWN'}.pdf',
                scrollViewDecoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                ),
                // ✅ Add loading builder
                loadingWidget: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'generatingPdfPreview'.tr,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),

      // Floating Action Buttons
      floatingActionButton: Obx(() {
        // ✅ Only show FABs when PDF is ready
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
              backgroundColor: const Color(0xFFC9A961),
              child: controller.isDownloading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.download, color: Colors.white),
              onPressed: controller.isDownloading.value
                  ? null
                  : controller.downloadAsPDF,
              tooltip: 'downloadPdf'.tr,
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'print',
              backgroundColor: const Color(0xFF1A1A1A),
              child: const Icon(Icons.print, color: Colors.white),
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