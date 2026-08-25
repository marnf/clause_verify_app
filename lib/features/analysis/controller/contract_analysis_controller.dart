import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

class ContractAnalysisController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController progressController;
  
  final NetworkCaller _networkCaller = NetworkCaller();
  
  List<File> filesToUpload = [];
  String lawCountry = '';
  
  // এখানে .tr যুক্ত করা হয়েছে
  List<AnalysisStep> get analysisSteps => [
    AnalysisStep(title: 'uploadingDocuments'.tr, duration: 5), 
    AnalysisStep(title: 'analyzingContractClauses'.tr, duration: 7), 
    AnalysisStep(title: 'identifyingLegalRisks'.tr, duration: 6), 
    AnalysisStep(title: 'evaluatingCompliance'.tr, duration: 6), 
    AnalysisStep(title: 'generatingFinalReport'.tr, duration: 6), 
  ];
  
  int get totalStepsDuration => analysisSteps.fold(0, (sum, step) => sum + step.duration);
  
  RxInt currentStepIndex = 0.obs;
  RxDouble overallProgress = 0.0.obs;
  RxInt remainingSeconds = 30.obs;
  RxString currentStepTitle = ''.obs;
  
  Timer? _stepTimer;
  Timer? _countdownTimer;
  DateTime? _startTime;
  bool _isUploadDone = false;

  @override
  void onInit() {
    super.onInit();
    
    final args = Get.arguments;
    if (args != null && args is Map) {
      filesToUpload = List<File>.from(args['files'] ?? []);
      lawCountry = args['law_country'] ?? '';
    }

    _startTime = DateTime.now();
    _startAnalysisAnimation();
    _uploadFilesToServer();
  }

  void _startAnalysisAnimation() {
    remainingSeconds.value = totalStepsDuration;
    
    progressController = AnimationController(
      duration: Duration(seconds: totalStepsDuration),
      vsync: this,
    );
    
    progressController.addListener(() {
      overallProgress.value = progressController.value;
    });
    
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
          overallProgress.value = 1.0;
        }
      });
    }
  }

  Future<void> _uploadFilesToServer() async {
    try {
      final fileList = filesToUpload.map((file) => MapEntry('files', file.path)).toList();

      final response = await _networkCaller.multipartRequest(
        Endpoints.fileUpload,
        files: fileList,
        fields: {
          'law_country': lawCountry,
        },
      );

      _isUploadDone = true;

      if (response.isSuccess && response.responseData != null) {
        _tryNavigateToResult(response.responseData!);
      } else {
        _handleError(response.errorMessage ?? 'uploadFailedPleaseTryAgain'.tr);
      }
    } catch (e) {
      _isUploadDone = true;
      _handleError('anErrorOccurred'.trParams({'error': e.toString()}));
    }
  }

  void _tryNavigateToResult(Map<String, dynamic> responseData) {
    final elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
    
    void navigateAction() {
      final dataMap = responseData['data'] as Map<String, dynamic>?;
      if (dataMap == null) {
        _handleError('invalidResponseDataFormat'.tr);
        return;
      }

      final resultModel = AnalysisResultModel.fromJson(dataMap);
      
      Get.offNamed(
        AppRoute.analysisResultScreen,
        arguments: resultModel,
      );
    }

    if (elapsedSeconds >= totalStepsDuration) {
      navigateAction();
    } else {
      final waitTime = totalStepsDuration - elapsedSeconds;
      Future.delayed(Duration(seconds: waitTime), navigateAction);
    }
  }

  void _handleError(String message) {
    _cancelTimers();
    Get.snackbar(
      'error'.tr, // 'Error' এর জন্য আগে থেকেই JSON এ আছে
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  void _cancelTimers() {
    _stepTimer?.cancel();
    _countdownTimer?.cancel();
    if (progressController.isAnimating) progressController.stop();
  }

  bool isStepCompleted(int index) => index < currentStepIndex.value;
  bool isStepActive(int index) => index == currentStepIndex.value;

  @override
  void onClose() {
    _cancelTimers();
    progressController.dispose();
    super.onClose();
  }
}

class AnalysisStep {
  final String title;
  final int duration;
  AnalysisStep({required this.title, required this.duration});
}