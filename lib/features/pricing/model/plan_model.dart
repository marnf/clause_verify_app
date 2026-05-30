// // // // Plan Data Model (API Response)
// // // class PlanData {
// // //   final String id;
// // //   final String name;
// // //   final String category;
// // //   final String description;
// // //   final String price;
// // //   final int? durationDays;
// // //   final int scansIncluded;
// // //   final String? googleProductId;
// // //   final String? appleProductId;
// // //   final bool isActive;
// // //   final int sortOrder;
// // //   final String analysisType;
// // //   final bool basicAuthenticityCheck;
// // //   final bool fastProcessing;
// // //   final bool showComponentBreakdown;
// // //   final bool showComponentObservations;
// // //   final int componentDetailLevel;
// // //   final bool showWatchInformation;
// // //   final bool showExpertNotes;
// // //   final bool showConfidenceMetrics;
// // //   final bool canDownloadPdf;
// // //   final bool pdfIncludesStamps;
// // //   final bool pdfIsBilingual;
// // //   final bool includesPriceEstimation;
// // //   final bool priorityProcessing;
// // //   final bool prioritySupport;
// // //   final bool unlimitedAnalyses;

// // //   PlanData({
// // //     required this.id,
// // //     required this.name,
// // //     required this.category,
// // //     required this.description,
// // //     required this.price,
// // //     this.durationDays,
// // //     required this.scansIncluded,
// // //     this.googleProductId,
// // //     this.appleProductId,
// // //     required this.isActive,
// // //     required this.sortOrder,
// // //     required this.analysisType,
// // //     required this.basicAuthenticityCheck,
// // //     required this.fastProcessing,
// // //     required this.showComponentBreakdown,
// // //     required this.showComponentObservations,
// // //     required this.componentDetailLevel,
// // //     required this.showWatchInformation,
// // //     required this.showExpertNotes,
// // //     required this.showConfidenceMetrics,
// // //     required this.canDownloadPdf,
// // //     required this.pdfIncludesStamps,
// // //     required this.pdfIsBilingual,
// // //     required this.includesPriceEstimation,
// // //     required this.priorityProcessing,
// // //     required this.prioritySupport,
// // //     required this.unlimitedAnalyses,
// // //   });

// // //   factory PlanData.fromJson(Map<String, dynamic> json) {
// // //     return PlanData(
// // //       id: json['id'] ?? '',
// // //       name: json['name'] ?? '',
// // //       category: json['category'] ?? '',
// // //       description: json['description'] ?? '',
// // //       price: json['price'] ?? '0.00',
// // //       durationDays: json['duration_days'],
// // //       scansIncluded: json['scans_included'] ?? 0,
// // //       googleProductId: json['google_product_id'],
// // //       appleProductId: json['apple_product_id'],
// // //       isActive: json['is_active'] ?? false,
// // //       sortOrder: json['sort_order'] ?? 0,
// // //       analysisType: json['analysis_type'] ?? '',
// // //       basicAuthenticityCheck: json['basic_authenticity_check'] ?? false,
// // //       fastProcessing: json['fast_processing'] ?? false,
// // //       showComponentBreakdown: json['show_component_breakdown'] ?? false,
// // //       showComponentObservations: json['show_component_observations'] ?? false,
// // //       componentDetailLevel: json['component_detail_level'] ?? 0,
// // //       showWatchInformation: json['show_watch_information'] ?? false,
// // //       showExpertNotes: json['show_expert_notes'] ?? false,
// // //       showConfidenceMetrics: json['show_confidence_metrics'] ?? false,
// // //       canDownloadPdf: json['can_download_pdf'] ?? false,
// // //       pdfIncludesStamps: json['pdf_includes_stamps'] ?? false,
// // //       pdfIsBilingual: json['pdf_is_bilingual'] ?? false,
// // //       includesPriceEstimation: json['includes_price_estimation'] ?? false,
// // //       priorityProcessing: json['priority_processing'] ?? false,
// // //       prioritySupport: json['priority_support'] ?? false,
// // //       unlimitedAnalyses: json['unlimited_analyses'] ?? false,
// // //     );
// // //   }
// // // }

