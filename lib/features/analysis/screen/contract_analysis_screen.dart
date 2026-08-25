import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:flutter/material.dart';
import 'package:clause_verify/features/analysis/controller/contract_analysis_controller.dart';
import 'package:get/get.dart';

class ContractAnalysisScreen extends StatelessWidget {
  const ContractAnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractAnalysisController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
          child: Column(
            children: [
              SizedBox(height: 60.h),

              // Animated Icon
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFB8860B).withOpacity(0.1),
                  border: Border.all(color: const Color(0xFFB8860B).withOpacity(0.3), width: 2),
                ),
                child: Icon(Icons.gavel_rounded, color: const Color(0xFFB8860B), size: 50.sp),
              ),

              SizedBox(height: 40.h),

              Text(
                'legalAiAnalysis'.tr,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5.h),

              Obx(() => Text(
                controller.currentStepTitle.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              )),

              SizedBox(height: 30.h),

              // Progress Bar
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 8.h,
                      child: LinearProgressIndicator(
                        value: controller.overallProgress.value,
                        backgroundColor: const Color(0xFF2D2D2D),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('analyzing'.tr, style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.5))),
                      Text('${(controller.overallProgress.value * 100).toInt()}%', style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.5))),
                    ],
                  ),
                ],
              )),

              SizedBox(height: 40.h),

              // Analysis Steps List
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: controller.analysisSteps.length,
                  itemBuilder: (context, index) {
                    final step = controller.analysisSteps[index];
                    return Obx(() {
                      final isCompleted = controller.isStepCompleted(index);
                      final isActive = controller.isStepActive(index);

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            Container(
                              width: 28.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted ? const Color(0xFF4CAF50) : isActive ? const Color(0xFFB8860B) : const Color(0xFF2D2D2D),
                              ),
                              child: isCompleted
                                  ? Icon(Icons.check, color: Colors.white, size: 18.sp)
                                  : isActive
                                      ? SizedBox(
                                          width: 18.w,
                                          height: 18.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.w,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : null,
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Text(
                                step.title, // Note: এই step.title গুলো যদি কন্ট্রোলারে হার্ডকোড করা থাকে, তবে সেগুলোও .tr দিয়ে আপডেট করতে হবে
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isCompleted || isActive ? Colors.white : Colors.white.withOpacity(0.3),
                                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
              ),

              // Estimated Time Box
              Obx(() => Container(
                width: double.infinity,
                height: 55.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 1.w),
                ),
                child: Center(
                  child: Text(
                    'estimatedWaitingTime'.trParams({'seconds': controller.remainingSeconds.value.toString()}),
                    style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}