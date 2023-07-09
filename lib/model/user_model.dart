import 'dart:convert';

class UserModel {
  String uName;
  String uEmail;
  String uId;
  String uDateOfBirth;
  String uGender;

  UserModel({
    required this.uName,
    required this.uEmail,
    required this.uId,
    required this.uDateOfBirth,
    required this.uGender,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uName: map['uName'] ?? '',
      uEmail: map['uEmail'] ?? '',
      uId: map['uId'] ?? '',
      uDateOfBirth: map['uDateOfBirth'] ?? '',
      uGender: map['uGender'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uName': uName,
      'uEmail': uEmail,
      'uId': uId,
      'uDateOfBirth': uDateOfBirth,
      'uGender': uGender,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uName: $uName, uEmail: $uEmail, uId: $uId, uDateOfBirth: $uDateOfBirth, uGender: $uGender)';
  }
}
