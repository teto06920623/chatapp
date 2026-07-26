class UserModel {
  final String password;
  final String uid;
  final String email;
  final String name;
  final String? urlImage;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.password,
    this.urlImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? 'مستخدم',
      password: json['password'] ?? '',
      urlImage: json['urlImage'],
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'password': password,
      'urlImage': urlImage,
    };
  }
}
