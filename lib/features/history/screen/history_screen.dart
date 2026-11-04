// lib/features/history/view/history_screen.dart

import 'package:clause_verify/core/utils/constants/app_colors.dart';
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

  static const Color _gold = AppColors.primaryColor;
  static const Color _card = AppColors.surface;
  static const Color _border = AppColors.cardBorder;
  static const Color _red = AppColors.error;
  static const Color _green = AppColors.success;
  static const Color _grey = AppColors.textMuted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                            color: AppColors.textMuted, size: 64.sp),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 16.sp),
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
                              style: TextStyle(
                                  color: AppColors.black,
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
                            color: AppColors.textMuted, size: 64.sp),
                        SizedBox(height: 16.h),
                        Text('noHistoryYet'.tr,
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 16.sp)),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  color: _gold,
                  backgroundColor: AppColors.surfaceLight,
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

  Widget _buildHeader() {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'scanHistory'.tr,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'documentsAnalyzed'.trParams(
                    {'count': controller.totalCount.value.toString()}),
                style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
              ),
            ],
          ),
        ));
  }

  // Card: Title / Subtitle (date · country) / Risk label / Counts line
  // Unread hole top-right corner e "New" badge (card er bhitore)
  Widget _buildHistoryCard(HistoryModel item) {
    // রং শুধু risk_breakdown থেকে ঠিক হওয়া level এর উপর নির্ভর করে
    final Color riskColor = _levelColor(item.level);
    final String subtitle = item.subtitle;
    final String riskLabel = _riskLabel(item);
    final String countsLine = item.countsLine;
    final bool isNew = !item.isRead;

    return GestureDetector(
      onTap: () => controller.navigateToDetails(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            // Unread card er border e halka gold highlight
            color: isNew ? _gold.withOpacity(0.45) : _border,
            width: 1,
          ),
        ),
        // Clip kore dey, tai badge card er rounded corner er sathe mile jay
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left colored bar
                  Container(width: 5.w, color: riskColor),
                  Expanded(
                    child: Padding(
                      // Unread hole upore ektu beshi jayga, jate badge er nichhe title na pore
                      padding: EdgeInsets.fromLTRB(
                        16.w,
                        isNew ? 26.h : 16.w,
                        16.w,
                        16.w,
                      ),
                      child: Row(
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
                                // Title
                                Text(
                                  item.displayTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                // Subtitle
                                if (subtitle.isNotEmpty) ...[
                                  SizedBox(height: 3.h),
                                  Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12.5.sp,
                                    ),
                                  ),
                                ],
                                // Risk level label
                                if (riskLabel.isNotEmpty) ...[
                                  SizedBox(height: 8.h),
                                  _riskBadge(riskLabel, riskColor),
                                ],
                                // Counts line
                                if (countsLine.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    countsLine,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11.5.sp,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: AppColors.textMuted, size: 24.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // "New" badge: top-right corner, card er bhitore
            if (isNew)
              Positioned(
                top: 0,
                right: 0,
                child: _newBadge(),
              ),
          ],
        ),
      ),
    );
  }

  // Amazon-style corner badge: top-right e lege thake, shudhu nicher-bam kon gola
  Widget _newBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _gold,
            _gold.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Top-right ta card er Clip.antiAlias diye nijei gol hoye jabe
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded,
              size: 11.sp, color: AppColors.black),
          SizedBox(width: 4.w),
          Text(
            'newTag'.tr.toUpperCase(),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskBadge(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.h,
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

  // Client's exact label texts
  String _riskLabel(HistoryModel item) {
    switch (item.level) {
      case 'high':
        return 'highRiskClausesFound'.tr;
      case 'medium':
        return 'mediumRiskClausesFound'.tr;
      case 'low':
        return 'noRiskyClausesFound'.tr;
      default:
        return item.overallRisk;
    }
  }

  // high -> red, medium -> gold, low -> green
  Color _levelColor(String level) {
    switch (level) {
      case 'high':
        return _red;
      case 'medium':
        return _gold;
      case 'low':
        return _green;
      default:
        return _grey;
    }
  }
}