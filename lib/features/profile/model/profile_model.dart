// Model Class
class UserModel {
  final String name;
  final String email;
  final String image;
  final bool isPremium;

  UserModel({
    required this.name,
    required this.email,
    required this.image,
    required this.isPremium,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      image: json['image'],
      isPremium: json['isPremium'],
    );
  }
}
