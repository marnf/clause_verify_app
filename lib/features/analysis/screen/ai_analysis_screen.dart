import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/image_path.dart';
import 'package:flutter_extension/features/analysis/controller/ai_analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// AI Analysis Screen Widget
class AiAnalysisScreen extends StatelessWidget {
  AiAnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiAnalysisController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
          child: Column(
            children: [
              SizedBox(height: 30.h),

              AnimatedAnalysisIcon(imagePath: ImagePath.analysis, size: 150),

              SizedBox(height: 40.h),

              // Title
              Text(
                   'aiAnalysisInProgress'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 5.h),

              // Subtitle
              Obx(
                () => Text(
                  controller.currentStepTitle.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 15.h),

              // Progress Bar
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 8.h,
                        child: LinearProgressIndicator(
                          value: controller.overallProgress.value,
                          backgroundColor: Color(0xFF2D2D2D),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFD4AF37),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Progress text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                         'analyzing'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          '${(controller.overallProgress.value * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50.h),

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
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            // Status Icon
                            Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? Color(0xFF00C853)
                                    : isActive
                                    ? Color(0xFFD4AF37)
                                    : Color(0xFF2D2D2D),
                              ),
                              child: isCompleted
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18.sp,
                                    )
                                  : isActive
                                  ? SizedBox(
                                      width: 18.w,
                                      height: 18.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.w,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16.w),
                            // Step Title
                            Expanded(
                              child: Text(
                                step.title,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isCompleted || isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  fontWeight: isActive
                                      ? FontWeight.w500
                                      : FontWeight.w400,
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

              // Estimated Time
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 55.h,
                  padding: EdgeInsets.symmetric(
                    // horizontal: 16.w,
                    // vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFF2D2D2D), width: 1.w),
                  ),
                  child: Center(
                    child: Text(
                      'Estimated waiting time: ${controller.remainingSeconds.value} seconds',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedAnalysisIcon extends StatefulWidget {
  final String imagePath;
  final double size;

  AnimatedAnalysisIcon({Key? key, required this.imagePath, this.size = 150})
    : super(key: key);

  @override
  State<AnimatedAnalysisIcon> createState() => _AnimatedAnalysisIconState();
}

class _AnimatedAnalysisIconState extends State<AnimatedAnalysisIcon>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _glowController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation - choto boro hobe
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_scaleController);

    // Rotate animation - halka narachara
    _rotateController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.05,
          end: 0.05,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.05,
          end: -0.05,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_rotateController);

    // Glow animation - glow pulse
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.5).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start all animations infinitely
    _scaleController.repeat();
    _rotateController.repeat();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleController,
        _rotateController,
        _glowController,
      ]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Animated Glow effect
            Container(
              width: widget.size.w * 1.3,
              height: widget.size.h * 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD4AF37).withOpacity(_glowAnimation.value),
                    blurRadius: 60 * _scaleAnimation.value,
                    spreadRadius: 20 * _scaleAnimation.value,
                  ),
                ],
              ),
            ),

            // Animated Image
            Transform.rotate(
              angle: _rotateAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Image.asset(
                  widget.imagePath,
                  width: widget.size.w,
                  height: widget.size.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: widget.size.w,
                      height: widget.size.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD4AF37),
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        size: widget.size.w * 0.5,
                        color: Color(0xFF1A1A1A),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}