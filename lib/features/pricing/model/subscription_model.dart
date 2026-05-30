// class SubscriptionPlan {
//   final String id;
//   final String name;
//   final String description;
//   final String icon;
//   final List<PricingOption> pricingOptions;
//   final List<String> benefits;

//   SubscriptionPlan({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.icon,
//     required this.pricingOptions,
//     required this.benefits,
//   });

//   factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
//     return SubscriptionPlan(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       icon: json['icon'],
//       pricingOptions: (json['pricing_options'] as List)
//           .map((option) => PricingOption.fromJson(option))
//           .toList(),
//       benefits: List<String>.from(json['benefits']),
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

// class PricingOption {
//   final String id;
//   final String type; // 'monthly' or 'yearly'
//   final double price;
//   final String currency;
//   final String? badge; // 'MOST POPULAR', 'Best Value', etc.
//   final double? monthlyEquivalent;
//   final double? savings;
//   final bool isSelected;

//   PricingOption({
//     required this.id,
//     required this.type,
//     required this.price,
//     required this.currency,
//     this.badge,
//     this.monthlyEquivalent,
//     this.savings,
//     this.isSelected = false,
//   });

//   factory PricingOption.fromJson(Map<String, dynamic> json) {
//     return PricingOption(
//       id: json['id'],
//       type: json['type'],
//       price: json['price'].toDouble(),
//       currency: json['currency'],
//       badge: json['badge'],
//       monthlyEquivalent: json['monthly_equivalent']?.toDouble(),
//       savings: json['savings']?.toDouble(),
//       isSelected: json['is_selected'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
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
//     String? type,
//     double? price,
//     String? currency,
//     String? badge,
//     double? monthlyEquivalent,
//     double? savings,
//     bool? isSelected,
//   }) {
//     return PricingOption(
//       id: id ?? this.id,
//       type: type ?? this.type,
//       price: price ?? this.price,
//       currency: currency ?? this.currency,
//       badge: badge ?? this.badge,
//       monthlyEquivalent: monthlyEquivalent ?? this.monthlyEquivalent,
//       savings: savings ?? this.savings,
//       isSelected: isSelected ?? this.isSelected,
//     );
//   }
// }