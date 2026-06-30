// lib/features/history/controller/history_controller.dart

import 'package:flutter/material.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/features/analysis/controller/analysis_result_controller.dart';
import 'package:clause_verify/features/history/model/history_model.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  // ── Observables ──
  var historyList = <HistoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt totalCount = 0.obs;
  final RxBool hasMoreData = true.obs;

  // ── Pagination state ──
  final int _limit = 5;
  int _offset = 0;
  String? _nextUrl;

  // ── Scroll controller ──
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    fetchHistoryData();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      if (!isLoadingMore.value && hasMoreData.value && !isLoading.value) {
        loadMoreData();
      }
    }
  }

  // ── Initial / Refresh fetch ──
  Future<void> fetchHistoryData() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      _offset = 0;
      hasMoreData.value = true;
      historyList.clear();

      final response = await _networkCaller.getRequest(
        '${Endpoints.fileAnalysis}?limit=$_limit&offset=$_offset',
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        totalCount.value = data['count'] ?? 0;
        _nextUrl = data['next'] as String?;

        final List<dynamic> results = data['results'] ?? [];
        final List<HistoryModel> newList = results
            .map((json) =>
                HistoryModel.fromJson(json as Map<String, dynamic>))
            .toList();

        historyList.assignAll(newList);
        _offset = newList.length;
        hasMoreData.value = _nextUrl != null && _nextUrl!.isNotEmpty;
      } else {
        errorMessage.value =
            response.errorMessage ?? 'Failed to load history';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Load next page ──
  Future<void> loadMoreData() async {
    if (isLoadingMore.value || !hasMoreData.value || isLoading.value) return;

    try {
      isLoadingMore.value = true;

      final response = await _networkCaller.getRequest(
        '${Endpoints.fileAnalysis}?limit=$_limit&offset=$_offset',
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;
        _nextUrl = data['next'] as String?;

        final List<dynamic> results = data['results'] ?? [];
        final List<HistoryModel> newList = results
            .map((json) =>
                HistoryModel.fromJson(json as Map<String, dynamic>))
            .toList();

        historyList.addAll(newList);
        _offset += newList.length;
        hasMoreData.value = _nextUrl != null && _nextUrl!.isNotEmpty;
      }
    } catch (e) {
      print('❌ Error loading more: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ── Navigate to detail: fetch detail API then go to AnalysisResultScreen ──
  Future<void> navigateToDetails(HistoryModel item) async {
    try {
      // Show loading dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFFD4A574)),
          ),
        ),
        barrierDismissible: false,
      );

      final response = await _networkCaller.getRequest(
        '${Endpoints.fileAnalysis}${item.id}/',
      );

      Get.back(); // Close loading dialog

      if (response.isSuccess && response.responseData != null) {
        final analysisResult =
            AnalysisResultModel.fromJson(response.responseData);

        // Delete existing controller so fresh one is created by binding
        try {
          Get.delete<AnalysisResultController>(force: true);
        } catch (_) {}

        // Navigate to AnalysisResultScreen with the data
        Get.toNamed(
          AppRoute.analysisResultScreen,
          arguments: analysisResult,
        );
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFF1A1A1A),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();

      Get.snackbar(
        'Error',
        'Failed to load analysis details',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Colors.white,
      );
    }
  }

  // ── Pull to refresh ──
  Future<void> refreshData() async {
    await fetchHistoryData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    historyList.clear();
    super.onClose();
  }
}