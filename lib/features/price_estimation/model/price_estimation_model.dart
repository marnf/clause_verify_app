


class PriceEstimationModel {
  final String estimatedPriceUsd;
  final String estimatedPriceEur;
  final String currencyUsd;
  final String currencyEur;
  final String conditionAssumed;
  final String confidenceLevel;
  final String notes;
  
  // Watch Information
  final String brand;
  final String model;
  final String serialRefNo;
  
  // Statistics
  final double averageComponentScore;
  final int totalComponentsAnalyzed;
  
  // Accessories
  final bool hasOriginalBox;
  final bool hasOriginalCertificate;
  final bool hasInvoice;

  PriceEstimationModel({
    required this.estimatedPriceUsd,
    required this.estimatedPriceEur,
    required this.currencyUsd,
    required this.currencyEur,
    required this.conditionAssumed,
    required this.confidenceLevel,
    required this.notes,
    required this.brand,
    required this.model,
    required this.serialRefNo,
    required this.averageComponentScore,
    required this.totalComponentsAnalyzed,
    required this.hasOriginalBox,
    required this.hasOriginalCertificate,
    required this.hasInvoice,
  });

  factory PriceEstimationModel.fromJson(Map<String, dynamic> json) {
    final priceEstimation = json['price_estimation'] ?? {};
    final watchInfo = json['watch_information'] ?? {};
    final statistics = json['statistics'] ?? {};
    final accessories = json['certificate_and_documentation'] ?? {};
    
    return PriceEstimationModel(
      // Price Estimation
      estimatedPriceUsd: priceEstimation['estimated_price_usd'] ?? 'N/A',
      estimatedPriceEur: priceEstimation['estimated_price_eur'] ?? 'N/A',
      currencyUsd: priceEstimation['currency_usd'] ?? 'USD',
      currencyEur: priceEstimation['currency_eur'] ?? 'EUR',
      conditionAssumed: priceEstimation['condition_assumed'] ?? 'Unknown',
      confidenceLevel: priceEstimation['confidence_level'] ?? 'Unknown',
      notes: priceEstimation['notes'] ?? '',
      
      // Watch Information
      brand: watchInfo['brand'] ?? 'Unknown',
      model: watchInfo['model'] ?? 'Unknown',
      serialRefNo: watchInfo['serial_ref_no'] ?? 'Unknown',
      
      // Statistics
      averageComponentScore: (statistics['average_component_score'] ?? 0.0).toDouble(),
      totalComponentsAnalyzed: statistics['total_components_analyzed'] ?? 0,
      
      // Accessories
      hasOriginalBox: accessories['original_box'] ?? false,
      hasOriginalCertificate: accessories['original_brand_certificate'] ?? false,
      hasInvoice: accessories['invoice'] ?? false,
    );
  }

  // ==========================================
  // ✨ CURRENCY-AWARE METHODS
  // ==========================================

  /// Get price string based on selected currency
  String getEstimatedPrice(String selectedCurrency) {
    if (selectedCurrency == 'EUR' || selectedCurrency == 'eur') {
      return estimatedPriceEur;
    }
    // Default to USD for both 'USD' and 'Auto'
    return estimatedPriceUsd;
  }

  /// Get currency code based on selection
  String getCurrency(String selectedCurrency) {
    if (selectedCurrency == 'EUR' || selectedCurrency == 'eur') {
      return currencyEur;
    }
    return currencyUsd;
  }

  /// Parse price string to get numeric range
  /// Example: "$7,500.00" → [7500, 7500]
  /// Example: "$15,000-20,000" → [15000, 20000]
  List<int> getPriceRange(String selectedCurrency) {
    final priceString = getEstimatedPrice(selectedCurrency);
    
    try {
      // Remove currency symbols ($, €), commas, and extra spaces
      String cleanPrice = priceString
          .replaceAll(RegExp(r'[\$€,\s]'), '')
          .trim();
      
      // Check if it's a range (contains dash)
      if (cleanPrice.contains('-')) {
        final parts = cleanPrice.split('-');
        if (parts.length == 2) {
          final min = double.parse(parts[0].trim()).round();
          final max = double.parse(parts[1].trim()).round();
          return [min, max];
        }
      }
      
      // Single price value
      final price = double.parse(cleanPrice).round();
      return [price, price];
      
    } catch (e) {
      print('❌ Error parsing price "$priceString": $e');
      return [0, 0];
    }
  }

  /// Get average price for selected currency
  int getAveragePrice(String selectedCurrency) {
    final range = getPriceRange(selectedCurrency);
    return ((range[0] + range[1]) / 2).round();
  }

  /// Get formatted average price with thousand separators
  String getFormattedAveragePrice(String selectedCurrency) {
    final avgPrice = getAveragePrice(selectedCurrency);
    return _formatNumberWithCommas(avgPrice);
  }

  /// Get formatted price range
  String getFormattedPriceRange(String selectedCurrency) {
    final range = getPriceRange(selectedCurrency);
    
    // If min and max are same, show single value
    if (range[0] == range[1]) {
      return _formatNumberWithCommas(range[0]);
    }
    
    // Show range
    final min = _formatNumberWithCommas(range[0]);
    final max = _formatNumberWithCommas(range[1]);
    return '$min - $max';
  }

  /// Helper method to format number with commas
  String _formatNumberWithCommas(int number) {
    return number
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }

  // ==========================================
  // ACCESSORIES & PRODUCT INFO
  // ==========================================

  /// Get list of available accessories
  List<String> get accessoriesList {
    List<String> items = [];
    if (hasOriginalBox) items.add('Original Box');
    if (hasOriginalCertificate) items.add('Certificate');
    if (hasInvoice) items.add('Invoice');
    return items;
  }
  
  /// Get total count of accessories
  int get accessoriesCount => accessoriesList.length;
  
  /// Get product reference string
  String get productReference => 'Ref: $serialRefNo';
  
  /// Get full product name
  String get fullProductName => '$brand $model';

  // ==========================================
  // BACKWARD COMPATIBILITY (DEPRECATED)
  // ==========================================
  // These methods are kept for backward compatibility
  // but new code should use the currency-aware methods above

  @Deprecated('Use getPriceRange(selectedCurrency) instead')
  List<int> get priceRangeUsd => getPriceRange('USD');

  @Deprecated('Use getPriceRange(selectedCurrency) instead')
  List<int> get priceRangeEur => getPriceRange('EUR');

  @Deprecated('Use getAveragePrice(selectedCurrency) instead')
  int get averagePriceUsd => getAveragePrice('USD');

  @Deprecated('Use getAveragePrice(selectedCurrency) instead')
  int get averagePriceEur => getAveragePrice('EUR');

  @Deprecated('Use getFormattedAveragePrice(selectedCurrency) instead')
  String get formattedAveragePriceUsd => getFormattedAveragePrice('USD');

  @Deprecated('Use getFormattedAveragePrice(selectedCurrency) instead')
  String get formattedAveragePriceEur => getFormattedAveragePrice('EUR');

  @Deprecated('Use getFormattedPriceRange(selectedCurrency) instead')
  String get formattedPriceRangeUsd => getFormattedPriceRange('USD');

  @Deprecated('Use getFormattedPriceRange(selectedCurrency) instead')
  String get formattedPriceRangeEur => getFormattedPriceRange('EUR');
}