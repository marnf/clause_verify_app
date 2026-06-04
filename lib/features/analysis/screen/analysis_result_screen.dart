// lib/screens/analysis_result_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_extension/features/analysis/controller/analysis_result_controller.dart';
import 'package:flutter_extension/features/analysis/model/analysis_result_model.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({super.key});

  @override
Widget build(BuildContext context) {
  final controller = Get.find<AnalysisResultController>();
  
  return Scaffold(
    backgroundColor: const Color(0xFF0A0A0A),
    body: _buildBody(controller),
  );
}

  Widget _buildBody(AnalysisResultController controller) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(controller),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                _buildSummaryCard(controller),
                SizedBox(height: 24.h),
                _buildRiskBreakdownRow(controller),
                SizedBox(height: 24.h),
                if (controller.positivePoints.isNotEmpty) ...[
                  _buildPositivePointsSection(controller),
                  SizedBox(height: 24.h),
                ],
                _buildTermsHeader(controller),
                SizedBox(height: 12.h),
                _buildFilterTabs(controller),
                SizedBox(height: 16.h),
                _buildTermsList(controller),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SLIVER APP BAR
  // ─────────────────────────────────────────────
    // ─────────────────────────────────────────────
  // SLIVER APP BAR (Premium Shrink Animation)
  // ─────────────────────────────────────────────
   // ─────────────────────────────────────────────
  // SLIVER APP BAR (Increased Subtitle Size)
  // ─────────────────────────────────────────────
  Widget _buildSliverAppBar(AnalysisResultController controller) {
    return SliverAppBar(
      expandedHeight: 130.h,
      pinned: true,
      toolbarHeight: 70.h, // টেক্সট বড় করার কারণে ছোট অ্যাপ বারের হাইট ২ পিক্সেল বাড়ানো হয়েছে
      backgroundColor: const Color(0xFF0A0A0A),
      surfaceTintColor: Colors.transparent,
      leadingWidth: 56.w,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFFB8860B),
            size: 20.sp,
          ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final top = MediaQuery.of(context).padding.top;
          final currentHeight = constraints.maxHeight - top;
          final collapsedHeight = 70.h; 
          
          // 1.0 = পুরো খোলা, 0.0 = পুরো উপরে স্ক্রল করা (ছোট)
          double expandRatio;
          if (currentHeight <= collapsedHeight) {
            expandRatio = 0.0;
          } else {
            expandRatio = ((currentHeight - collapsedHeight) / (130.h - collapsedHeight)).clamp(0.0, 1.0);
          }

          // টাইটেল সাইজ অ্যানিমেশন: ছোট অবস্থায় 18.sp, বড় অবস্থায় 26.sp
          final double titleFontSize = 18.sp + 8.sp * expandRatio;
          
          // ✅ সাব-টাইটেল সাইজ অ্যানিমেশন বাড়ানো হয়েছে: ছোট অবস্থায় 10.sp, বড় অবস্থায় 13.sp
          final double subtitleFontSize = 10.sp + 3.sp * expandRatio;

          // ডানদিকে সরানোর অ্যানিমেশন
          final double leftPadding = 56.w - 36.w * expandRatio; 

          // ভার্টিক্যাল অ্যালাইনমেন্ট: ছোট অবস্থায় Center (0.0), বড় অবস্থায় উপরে (0.6)
          final double yAlignment = 0.0 + 0.6 * expandRatio; 

          return Padding(
            padding: EdgeInsets.only(
              left: leftPadding,
              right: 20.w,
              top: top,
            ),
            child: Align(
              alignment: Alignment(-1.0, yAlignment), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Analysis Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize, 
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2.h), // টেক্সট দুটোর মাঝে সামান্য গ্যাপ বাড়ানো হয়েছে
                  Text(
                    'AI confidence: ${controller.confidenceScore}% · ${controller.country}',
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: subtitleFontSize, // ✅ এখানে ডাইনামিক বড় সাইজ ব্যবহার করা হচ্ছে
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SUMMARY CARD
  // ─────────────────────────────────────────────
  Widget _buildSummaryCard(AnalysisResultController controller) {
    final riskColor = _overallRiskColor(controller.overallRiskLabel);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confidence Score',
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${controller.confidenceScore}',
                        style: TextStyle(
                          color: const Color(0xFFB8860B),
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                          color: const Color(0xFFB8860B),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              _buildOverallRiskBadge(controller.overallRiskLabel, riskColor),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: controller.confidenceScore / 100,
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
              minHeight: 4.h,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1500),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xFFB8860B).withOpacity(0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        color: const Color(0xFFB8860B), size: 14.sp),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        controller.recommendation,
                        style: TextStyle(
                          color: const Color(0xFFD4A017),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  controller.recommendationGuidance,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontSize: 11.5.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRiskBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // RISK BREAKDOWN ROW
  // ─────────────────────────────────────────────
  Widget _buildRiskBreakdownRow(AnalysisResultController controller) {
    final rb = controller.riskBreakdown;
    if (rb == null) return const SizedBox.shrink();
    return Row(
      children: [
        _buildRiskBox('High Risk', rb.highRisk, const Color(0xFFE53935)),
        SizedBox(width: 10.w),
        _buildRiskBox('Medium Risk', rb.mediumRisk, const Color(0xFFFF8F00)),
        SizedBox(width: 10.w),
        _buildRiskBox('Low Risk', rb.lowRisk, const Color(0xFF2E7D32)),
      ],
    );
  }

  Widget _buildRiskBox(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25), width: 1),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // POSITIVE POINTS
  // ─────────────────────────────────────────────
  Widget _buildPositivePointsSection(AnalysisResultController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            'Positive Findings', Icons.check_circle_outline_rounded),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1A0D),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF2E7D32).withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: controller.positivePoints.asMap().entries.map((entry) {
              final isLast =
                  entry.key == controller.positivePoints.length - 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF4CAF50),
                          size: 15.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: const Color(0xFFCCCCCC),
                            fontSize: 12.5.sp,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    SizedBox(height: 8.h),
                    Divider(
                        color: const Color(0xFF2E7D32).withOpacity(0.15),
                        height: 1),
                    SizedBox(height: 8.h),
                  ],
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // TERMS HEADER
  // ─────────────────────────────────────────────
  Widget _buildTermsHeader(AnalysisResultController controller) {
    return Row(
      children: [
        _buildSectionTitle('Clause Analysis', Icons.document_scanner_rounded),
        const Spacer(),
        Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFB8860B).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${controller.filteredTerms.length} clauses',
                style: TextStyle(
                  color: const Color(0xFFB8860B),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // FILTER TABS
  // ─────────────────────────────────────────────
  Widget _buildFilterTabs(AnalysisResultController controller) {
    final filters = [
      {'key': 'all', 'label': 'All'},
      {'key': 'high', 'label': 'High'},
      {'key': 'medium', 'label': 'Medium'},
      {'key': 'low', 'label': 'Low'},
    ];

    return Obx(() => Row(
          children: filters.map((f) {
            final isActive = controller.activeFilter.value == f['key'];
            final color = _filterColor(f['key'] ?? 'all');
            return GestureDetector(
              onTap: () => controller.setFilter(f['key'] ?? 'all'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: 8.w),
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withOpacity(0.18)
                      : const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? color.withOpacity(0.5)
                        : const Color(0xFF2A2A2A),
                    width: 1,
                  ),
                ),
                child: Text(
                  f['label'] ?? '',
                  style: TextStyle(
                    color: isActive ? color : const Color(0xFF666666),
                    fontSize: 11.5.sp,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  // ─────────────────────────────────────────────
  // TERMS LIST
  // ─────────────────────────────────────────────
  Widget _buildTermsList(AnalysisResultController controller) {
    return Obx(() {
      final terms = controller.filteredTerms;
      if (terms.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.search_off_rounded,
                    color: const Color(0xFF444444), size: 40.sp),
                SizedBox(height: 12.h),
                Text(
                  'No clauses found for this filter',
                  style: TextStyle(
                      color: const Color(0xFF555555), fontSize: 13.sp),
                ),
              ],
            ),
          ),
        );
      }
      return Column(
        children: terms.asMap().entries.map((entry) {
          return _buildTermCard(controller, entry.value, entry.key);
        }).toList(),
      );
    });
  }

  Widget _buildTermCard(
      AnalysisResultController controller, ImportantTerm term, int index) {
    final statusColor = _statusColor(term.status);
    final statusIcon = _statusIcon(term.status);

    return Obx(() {
      final isExpanded = controller.isExpanded(index);
      return GestureDetector(
        onTap: () => controller.toggleExpand(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isExpanded
                  ? statusColor.withOpacity(0.4)
                  : const Color(0xFF2A2A2A),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: statusColor.withOpacity(0.3), width: 1),
                      ),
                      child: Icon(statusIcon,
                          color: statusColor, size: 16.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            term.termTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (!isExpanded) ...[
                            SizedBox(height: 3.h),
                            Text(
                              term.extractedText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF666666),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF555555),
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                Container(
                  padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: const Color(0xFF2A2A2A), height: 1),
                      SizedBox(height: 14.h),
                      if (term.lawReference.isNotEmpty)
                        _buildChip(Icons.gavel_rounded, term.lawReference,
                            const Color(0xFFB8860B)),
                      SizedBox(height: 12.h),
                      _buildExpandedSection(
                        'Full Text',
                        term.extractedText,
                        const Color(0xFFAAAAAA),
                        Icons.format_quote_rounded,
                        isQuote: true,
                      ),
                      SizedBox(height: 12.h),
                      _buildExpandedSection(
                        'AI Explanation',
                        term.aiExplanation,
                        const Color(0xFFCCCCCC),
                        Icons.psychology_rounded,
                      ),
                      SizedBox(height: 12.h),
                      _buildExpandedSection(
                        'Recommendation',
                        term.aiRecommendation,
                        statusColor,
                        Icons.tips_and_updates_rounded,
                        accentColor: statusColor,
                      ),
                      SizedBox(height: 10.h),
                      _buildConfidenceBar(term.confidenceScore),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSection(
    String title,
    String content,
    Color textColor,
    IconData icon, {
    Color? accentColor,
    bool isQuote = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                color: accentColor ?? const Color(0xFF888888), size: 13.sp),
            SizedBox(width: 5.w),
            Text(
              title,
              style: TextStyle(
                color: accentColor ?? const Color(0xFF888888),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        if (isQuote)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                    color: const Color(0xFFB8860B).withOpacity(0.5),
                    width: 2),
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: textColor,
                fontSize: 11.5.sp,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Text(
            content,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
              height: 1.6,
            ),
          ),
      ],
    );
  }

  Widget _buildConfidenceBar(int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clause Confidence',
              style:
                  TextStyle(color: const Color(0xFF666666), fontSize: 10.sp),
            ),
            Text(
              '$score%',
              style: TextStyle(
                color: const Color(0xFFB8860B),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: const Color(0xFF2A2A2A),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
            minHeight: 3.h,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFB8860B), size: 16.sp),
        SizedBox(width: 7.w),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'red':
        return const Color(0xFFE53935);
      case 'warning':
        return const Color(0xFFFF8F00);
      case 'green':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF888888);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'red':
        return Icons.warning_rounded;
      case 'warning':
        return Icons.info_rounded;
      case 'green':
        return Icons.check_circle_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  Color _overallRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return const Color(0xFFE53935);
      case 'medium':
        return const Color(0xFFFF8F00);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFFB8860B);
    }
  }

  Color _filterColor(String key) {
    switch (key) {
      case 'high':
        return const Color(0xFFE53935);
      case 'medium':
        return const Color(0xFFFF8F00);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFFB8860B);
    }
  }
}