class HomeModel {
  final HomeUserData userData;
  final PlanLimit planLimit;

  const HomeModel({required this.userData, required this.planLimit});

  factory HomeModel.empty() =>
      HomeModel(userData: HomeUserData.empty(), planLimit: PlanLimit.empty());

  /// API response: { "user_data": {...}, "user_plan_limit": {...} }
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      userData: HomeUserData.fromJson(
        (json['user_data'] as Map<String, dynamic>?) ?? {},
      ),
      planLimit: PlanLimit.fromJson(
        (json['user_plan_limit'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  /// Local cache (AuthService) theke banano
  factory HomeModel.fromLocal(
    Map<String, dynamic>? user,
    Map<String, dynamic>? plan,
  ) {
    return HomeModel(
      userData: HomeUserData.fromJson(user ?? {}),
      planLimit: PlanLimit.fromJson(plan ?? {}),
    );
  }

  int get totalScans => planLimit.total;
  bool get isPremium => userData.userStatus == 'premium';
}

class HomeUserData {
  final int id;
  final String customizedUserId;
  final String? profilePicture;
  final String userType;
  final String userStatus;
  final bool isVerified;
  final String fullName;
  final String email;
  final String? phone;
  final String? address;

  const HomeUserData({
    required this.id,
    required this.customizedUserId,
    this.profilePicture,
    required this.userType,
    required this.userStatus,
    required this.isVerified,
    required this.fullName,
    required this.email,
    this.phone,
    this.address,
  });

  factory HomeUserData.empty() => const HomeUserData(
        id: 0,
        customizedUserId: '',
        userType: 'user',
        userStatus: 'non_premium',
        isVerified: false,
        fullName: '',
        email: '',
      );

  factory HomeUserData.fromJson(Map<String, dynamic> json) {
    return HomeUserData(
      id: _toInt(json['id']),
      customizedUserId: json['customized_user_id']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString(),
      userType: json['user_type']?.toString() ?? 'user',
      userStatus: json['user_status']?.toString() ?? 'non_premium',
      isVerified: json['is_verified']?.toString().toLowerCase() == 'true',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
    );
  }
}

class PlanLimit {
  final int scanLimit;
  final int monthlyPackage;
  final int unlimitedPackage;

  const PlanLimit({
    required this.scanLimit,
    required this.monthlyPackage,
    required this.unlimitedPackage,
  });

  factory PlanLimit.empty() =>
      const PlanLimit(scanLimit: 0, monthlyPackage: 0, unlimitedPackage: 0);

  factory PlanLimit.fromJson(Map<String, dynamic> json) {
    return PlanLimit(
      scanLimit: _toInt(json['scan_limit']),
      monthlyPackage: _toInt(json['monthly_package']),
      unlimitedPackage: _toInt(json['unlimited_package']),
    );
  }

  int get total => scanLimit + monthlyPackage + unlimitedPackage;
}

/// "not purchased yet" / null / "5" / 5 / 5.0 shob handle kore
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    final d = double.tryParse(value.trim());
    return d?.toInt() ?? 0; // "not purchased yet" => 0
  }
  return 0;
}