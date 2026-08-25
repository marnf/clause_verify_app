// lib/screens/analysis_result_screen.dart

import 'package:flutter/material.dart';
import 'package:clause_verify/features/analysis/controller/analysis_result_controller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
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
  Widget _buildSliverAppBar(AnalysisResultController controller) {
    return SliverAppBar(
      expandedHeight: 130.h,
      pinned: true,
      toolbarHeight: 70.h,
      backgroundColor: const Color(0xFF0A0A0A),
      surfaceTintColor: Colors.transparent,
      leadingWidth: 56.w,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Center(
          child: Icon(Icons.arrow_back_ios_new_rounded, color: const Color(0xFFB8860B), size: 20.sp),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final top = MediaQuery.of(context).padding.top;
          final currentHeight = constraints.maxHeight - top;
          final collapsedHeight = 70.h; 
          
          double expandRatio;
          if (currentHeight <= collapsedHeight) {
            expandRatio = 0.0;
          } else {
            expandRatio = ((currentHeight - collapsedHeight) / (130.h - collapsedHeight)).clamp(0.0, 1.0);
          }

          final double titleFontSize = 18.sp + 8.sp * expandRatio;
          final double subtitleFontSize = 10.sp + 3.sp * expandRatio;
          final double leftPadding = 56.w - 36.w * expandRatio; 
          final double yAlignment = 0.0 + 0.6 * expandRatio; 

          return Padding(
            padding: EdgeInsets.only(left: leftPadding, right: 20.w, top: top),
            child: Align(
              alignment: Alignment(-1.0, yAlignment), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'analysisResults'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize, 
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${'confidence'.tr}: ${controller.confidenceScore}% · ${controller.country} · ${controller.totalPages} ${'pages'.tr}',
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: subtitleFontSize,
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
          // ✅ Confidence Score & Risk Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('confidenceScore'.tr, style: TextStyle(color: const Color(0xFF888888), fontSize: 12.sp)),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${controller.confidenceScore}', style: TextStyle(color: const Color(0xFFB8860B), fontSize: 48.sp, fontWeight: FontWeight.w800, height: 1)),
                      Text('%', style: TextStyle(color: const Color(0xFFB8860B), fontSize: 20.sp, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              _buildOverallRiskBadge(controller.overallRiskLabel, riskColor),
            ],
          ),
          SizedBox(height: 12.h),
          
          // ✅ Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: controller.confidenceScore / 100,
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
              minHeight: 4.h,
            ),
          ),
          SizedBox(height: 16.h),
          
          // ✅ Date & Pages Info
          if (controller.createdAt.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, color: const Color(0xFF666666), size: 12.sp),
                  SizedBox(width: 6.w),
                  Text('${'analyzedOn'.tr} ${controller.formattedDate}', style: TextStyle(color: const Color(0xFF666666), fontSize: 11.sp)),
                ],
              ),
            ),

          // ✅ Recommendation Box
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1500),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFB8860B).withOpacity(0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: const Color(0xFFB8860B), size: 14.sp),
                    SizedBox(width: 6.w),
                    Expanded(child: Text(controller.recommendation, style: TextStyle(color: const Color(0xFFD4A017), fontSize: 13.sp, fontWeight: FontWeight.w700))),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  controller.recommendationGuidance, 
                  style: TextStyle(color: const Color(0xFF999999), fontSize: 11.5.sp, height: 1.5)
                ),
              ],
            ),
          ),
          
          // ✅ View PDF Button
          SizedBox(height: 16.h),
          Obx(() => _buildViewPdfButton(controller)),
        ],
      ),
    );
  }

  Widget _buildViewPdfButton(AnalysisResultController controller) {
    return GestureDetector(
      onTap: controller.isGeneratingPdf.value ? null : controller.generatePdfReport,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: controller.isGeneratingPdf.value ? const Color(0xFFB8860B).withOpacity(0.5) : const Color(0xFFB8860B),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: controller.isGeneratingPdf.value
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf_rounded, color: Colors.black, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text('viewPdfReport'.tr, style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                  ],
                ),
        ),
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
      child: Text(label.toUpperCase(), style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
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
        _buildRiskBox('highRisk'.tr, rb.highRisk, const Color(0xFFE53935)),
        SizedBox(width: 10.w),
        _buildRiskBox('mediumRisk'.tr, rb.mediumRisk, const Color(0xFFFF8F00)),
        SizedBox(width: 10.w),
        _buildRiskBox('lowRisk'.tr, rb.lowRisk, const Color(0xFF2E7D32)),
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
            Text('$count', style: TextStyle(color: color, fontSize: 26.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: 4.h),
            Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 10.sp, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
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
        _buildSectionTitle('positiveFindings'.tr, Icons.check_circle_outline_rounded),
        SizedBox(height: 12.h),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1A0D),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: controller.positivePoints.asMap().entries.map((entry) {
              final isLast = entry.key == controller.positivePoints.length - 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 2.h), child: Icon(Icons.check_circle_rounded, color: const Color(0xFF4CAF50), size: 15.sp)),
                      SizedBox(width: 10.w),
                      Expanded(child: Text(entry.value, style: TextStyle(color: const Color(0xFFCCCCCC), fontSize: 12.5.sp, height: 1.5))),
                    ],
                  ),
                  if (!isLast) ...[
                    SizedBox(height: 8.h),
                    Divider(color: const Color(0xFF2E7D32).withOpacity(0.15), height: 1),
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
  // TERMS HEADER & FILTERS
  // ─────────────────────────────────────────────
  Widget _buildTermsHeader(AnalysisResultController controller) {
    return Row(
      children: [
        _buildSectionTitle('clauseAnalysis'.tr, Icons.document_scanner_rounded),
        const Spacer(),
        Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(color: const Color(0xFFB8860B).withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: Text('${controller.filteredTerms.length} ${'clauses'.tr}', style: TextStyle(color: const Color(0xFFB8860B), fontSize: 11.sp, fontWeight: FontWeight.w600)),
            )),
      ],
    );
  }

  Widget _buildFilterTabs(AnalysisResultController controller) {
    final filters = [
      {'key': 'all', 'label': 'all'.tr},
      {'key': 'high', 'label': 'high'.tr},
      {'key': 'medium', 'label': 'medium'.tr},
      {'key': 'low', 'label': 'low'.tr},
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isActive ? color.withOpacity(0.18) : const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isActive ? color.withOpacity(0.5) : const Color(0xFF2A2A2A), width: 1),
                ),
                child: Text(f['label'] ?? '', style: TextStyle(color: isActive ? color : const Color(0xFF666666), fontSize: 11.5.sp, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
              ),
            );
          }).toList(),
        ));
  }

  // ─────────────────────────────────────────────
  // TERMS LIST & CARDS
  // ─────────────────────────────────────────────
  Widget _buildTermsList(AnalysisResultController controller) {
    return Obx(() {
      final terms = controller.filteredTerms;
      if (terms.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(child: Column(children: [Icon(Icons.search_off_rounded, color: const Color(0xFF444444), size: 40.sp), SizedBox(height: 12.h), Text('noClausesFound'.tr, style: TextStyle(color: const Color(0xFF555555), fontSize: 13.sp))])),
        );
      }
      return Column(children: terms.asMap().entries.map((entry) => _buildTermCard(controller, entry.value, entry.key)).toList());
    });
  }

  Widget _buildTermCard(AnalysisResultController controller, ImportantTerm term, int index) {
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
            border: Border.all(color: isExpanded ? statusColor.withOpacity(0.4) : const Color(0xFF2A2A2A), width: 1),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(width: 36.w, height: 36.w, decoration: BoxDecoration(color: statusColor.withOpacity(0.12), shape: BoxShape.circle, border: Border.all(color: statusColor.withOpacity(0.3), width: 1)), child: Icon(statusIcon, color: statusColor, size: 16.sp)),
                    SizedBox(width: 12.w),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(term.termTitle, style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)), if (!isExpanded) ...[SizedBox(height: 3.h), Text(term.extractedText, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: const Color(0xFF666666), fontSize: 11.sp))]])),
                    SizedBox(width: 8.w),
                    AnimatedRotation(turns: isExpanded ? 0.5 : 0, duration: const Duration(milliseconds: 250), child: Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF555555), size: 20.sp)),
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
                      
                      if (term.lawReference.isNotEmpty) _buildLawReference(term.lawReference, const Color(0xFFB8860B)),
                      SizedBox(height: 12.h),
                      
                      _buildExpandedSection('fullText'.tr, term.extractedText, const Color(0xFFAAAAAA), Icons.format_quote_rounded, isQuote: true),
                      SizedBox(height: 12.h),
                      _buildExpandedSection('aiExplanation'.tr, term.aiExplanation, const Color(0xFFCCCCCC), Icons.psychology_rounded),
                      SizedBox(height: 12.h),
                      _buildExpandedSection('recommendation'.tr, term.aiRecommendation, statusColor, Icons.tips_and_updates_rounded, accentColor: statusColor),
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

  // ✅ লং টেক্সটের জন্য ল রেফারেন্স উইজেট (যেমন: Contract Act 1872...)
  Widget _buildLawReference(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Icon(Icons.gavel_rounded, color: color, size: 14.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSection(String title, String content, Color textColor, IconData icon, {Color? accentColor, bool isQuote = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, color: accentColor ?? const Color(0xFF888888), size: 13.sp), SizedBox(width: 5.w), Text(title, style: TextStyle(color: accentColor ?? const Color(0xFF888888), fontSize: 11.sp, fontWeight: FontWeight.w700, letterSpacing: 0.3))]),
        SizedBox(height: 6.h),
        if (isQuote)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8), border: Border(left: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.5), width: 2))),
            child: Text(content, style: TextStyle(color: textColor, fontSize: 11.5.sp, height: 1.6, fontStyle: FontStyle.italic)),
          )
        else
          Text(content, style: TextStyle(color: textColor, fontSize: 12.sp, height: 1.6)),
      ],
    );
  }

  Widget _buildConfidenceBar(int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('clauseConfidence'.tr, style: TextStyle(color: const Color(0xFF666666), fontSize: 10.sp)), Text('$score%', style: TextStyle(color: const Color(0xFFB8860B), fontSize: 10.sp, fontWeight: FontWeight.w700))]),
        SizedBox(height: 4.h),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: score / 100, backgroundColor: const Color(0xFF2A2A2A), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)), minHeight: 3.h)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(children: [Icon(icon, color: const Color(0xFFB8860B), size: 16.sp), SizedBox(width: 7.w), Text(title, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700))]);
  }

  Color _statusColor(String status) {
    switch (status) { case 'red': return const Color(0xFFE53935); case 'warning': return const Color(0xFFFF8F00); case 'green': return const Color(0xFF4CAF50); default: return const Color(0xFF888888); }
  }

  IconData _statusIcon(String status) {
    switch (status) { case 'red': return Icons.warning_rounded; case 'warning': return Icons.info_rounded; case 'green': return Icons.check_circle_rounded; default: return Icons.help_rounded; }
  }

  Color _overallRiskColor(String risk) {
    switch (risk.toLowerCase()) { case 'high': return const Color(0xFFE53935); case 'medium': return const Color(0xFFFF8F00); case 'low': return const Color(0xFF4CAF50); default: return const Color(0xFFB8860B); }
  }

  Color _filterColor(String key) {
    switch (key) { case 'high': return const Color(0xFFE53935); case 'medium': return const Color(0xFFFF8F00); case 'low': return const Color(0xFF4CAF50); default: return const Color(0xFFB8860B); }
  }
}