// // // // Subscription Plan Model (for UI)
// // // class SubscriptionPlan {
// // //   final String id;
// // //   final String name;
// // //   final String description;
// // //   final String icon;
// // //   final List<PricingOption> pricingOptions;
// // //   final List<String> benefits;

// // //   SubscriptionPlan({
// // //     required this.id,
// // //     required this.name,
// // //     required this.description,
// // //     required this.icon,
// // //     required this.pricingOptions,
// // //     required this.benefits,
// // //   });

// // //   factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
// // //     return SubscriptionPlan(
// // //       id: json['id'] ?? '',
// // //       name: json['name'] ?? '',
// // //       description: json['description'] ?? '',
// // //       icon: json['icon'] ?? 'crown',
// // //       pricingOptions: (json['pricing_options'] as List<dynamic>?)
// // //               ?.map((option) => PricingOption.fromJson(option))
// // //               .toList() ??
// // //           [],
// // //       benefits: List<String>.from(json['benefits'] ?? []),
// // //     );
// // //   }

// // //   Map<String, dynamic> toJson() {
// // //     return {
// // //       'id': id,
// // //       'name': name,
// // //       'description': description,
// // //       'icon': icon,
// // //       'pricing_options': pricingOptions.map((o) => o.toJson()).toList(),
// // //       'benefits': benefits,
// // //     };
// // //   }
// // // }

// // // // Pricing Option Model
// // // class PricingOption {
// // //   final String id;
// // //   final String type;
// // //   final double price;
// // //   final String currency;
// // //   final String? badge;
// // //   final String? displayPrice;
// // //   final double? monthlyEquivalent;
// // //   final double? savings;
// // //   final bool isSelected;

// // //   PricingOption({
// // //     required this.id,
// // //     required this.type,
// // //     required this.price,
// // //     required this.currency,
// // //     this.badge,
// // //     this.displayPrice,
// // //     this.monthlyEquivalent,
// // //     this.savings,
// // //     required this.isSelected,
// // //   });

// // //   factory PricingOption.fromJson(Map<String, dynamic> json) {
// // //     return PricingOption(
// // //       id: json['id'] ?? '',
// // //       type: json['type'] ?? 'monthly',
// // //       price: (json['price'] is String)
// // //           ? double.tryParse(json['price']) ?? 0.0
// // //           : (json['price'] as num?)?.toDouble() ?? 0.0,
// // //       currency: json['currency'] ?? 'USD',
// // //       badge: json['badge'],
// // //       displayPrice: null,
// // //       monthlyEquivalent: (json['monthly_equivalent'] is String)
// // //           ? double.tryParse(json['monthly_equivalent'])
// // //           : (json['monthly_equivalent'] as num?)?.toDouble(),
// // //       savings: (json['savings'] is String)
// // //           ? double.tryParse(json['savings'])
// // //           : (json['savings'] as num?)?.toDouble(),
// // //       isSelected: json['is_selected'] ?? false,
// // //     );
// // //   }

// // //   Map<String, dynamic> toJson() {
// // //     return {
// // //       'id': id,
// // //       'type': type,
// // //       'price': price,
// // //       'currency': currency,
// // //       'badge': badge,
// // //       'monthly_equivalent': monthlyEquivalent,
// // //       'savings': savings,
// // //       'is_selected': isSelected,
// // //     };
// // //   }

// // //   PricingOption copyWith({
// // //     String? id,
// // //     String? type,
// // //     double? price,
// // //     String? currency,
// // //     String? badge,
// // //     String? displayPrice,
// // //     double? monthlyEquivalent,
// // //     double? savings,
// // //     bool? isSelected,
// // //   }) {
// // //     return PricingOption(
// // //       id: id ?? this.id,
// // //       type: type ?? this.type,
// // //       price: price ?? this.price,
// // //       currency: currency ?? this.currency,
// // //       badge: badge ?? this.badge,
// // //       displayPrice: displayPrice ?? this.displayPrice,
// // //       monthlyEquivalent: monthlyEquivalent ?? this.monthlyEquivalent,
// // //       savings: savings ?? this.savings,
// // //       isSelected: isSelected ?? this.isSelected,
// // //     );
// // //   }
// // // }



