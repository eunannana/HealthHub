// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String uId;
  String uName;
  String uEmail;
  String uDateOfBirth;
  String uGender;

  UserModel({
    required this.uId,
    required this.uName,
    required this.uEmail,
    required this.uDateOfBirth,
    required this.uGender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'uName': uName,
      'uEmail': uEmail,
      'uDateOfBirth': uDateOfBirth,
      'uGender': uGender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] as String,
      uName: map['uName'] as String,
      uEmail: map['uEmail'] as String,
      uDateOfBirth: map['uDateOfBirth'] as String,
      uGender: map['uGender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? uId,
    String? uName,
    String? uEmail,
    String? uDateOfBirth,
    String? uGender,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      uName: uName ?? this.uName,
      uEmail: uEmail ?? this.uEmail,
      uDateOfBirth: uDateOfBirth ?? this.uDateOfBirth,
      uGender: uGender ?? this.uGender,
    );
  }

  @override
  String toString() {
    return 'UserModel(uId: $uId, uName: $uName, uEmail: $uEmail, uDateOfBirth: $uDateOfBirth, uGender: $uGender)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uId == uId &&
      other.uName == uName &&
      other.uEmail == uEmail &&
      other.uDateOfBirth == uDateOfBirth &&
      other.uGender == uGender;
  }

  @override
  int get hashCode {
    return uId.hashCode ^
      uName.hashCode ^
      uEmail.hashCode ^
      uDateOfBirth.hashCode ^
      uGender.hashCode;
  }
}
