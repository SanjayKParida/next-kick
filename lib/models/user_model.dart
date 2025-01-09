import 'dart:convert';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String? token;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.token,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      token: map['token']?.toString(),
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