// // // ============================================================
// // // Plan Data Model (API Response)
// // // ============================================================
// // class PlanData {
// //   final String id;
// //   final String name;
// //   final String category;
// //   final String description;
// //   final String price;
// //   final int? durationDays;
// //   final int scansIncluded;
// //   final String? googleProductId;
// //   final String? appleProductId;
// //   final bool isActive;
// //   final int sortOrder;
// //   final String analysisType;
// //   final bool basicAuthenticityCheck;
// //   final bool fastProcessing;
// //   final bool showComponentBreakdown;
// //   final bool showComponentObservations;
// //   final int componentDetailLevel;
// //   final bool showWatchInformation;
// //   final bool showExpertNotes;
// //   final bool showConfidenceMetrics;
// //   final bool canDownloadPdf;
// //   final bool pdfIncludesStamps;
// //   final bool pdfIsBilingual;
// //   final bool includesPriceEstimation;
// //   final bool priorityProcessing;
// //   final bool prioritySupport;
// //   final bool unlimitedAnalyses;

// //   const PlanData({
// //     required this.id,
// //     required this.name,
// //     required this.category,
// //     required this.description,
// //     required this.price,
// //     this.durationDays,
// //     required this.scansIncluded,
// //     this.googleProductId,
// //     this.appleProductId,
// //     required this.isActive,
// //     required this.sortOrder,
// //     required this.analysisType,
// //     required this.basicAuthenticityCheck,
// //     required this.fastProcessing,
// //     required this.showComponentBreakdown,
// //     required this.showComponentObservations,
// //     required this.componentDetailLevel,
// //     required this.showWatchInformation,
// //     required this.showExpertNotes,
// //     required this.showConfidenceMetrics,
// //     required this.canDownloadPdf,
// //     required this.pdfIncludesStamps,
// //     required this.pdfIsBilingual,
// //     required this.includesPriceEstimation,
// //     required this.priorityProcessing,
// //     required this.prioritySupport,
// //     required this.unlimitedAnalyses,
// //   });

// //   factory PlanData.fromJson(Map<String, dynamic> json) {
// //     return PlanData(
// //       id: json['id']?.toString() ?? '',
// //       name: json['name']?.toString() ?? '',
// //       category: json['category']?.toString() ?? '',
// //       description: json['description']?.toString() ?? '',
// //       price: json['price']?.toString() ?? '0.00',
// //       durationDays: json['duration_days'] is int
// //           ? json['duration_days']
// //           : int.tryParse(json['duration_days']?.toString() ?? ''),
// //       scansIncluded: json['scans_included'] is int
// //           ? json['scans_included']
// //           : int.tryParse(json['scans_included']?.toString() ?? '') ?? 0,
// //       googleProductId: json['google_product_id']?.toString(),
// //       appleProductId: json['apple_product_id']?.toString(),
// //       isActive: json['is_active'] == true,
// //       sortOrder: json['sort_order'] is int
// //           ? json['sort_order']
// //           : int.tryParse(json['sort_order']?.toString() ?? '') ?? 0,
// //       analysisType: json['analysis_type']?.toString() ?? '',
// //       basicAuthenticityCheck: json['basic_authenticity_check'] == true,
// //       fastProcessing: json['fast_processing'] == true,
// //       showComponentBreakdown: json['show_component_breakdown'] == true,
// //       showComponentObservations: json['show_component_observations'] == true,
// //       componentDetailLevel: json['component_detail_level'] is int
// //           ? json['component_detail_level']
// //           : int.tryParse(json['component_detail_level']?.toString() ?? '') ?? 0,
// //       showWatchInformation: json['show_watch_information'] == true,
// //       showExpertNotes: json['show_expert_notes'] == true,
// //       showConfidenceMetrics: json['show_confidence_metrics'] == true,
// //       canDownloadPdf: json['can_download_pdf'] == true,
// //       pdfIncludesStamps: json['pdf_includes_stamps'] == true,
// //       pdfIsBilingual: json['pdf_is_bilingual'] == true,
// //       includesPriceEstimation: json['includes_price_estimation'] == true,
// //       priorityProcessing: json['priority_processing'] == true,
// //       prioritySupport: json['priority_support'] == true,
// //       unlimitedAnalyses: json['unlimited_analyses'] == true,
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'name': name,
// //       'category': category,
// //       'description': description,
// //       'price': price,
// //       'duration_days': durationDays,
// //       'scans_included': scansIncluded,
// //       'google_product_id': googleProductId,
// //       'apple_product_id': appleProductId,
// //       'is_active': isActive,
// //       'sort_order': sortOrder,
// //       'analysis_type': analysisType,
// //       'basic_authenticity_check': basicAuthenticityCheck,
// //       'fast_processing': fastProcessing,
// //       'show_component_breakdown': showComponentBreakdown,
// //       'show_component_observations': showComponentObservations,
// //       'component_detail_level': componentDetailLevel,
// //       'show_watch_information': showWatchInformation,
// //       'show_expert_notes': showExpertNotes,
// //       'show_confidence_metrics': showConfidenceMetrics,
// //       'can_download_pdf': canDownloadPdf,
// //       'pdf_includes_stamps': pdfIncludesStamps,
// //       'pdf_is_bilingual': pdfIsBilingual,
// //       'includes_price_estimation': includesPriceEstimation,
// //       'priority_processing': priorityProcessing,
// //       'priority_support': prioritySupport,
// //       'unlimited_analyses': unlimitedAnalyses,
// //     };
// //   }
// // }

