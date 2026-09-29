import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/history/controller/history_controller.dart';
import 'package:clause_verify/features/history/model/history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController controller = Get.put(
    HistoryController(),
    permanent: false,
  );

  HistoryScreen({Key? key}) : super(key: key);

  static const Color _gold = Color(0xFFD4A574);
  static const Color _card = Color(0xFF141414);
  static const Color _border = Color(0xFF2A2A2A);
  static const Color _red = Color(0xFFE53935);
  static const Color _orange = Color(0xFFFF8F00);
  static const Color _green = Color(0xFF4CAF50);
  static const Color _grey = Color(0xFF888888);

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
                  return const Center(
                    child: CircularProgressIndicator(color: _gold),
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () => controller.refreshData(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _gold,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 12.h),
                          ),
                          child: Text('retry'.tr,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
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
                  color: _gold,
                  backgroundColor: const Color(0xFF1A1A1A),
                  child: ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                              child: const CircularProgressIndicator(
                                color: _gold,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'scanHistory'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'documentsAnalyzed'.trParams(
                    {'count': controller.totalCount.value.toString()}),
                style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
              ),
            ],
          ),
        ));
  }

  // ─────────────────────────────────────────────
  // HISTORY CARD
  // ─────────────────────────────────────────────
  Widget _buildHistoryCard(HistoryModel item) {
    final Color riskColor = _levelColor(item.level);

    return GestureDetector(
      onTap: () => controller.navigateToDetails(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── বাঁ পাশের risk strip ──
              Container(width: 5.w, color: riskColor),

              // ── কনটেন্ট ──
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // উপরে: icon + দেশ + risk badge + তীর
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: riskColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.description_outlined,
                                color: riskColor, size: 22.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.country.isNotEmpty)
                                  Text(
                                    item.country,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.5.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                if (item.overallRisk.isNotEmpty) ...[
                                  SizedBox(height: 5.h),
                                  _riskBadge(item, riskColor),
                                ],
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: Colors.grey[700], size: 24.sp),
                        ],
                      ),

                      // নিচে: recommendation
                      if (item.recommendation.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        _recommendationRow(item),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// "● High Risk" — চেনা না গেলে backend-এর লেখাই ধূসর রঙে
  Widget _riskBadge(HistoryModel item, Color color) {
    final label = _riskLabel(item);

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _recommendationRow(HistoryModel item) {
    final color = _recColor(item.recKind);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(_recIcon(item.recKind), color: color, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _recLabel(item),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  String _riskLabel(HistoryModel item) {
    switch (item.level) {
      case 'high':
        return 'highRisk'.tr;
      case 'medium':
        return 'mediumRisk'.tr;
      case 'low':
        return 'lowRisk'.tr;
      default:
        return item.overallRisk;
    }
  }

String _recLabel(HistoryModel item) {
  switch (item.recKind) {
    case 'accept':
      return 'accept'.tr;
    case 'review':
      return 'legalReviewRequired'.tr; // ✅ আগে ছিল 'legalReview'
    case 'reject':
      return 'reject'.tr;
    default:
      return item.recommendation;
  }
}

  Color _levelColor(String level) {
    switch (level) {
      case 'high':
        return _red;
      case 'medium':
        return _orange;
      case 'low':
        return _green;
      default:
        return _grey;
    }
  }

  Color _recColor(String kind) {
    switch (kind) {
      case 'accept':
        return _green;
      case 'review':
        return _orange;
      case 'reject':
        return _red;
      default:
        return _grey;
    }
  }

  IconData _recIcon(String kind) {
    switch (kind) {
      case 'accept':
        return Icons.check_circle_rounded;
      case 'review':
        return Icons.gavel_rounded;
      case 'reject':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}