// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthhub/model/user_model.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel?> createUserWithEmailAndPassword(String email,
      String password, String name, String dob, String gender) async {
    try {
      final QuerySnapshot snapshot = await usersCollection
          .where('uEmail', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        throw Exception('Email is already registered');
      }

      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      // Update user profile with display name
      if (user != null) {
        final UserModel newUser = UserModel(
            uName: name,
            uEmail: user.email ?? '',
            uId: user.uid,
            uDateOfBirth: dob,
            uGender: gender);

        final DateTime now = DateTime.now();
        final String formattedDate =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        final Map<String, dynamic> initialSuccessPoint = {
          'uHydrationLevel': 0,
          'uHydrationPoint': 0,
          'uExerciseDuration': 0,
          'uExercisePoint': 0,
          'uCalorieCount': 0,
          'uCaloriePoint': 0,
          'uSleepDuration': 0,
          'uSleepPoint': 0,
          'uSuccessPoint': 0,
        };

        await usersCollection.doc(newUser.uId).set(newUser.toMap());
        await usersCollection
            .doc(newUser.uId)
            .collection('uDailysuccesspoint')
            .doc(formattedDate)
            .set(initialSuccessPoint);

        return newUser;
      }
    } catch (e) {
      print('Error registering user: $e');
    }
    return null;
  }

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot snapshot =
            await usersCollection.doc(user.uid).get();

        if (snapshot.exists) {
          final UserModel loggedInUser =
              UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

          final DateTime now = DateTime.now();
          final String formattedDate =
              '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

          final DocumentSnapshot dailySuccessPointSnapshot =
              await usersCollection
                  .doc(loggedInUser.uId)
                  .collection('uDailysuccesspoint')
                  .doc(formattedDate)
                  .get();

          if (!dailySuccessPointSnapshot.exists) {
            // Inisialisasi daily success point dengan data kosong
            final Map<String, dynamic> initialSuccessPoint = {
              'uHydrationLevel': 0,
              'uHydrationPoint': 0,
              'uExerciseDuration': 0,
              'uExercisePoint': 0,
              'uCalorieCount': 0,
              'uCaloriePoint': 0,
              'uSleepDuration': 0,
              'uSleepPoint': 0,
              'uSuccessPoint': 0,
            };

            await usersCollection
                .doc(loggedInUser.uId)
                .collection('uDailysuccesspoint')
                .doc(formattedDate)
                .set(initialSuccessPoint);
          }

          return loggedInUser;
        }
      }
    } catch (e) {
      print('Error logging in: $e');
    }
    return null;
  }
}
