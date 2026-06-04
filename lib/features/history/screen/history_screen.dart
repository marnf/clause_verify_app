// lib/features/history/screen/history_screen.dart

import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/features/history/controller/history_controller.dart';
import 'package:flutter_extension/features/history/model/history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController controller = Get.put(
    HistoryController(),
    permanent: false,
  );

  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4A574),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.historyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.grey[600], size: 64.sp),
                        SizedBox(height: 16.h),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () => controller.refreshData(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD4A574),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 12.h),
                          ),
                          child: Text('Retry',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.historyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history,
                            color: Colors.grey[600], size: 64.sp),
                        SizedBox(height: 16.h),
                        Text('noHistoryYet'.tr,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16.sp)),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  color: Color(0xFFD4A574),
                  backgroundColor: Color(0xFF1A1A1A),
                  child: ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: controller.historyList.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.historyList.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: SizedBox(
                              width: 24.sp,
                              height: 24.sp,
                              child: CircularProgressIndicator(
                                color: Color(0xFFD4A574),
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        );
                      }
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

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scan History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${controller.totalCount.value} documents analyzed',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // ─────────────────────────────────────────────
  // HISTORY CARD (Reference Image Design)
  // ─────────────────────────────────────────────
  Widget _buildHistoryCard(HistoryModel item) {
    final bool hasData = item.hasData;
    final Color riskColor = _getRiskColor(item.overallRisk);
    final Color recColor = _getRecColor(item.recommendation);

    return GestureDetector(
      onTap: hasData ? () => controller.navigateToDetails(item) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Color(0xFF141414),
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(
            color: hasData ? Color(0xFF2A2A2A) : Colors.grey[800]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Doc Icon + Title and Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document Icon Container
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: riskColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.description_outlined,
                      color: riskColor,
                      size: 22.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                
                // Title (Country) and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.country ?? 'Analysis Pending',
                        style: TextStyle(
                          color: hasData ? Colors.white : Colors.grey[600],
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item.formattedDate.isNotEmpty ? item.formattedDate : 'Processing...',
                        style: TextStyle(
                          color: hasData ? Colors.grey[500] : Colors.grey[700],
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Middle Section: Score % above Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  hasData ? '${item.confidenceScore}%' : '--%',
                  style: TextStyle(
                    color: hasData ? riskColor : Colors.grey[700],
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.w),
              child: LinearProgressIndicator(
                value: hasData ? (item.confidenceScore! / 100) : 0,
                backgroundColor: Color(0xFF2A2A2A),
                valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                minHeight: 6.h,
              ),
            ),

            SizedBox(height: 16.h),

            // Bottom Section: Recommendation Button + Conditional Download Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (item.recommendation != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: recColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.w),
                      border: Border.all(
                        color: recColor.withOpacity(0.4),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: recColor, size: 14.sp),
                        SizedBox(width: 6.w),
                        Text(
                          _shortenRecommendation(item.recommendation!),
                          style: TextStyle(
                            color: recColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                Spacer(),
                
                // ✅ Download Icon (Only if is_paid_report is "true")
                if (item.isReportPaid)
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                    ),
                    child: Icon(
                      Icons.download_rounded,
                      color: Colors.grey[400],
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HELPER METHODS
  // ─────────────────────────────────────────────
  
  String _shortenRecommendation(String rec) {
    if (rec.toLowerCase().contains('accept')) return 'Accept';
    if (rec.toLowerCase().contains('review')) return 'Legal Review';
    if (rec.toLowerCase().contains('reject') || rec.toLowerCase().contains('refuse')) return 'Reject';
    if (rec.length > 20) return '${rec.substring(0, 17)}...';
    return rec;
  }

  Color _getRiskColor(String? risk) {
    switch (risk?.toLowerCase()) {
      case 'high':
        return const Color(0xFFE53935);
      case 'medium':
        return const Color(0xFFFF8F00);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey[600]!;
    }
  }

  Color _getRecColor(String? rec) {
    if (rec == null) return Colors.grey[600]!;
    final lower = rec.toLowerCase();
    if (lower.contains('accept')) return const Color(0xFF4CAF50);   // Green
    if (lower.contains('review')) return const Color(0xFFFF8F00);   // Orange
    if (lower.contains('reject') || lower.contains('refuse')) return const Color(0xFFE53935); // Red
    return const Color(0xFFB8860B); // Default Gold
  }
}