// // // ============================================================
// // // Subscription Plan Model (for UI)
// // // ============================================================
// // class SubscriptionPlan {
// //   final String id;
// //   final String name;
// //   final String description;
// //   final String icon;
// //   final List<PricingOption> pricingOptions;
// //   final List<String> benefits;

// //   const SubscriptionPlan({
// //     required this.id,
// //     required this.name,
// //     required this.description,
// //     required this.icon,
// //     required this.pricingOptions,
// //     required this.benefits,
// //   });

// //   factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
// //     return SubscriptionPlan(
// //       id: json['id']?.toString() ?? '',
// //       name: json['name']?.toString() ?? '',
// //       description: json['description']?.toString() ?? '',
// //       icon: json['icon']?.toString() ?? 'crown',
// //       pricingOptions: (json['pricing_options'] as List<dynamic>?)
// //               ?.map((option) => PricingOption.fromJson(option as Map<String, dynamic>))
// //               .toList() ??
// //           [],
// //       benefits: (json['benefits'] as List<dynamic>?)
// //               ?.map((e) => e.toString())
// //               .toList() ??
// //           [],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'name': name,
// //       'description': description,
// //       'icon': icon,
// //       'pricing_options': pricingOptions.map((o) => o.toJson()).toList(),
// //       'benefits': benefits,
// //     };
// //   }
// // }

// // // ============================================================
// // // Pricing Option Model
// // // ============================================================
// // class PricingOption {
// //   final String id;
// //   final String type;
// //   final double price;
// //   final String currency;
// //   final String? badge;
// //   final String? displayPrice;
// //   final double? monthlyEquivalent;
// //   final double? savings;
// //   final bool isSelected;

// //   const PricingOption({
// //     required this.id,
// //     required this.type,
// //     required this.price,
// //     required this.currency,
// //     this.badge,
// //     this.displayPrice,
// //     this.monthlyEquivalent,
// //     this.savings,
// //     required this.isSelected,
// //   });

// //   factory PricingOption.fromJson(Map<String, dynamic> json) {
// //     return PricingOption(
// //       id: json['id']?.toString() ?? '',
// //       type: json['type']?.toString() ?? 'monthly',
// //       price: _parseDouble(json['price']) ?? 0.0,
// //       currency: json['currency']?.toString() ?? 'USD',
// //       badge: json['badge']?.toString(),
// //       displayPrice: null,
// //       monthlyEquivalent: _parseDouble(json['monthly_equivalent']),
// //       savings: _parseDouble(json['savings']),
// //       isSelected: json['is_selected'] == true,
// //     );
// //   }

