import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryConfirmationModal extends StatefulWidget {
  final Country initialCountry;

  const CountryConfirmationModal({
    Key? key,
    required this.initialCountry,
  }) : super(key: key);

  @override
  State<CountryConfirmationModal> createState() => _CountryConfirmationModalState();
}

class _CountryConfirmationModalState extends State<CountryConfirmationModal> {
  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialCountry;
  }

  void _openCountryPicker() {
    // ✅ Dismiss keyboard first to prevent resize overflow
    FocusScope.of(context).unfocus();
    
    // Wait a tiny bit for keyboard to start closing, then open picker
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
          // ✅ Dynamic height that considers keyboard state
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // ✅ Prevents the dialog from resizing when keyboard pops up/down
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        // ✅ Make the dialog content scrollable to prevent any overflow
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(), // Won't scroll unless needed
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.gavel_rounded, color: AppColors.primaryColor, size: 28.sp),
              ),
              SizedBox(height: 20.h),

              // Title
              Text('Confirm Jurisdiction', style: TextStyle(color: AppColors.textWhite, fontSize: 18.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 8.h),

              // Subtitle
              Text('We will analyze your contract based on the laws and regulations of your selected country.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp, height: 1.4)),
              SizedBox(height: 24.h),

              // Country Selector
              GestureDetector(
                onTap: _openCountryPicker,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.5), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Text(selectedCountry.flagEmoji, style: TextStyle(fontSize: 24.sp)),
                      SizedBox(width: 12.w),
                      Expanded(child: Text(selectedCountry.name, style: TextStyle(color: AppColors.textWhite, fontSize: 15.sp, fontWeight: FontWeight.w600))),
                      Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.centerRight, 
                child: Text('Tap to change country', style: TextStyle(color: AppColors.primaryColor, fontSize: 11.sp, fontStyle: FontStyle.italic))
              ),
              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cardBorder), 
                        padding: EdgeInsets.symmetric(vertical: 14), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      onPressed: () => Get.back(result: null),
                      child: Text('Cancel', style: TextStyle(color: AppColors.textWhite)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor, 
                        padding: EdgeInsets.symmetric(vertical: 14), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      onPressed: () {
                        Get.back(result: selectedCountry);
                      },
                      child: Text('Confirm', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
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
}