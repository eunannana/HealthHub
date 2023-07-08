// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDailyCaloriesData(
      String userId, String date) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference caloriesRef =
          userRef.collection('uDailysuccesspoint').doc(date).collection('uCalories').doc('data');

      final DocumentSnapshot caloriesSnapshot = await caloriesRef.get();
      if (caloriesSnapshot.exists) {
        final Map<String, dynamic> caloriesData =
            caloriesSnapshot.data() as Map<String, dynamic>;
        return caloriesData;
      }
    } catch (e) {
      print('Error getting daily calories: $e');
    }

    return {};
  }
  
  Future<Map<String, dynamic>> getDailySuccessPoint(
      String userId, String date) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference successPointRef =
          userRef.collection('uDailysuccesspoint').doc(date);

      final DocumentSnapshot successPointSnapshot = await successPointRef.get();
      if (successPointSnapshot.exists) {
        final Map<String, dynamic> successPointData =
            successPointSnapshot.data() as Map<String, dynamic>;
        return successPointData;
      }
    } catch (e) {
      print('Error getting daily success point: $e');
    }

    return {};
  }

  Future<int> getGlobalRank(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('uSuccessPoint', descending: true)
        .get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    int userRank = 0;

    for (int i = 0; i < documents.length; i++) {
      String documentUserId = documents[i].id;

      if (documentUserId == userId) {
        userRank = i + 1;
        break;
      }
    }

    return userRank;
  }

  Future<void> updateDailySuccessPoint(
      String userId,
      String date,
      int hydrationLevel,
      int exerciseDuration,
      int calorieCount,
      int sleepDuration) async {
    try {
      final DocumentReference userRef =
          firestore.collection('users').doc(userId);
      final DocumentReference successPointRef =
          userRef.collection('uDailysuccesspoint').doc(date);

      final DocumentSnapshot successPointSnapshot = await successPointRef.get();
      if (successPointSnapshot.exists) {
        final Map<String, dynamic> successPointData =
            successPointSnapshot.data() as Map<String, dynamic>;

        final int hydrationPoint = hydrationLevel >= 2000 ? 1 : 0;
        final int exercisePoint = exerciseDuration >= 30 ? 1 : 0;
        final int caloriePoint = calorieCount <= 2000 ? 1 : 0;
        final int sleepPoint = sleepDuration >= 7 ? 1 : 0;
        final int successPoint =
            hydrationPoint + exercisePoint + caloriePoint + sleepPoint;

        successPointData['uHydrationLevel'] = hydrationLevel;
        successPointData['uHydrationPoint'] = hydrationPoint;
        successPointData['uExerciseDuration'] = exerciseDuration;
        successPointData['uExercisePoint'] = exercisePoint;
        successPointData['uCalorieCount'] = calorieCount;
        successPointData['uCaloriePoint'] = caloriePoint;
        successPointData['uSleepDuration'] = sleepDuration;
        successPointData['uSleepPoint'] = sleepPoint;
        successPointData['uSuccessPoint'] = successPoint;

        await successPointRef.update(successPointData);
      }
    } catch (e) {
      print('Error updating daily success point: $e');
    }
  }
}