// //   // ✅ Helper: যেকোনো type থেকে double parse করে
// //   static double? _parseDouble(dynamic value) {
// //     if (value == null) return null;
// //     if (value is double) return value;
// //     if (value is int) return value.toDouble();
// //     if (value is String) return double.tryParse(value);
// //     return null;
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'type': type,
// //       'price': price,
// //       'currency': currency,
// //       'badge': badge,
// //       'monthly_equivalent': monthlyEquivalent,
// //       'savings': savings,
// //       'is_selected': isSelected,
// //     };
// //   }

// //   PricingOption copyWith({
// //     String? id,
// //     String? type,
// //     double? price,
// //     String? currency,
// //     String? badge,
// //     String? displayPrice,
// //     double? monthlyEquivalent,
// //     double? savings,
// //     bool? isSelected,
// //   }) {
// //     return PricingOption(
// //       id: id ?? this.id,
// //       type: type ?? this.type,
// //       price: price ?? this.price,
// //       currency: currency ?? this.currency,
// //       badge: badge ?? this.badge,
// //       displayPrice: displayPrice ?? this.displayPrice,
// //       monthlyEquivalent: monthlyEquivalent ?? this.monthlyEquivalent,
// //       savings: savings ?? this.savings,
// //       isSelected: isSelected ?? this.isSelected,
// //     );
// //   }
// // }




// // ============================================================
// // Plan Data Model (API Response)
// // ============================================================
// class PlanData {
//   final String id;
//   final String name;
//   final String category;
//   final String description;
//   final String price;
//   final int? durationDays;
//   final int scansIncluded;
//   final String? googleProductId;
//   final String? appleProductId;
//   final bool isActive;
//   final int sortOrder;
//   final String analysisType;
//   final bool basicAuthenticityCheck;
//   final bool fastProcessing;
//   final bool showComponentBreakdown;
//   final bool showComponentObservations;
//   final int componentDetailLevel;
//   final bool showWatchInformation;
//   final bool showExpertNotes;
//   final bool showConfidenceMetrics;
//   final bool canDownloadPdf;
//   final bool pdfIncludesStamps;
//   final bool pdfIsBilingual;
//   final bool includesPriceEstimation;
//   final bool priorityProcessing;
//   final bool prioritySupport;
//   final bool unlimitedAnalyses;

//   const PlanData({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.description,
//     required this.price,
//     this.durationDays,
//     required this.scansIncluded,
//     this.googleProductId,
//     this.appleProductId,
//     required this.isActive,
//     required this.sortOrder,
//     required this.analysisType,
//     required this.basicAuthenticityCheck,
//     required this.fastProcessing,
//     required this.showComponentBreakdown,
//     required this.showComponentObservations,
//     required this.componentDetailLevel,
//     required this.showWatchInformation,
//     required this.showExpertNotes,
//     required this.showConfidenceMetrics,
//     required this.canDownloadPdf,
//     required this.pdfIncludesStamps,
//     required this.pdfIsBilingual,
//     required this.includesPriceEstimation,
//     required this.priorityProcessing,
//     required this.prioritySupport,
//     required this.unlimitedAnalyses,
//   });

