import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/features/history/controller/history_controller.dart';
import 'package:flutter_extension/features/history/model/history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  // ✅ Controller কে class-level variable বানান
  final HistoryController controller = Get.put(
    HistoryController(),
    permanent: false,
  );

  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Ensure initialization after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.historyList.isEmpty && !controller.isLoading.value) {
        controller.fetchHistoryData();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                // Show loading indicator
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4A574),
                    ),
                  );
                }

                // Show error message if any
                if (controller.errorMessage.value.isNotEmpty && 
                    controller.historyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.grey[600],
                          size: 64.sp,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () => controller.refreshData(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD4A574),
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Show empty state
                if (controller.historyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.grey[600],
                          size: 64.sp,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'noHistoryYet'.tr,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Show list with pull to refresh
                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  color: Color(0xFFD4A574),
                  backgroundColor: Color(0xFF1A1A1A),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: controller.historyList.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryCard(controller.historyList[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() => Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'myHistory'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${controller.historyList.length} ${'analyses'.tr}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildHistoryCard(HistoryModel item) {
    Color scoreColor = _getScoreColor(item.score);

    return GestureDetector(
      onTap: () => controller.navigateToDetails(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// LEFT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.modelNumber,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: scoreColor.withOpacity(0.15),
                          border: Border.all(
                            color: scoreColor,
                            width: 1.5.w,
                          ),
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: scoreColor,
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${item.score}/100',
                              style: TextStyle(
                                color: scoreColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        item.date,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE BUTTON
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_outward,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) {
      return Color(0xFF10B981);
    } else if (score >= 60) {
      return Color(0xFFF59E0B);
    } else {
      return Color(0xFFEF4444);
    }
  }
}