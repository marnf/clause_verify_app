import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/features/camera/controllers/camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CameraScreen extends StatelessWidget {
  CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CameraController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Scan Contract',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ══════════════════════════════════════
          //  1. SCROLLABLE: Buttons, Header & Grid
          // ══════════════════════════════════════
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  
                  // ── Action Buttons ──
                  _buildActionButtons(controller),
                  SizedBox(height: 24.h),

                  // ── Header & Empty State / Grid ──
                  Obx(() {
                    if (!controller.hasPhotos) {
                      return _buildEmptyState();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(controller),
                        SizedBox(height: 12.h),
                        _buildPhotoGrid(controller),
                      ],
                    );
                  }),

                  // Extra space so grid doesn't hide behind the fixed bottom button
                  SizedBox(height: 100.h), 
                ],
              ),
            ),
          ),

          // ══════════════════════════════════════
          //  2. PINNED BOTTOM: Counter
          // ══════════════════════════════════════
          Obx(() {
            if (!controller.hasPhotos) return SizedBox.shrink();
            return _buildPinnedCounter(controller);
          }),

          // ══════════════════════════════════════
          //  3. PINNED BOTTOM: Submit Button
          // ══════════════════════════════════════
          _buildStickySubmitButton(controller),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Compact Action Buttons (Camera + Gallery)
  // ══════════════════════════════════════
  Widget _buildActionButtons(CameraController controller) {
    return Obx(() {
      final canAdd = controller.canAddMore;

      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: canAdd ? () => controller.takePhoto() : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: canAdd
                      ? AppColors.primaryColor
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: canAdd
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      color: canAdd ? Colors.black : AppColors.textMuted,
                      size: 28.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Take Photo',
                      style: TextStyle(
                        color: canAdd ? Colors.black : AppColors.textMuted,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: canAdd ? () => controller.pickFromGallery() : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: canAdd
                        ? AppColors.primaryColor.withOpacity(0.5)
                        : AppColors.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_rounded,
                      color:
                          canAdd ? AppColors.primaryColor : AppColors.textMuted,
                      size: 28.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'From Gallery',
                      style: TextStyle(
                        color:
                            canAdd ? AppColors.primaryColor : AppColors.textMuted,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ══════════════════════════════════════
  //  Header (Selected Photos + Clear All)
  // ══════════════════════════════════════
  Widget _buildHeader(CameraController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Selected Photos',
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
    );
  }

  // ══════════════════════════════════════
  //  Empty State
  // ══════════════════════════════════════
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Icon(
              Icons.add_a_photo_outlined,
              color: AppColors.textMuted,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No photos yet',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Use the buttons above to photograph\nor upload your contract pages.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Photo Grid (2 per row)
  // ══════════════════════════════════════
  Widget _buildPhotoGrid(CameraController controller) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: List.generate(
        controller.capturedPhotos.length,
        (index) => _buildPhotoItem(controller, index),
      ),
    );
  }

  Widget _buildPhotoItem(CameraController controller, int index) {
    double itemWidth = (Get.width - 48.w - 10.w) / 2;
    double itemHeight = itemWidth * 1.3; // Slightly taller for contracts

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
                controller.capturedPhotos[index],
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
              onTap: () => controller.removePhoto(index),
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
  //  Pinned Counter (Compact)
  // ══════════════════════════════════════
  Widget _buildPinnedCounter(CameraController controller) {
    final count = controller.capturedPhotos.length;
    final total = CameraController.maxPhotos;
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
  Widget _buildStickySubmitButton(CameraController controller) {
    return Obx(() {
      final hasPhotos = controller.hasPhotos;
      final isUploading = controller.isUploading.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
        color: AppColors.background,
        child: GestureDetector(
          onTap: (hasPhotos && !isUploading)
              ? () => controller.submitForAnalysis()
              : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: (hasPhotos && !isUploading)
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
                          width: 16,
                          height: 16,
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
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Submit for Analysis',
                      style: TextStyle(
                        color: (hasPhotos) ? Colors.black : AppColors.textMuted,
                        fontSize: 15.sp,
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