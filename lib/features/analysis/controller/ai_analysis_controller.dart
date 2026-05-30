import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/core/services/watch_image_services.dart';
import 'package:flutter_extension/features/home/controllers/home_controller.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class AiAnalysisController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController progressController;
  
  final NetworkCaller _networkCaller = NetworkCaller();
  final homeController = Get.find<HomeController>();
  final WatchImagesService _imagesService = WatchImagesService.instance;
  
  String? analysisId;
  
  List<AnalysisStep> get analysisSteps => [
    AnalysisStep(title: 'analyzingWatchModel'.tr, duration: 5), 
    AnalysisStep(title: 'checkingAuthenticityIndicators'.tr, duration: 6), 
    AnalysisStep(title: 'detectingPolishingDefects'.tr, duration: 5), 
    AnalysisStep(title: 'evaluatingConditionScore'.tr, duration: 5), 
    AnalysisStep(title: 'verifyingEngravings'.tr, duration: 5), 
    AnalysisStep(title: 'finalizingReport'.tr, duration: 4), 
  ];
  
  int get totalStepsDuration {
    return analysisSteps.fold(0, (sum, step) => sum + step.duration);
  }
  
  RxInt currentStepIndex = 0.obs;
  RxDouble overallProgress = 0.0.obs;
  RxInt remainingSeconds = 30.obs;
  RxString currentStepTitle = ''.obs;
  
  Timer? _stepTimer;
  Timer? _countdownTimer;
  Timer? _pollingTimer;
  
  DateTime? _startTime;
  bool _isDataReady = false;
  
  @override
  void onInit() {
    super.onInit();
    
    print('🔵 AiAnalysisController onInit called');
    
    final args = Get.arguments;
    
    if (args != null && args is Map<String, dynamic>) {
      if (args['startUpload'] == true) {
        _startUploadAndAnalysis();
      } else if (args['id'] != null) {
        analysisId = args['id'];
        _startAnalysisWithId();
      }
    } else {
      print('❌ No valid arguments found!');
      _handleError('No arguments provided');
    }
  }
  
  Future<void> _startUploadAndAnalysis() async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 Starting upload from AI Analysis Screen...');
    print('Front: ${_imagesService.frontViewImage.value}');
    print('Back: ${_imagesService.backViewImage.value}');
    print('Bracelet: ${_imagesService.braceletClaspImage.value}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    _startTime = DateTime.now();
    _startAnalysis();
    
    try {
      Map<String, String> imagePaths = {
        'front_image': _imagesService.frontViewImage.value,
        'back_image': _imagesService.backViewImage.value,
        'bracelet_image': _imagesService.braceletClaspImage.value,
      };

      Map<String, String> fields = {
        'original_box': _imagesService.hasBox.value.toString(),
        'original_brand_certificate': _imagesService.hasCertificate.value.toString(),
        'invoice': _imagesService.hasInvoice.value.toString(),
      };

      print('📤 Uploading to: ${Endpoints.analysis}');
      print('🖼️ Files: ${imagePaths.keys}');
      print('📦 Fields: $fields');
      
      final uploadResponse = await _networkCaller.multipartRequest(
        Endpoints.analysis,
        files: imagePaths,
        fields: fields,
      );

      print('📥 Upload Response Status: ${uploadResponse.statusCode}');

      if (uploadResponse.isSuccess) {
        analysisId = uploadResponse.responseData['id'];
        String status = uploadResponse.responseData['status'] ?? 'pending';

        print('✅ Upload successful!');
        print('Analysis ID: $analysisId');
        print('Initial Status: $status');

        _startPollingForResult();
      } else {
        print('❌ Upload failed: ${uploadResponse.errorMessage}');
        
        // ✅ CRITICAL: Clear service immediately
        _clearServiceAndNavigate(
          errorMessage: uploadResponse.errorMessage,
          statusCode: uploadResponse.statusCode,
        );
      }
    } catch (e) {
      print('❌ Exception during upload: $e');
      
      // ✅ CRITICAL: Clear service on exception
      _clearServiceAndNavigate(
        errorMessage: 'An error occurred while uploading. Please try again.',
        isException: true,
      );
    }
  }
  
  /// ✅ Central method for cleanup and navigation on errors
  void _clearServiceAndNavigate({
    required String errorMessage,
    int? statusCode,
    bool isException = false,
  }) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🧹 CLEARING SERVICE DUE TO ERROR');
    print('Error: $errorMessage');
    print('Status Code: $statusCode');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    // Step 1: Cancel all timers
    _cancelAllTimers();
    
    // Step 2: Clear service - THIS IS CRITICAL
    _imagesService.clearAll();
    print('✅ Service cleared successfully');
    
    // Step 3: Verify service is empty
    print('🔍 Verifying service state:');
    print('   Front: ${_imagesService.frontViewImage.value}');
    print('   Back: ${_imagesService.backViewImage.value}');
    print('   Bracelet: ${_imagesService.braceletClaspImage.value}');
    
    // Step 4: Handle specific errors
    if (statusCode == 403) {
      final errorMsg = errorMessage.toLowerCase();
      
      if (errorMsg.contains('premium') || 
          errorMsg.contains('scan') || 
          errorMsg.contains('purchase')) {
        
        print('🚫 Premium scan limit reached');
        
        Get.snackbar(
          'Scan Limit Reached',
          'Please purchase a subscription to continue',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFFD4A574),
          colorText: Colors.black,
          duration: Duration(seconds: 2),
        );
        
        Future.delayed(Duration(seconds: 2), () {
          print('➡️ Navigating to subscription screen');
          Get.offAllNamed(AppRoute.subscriptionScreen);
        });
        
        return;
      }
    }
    
    // Step 5: Generic error handling
    if (!isException) {
      Get.snackbar(
        'Upload Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFEF4444),
        duration: Duration(seconds: 2),
      );
    }
    
    Future.delayed(Duration(seconds: 2), () {
      print('⬅️ Navigating back to previous screen');
      Get.back();
    });
  }
  
  void _startAnalysisWithId() {
    if (analysisId == null) {
      print('❌ Analysis ID not found!');
      _handleError('Analysis ID missing');
      return;
    }
    
    print('✅ Starting AI Analysis for ID: $analysisId');
    
    _startTime = DateTime.now();
    _startAnalysis();
    _startPollingForResult();
  }
  
  void _setupProgressAnimation() {
    progressController = AnimationController(
      duration: Duration(seconds: totalStepsDuration),
      vsync: this,
    );
    
    progressController.addListener(() {
      overallProgress.value = progressController.value;
    });
  }
  
  void _startAnalysis() {
    remainingSeconds.value = totalStepsDuration;
    
    _setupProgressAnimation();
    progressController.forward();
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
    
    _processNextStep();
  }
  
  void _processNextStep() {
    if (currentStepIndex.value < analysisSteps.length) {
      final step = analysisSteps[currentStepIndex.value];
      currentStepTitle.value = step.title;
      
      _stepTimer = Timer(Duration(seconds: step.duration), () {
        currentStepIndex.value++;
        
        if (currentStepIndex.value < analysisSteps.length) {
          _processNextStep();
        } else {
          print('✅ All animation steps completed!');
          overallProgress.value = 1.0;
        }
      });
    }
  }
  
  void _startPollingForResult() {
    print('🔄 Starting polling for analysis result...');
    
    _checkAnalysisStatus();
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isDataReady) {
        timer.cancel();
      } else {
        _checkAnalysisStatus();
      }
    });
  }
  
  Future<void> _checkAnalysisStatus() async {
    if (analysisId == null) return;
    
    try {
      print('📡 Checking status for ID: $analysisId');
      
      final response = await _networkCaller.getRequest(
        '${Endpoints.historyDetails}$analysisId/',
      );
      
      if (response.isSuccess && response.responseData != null) {
        final status = response.responseData['status'];
        
        print('📥 Current status: $status');
        
        if (status == 'completed') {
          print('✅ Analysis completed!');
          _isDataReady = true;
          _pollingTimer?.cancel();
          
          _tryNavigateToResult();
        } else if (status == 'processing') {
          print('⏳ Still processing...');
        } else if (status == 'failed') {
          print('❌ Analysis failed!');
          
          // ✅ CRITICAL: Clear service when analysis fails
          _handleAnalysisFailed();
        }
      } else {
        print('⚠️ Failed to check status: ${response.errorMessage}');
      }
    } catch (e) {
      print('💥 Error checking status: $e');
    }
  }
  
  /// ✅ Handle analysis failed scenario
  void _handleAnalysisFailed() {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🧹 CLEARING SERVICE - ANALYSIS FAILED');
    
    _cancelAllTimers();
    
    // Clear service
    _imagesService.clearAll();
    print('✅ Service cleared successfully');
    
    // Verify
    print('🔍 Service state after clear:');
    print('   Front: ${_imagesService.frontViewImage.value}');
    print('   Back: ${_imagesService.backViewImage.value}');
    print('   Bracelet: ${_imagesService.braceletClaspImage.value}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    Get.snackbar(
      'Error',
      'Analysis failed. Please try again.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF1A1A1A),
      colorText: Color(0xFFEF4444),
      duration: Duration(seconds: 2),
    );
    
    Future.delayed(Duration(seconds: 2), () {
      homeController.refreshData();
      Get.offAllNamed(AppRoute.navBar);
    });
  }
  
  void _tryNavigateToResult() {
    if (!_isDataReady) return;
    
    final elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
    
    print('⏱️ Elapsed time: $elapsedSeconds seconds');
    print('⏱️ Total steps duration: $totalStepsDuration seconds');
    
    if (elapsedSeconds >= totalStepsDuration) {
      print('✅ All steps completed, navigating now!');
      _navigateToResult();
    } else {
      final waitTime = totalStepsDuration - elapsedSeconds;
      print('⏳ Waiting $waitTime more seconds for animation...');
      
      Future.delayed(Duration(seconds: waitTime), () {
        print('✅ Animation completed, navigating now!');
        _navigateToResult();
      });
    }
  }
  
  void _navigateToResult() {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('✅ ANALYSIS SUCCESSFUL - CLEARING SERVICE');
    
    _cancelAllTimers();
    
    // Clear service after successful completion
    _imagesService.clearAll();
    print('✅ Service cleared successfully');
    
    print('➡️ Navigating to result screen');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    Get.offNamed(
      AppRoute.analysisCompleteScreen,
      arguments: {'id': analysisId},
    );
  }
  
  void _cancelAllTimers() {
    _stepTimer?.cancel();
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    
    if (progressController.isAnimating) {
      progressController.stop();
    }
    
    print('⏸️ All timers cancelled');
  }
  
  void _handleError(String message) {
    print('❌ Error: $message');
    
    _cancelAllTimers();
    _imagesService.clearAll();
    
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF1A1A1A),
      colorText: Color(0xFFEF4444),
    );
    
    Future.delayed(Duration(seconds: 2), () {
      Get.back();
    });
  }
  
  bool isStepCompleted(int index) {
    return index < currentStepIndex.value;
  }
  
  bool isStepActive(int index) {
    return index == currentStepIndex.value;
  }
  
  @override
  void onClose() {
    print('🔴 AiAnalysisController onClose called');
    _cancelAllTimers();
    progressController.dispose();
    super.onClose();
  }
}

class AnalysisStep {
  final String title;
  final int duration;
  
  AnalysisStep({required this.title, required this.duration});
}