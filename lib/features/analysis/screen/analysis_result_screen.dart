

import 'package:flutter/material.dart';
import 'package:clause_verify/features/analysis/controller/analysis_result_controller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({super.key});

  static const Color _bg = AppColors.background;
  static const Color _card = AppColors.surface;
  static const Color _border = AppColors.cardBorder;
  static const Color _gold = AppColors.primaryColor;
  static const Color _red = AppColors.error;
  static const Color _orange = AppColors.warning;
  static const Color _green = AppColors.success;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AnalysisResultController>();

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(c, context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildVerdictCard(c),
                  _buildOverviewSection(c),
                  if (c.positivePoints.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    _buildPositivePoints(c),
                  ],
                  if (c.allTerms.isNotEmpty) ...[
                    SizedBox(height: 28.h),
                    _buildTermsHeader(c),
                    SizedBox(height: 12.h),
                    _buildFilterTabs(c),
                    SizedBox(height: 14.h),
                    _buildTermsList(c),
                  ],
                  if (c.missingTerms.isNotEmpty) ...[
                    SizedBox(height: 28.h),
                    _buildMissingSection(c),
                  ],
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AnalysisResultController c, BuildContext context) {
  // 👈 Point 2: "1 Pages" becomes "1 page" (singular when 1)
  final subtitleParts = <String>[
    if (c.country.isNotEmpty) c.country,
    if (c.totalPages > 0) '${c.totalPages} ${c.totalPages == 1 ? 'page'.tr : 'pages'.tr}',
  ];
  final bool hasSub = subtitleParts.isNotEmpty;

  final double topPad = MediaQuery.of(context).padding.top;
  final double toolbarH = 70.h;
  final double circle = 40.w;
  final double bigFont = 26.sp;
  final double smallFont = 20.sp;
  final double subFont = 12.sp;
  final double gap = 2.h;

  final double backTop = topPad + (toolbarH - circle) / 2;
  final double expTitleTop = backTop + circle + 10.h;
  final double expBlockH =
      bigFont * 1.2 + (hasSub ? gap + subFont * 1.3 : 0);
  final double expandedH = (expTitleTop - topPad) + expBlockH + 14.h;

  final double colBlockH =
      smallFont * 1.2 + (hasSub ? gap + subFont * 1.3 : 0);
  final double colTitleTop = topPad + (toolbarH - colBlockH) / 2;

  final double leftExpanded = 20.w;
  final double leftCollapsed = 20.w + circle + 12.w;

  final double maxExtent = topPad + expandedH;
  final double minExtent = topPad + toolbarH;

  return SliverAppBar(
    pinned: true,
    toolbarHeight: toolbarH,
    expandedHeight: expandedH,
    backgroundColor: _bg,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false,
    flexibleSpace: LayoutBuilder(
      builder: (context, constraints) {
        final double t =
            (1 - (constraints.maxHeight - minExtent) / (maxExtent - minExtent))
                .clamp(0.0, 1.0);
        final double eased = Curves.easeInOut.transform(t);

        final double titleLeft =
            leftExpanded + (leftCollapsed - leftExpanded) * eased;
        final double titleTop = expTitleTop + (colTitleTop - expTitleTop) * eased;
        final double fontSize = bigFont + (smallFont - bigFont) * eased;

        return Container(
          color: _bg,
          child: Stack(
            children: [
              Positioned(
                left: 20.w,
                top: backTop,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.back(),
                  child: Container(
                    width: circle,
                    height: circle,
                                        decoration: BoxDecoration(
                      color: AppColors.navy,
                      shape: BoxShape.circle,
                      border: Border.all(color: _border, width: 1),
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: _gold, size: 18.sp),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: titleLeft,
                top: titleTop,
                right: 20.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'analysisResults'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    if (hasSub) ...[
                      SizedBox(height: gap),
                      Text(
                        subtitleParts.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: subFont,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

   Widget _buildVerdictCard(AnalysisResultController c) {
    final level = _normalizeLevel(c.overallRisk);
    final color = _levelColor(level);
    final hasRisk = c.overallRisk.isNotEmpty;
    final hasGuidance = c.recommendationGuidance.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.35), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasRisk)
            Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_levelIcon(level), color: color, size: 28.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    _riskLabel(c.overallRisk),
                    style: TextStyle(
                        color: color,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1),
                  ),
                ),
              ],
            ),
          if (hasGuidance) ...[ 
            SizedBox(height: hasRisk ? 16.h : 0),
            Text(c.recommendationGuidance,
                style: TextStyle(
                    color: AppColors.cream,
                    fontSize: 12.5.sp,
                    height: 1.55)),
          ],
          if (c.createdAt.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: AppColors.textMuted, size: 12.sp),
                SizedBox(width: 6.w),
                Text('${'analyzedOn'.tr} ${c.formattedDate}',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 11.sp)),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          Obx(() => _buildViewPdfButton(c)),
        ],
      ),
    );
  }

  Widget _buildViewPdfButton(AnalysisResultController c) {
    final bool isBusy = c.isGeneratingPdf.value;
    final bool isLocked = c.isPdfLocked;
    final Color contentColor = isLocked ? _gold : AppColors.black;

    return GestureDetector(
      onTap: isBusy ? null : c.onPdfButtonTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isLocked
              ? AppColors.surfaceLight
              : (isBusy ? _gold.withOpacity(0.5) : _gold),
          borderRadius: BorderRadius.circular(10),
          border: isLocked
              ? Border.all(color: _gold.withOpacity(0.6), width: 1)
              : null,
        ),
        child: Center(
          child: isBusy
              ? SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.black))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        isLocked
                            ? Icons.lock_rounded
                            : Icons.picture_as_pdf_rounded,
                        color: contentColor,
                        size: 18.sp),
                    SizedBox(width: 8.w),
                    Text('viewPdfReport'.tr,
                        style: TextStyle(
                            color: contentColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection(AnalysisResultController c) {
    final high = c.countOfLevel('high');
    final medium = c.countOfLevel('medium');
    final low = c.countOfLevel('low');
    final found = c.foundCount;
    final missing = c.missingCount;

    if (found == 0 && missing == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (found > 0) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$found',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          height: 1)),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text('clausesFound'.tr,
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 10.h,
                  child: Row(
                    children: [
                      if (high > 0)
                        Expanded(flex: high, child: Container(color: _red)),
                      if (medium > 0)
                        Expanded(
                            flex: medium, child: Container(color: _orange)),
                      if (low > 0)
                        Expanded(flex: low, child: Container(color: _green)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  _riskLegend('highRisk'.tr, high, _red),
                  _riskLegend('mediumRisk'.tr, medium, _orange),
                  // 👈 Point 1: Replace "Low Risk" with "Standard" in the summary
                  _riskLegend('standardLabel'.tr, low, _green),
                ],
              ),
            ],
            if (missing > 0) ...[
              if (found > 0) ...[
                SizedBox(height: 14.h),
                const Divider(color: _border, height: 1),
                SizedBox(height: 14.h),
              ],
              _missingTile(missing),
            ],
          ],
        ),
      ),
    );
  }

  Widget _riskLegend(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text('$count',
              style: TextStyle(
                  color: count > 0 ? color : AppColors.textMuted,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 8.w,
                  height: 8.h,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 10.5.sp)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _missingTile(int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _red.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.report_gmailerrorred_rounded, color: _red, size: 20.sp),
          SizedBox(width: 10.w),
          Text('$count',
              style: TextStyle(
                  color: _red, fontSize: 22.sp, fontWeight: FontWeight.w800)),
          SizedBox(width: 8.w),
          Expanded(
            // 👈 Point 3: "1 Clauses Missing" becomes "1 missing protection" (plural: "2 missing protections")
            child: Text(
              count == 1 ? 'missingProtection'.tr : 'missingProtections'.tr,
              style: TextStyle(
                  color: _red.withOpacity(0.9),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildPositivePoints(AnalysisResultController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('positiveFindings'.tr, Icons.check_circle_outline_rounded),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.success.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: c.positivePoints.asMap().entries.map((e) {
              final isLast = e.key == c.positivePoints.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Icon(Icons.check_circle_rounded,
                          color: _green, size: 15.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(e.value,
                          style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 12.5.sp,
                              height: 1.5)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsHeader(AnalysisResultController c) {
    return Row(
      children: [
        _sectionTitle('clauseAnalysis'.tr, Icons.document_scanner_rounded),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
              color: _gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20)),
          child: Text('${c.foundCount} ${'clauses'.tr}',
              style: TextStyle(
                  color: _gold, fontSize: 11.sp, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(AnalysisResultController c) {
    final filters = <Map<String, dynamic>>[
      {'key': 'all', 'label': 'all'.tr, 'count': c.foundCount},
      if (c.countOfLevel('high') > 0)
        {'key': 'high', 'label': 'high'.tr, 'count': c.countOfLevel('high')},
      if (c.countOfLevel('medium') > 0)
        {
          'key': 'medium',
          'label': 'medium'.tr,
          'count': c.countOfLevel('medium')
        },
      // 👈 Point 1: filter chip "Low · 1" becomes "Standard · 1"
      if (c.countOfLevel('low') > 0)
        {'key': 'low', 'label': 'standardLabel'.tr, 'count': c.countOfLevel('low')},
    ];

    if (filters.length <= 2) return const SizedBox.shrink();

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((f) {
              final key = f['key'] as String;
              final isActive = c.activeFilter.value == key;
              final color = key == 'all' ? _gold : _levelColor(key);
              return GestureDetector(
                onTap: () => c.setFilter(key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? color.withOpacity(0.18)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isActive ? color.withOpacity(0.5) : _border,
                        width: 1),
                  ),
                  child: Text('${f['label']} · ${f['count']}',
                      style: TextStyle(
                          color: isActive ? color : AppColors.textMuted,
                          fontSize: 11.5.sp,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500)),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Widget _buildTermsList(AnalysisResultController c) {
    return Obx(() {
      final entries = c.filteredEntries;
      if (entries.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.search_off_rounded,
                    color: AppColors.textMuted, size: 40.sp),
                SizedBox(height: 12.h),
                Text('noClausesFound'.tr,
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 13.sp)),
              ],
            ),
          ),
        );
      }
      return Column(
        children:
            entries.map((e) => _buildTermCard(c, e.value, e.key)).toList(),
      );
    });
  }

  Widget _buildMissingSection(AnalysisResultController c) {
    final missing = c.missingTerms;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // 👈 Point 3: Section title updated to match the new text
            _sectionTitle('missingProtections'.tr, Icons.report_gmailerrorred_rounded),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                  color: _red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('${missing.length}',
                  style: TextStyle(
                      color: _red,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        ...missing.asMap().entries.map(
              (e) => _buildTermCard(c, e.value, 1000 + e.key),
            ),
      ],
    );
  }

  Widget _buildTermCard(
      AnalysisResultController c, ImportantTerm term, int index) {
    final color = _levelColor(term.level);

    return Obx(() {
      final expanded = c.isExpanded(index);
      final preview = term.aiExplanation.isNotEmpty
          ? term.aiExplanation
          : term.extractedText;

      return GestureDetector(
        onTap: () => c.toggleExpand(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: expanded ? color.withOpacity(0.45) : _border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: color.withOpacity(0.3), width: 1),
                      ),
                      child: Icon(_levelIcon(term.level),
                          color: color, size: 17.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(term.termTitle,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3)),
                          if (!expanded && preview.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(preview,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11.5.sp,
                                    height: 1.4)),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textMuted, size: 22.sp),
                    ),
                  ],
                ),
              ),
              if (expanded)
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: _border, height: 1),
                      SizedBox(height: 14.h),
                      if (term.lawReference.isNotEmpty) ...[
                        _lawReference(term.lawReference),
                        SizedBox(height: 14.h),
                      ],
                      if (term.aiExplanation.isNotEmpty) ...[
                        _section('aiExplanation'.tr, term.aiExplanation,
                            AppColors.cream, Icons.psychology_rounded),
                        SizedBox(height: 14.h),
                      ],
                      if (term.aiRecommendation.isNotEmpty) ...[
                        _recommendationBox(term.aiRecommendation, color),
                        SizedBox(height: 14.h),
                      ],
                      if (term.extractedText.isNotEmpty)
                        _section('fullText'.tr, term.extractedText,
                            AppColors.textMuted, Icons.format_quote_rounded,
                            isQuote: true),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _lawReference(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _gold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _gold.withOpacity(0.25), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Icon(Icons.gavel_rounded, color: _gold, size: 14.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: _gold,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _recommendationBox(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_rounded, color: color, size: 14.sp),
              SizedBox(width: 6.w),
              Text('recommendation'.tr,
                  style: TextStyle(
                      color: color,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3)),
            ],
          ),
          SizedBox(height: 6.h),
          Text(text,
              style: TextStyle(
                  color: AppColors.cream,
                  fontSize: 12.5.sp,
                  height: 1.55)),
        ],
      ),
    );
  }

  Widget _section(String title, String content, Color textColor, IconData icon,
      {bool isQuote = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 14.sp),
            SizedBox(width: 6.w),
            Text(title,
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3)),
          ],
        ),
        SizedBox(height: 6.h),
        if (isQuote)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border(
                  left: BorderSide(color: _gold.withOpacity(0.5), width: 2)),
            ),
            child: Text(content,
                style: TextStyle(
                    color: textColor,
                    fontSize: 11.5.sp,
                    height: 1.6,
                    fontStyle: FontStyle.italic)),
          )
        else
          Text(content,
              style:
                  TextStyle(color: textColor, fontSize: 12.5.sp, height: 1.6)),
      ],
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _gold, size: 16.sp),
        SizedBox(width: 7.w),
        Text(title,
            style: TextStyle(
                color: AppColors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  String _normalizeLevel(String risk) {
    final r = risk.toLowerCase();
    if (r.contains('high')) return 'high';
    if (r.contains('medium') || r.contains('moderate')) return 'medium';
    if (r.contains('low')) return 'low';
    return '';
  }

  String _riskLabel(String risk) {
    switch (_normalizeLevel(risk)) {
      case 'high':
        return 'highRisk'.tr;
      case 'medium':
        return 'mediumRisk'.tr;
      // 👈 Point 1: Replace "Low Risk" with "Standard" in the summary verdict
      case 'low':
        return 'standardRisk'.tr;
      default:
        return risk;
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
        return _gold;
    }
  }

  IconData _levelIcon(String level) {
    switch (level) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      case 'low':
        return Icons.check_circle_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}