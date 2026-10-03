

import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Backend-এ `scan_type` field-এ যে value যাবে
enum ScanType {
  single('scan_limit'),
  monthly('monthly_package'),
  unlimited('unlimited_package');

  final String apiValue;
  const ScanType(this.apiValue);
}

/// Modal থেকে ফেরত আসা ফলাফল: country + কোন scan ব্যবহার হবে
class ScanSelection {
  final Country country;
  final ScanType scanType;

  const ScanSelection({required this.country, required this.scanType});
}

class CountryConfirmationModal extends StatefulWidget {
  final Country initialCountry;

  const CountryConfirmationModal({
    Key? key,
    required this.initialCountry,
  }) : super(key: key);

  @override
  State<CountryConfirmationModal> createState() =>
      _CountryConfirmationModalState();
}

class _CountryConfirmationModalState extends State<CountryConfirmationModal> {
  late Country selectedCountry;

  /// null মানে user এখনো select করেনি
  ScanType? selectedType;

  int _singleCount = 0;
  int _monthlyCount = 0;
  int _unlimitedCount = 0;

  /// Paragraph-এর শেষে "Privacy Policy" tap করার জন্য
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _privacyTap = TapGestureRecognizer()..onTap = _openPrivacyPolicy;

    selectedCountry = widget.initialCountry;

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      _singleCount = home.scanLimit;
      _monthlyCount = home.monthlyPackage;
      _unlimitedCount = home.unlimitedPackage;
    }

    // শুধু একটাই scan type enabled থাকলে সেটা auto-select
    final enabledTypes =
        ScanType.values.where((t) => _countOf(t) > 0).toList();
    if (enabledTypes.length == 1) {
      selectedType = enabledTypes.first;
    }
  }

  @override
  void dispose() {
    _privacyTap.dispose();
    super.dispose();
  }

  int _countOf(ScanType type) {
    switch (type) {
      case ScanType.single:
        return _singleCount;
      case ScanType.monthly:
        return _monthlyCount;
      case ScanType.unlimited:
        return _unlimitedCount;
    }
  }

  bool get _hasAnyScan =>
      _singleCount > 0 || _monthlyCount > 0 || _unlimitedCount > 0;

  void _openCountryPicker() {
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      final screenHeight = MediaQuery.of(context).size.height;

      showCountryPicker(
        context: context,
        showPhoneCode: false,
        useSafeArea: true,
        countryListTheme: CountryListThemeData(
          borderRadius: BorderRadius.circular(16),
          backgroundColor: AppColors.surface,
          textStyle: TextStyle(color: AppColors.textWhite, fontSize: 14.sp),
          searchTextStyle: TextStyle(color: AppColors.textWhite),
          bottomSheetHeight: screenHeight * 0.55,
        ),
        onSelect: (Country country) {
          setState(() {
            selectedCountry = country;
          });
        },
      );
    });
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse('https://www.clauseverify.app/privacy-policy');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = selectedType != null;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.all(22.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon ──
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.gavel_rounded,
                      color: AppColors.primaryColor, size: 28.sp),
                ),
              ),
              SizedBox(height: 16.h),

              // ── Title ──
              Center(
                child: Text('confirmJurisdiction'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700)),
              ),
              SizedBox(height: 8.h),

              // ── Description + শেষে inline Privacy Policy link ──
              Text.rich(
                TextSpan(
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12.sp,
                      height: 1.4),
                  children: [
                    TextSpan(text: '${'jurisdictionDescription'.tr} '),
                    TextSpan(
                      text: 'privacyPolicy'.tr,
                      recognizer: _privacyTap,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14.h),

              // ── Country selector ──
              GestureDetector(
                onTap: _openCountryPicker,
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.5),
                        width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Text(selectedCountry.flagEmoji,
                          style: TextStyle(fontSize: 24.sp)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(selectedCountry.name,
                            style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600)),
                      ),
                      Icon(Icons.chevron_right,
                          color: AppColors.textMuted, size: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text('tapToChangeCountry'.tr,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic)),
              ),
              SizedBox(height: 18.h),

              // ── Scan type selector ──
              Row(
                children: [
                  Text('selectScanType'.tr,
                      style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: 6.w),
                  Text('*',
                      style: TextStyle(
                          color: AppColors.error,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  _buildScanOption(
                    type: ScanType.single,
                    
                    label: 'scanTypeSingle'.tr,
                  ),
                  SizedBox(width: 8.w),
                  _buildScanOption(
                    type: ScanType.monthly,
                    
                    label: 'scanTypeMonthly'.tr,
                  ),
                  SizedBox(width: 8.w),
                  _buildScanOption(
                    type: ScanType.unlimited,
                   
                    label: 'scanTypeUnlimited'.tr,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                !_hasAnyScan
                    ? 'noScansAvailable'.tr
                    : (canConfirm
                        ? 'scanDeductedFromSelected'.tr
                        : 'chooseScanBalance'.tr),
                style: TextStyle(
                  color: !_hasAnyScan ? AppColors.error : AppColors.textMuted,
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 20.h),

              // ── Action buttons ──
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cardBorder),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Get.back(result: null),
                      child: Text('cancel'.tr,
                          style: TextStyle(color: AppColors.textWhite)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.black,
                        disabledBackgroundColor: AppColors.surfaceLight,
                        disabledForegroundColor: AppColors.textMuted,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: canConfirm
                          ? () => Get.back(
                                result: ScanSelection(
                                  country: selectedCountry,
                                  scanType: selectedType!,
                                ),
                              )
                          : null,
                      child: Text('confirm'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════ Single scan-type box ══════════════
  Widget _buildScanOption({
    required ScanType type,
    
    required String label,
  }) {
    final count = _countOf(type);
    final enabled = count > 0;
    final selected = selectedType == type;

    final Color accent = enabled ? AppColors.primaryColor : AppColors.textMuted;

    return Expanded(
      child: GestureDetector(
        onTap: enabled ? () => setState(() => selectedType = type) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.4,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryColor.withOpacity(0.15)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    selected ? AppColors.primaryColor : AppColors.cardBorder,
                width: selected ? 1.8 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$count',
                    style: TextStyle(
                        color:
                            enabled ? AppColors.textWhite : AppColors.textMuted,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        height: 1)),
                SizedBox(height: 6.h),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: selected
                            ? AppColors.primaryColor
                            : AppColors.textMuted,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}