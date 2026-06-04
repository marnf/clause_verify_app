import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/features/upload/controllers/upload_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploadController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Upload Contract',
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    'Select files to upload for analysis',
                    style: TextStyle(
                      color: AppColors.textSubtle,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'PDF, DOC (1 file) or Images (max 10) • 20MB per file',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ── Dashed Upload Area ──
                  _buildUploadArea(controller),
                  SizedBox(height: 24.h),

                  // ── Selected Files / Images ──
                  Obx(() {
                    if (!controller.hasFiles) return SizedBox.shrink();
                    
                    // Show Image Grid if in Image Mode
                    if (controller.isImageMode) {
                      return _buildImageSection(controller);
                    }
                    
                    // Show Doc List if in Document Mode
                    return _buildDocList(controller);
                  }),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),

          // ══════════════════════════════════════
          //  PINNED BOTTOM: Counter (Only for Images)
          // ══════════════════════════════════════
          Obx(() {
            if (!controller.hasFiles || !controller.isImageMode) return SizedBox.shrink();
            return _buildPinnedCounter(controller);
          }),

          // ══════════════════════════════════════
          //  PINNED BOTTOM: Submit Button
          // ══════════════════════════════════════
          _buildStickySubmitButton(controller),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Dashed Upload Area (Fixed Border)
  // ══════════════════════════════════════
  Widget _buildUploadArea(UploadController controller) {
    return Obx(() {
      final canAdd = controller.canAddMore;

      return GestureDetector(
        onTap: canAdd ? () => controller.browseFiles() : null,
        child: DottedBorder(
          color: canAdd
              ? AppColors.primaryColor.withOpacity(0.6)
              : AppColors.error.withOpacity(0.4),
          strokeWidth: 2,
          dashPattern: [8, 4],
          borderType: BorderType.RRect,
          radius: Radius.circular(16),
          padding: EdgeInsets.all(2), // ✅ Added small padding so border is clearly visible
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 24.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.primaryColor,
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Browse Files',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Tap to select files from your device',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(() {
                    final count = controller.selectedFiles.length;
                    final max = controller.effectiveMaxFiles;
                    final typeStr = controller.isDocumentMode.value == true ? 'document' : 'files';
                    return Text(
                      '$count/$max $typeStr',
                      style: TextStyle(
                        color: AppColors.textSubtle,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ══════════════════════════════════════
  //  Image Section (Grid + Header)
  // ══════════════════════════════════════
  Widget _buildImageSection(UploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Images',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => controller.clearAll(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.error.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildImageGrid(controller),
      ],
    );
  }

  // ══════════════════════════════════════
  //  Image Grid (2 per row, like Camera)
  // ══════════════════════════════════════
  Widget _buildImageGrid(UploadController controller) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: List.generate(
        controller.selectedFiles.length,
        (index) => _buildImageItem(controller, index),
      ),
    );
  }

  Widget _buildImageItem(UploadController controller, int index) {
    double itemWidth = (Get.width - 48.w - 10.w) / 2;
    double itemHeight = itemWidth * 1.3;

    return SizedBox(
      width: itemWidth,
      height: itemHeight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                controller.selectedFiles[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                'Page ${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => controller.removeFile(index),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Doc List (Standard File View)
  // ══════════════════════════════════════
  Widget _buildDocList(UploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Document',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => controller.clearAll(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.error.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDocItem(controller, 0),
      ],
    );
  }

  Widget _buildDocItem(UploadController controller, int index) {
    final fileName = controller.fileNames[index];
    final fileSize = controller.fileSizes[index];
    final fileIcon = controller.getFileIcon(fileName);
    final fileColor = controller.getFileColor(fileName);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: fileColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(fileIcon, color: fileColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  controller.formatFileSize(fileSize),
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.removeFile(index),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.error,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Pinned Counter (Same as Camera Screen)
  // ══════════════════════════════════════
  Widget _buildPinnedCounter(UploadController controller) {
    final count = controller.selectedFiles.length;
    final total = controller.effectiveMaxFiles; // Will be 10 for images
    final remaining = controller.remainingSlots;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count of $total photos added',
            style: TextStyle(
              color: AppColors.textSubtle,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          if (remaining > 0)
            Text(
              '$remaining remaining',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'MAX',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Sticky Submit Button
  // ══════════════════════════════════════
  Widget _buildStickySubmitButton(UploadController controller) {
    return Obx(() {
      final hasFiles = controller.hasFiles;
      final isUploading = controller.isUploading.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
        color: AppColors.background,
        child: GestureDetector(
          onTap: (hasFiles && !isUploading)
              ? () => controller.submitForAnalysis()
              : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: (hasFiles && !isUploading)
                  ? AppColors.primaryColor
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: isUploading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Uploading...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Submit for Analysis',
                      style: TextStyle(
                        color: (hasFiles) ? Colors.black : AppColors.textMuted,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}