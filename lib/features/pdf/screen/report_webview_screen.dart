import 'package:clause_verify/features/pdf/controller/report_web_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

class ReportWebViewScreen extends StatelessWidget {
  final controller = Get.put(ReportWebViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('AI Pre-Expertise Report'),
        backgroundColor: Color(0xFF1A1A1A),
        actions: [
          // Zoom Controls
          IconButton(
            icon: Icon(Icons.zoom_out, color: Colors.white),
            onPressed: controller.zoomOut,
            tooltip: 'Zoom Out',
          ),
          Obx(() => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${(controller.zoomLevel.value * 100).toInt()}%',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              )),
          IconButton(
            icon: Icon(Icons.zoom_in, color: Colors.white),
            onPressed: controller.zoomIn,
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.resetZoom,
            tooltip: 'Reset Zoom',
          ),

          // Download/Print Menu
          Obx(() => controller.isDownloading.value
              ? Padding(
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
                  icon: Icon(Icons.more_vert, color: Colors.white),
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
                          Icon(Icons.download, size: 20),
                          SizedBox(width: 12),
                          Text('Download PDF'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'print',
                      child: Row(
                        children: [
                          Icon(Icons.print, size: 20),
                          SizedBox(width: 12),
                          Text('Print PDF'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 20),
                          SizedBox(width: 12),
                          Text('Reload Report'),
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
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading report data...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                Text(
                  'This may take a few moments',
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
                Icon(Icons.description, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No report data available',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshData(),
                  icon: Icon(Icons.refresh),
                  label: Text('Reload Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC9A961),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)),
                ),
                SizedBox(height: 16),
                Text(
                  'Preparing PDF...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                Text(
                  'Loading images and assets',
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
          boundaryMargin: EdgeInsets.all(20),
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
                scrollViewDecoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                ),
                // ✅ Add loading builder
                loadingWidget: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Generating PDF preview...',
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
          return SizedBox.shrink();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'download',
              backgroundColor: Color(0xFFC9A961),
              child: controller.isDownloading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(Icons.download, color: Colors.white),
              onPressed: controller.isDownloading.value
                  ? null
                  : controller.downloadAsPDF,
              tooltip: 'Download PDF',
            ),
            SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'print',
              backgroundColor: Color(0xFF1A1A1A),
              child: Icon(Icons.print, color: Colors.white),
              onPressed:
                  controller.isDownloading.value ? null : controller.printPDF,
              tooltip: 'Print PDF',
            ),
          ],
        );
      }),
    );
  }
}