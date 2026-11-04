import 'package:flutter/material.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
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
            response.errorMessage ?? 'failedToLoadHistory'.tr;
      }
    } catch (e) {
      errorMessage.value = 'anErrorOccurred'.trParams({'error': e.toString()});
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

  // ── Local list e item ke read mark kora (New badge sathe sathe soray dey) ──
  // AnalysisResultController mark-as-read API success hole eta call kore
  void markAsReadLocally(String id) {
    final index = historyList.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final old = historyList[index];
    if (old.isRead) return;

    historyList[index] = old.copyWith(isRead: true);
  }

  // ── Navigate to detail: shudhu id pass kori ──
  // Report GET kora ar is_read false hole mark-as-read PATCH kora
  // AnalysisResultController nijei korbe
  void navigateToDetails(HistoryModel item) {
    // Delete existing controller so fresh one is created by binding
    try {
      Get.delete<AnalysisResultController>(force: true);
    } catch (_) {}

    Get.toNamed(
      AppRoute.analysisResultScreen,
      arguments: item.id,
    );
  }

  // ── Pull to refresh ──
  Future<void> refreshData() async {
    await fetchHistoryData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
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