import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/services/auth_service.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/features/price_estimation/controller/price_estimation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceEstimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PriceEstimationController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Scaffold(
        backgroundColor: Color(0xFF000000),
        appBar: CustomAppBar(title: 'Price Estimation'),
        body: Obx(() {
          // Loading State
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          // Error State
          if (controller.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64.sp),
                  SizedBox(height: 16.h),
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: controller.refreshData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                    ),
                    child: Text('Retry', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            );
          }

          // No Data State
          if (!controller.hasData) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            );
          }

          final data = controller.priceData.value!;
          // ✨ Get currency from AuthService
          final selectedCurrency = AuthService.selectedCurrency;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                _buildEstimatedValueCard(data, selectedCurrency),
                SizedBox(height: 16.h),
                _buildProductInfoCard(data),
                SizedBox(height: 16.h),
                _buildValuationFactorsCard(data),
                SizedBox(height: 16.h),
                _buildMarketInsightsCard(data, selectedCurrency),
                SizedBox(height: 16.h),
                _buildNoteCard(data.notes),
                SizedBox(height: 32.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEstimatedValueCard(data, String selectedCurrency) {
    // ✨ Get currency symbol from AuthService
    String currencySymbol = selectedCurrency == 'EUR' ? '€' : '\$';
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Color(0xFF292315),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'Estimated Market Value',
            style: TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '$currencySymbol${data.getFormattedAveragePrice(selectedCurrency)}',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$currencySymbol${data.getFormattedPriceRange(selectedCurrency)}',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Color(0xFF605C52).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  data.conditionAssumed,
                  style: TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard(data) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF1A1A1A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.fullProductName,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                data.productReference,
                style: TextStyle(color: Color(0xFF999999), fontSize: 14.sp),
              ),
              if (data.serialRefNo != 'Unknown') ...[
                SizedBox(width: 12.w),
                Container(
                  width: 4.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF4A4A4A),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${data.totalComponentsAnalyzed} Components',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14.sp),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValuationFactorsCard(data) {
    double progress = data.averageComponentScore / 100;
    Color trendColor = data.averageComponentScore >= 90
        ? Color(0xFF4ADE80)
        : data.averageComponentScore >= 70
            ? Color(0xFFFFA500)
            : Color(0xFFEF4444);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF1A1A1A), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: Color(0xFF332D1F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Valuation Factors',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Condition Score
          Row(
            children: [
              Image.asset(
                IconPath.condition,
                width: 16.w,
                height: 16.h,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'Condition Score',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                '${data.averageComponentScore.toStringAsFixed(1)}/100',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Color(0xFF1A1A1A),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 8.h,
            ),
          ),

          SizedBox(height: 20.h),

          // Accessories
          Row(
            children: [
              Image.asset(
                IconPath.box,
                width: 16.w,
                height: 16.h,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'Accessories',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                '${data.accessoriesCount} items',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          if (data.accessoriesCount > 0) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: data.accessoriesList.map<Widget>((item) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          SizedBox(height: 20.h),

          // Confidence Level
          Row(
            children: [
              Image.asset(
                IconPath.historical,
                width: 16.w,
                height: 16.h,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'Confidence Level',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                data.confidenceLevel,
                style: TextStyle(
                  color: trendColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.confidenceLevel.toLowerCase() == 'high' ? 0.9 : 
                     data.confidenceLevel.toLowerCase() == 'medium' ? 0.6 : 0.3,
              backgroundColor: Color(0xFF1A1A1A),
              valueColor: AlwaysStoppedAnimation<Color>(trendColor),
              minHeight: 8.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInsightsCard(data, String selectedCurrency) {
    // Create market insights based on data and currency
    String currencyCode = selectedCurrency == 'EUR' ? 'EUR' : 'USD';
    
    List<String> insights = [
      'Average component score is ${data.averageComponentScore.toStringAsFixed(1)}%, indicating ${data.conditionAssumed.toLowerCase()} condition',
      'Watch includes ${data.accessoriesCount} original accessories',
      'Confidence level: ${data.confidenceLevel}',
      'Prices displayed in $currencyCode',
    ];

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF1A1A1A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Insights',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          ...insights.map((insight) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.h,
                    margin: EdgeInsets.only(top: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      insight,
                      style: TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNoteCard(String note) {
    if (note.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(0xFF292315),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note:',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            note,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}