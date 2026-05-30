
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final String? profileImageUrl;
  final String subscriptionType;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final int freeScansRemaining;
  final int totalScansUsed;
  final bool isPremium;
  final bool canScan;
  final String languagePreference;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.profileImageUrl,
    required this.subscriptionType,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    required this.freeScansRemaining,
    required this.totalScansUsed,
    required this.isPremium,
    required this.canScan,
    required this.languagePreference,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      profileImage: json['profile_image']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      subscriptionType: json['subscription_type']?.toString() ?? 'free',
      subscriptionStartDate: json['subscription_start_date'] != null
          ? DateTime.parse(json['subscription_start_date'])
          : null,
      subscriptionEndDate: json['subscription_end_date'] != null
          ? DateTime.parse(json['subscription_end_date'])
          : null,
      freeScansRemaining: json['free_scans_remaining'] ?? 3,
      totalScansUsed: json['total_scans_used'] ?? 0,
      isPremium: json['is_premium'] ?? false,
      canScan: json['can_scan'] ?? true,
      languagePreference: json['language_preference']?.toString() ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image': profileImage,
      'profile_image_url': profileImageUrl,
      'subscription_type': subscriptionType,
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'free_scans_remaining': freeScansRemaining,
      'total_scans_used': totalScansUsed,
      'is_premium': isPremium,
      'can_scan': canScan,
      'language_preference': languagePreference,
    };
  }
}