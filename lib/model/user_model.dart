// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String uId;
  String uName;
  String uEmail;
  String uDateOfBirth;
  String uGender;
  int? uHydrateValue;
  int? uHydratePoint;
  int? uCalorieValue;
  int? uCaloriePoint;
  int? uExerciseValue;
  int? uExercisePoint;
  int? uSleepValue;
  int? uSleepPoint;
  int? uSuccessPoint;
  

  UserModel({
    required this.uId,
    required this.uName,
    required this.uEmail,
    required this.uDateOfBirth,
    required this.uGender,
    this.uHydrateValue,
    this.uHydratePoint,
    this.uCalorieValue,
    this.uCaloriePoint,
    this.uExerciseValue,
    this.uExercisePoint,
    this.uSleepValue,
    this.uSleepPoint,
    this.uSuccessPoint,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'uName': uName,
      'uEmail': uEmail,
      'uDateOfBirth': uDateOfBirth,
      'uGender': uGender,
      'uHydrateValue': uHydrateValue,
      'uHydratePoint': uHydratePoint,
      'uCalorieValue': uCalorieValue,
      'uCaloriePoint': uCaloriePoint,
      'uExerciseValue': uExerciseValue,
      'uExercisePoint': uExercisePoint,
      'uSleepValue': uSleepValue,
      'uSleepPoint': uSleepPoint,
      'uSuccessPoint': uSuccessPoint,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] as String,
      uName: map['uName'] as String,
      uEmail: map['uEmail'] as String,
      uDateOfBirth: map['uDateOfBirth'] as String,
      uGender: map['uGender'] as String,
      uHydrateValue: map['uHydrateValue']?.toInt(),
      uHydratePoint: map['uHydratePoint']?.toInt(),
      uCalorieValue: map['uCalorieValue']?.toInt(),
      uCaloriePoint: map['uCaloriePoint']?.toInt(),
      uExerciseValue: map['uExerciseValue']?.toInt(),
      uExercisePoint: map['uExercisePoint']?.toInt(),
      uSleepValue: map['uSleepValue']?.toInt(),
      uSleepPoint: map['uSleepPoint']?.toInt(),
      uSuccessPoint: map['uSuccessPoint']?.toInt(),
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
     int? uHydrateValue,
    int? uHydratePoint,
    int? uCalorieValue,
    int? uCaloriePoint,
    int? uExerciseValue,
    int? uExercisePoint,
    int? uSleepValue,
    int? uSleepPoint,
    int? uSuccessPoint,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      uName: uName ?? this.uName,
      uEmail: uEmail ?? this.uEmail,
      uDateOfBirth: uDateOfBirth ?? this.uDateOfBirth,
      uGender: uGender ?? this.uGender,
      uHydrateValue: uHydrateValue ?? this.uHydrateValue,
      uHydratePoint: uHydratePoint ?? this.uHydratePoint,
      uCalorieValue: uCalorieValue ?? this.uCalorieValue,
      uCaloriePoint: uCaloriePoint ?? this.uCaloriePoint,
      uExerciseValue: uExerciseValue ?? this.uExerciseValue,
      uExercisePoint: uExercisePoint ?? this.uExercisePoint,
      uSleepValue: uSleepValue ?? this.uSleepValue,
      uSleepPoint: uSleepPoint ?? this.uSleepPoint,
      uSuccessPoint: uSuccessPoint ?? this.uSuccessPoint,
    );
  }

  @override
  String toString() {
    return 'UserModel(uId: $uId, uName: $uName, uEmail: $uEmail, uDateOfBirth: $uDateOfBirth, uGender: $uGender, uHydrateValue: $uHydrateValue, uHydratePoint: $uHydratePoint, uCalorieValue: $uCalorieValue, uCaloriePoint: $uCaloriePoint, uExerciseValue: $uExerciseValue, uExercisePoint: $uExercisePoint, uSleepValue: $uSleepValue, uSleepPoint: $uSleepPoint, uSuccessPoint: $uSuccessPoint)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uId == uId &&
      other.uName == uName &&
      other.uEmail == uEmail &&
      other.uDateOfBirth == uDateOfBirth &&
      other.uGender == uGender&&
      other.uHydrateValue == uHydrateValue &&
      other.uHydratePoint == uHydratePoint &&
      other.uCalorieValue == uCalorieValue &&
      other.uCaloriePoint == uCaloriePoint &&
      other.uExerciseValue == uExerciseValue &&
      other.uExercisePoint == uExercisePoint &&
      other.uSleepValue == uSleepValue &&
      other.uSleepPoint == uSleepPoint &&
      other.uSuccessPoint == uSuccessPoint;;
  }

  @override
  int get hashCode {
    return uId.hashCode ^
      uName.hashCode ^
      uEmail.hashCode ^
      uDateOfBirth.hashCode ^
      uGender.hashCode ^
      uHydrateValue.hashCode ^
      uHydratePoint.hashCode ^
      uCalorieValue.hashCode ^
      uCaloriePoint.hashCode ^
      uExerciseValue.hashCode ^
      uExercisePoint.hashCode ^
      uSleepValue.hashCode ^
      uSleepPoint.hashCode ^
      uSuccessPoint.hashCode;
      
  }
}
