import 'package:flutter_extension/core/services/auth_service.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/features/pdf/model/pdf_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Helper class for PDF components (Moved to top-level)
class ComponentForPdf {
  final String name;
  final String matchScore;
  final String observations;

  ComponentForPdf({
    required this.name,
    required this.matchScore,
    required this.observations,
  });
}

class ReportWebViewController extends GetxController {
  var isLoading = true.obs;
  var isDownloading = false.obs;
  Rx<PdfDataModel?> reportData = Rx<PdfDataModel?>(null);

  // ✅ Simple flag - images loaded only when generating PDF
  var isPdfReady = false.obs;
  
  // Images for PDF - loaded on-demand
  Uint8List? logoImage;
  Uint8List? logoNameImage;
  Uint8List? sealImage;
  Uint8List? starImage;
  
  // ✅ Watch images - cached versions
  Map<String, Uint8List?> imageCache = {};
  
  Uint8List? qrCodeImage;

  // Zoom control
  var zoomLevel = 1.0.obs;

  String? analysisId;

  @override
  void onInit() {
    super.onInit();
    // Get ID from navigation arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      analysisId = args['id'];
    }
    
    if (analysisId != null) {
      loadReportData();
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Analysis ID not found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  Future<void> loadReportData() async {
    try {
      isLoading.value = true;
      isPdfReady.value = false;

      // ✅ Ensure token is loaded
      if (AuthService.token == null || AuthService.token!.isEmpty) {
        print('⏳ Token not loaded, reinitializing AuthService...');
        await AuthService.init();
        await Future.delayed(Duration(milliseconds: 100));
      }

      if (AuthService.token == null || AuthService.token!.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Session expired. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
        );
        return;
      }

      print('✅ Token available: ${AuthService.token!.substring(0, 20)}...');

      // ✅ Only load static assets and API data - NO image downloading yet!
      await Future.wait([
        _loadAssetImages(),
        fetchAnalysisFromAPI(),
      ]);

      // ✅ PDF is ready to generate (images will load on-demand)
      isPdfReady.value = true;
      isLoading.value = false;
      
      print('✅ Data loaded, PDF ready (images will load on-demand)');
    } catch (e) {
      isLoading.value = false;
      isPdfReady.value = false;
      print('❌ Load report error: $e');
      Get.snackbar(
        'Error',
        'Failed to load report: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  Future<void> fetchAnalysisFromAPI() async {
    try {
      if (AuthService.token == null || AuthService.token!.isEmpty) {
        throw Exception('No authentication token available');
      }

      print('📤 Fetching analysis with ID: $analysisId');

      final response = await NetworkCaller().getRequest(
        '${Endpoints.historyDetails}$analysisId/',
      );

      if (response.isSuccess && response.responseData != null) {
        reportData.value = PdfDataModel.fromJson(response.responseData);
        print('✅ Report data loaded successfully');
        
        // ✅ Generate QR code only (small, fast)
        await _generateQRCode();
      } else {
        throw Exception(response.errorMessage ?? 'Failed to fetch data');
      }
    } catch (e) {
      print('❌ Fetch analysis error: $e');
      throw Exception('API Error: $e');
    }
  }

  // Load static images from assets
  Future<void> _loadAssetImages() async {
    try {
      print('📥 Loading asset images...');
      
      final results = await Future.wait([
        rootBundle.load('assets/logos/logo.png'),
        rootBundle.load('assets/logos/logo_name.png'),
        rootBundle.load('assets/images/seal.png'),
        rootBundle.load('assets/images/star.png'),
      ]);

      logoImage = results[0].buffer.asUint8List();
      logoNameImage = results[1].buffer.asUint8List();
      sealImage = results[2].buffer.asUint8List();
      starImage = results[3].buffer.asUint8List();
      
      print('✅ Asset images loaded');
    } catch (e) {
      print('❌ Error loading asset images: $e');
    }
  }

  // ✅ NEW: Load image on-demand with caching
  Future<Uint8List?> _getImageBytes(String? url) async {
    if (url == null || url.isEmpty) {
      print('⚠️ Empty URL provided');
      return null;
    }

    // Check cache first
    if (imageCache.containsKey(url)) {
      print('📦 Using cached image for: $url');
      return imageCache[url];
    }

    // Download and cache
    try {
      print('📥 Downloading image: $url');
      
      // ✅ Use Flutter Cache Manager for better caching
      final file = await DefaultCacheManager().getSingleFile(url);
      final bytes = await file.readAsBytes();
      
      if (bytes.isNotEmpty) {
        imageCache[url] = bytes;
        print('✅ Image cached: ${bytes.length} bytes');
        return bytes;
      }
      
      return null;
    } catch (e) {
      print('❌ Image download failed: $e');
      return null;
    }
  }

  // Generate QR code from report ID
  Future<void> _generateQRCode() async {
    try {
      print('📥 Generating QR code...');
      final reportId = reportData.value?.reportId ?? 'UNKNOWN';
      final qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=ReportID:$reportId';
      
      final response = await http.get(Uri.parse(qrUrl)).timeout(
        Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        qrCodeImage = response.bodyBytes;
        print('✅ QR code generated');
      }
    } catch (e) {
      print('❌ Error generating QR code: $e');
      qrCodeImage = null;
    }
  }

  // Zoom controls
  void zoomIn() {
    if (zoomLevel.value < 3.0) zoomLevel.value += 0.2;
  }

  void zoomOut() {
    if (zoomLevel.value > 0.5) zoomLevel.value -= 0.2;
  }

  void resetZoom() {
    zoomLevel.value = 1.0;
  }

  // Generate EXACT PDF matching the design image
  Future<pw.Document> generatePdfDocument() async {
    if (reportData.value == null) {
      throw Exception('Report data not loaded');
    }

    if (!isPdfReady.value) {
      print('⚠️ PDF generation called before data is ready, waiting...');
      int attempts = 0;
      while (!isPdfReady.value && attempts < 50) {
        await Future.delayed(Duration(milliseconds: 100));
        attempts++;
      }
      
      if (!isPdfReady.value) {
        throw Exception('PDF data not ready after timeout');
      }
    }

    print('📄 Generating PDF document...');
    
    final pdf = pw.Document();
    final data = reportData.value!;

    // ✅ Load watch images NOW (only when generating PDF)
    print('📥 Loading watch images for PDF...');
    final images = data.images;
    final watchImages = await Future.wait([
      _getImageBytes(images.front),
      _getImageBytes(images.back),
      _getImageBytes(images.bracelet),
    ]);
    print('✅ Watch images loaded for PDF');

    // Load fonts
    final regularFont = await PdfGoogleFonts.notoSerifRegular();
    final boldFont = await PdfGoogleFonts.notoSerifBold();
    final italicFont = await PdfGoogleFonts.notoSerifItalic();

    // Exact colors from design
    final goldColor = PdfColor.fromHex('#C9A961');
    final creamBg = PdfColor.fromHex('#F5E6D3');
    final darkBg = PdfColor.fromHex('#2B2B2B');
    final borderGrey = PdfColor.fromHex('#CCCCCC');

    // Use larger page size to accommodate all content
    final customPageFormat = PdfPageFormat(
      21.0 * PdfPageFormat.cm,
      33.0 * PdfPageFormat.cm,
      marginAll: 0,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: customPageFormat,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          final pageWidth = customPageFormat.width;
          final pageHeight = customPageFormat.height;
          final starPositionY = pageHeight * 0.50;
          final starSize = 40.0;

          return pw.Stack(
            children: [
              // Main container
              pw.Container(
                color: PdfColors.white,
                child: pw.CustomPaint(
                  painter: (PdfGraphics canvas, PdfPoint size) {
                    _drawCustomBorder(canvas, size, goldColor);
                  },
                  child: pw.Container(
                    padding: pw.EdgeInsets.only(
                      left: 55,
                      top: 30,
                      right: 55,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(
                          data,
                          regularFont,
                          boldFont,
                          goldColor,
                          darkBg,
                        ),

                        // Main Title
                        pw.Center(
                          child: pw.Text(
                            'AI Pre-Expertise Report',
                            style: pw.TextStyle(
                              fontSize: 16,
                              letterSpacing: 4.5,
                              color: PdfColor.fromInt(0xFF937C49),
                              font: regularFont,
                            ),
                          ),
                        ),

                        // Content Grid
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Submitted Photos (Left)
                            pw.Expanded(
                              flex: 5,
                              child: _buildSubmittedPhotos(
                                watchImages, // ✅ Pass loaded images
                                regularFont,
                                boldFont,
                                borderGrey,
                              ),
                            ),

                            pw.SizedBox(width: 5),

                            // Watch Information (Right)
                            pw.Expanded(
                              flex: 5,
                              child: pw.Align(
                                alignment: pw.Alignment.topRight,
                                child: pw.SizedBox(
                                  width: 200,
                                  child: _buildWatchInfo(
                                    data,
                                    regularFont,
                                    boldFont,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        pw.SizedBox(height: 18),

                        // Detailed Analysis Table
                        _buildAnalysisTable(
                          data,
                          regularFont,
                          boldFont,
                          creamBg,
                          borderGrey,
                        ),

                        pw.SizedBox(height: 16),

                        // Conclusion
                        _buildConclusion(data, regularFont, boldFont),

                        pw.SizedBox(height: 14),

                        // Expert Note
                        _buildExpertNote(data, regularFont, boldFont),

                        pw.SizedBox(height: 16),

                        // Footer
                        _buildFooter(
                          data,
                          regularFont,
                          boldFont,
                          italicFont,
                          goldColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Left star
              if (starImage != null)
                pw.Positioned(
                  left: 8,
                  top: starPositionY - starSize / 2,
                  child: pw.Image(
                    pw.MemoryImage(starImage!),
                    width: starSize,
                    height: starSize,
                  ),
                ),

              // Right star
              if (starImage != null)
                pw.Positioned(
                  right: 8,
                  top: starPositionY - starSize / 2,
                  child: pw.Image(
                    pw.MemoryImage(starImage!),
                    width: starSize,
                    height: starSize,
                  ),
                ),
            ],
          );
        },
      ),
    );

    print('✅ PDF document generated successfully');
    return pdf;
  }

  // Draw simple border with star cutouts
  void _drawCustomBorder(
    PdfGraphics canvas,
    PdfPoint size,
    PdfColor goldColor,
  ) {
    final width = size.x;
    final height = size.y;
    final borderWidth = 2.0;
    final margin = 25.0;
    final starPositionY = height * 0.50;
    final starSize = 45.0;

    canvas.setStrokeColor(goldColor);
    canvas.setLineWidth(borderWidth);

    // TOP BORDER
    canvas.drawLine(margin, margin, width - margin, margin);
    canvas.strokePath();

    // BOTTOM BORDER
    canvas.drawLine(margin, height - margin, width - margin, height - margin);
    canvas.strokePath();

    // LEFT SIDE - with star cutout
    final leftTopEnd = starPositionY - starSize / 2 - 5;
    canvas.drawLine(margin, margin, margin, leftTopEnd);
    canvas.strokePath();

    final leftBottomStart = starPositionY + starSize / 2 + 5;
    canvas.drawLine(margin, leftBottomStart, margin, height - margin);
    canvas.strokePath();

    // RIGHT SIDE - with star cutout
    final rightTopEnd = starPositionY - starSize / 2 - 5;
    canvas.drawLine(width - margin, margin, width - margin, rightTopEnd);
    canvas.strokePath();

    final rightBottomStart = starPositionY + starSize / 2 + 5;
    canvas.drawLine(
      width - margin,
      rightBottomStart,
      width - margin,
      height - margin,
    );
    canvas.strokePath();
  }

  pw.Widget _buildHeader(
    PdfDataModel data,
    pw.Font regular,
    pw.Font bold,
    PdfColor goldColor,
    PdfColor darkBg,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left: Report Info
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Report ID: ${data.reportId}',
              style: pw.TextStyle(
                fontSize: 9,
                font: regular,
                color: PdfColors.grey800,
              ),
            ),
            pw.SizedBox(height: 2.5),
            pw.Text(
              'Date of Issue: ${data.formattedCreatedDate}',
              style: pw.TextStyle(
                fontSize: 9,
                font: regular,
                color: PdfColors.grey800,
              ),
            ),
          ],
        ),

        // Center: Logo
        pw.Column(
          children: [
            pw.Container(
              width: 75,
              height: 75,
              decoration: pw.BoxDecoration(
                color: darkBg,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: logoImage != null
                  ? pw.Center(
                      child: pw.Image(
                        pw.MemoryImage(logoImage!),
                        width: 75,
                        height: 75,
                        fit: pw.BoxFit.contain,
                      ),
                    )
                  : pw.Container(),
            ),

            pw.Container(
              height: 40,
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: logoNameImage != null
                  ? pw.Center(
                      child: pw.Image(
                        pw.MemoryImage(logoNameImage!),
                        width: 140,
                        height: 70,
                      ),
                    )
                  : pw.Container(),
            ),
          ],
        ),

        // Right: Seal
        pw.Container(
          width: 95,
          height: 95,
          child: pw.Stack(
            children: [
              pw.Center(
                child: pw.Container(
                  width: 95,
                  height: 95,
                  decoration: pw.BoxDecoration(shape: pw.BoxShape.circle),
                  child: pw.ClipOval(
                    child: sealImage != null
                        ? pw.Image(
                            pw.MemoryImage(sealImage!),
                            fit: pw.BoxFit.cover,
                          )
                        : pw.Container(color: darkBg),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSubmittedPhotos(
    List<Uint8List?> watchImages, // ✅ Accept images as parameter
    pw.Font regular,
    pw.Font bold,
    PdfColor borderGrey,
  ) {
    const double imageBoxSize = 60;
    const double imageGap = 10;
    const int imageCount = 3;

    final double totalWidth =
        imageBoxSize * imageCount + imageGap * (imageCount - 1);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.SizedBox(
          width: totalWidth,
          child: pw.Text(
            'Submitted Photos',
            style: pw.TextStyle(
              fontSize: 12,
              font: bold,
              color: PdfColor.fromInt(0xFF937C49),
            ),
          ),
        ),
        pw.SizedBox(height: 9),
        pw.SizedBox(
          width: totalWidth,
          child: pw.Row(
            children: List.generate(imageCount, (index) {
              String label = '';
              switch (index) {
                case 0:
                  label = 'Front View';
                  break;
                case 1:
                  label = 'Back View';
                  break;
                case 2:
                  label = 'Bracelet View';
                  break;
              }

              final hasImage = index < watchImages.length && 
                               watchImages[index] != null && 
                               watchImages[index]!.isNotEmpty;

              return pw.Padding(
                padding: pw.EdgeInsets.only(
                  right: index < imageCount - 1 ? imageGap : 0,
                ),
                child: pw.Column(
                  children: [
                    pw.Container(
                      width: imageBoxSize,
                      height: imageBoxSize,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: borderGrey, width: 1),
                        borderRadius: pw.BorderRadius.circular(6),
                        color: PdfColors.grey100,
                      ),
                      child: hasImage
                          ? pw.ClipRRect(
                              horizontalRadius: 6,
                              verticalRadius: 6,
                              child: pw.Image(
                                pw.MemoryImage(watchImages[index]!),
                                fit: pw.BoxFit.cover,
                              ),
                            )
                          : pw.Center(
                              child: pw.Icon(
                                pw.IconData(0xe410),
                                size: 30,
                                color: PdfColors.grey500,
                              ),
                            ),
                    ),

                    pw.SizedBox(height: 3.5),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 2,
                      ),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.grey400,
                          width: 0.8,
                        ),
                        borderRadius: pw.BorderRadius.circular(3),
                      ),
                      child: pw.Text(
                        label,
                        style: pw.TextStyle(
                          fontSize: 7,
                          font: regular,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildWatchInfo(
    PdfDataModel data,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Watch Information',
          style: pw.TextStyle(
            fontSize: 12,
            font: bold,
            color: PdfColor.fromInt(0xFF937C49),
          ),
        ),
        pw.SizedBox(height: 9),
        _buildInfoRow('Brand', data.watchInformation.brand, regular, bold),
        _buildInfoRow('Model', data.watchInformation.model, regular, bold),
        _buildInfoRow(
          'Serial Ref No',
          data.watchInformation.serialRefNo,
          regular,
          bold,
        ),
        _buildInfoRow(
          'Date of Analysis',
          data.watchInformation.dateOfAnalysis,
          regular,
          bold,
        ),
      ],
    );
  }

  pw.Widget _buildInfoRow(
    String label,
    String value,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 3.2),
      child: pw.Row(
        children: [
          pw.Container(
            width: 110,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                font: regular,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value.isNotEmpty ? value : 'Unknown',
              style: pw.TextStyle(
                fontSize: 10,
                font: bold,
                color: PdfColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildAnalysisTable(
    PdfDataModel data,
    pw.Font regular,
    pw.Font bold,
    PdfColor creamBg,
    PdfColor borderGrey,
  ) {
    final components = data.components.entries.map((entry) {
      final component = entry.value;
      return ComponentForPdf(
        name: entry.key,
        matchScore: component.matchScore,
        observations: component.observations,
      );
    }).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Detailed Analysis',
          style: pw.TextStyle(
            fontSize: 12,
            font: bold,
            color: PdfColor.fromInt(0xFF937C49),
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Table(
          border: pw.TableBorder.all(color: borderGrey, width: 0.8),
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1.2),
            2: pw.FlexColumnWidth(5),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: pw.BoxDecoration(color: creamBg),
              children: [
                _buildTableCell('Component', bold, isHeader: true),
                _buildTableCell('Match Score', bold, isHeader: true),
                _buildTableCell('Observations', bold, isHeader: true),
              ],
            ),
            // Data rows
            ...components.map((component) {
              return pw.TableRow(
                children: [
                  _buildTableCell(component.name, regular),
                  _buildTableCell(
                    component.matchScore,
                    bold,
                    centered: true,
                  ),
                  _buildTableCell(component.observations, regular, fontSize: 8),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(
    String text,
    pw.Font font, {
    bool isHeader = false,
    bool centered = false,
    double fontSize = 9,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 6.5, vertical: 5.5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          font: font,
          color: PdfColors.grey800,
        ),
        textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  pw.Widget _buildConclusion(
    PdfDataModel data,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Conclusion',
          style: pw.TextStyle(
            fontSize: 12,
            font: bold,
            color: PdfColor.fromInt(0xFF937C49),
          ),
        ),
        pw.SizedBox(height: 6),
        pw.RichText(
          text: pw.TextSpan(
            style: pw.TextStyle(
              fontSize: 10,
              font: regular,
              color: PdfColors.grey800,
            ),
            children: [
              pw.TextSpan(
                text: 'Overall Authenticity Score: ',
                style: pw.TextStyle(color: PdfColor.fromInt(0xFF937C49)),
              ),
              pw.TextSpan(
                text: '${data.conclusion.overallScore.round()}%',
                style: pw.TextStyle(font: bold, fontSize: 11),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 3),
        pw.RichText(
          text: pw.TextSpan(
            style: pw.TextStyle(
              fontSize: 10,
              font: regular,
              color: PdfColors.grey800,
            ),
            children: [
              pw.TextSpan(text: 'Verdict: '),
              pw.TextSpan(
                text: data.conclusion.verdict,
                style: pw.TextStyle(font: bold, fontSize: 11),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 3),
        pw.RichText(
          text: pw.TextSpan(
            style: pw.TextStyle(
              fontSize: 10,
              font: regular,
              color: PdfColors.grey800,
            ),
            children: [
              pw.TextSpan(text: 'Authenticity Level: '),
              pw.TextSpan(
                text: data.conclusion.authenticityLevel,
                style: pw.TextStyle(font: bold, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildExpertNote(
    PdfDataModel data,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Expert Note',
          style: pw.TextStyle(
            fontSize: 11,
            font: bold,
            color: PdfColor.fromInt(0xFF937C49),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          data.expertNote.isNotEmpty ? data.expertNote : 'No expert note available.',
          style: pw.TextStyle(
            fontSize: 8,
            font: regular,
            lineSpacing: 1.3,
            color: PdfColors.grey800,
          ),
          textAlign: pw.TextAlign.justify,
        ),
      ],
    );
  }

  pw.Widget _buildFooter(
    PdfDataModel data,
    pw.Font regular,
    pw.Font bold,
    pw.Font italic,
    PdfColor goldColor,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // QR Code section
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              width: 95,
              height: 95,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1.5),
              ),
              padding: pw.EdgeInsets.all(5),
              child: qrCodeImage != null
                  ? pw.Image(
                      pw.MemoryImage(qrCodeImage!),
                      fit: pw.BoxFit.contain,
                    )
                  : pw.Container(
                      color: PdfColors.white,
                      child: pw.CustomPaint(
                        painter: (PdfGraphics canvas, PdfPoint size) {
                          canvas.setFillColor(PdfColors.black);
                          final cellSize = size.x / 10;
                          for (int i = 0; i < 10; i++) {
                            for (int j = 0; j < 10; j++) {
                              if ((i + j) % 2 == 0) {
                                canvas.drawRect(
                                  i * cellSize,
                                  j * cellSize,
                                  cellSize,
                                  cellSize,
                                );
                                canvas.fillPath();
                              }
                            }
                          }
                        },
                      ),
                    ),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              'Scan to verify this report',
              style: pw.TextStyle(
                fontSize: 7,
                font: regular,
                color: PdfColors.grey700,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),

        pw.SizedBox(width: 13),

        // Disclaimer section
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'This report is generated by AI analysis and is not an official brand certificate. For official certification, contact the manufacturer directly.',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                  lineSpacing: 1.3,
                ),
                textAlign: pw.TextAlign.justify,
              ),

              pw.SizedBox(height: 6.5),

              pw.Text(
                'This report and its contents are intended solely for the recipient. Unauthorized copying, distribution, or disclosure of this report in whole or in part is strictly prohibited. The information contained herein is confidential and may not be used for any purpose other than verifying the authenticity of the submitted watch.',
                style: pw.TextStyle(
                  fontSize: 10,
                  font: regular,
                  color: PdfColors.grey700,
                  lineSpacing: 1.3,
                ),
                textAlign: pw.TextAlign.justify,
              ),

              pw.SizedBox(height: 9),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: pw.TextStyle(
                      fontSize: 8.5,
                      font: regular,
                      color: PdfColors.grey800,
                    ),
                    children: [
                      pw.TextSpan(text: 'Generated by '),
                      pw.TextSpan(
                        text: 'CHRONOVERIFY AI',
                        style: pw.TextStyle(
                          font: bold,
                          color: PdfColor.fromInt(0xFF937C49),
                          letterSpacing: 1,
                        ),
                      ),
                      pw.TextSpan(
                        text: ' on ${data.dateOfIssue}',
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(0xFF937C49),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Download PDF
  Future<void> downloadAsPDF() async {
    try {
      if (!isPdfReady.value) {
        Get.snackbar(
          'Please Wait',
          'Report is still loading...',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.shade100,
        );
        return;
      }

      isDownloading.value = true;

      final pdfDoc = await generatePdfDocument();
      final bytes = await pdfDoc.save();

      final directory = await getApplicationDocumentsDirectory();
      final reportId = reportData.value?.reportId ?? 'UNKNOWN';
      final fileName =
          'ChronoVerify_Report_${reportId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      Get.snackbar(
        'Success',
        'PDF saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        duration: Duration(seconds: 2),
      );

      await Share.shareXFiles([
        XFile(filePath),
      ], text: 'ChronoVerify AI Pre-Expertise Report');

      isDownloading.value = false;
    } catch (e) {
      isDownloading.value = false;
      print('❌ Download error: $e');
      Get.snackbar(
        'Error',
        'Failed to create PDF: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  // Print PDF
  Future<void> printPDF() async {
    try {
      if (!isPdfReady.value) {
        Get.snackbar(
          'Please Wait',
          'Report is still loading...',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.shade100,
        );
        return;
      }

      isDownloading.value = true;

      final pdfDoc = await generatePdfDocument();

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfDoc.save(),
      );

      isDownloading.value = false;
    } catch (e) {
      isDownloading.value = false;
      print('❌ Print error: $e');
      Get.snackbar(
        'Error',
        'Failed to print: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  // Refresh data
  void refreshData() {
    imageCache.clear(); // ✅ Clear cache on refresh
    if (analysisId != null) {
      loadReportData();
    }
  }
}