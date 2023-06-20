// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uId;
  String name;
  String email;
  DateTime dateOfBirth;
  String password;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? uId,
    String? name,
    String? email,
    DateTime? dateOfBirth,
    String? password,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'UserModel(uId: $uId, name: $name, email: $email, dateOfBirth: $dateOfBirth, password: $password)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uId == uId &&
      other.name == name &&
      other.email == email &&
      other.dateOfBirth == dateOfBirth &&
      other.password == password;
  }

  @override
  int get hashCode => uId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      dateOfBirth.hashCode ^
      password.hashCode;

      static UserModel? fromFirebaseUser(User user){
  }
}