//   factory PlanData.fromJson(Map<String, dynamic> json) {
//     return PlanData(
//       id: json['id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       category: json['category']?.toString() ?? '',
//       description: json['description']?.toString() ?? '',
//       price: json['price']?.toString() ?? '0.00',
//       durationDays: json['duration_days'] is int
//           ? json['duration_days']
//           : int.tryParse(json['duration_days']?.toString() ?? ''),
//       scansIncluded: json['scans_included'] is int
//           ? json['scans_included']
//           : int.tryParse(json['scans_included']?.toString() ?? '') ?? 0,
//       googleProductId: json['google_product_id']?.toString(),
//       appleProductId: json['apple_product_id']?.toString(),
//       isActive: json['is_active'] == true,
//       sortOrder: json['sort_order'] is int
//           ? json['sort_order']
//           : int.tryParse(json['sort_order']?.toString() ?? '') ?? 0,
//       analysisType: json['analysis_type']?.toString() ?? '',
//       basicAuthenticityCheck: json['basic_authenticity_check'] == true,
//       fastProcessing: json['fast_processing'] == true,
//       showComponentBreakdown: json['show_component_breakdown'] == true,
//       showComponentObservations: json['show_component_observations'] == true,
//       componentDetailLevel: json['component_detail_level'] is int
//           ? json['component_detail_level']
//           : int.tryParse(json['component_detail_level']?.toString() ?? '') ?? 0,
//       showWatchInformation: json['show_watch_information'] == true,
//       showExpertNotes: json['show_expert_notes'] == true,
//       showConfidenceMetrics: json['show_confidence_metrics'] == true,
//       canDownloadPdf: json['can_download_pdf'] == true,
//       pdfIncludesStamps: json['pdf_includes_stamps'] == true,
//       pdfIsBilingual: json['pdf_is_bilingual'] == true,
//       includesPriceEstimation: json['includes_price_estimation'] == true,
//       priorityProcessing: json['priority_processing'] == true,
//       prioritySupport: json['priority_support'] == true,
//       unlimitedAnalyses: json['unlimited_analyses'] == true,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'category': category,
//       'description': description,
//       'price': price,
//       'duration_days': durationDays,
//       'scans_included': scansIncluded,
//       'google_product_id': googleProductId,
//       'apple_product_id': appleProductId,
//       'is_active': isActive,
//       'sort_order': sortOrder,
//       'analysis_type': analysisType,
//       'basic_authenticity_check': basicAuthenticityCheck,
//       'fast_processing': fastProcessing,
//       'show_component_breakdown': showComponentBreakdown,
//       'show_component_observations': showComponentObservations,
//       'component_detail_level': componentDetailLevel,
//       'show_watch_information': showWatchInformation,
//       'show_expert_notes': showExpertNotes,
//       'show_confidence_metrics': showConfidenceMetrics,
//       'can_download_pdf': canDownloadPdf,
//       'pdf_includes_stamps': pdfIncludesStamps,
//       'pdf_is_bilingual': pdfIsBilingual,
//       'includes_price_estimation': includesPriceEstimation,
//       'priority_processing': priorityProcessing,
//       'priority_support': prioritySupport,
//       'unlimited_analyses': unlimitedAnalyses,
//     };
//   }
// }

// // ============================================================
// // Subscription Plan Model (for UI)
// // ============================================================
// class SubscriptionPlan {
//   final String id;
//   final String name;
//   final String description;
//   final String icon;
//   final List<PricingOption> pricingOptions;
//   final List<String> benefits;

//   const SubscriptionPlan({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.icon,
//     required this.pricingOptions,
//     required this.benefits,
//   });

//   factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
//     return SubscriptionPlan(
//       id: json['id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       description: json['description']?.toString() ?? '',
//       icon: json['icon']?.toString() ?? 'crown',
//       pricingOptions: (json['pricing_options'] as List<dynamic>?)
//               ?.map((option) => PricingOption.fromJson(option as Map<String, dynamic>))
//               .toList() ??
//           [],
//       benefits: (json['benefits'] as List<dynamic>?)
//               ?.map((e) => e.toString())
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'icon': icon,
//       'pricing_options': pricingOptions.map((o) => o.toJson()).toList(),
//       'benefits': benefits,
//     };
//   }
// }

// // ============================================================
// // Pricing Option Model
// // ============================================================
// class PricingOption {
//   final String id;           // RevenueCat package identifier (যেমন: $rc_monthly, $rc_annual)
//   final String productId;    // ✅ Google Play product ID (যেমন: premium_yearly, premium_monthly)
//   final String type;
//   final double price;
//   final String currency;
//   final String? badge;
//   final String? displayPrice;
//   final double? monthlyEquivalent;
//   final double? savings;
//   final bool isSelected;

//   const PricingOption({
//     required this.id,
//     required this.productId, // ✅ নতুন required field
//     required this.type,
//     required this.price,
//     required this.currency,
//     this.badge,
//     this.displayPrice,
//     this.monthlyEquivalent,
//     this.savings,
//     required this.isSelected,
//   });

//   factory PricingOption.fromJson(Map<String, dynamic> json) {
//     return PricingOption(
//       id: json['id']?.toString() ?? '',
//       productId: json['product_id']?.toString() ?? json['id']?.toString() ?? '', // ✅ fallback to id
//       type: json['type']?.toString() ?? 'monthly',
//       price: _parseDouble(json['price']) ?? 0.0,
//       currency: json['currency']?.toString() ?? 'USD',
//       badge: json['badge']?.toString(),
//       displayPrice: null,
//       monthlyEquivalent: _parseDouble(json['monthly_equivalent']),
//       savings: _parseDouble(json['savings']),
//       isSelected: json['is_selected'] == true,
//     );
//   }

//   static double? _parseDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value);
//     return null;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'product_id': productId, // ✅
//       'type': type,
//       'price': price,
//       'currency': currency,
//       'badge': badge,
//       'monthly_equivalent': monthlyEquivalent,
//       'savings': savings,
//       'is_selected': isSelected,
//     };
//   }

//   PricingOption copyWith({
//     String? id,
//     String? productId, // ✅
//     String? type,
//     double? price,
//     String? currency,
//     String? badge,
//     String? displayPrice,
//     double? monthlyEquivalent,
//     double? savings,
//     bool? isSelected,
//   }) {
//     return PricingOption(
//       id: id ?? this.id,
//       productId: productId ?? this.productId, // ✅
//       type: type ?? this.type,
//       price: price ?? this.price,
//       currency: currency ?? this.currency,
//       badge: badge ?? this.badge,
//       displayPrice: displayPrice ?? this.displayPrice,
//       monthlyEquivalent: monthlyEquivalent ?? this.monthlyEquivalent,
//       savings: savings ?? this.savings,
//       isSelected: isSelected ?? this.isSelected,
//     );
//   }
// }




class PlanData {
  final String id;
  final String name;
  final String category;
  final String description;
  final String price;
  final int? durationDays;
  final int scansIncluded;
  final String? googleProductId;
  final String? appleProductId;
  final bool isActive;
  final int sortOrder;
  final String analysisType;
  final bool basicAuthenticityCheck;
  final bool fastProcessing;
  final bool showComponentBreakdown;
  final bool showComponentObservations;
  final int componentDetailLevel;
  final bool showWatchInformation;
  final bool showExpertNotes;
  final bool showConfidenceMetrics;
  final bool canDownloadPdf;
  final bool pdfIncludesStamps;
  final bool pdfIsBilingual;
  final bool includesPriceEstimation;
  final bool priorityProcessing;
  final bool prioritySupport;
  final bool unlimitedAnalyses;

  const PlanData({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.durationDays,
    required this.scansIncluded,
    this.googleProductId,
    this.appleProductId,
    required this.isActive,
    required this.sortOrder,
    required this.analysisType,
    required this.basicAuthenticityCheck,
    required this.fastProcessing,
    required this.showComponentBreakdown,
    required this.showComponentObservations,
    required this.componentDetailLevel,
    required this.showWatchInformation,
    required this.showExpertNotes,
    required this.showConfidenceMetrics,
    required this.canDownloadPdf,
    required this.pdfIncludesStamps,
    required this.pdfIsBilingual,
    required this.includesPriceEstimation,
    required this.priorityProcessing,
    required this.prioritySupport,
    required this.unlimitedAnalyses,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '0.00',
      durationDays: json['duration_days'] is int
          ? json['duration_days']
          : int.tryParse(json['duration_days']?.toString() ?? ''),
      scansIncluded: json['scans_included'] is int
          ? json['scans_included']
          : int.tryParse(json['scans_included']?.toString() ?? '') ?? 0,
      googleProductId: json['google_product_id']?.toString(),
      appleProductId: json['apple_product_id']?.toString(),
      isActive: json['is_active'] == true,
      sortOrder: json['sort_order'] is int
          ? json['sort_order']
          : int.tryParse(json['sort_order']?.toString() ?? '') ?? 0,
      analysisType: json['analysis_type']?.toString() ?? '',
      basicAuthenticityCheck: json['basic_authenticity_check'] == true,
      fastProcessing: json['fast_processing'] == true,
      showComponentBreakdown: json['show_component_breakdown'] == true,
      showComponentObservations: json['show_component_observations'] == true,
      componentDetailLevel: json['component_detail_level'] is int
          ? json['component_detail_level']
          : int.tryParse(json['component_detail_level']?.toString() ?? '') ?? 0,
      showWatchInformation: json['show_watch_information'] == true,
      showExpertNotes: json['show_expert_notes'] == true,
      showConfidenceMetrics: json['show_confidence_metrics'] == true,
      canDownloadPdf: json['can_download_pdf'] == true,
      pdfIncludesStamps: json['pdf_includes_stamps'] == true,
      pdfIsBilingual: json['pdf_is_bilingual'] == true,
      includesPriceEstimation: json['includes_price_estimation'] == true,
      priorityProcessing: json['priority_processing'] == true,
      prioritySupport: json['priority_support'] == true,
      unlimitedAnalyses: json['unlimited_analyses'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'scans_included': scansIncluded,
      'google_product_id': googleProductId,
      'apple_product_id': appleProductId,
      'is_active': isActive,
      'sort_order': sortOrder,
      'analysis_type': analysisType,
      'basic_authenticity_check': basicAuthenticityCheck,
      'fast_processing': fastProcessing,
      'show_component_breakdown': showComponentBreakdown,
      'show_component_observations': showComponentObservations,
      'component_detail_level': componentDetailLevel,
      'show_watch_information': showWatchInformation,
      'show_expert_notes': showExpertNotes,
      'show_confidence_metrics': showConfidenceMetrics,
      'can_download_pdf': canDownloadPdf,
      'pdf_includes_stamps': pdfIncludesStamps,
      'pdf_is_bilingual': pdfIsBilingual,
      'includes_price_estimation': includesPriceEstimation,
      'priority_processing': priorityProcessing,
      'priority_support': prioritySupport,
      'unlimited_analyses': unlimitedAnalyses,
    };
  }
}

// ============================================================
// Subscription Plan Model (for UI)
// ============================================================
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final String icon;
  final List<PricingOption> pricingOptions;
  final List<String> benefits;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.pricingOptions,
    required this.benefits,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'crown',
      pricingOptions: (json['pricing_options'] as List<dynamic>?)
              ?.map((option) => PricingOption.fromJson(option as Map<String, dynamic>))
              .toList() ??
          [],
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'pricing_options': pricingOptions.map((o) => o.toJson()).toList(),
      'benefits': benefits,
    };
  }
}

// ============================================================
// Pricing Option Model
// ============================================================
class PricingOption {
  final String id;
  final String productId;
  final String type;
  final double price;
  final String currency;
  final String? badge;
  final String? displayPrice;
  final double? monthlyEquivalent;
  final double? savings;
  final bool isSelected;

  const PricingOption({
    required this.id,
    required this.productId,
    required this.type,
    required this.price,
    required this.currency,
    this.badge,
    this.displayPrice,
    this.monthlyEquivalent,
    this.savings,
    required this.isSelected,
  });

  factory PricingOption.fromJson(Map<String, dynamic> json) {
    return PricingOption(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'monthly',
      price: _parseDouble(json['price']) ?? 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      badge: json['badge']?.toString(),
      displayPrice: null,
      monthlyEquivalent: _parseDouble(json['monthly_equivalent']),
      savings: _parseDouble(json['savings']),
      isSelected: json['is_selected'] == true,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'type': type,
      'price': price,
      'currency': currency,
      'badge': badge,
      'monthly_equivalent': monthlyEquivalent,
      'savings': savings,
      'is_selected': isSelected,
    };
  }

  PricingOption copyWith({
    String? id,
    String? productId,
    String? type,
    double? price,
    String? currency,
    String? badge,
    String? displayPrice,
    double? monthlyEquivalent,
    double? savings,
    bool? isSelected,
  }) {
    return PricingOption(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      badge: badge ?? this.badge,
      displayPrice: displayPrice ?? this.displayPrice,
      monthlyEquivalent: monthlyEquivalent ?? this.monthlyEquivalent,
      savings: savings ?? this.savings,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}