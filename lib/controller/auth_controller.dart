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
      throw e;
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

  Future<String?> getUserName(String uId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(uId).get();

      if (userSnapshot.exists) {
        return userSnapshot['uName'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }
  Future<List<String>> getAllUserNames() async {
    try {
      final QuerySnapshot snapshot = await usersCollection.get();
      final List<String> userNames = [];

      for (final DocumentSnapshot doc in snapshot.docs) {
        final String? userName = doc['uName'];
        if (userName != null) {
          userNames.add(userName);
        }
      }

      return userNames;
    } catch (e) {
      print('Error fetching user names: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllUserNamesWithPoints() async {
    try {
      final QuerySnapshot snapshot = await usersCollection.get();
      final List<Map<String, dynamic>> userNamesWithPoints = [];

      for (final DocumentSnapshot doc in snapshot.docs) {
        final String? userName = doc['uName'];

        final QuerySnapshot successPointSnapshot = await usersCollection
            .doc(doc.id)
            .collection('uDailysuccesspoint')
            .get();

        int totalSuccessPoint = 0;
        for (final DocumentSnapshot successPointDoc
            in successPointSnapshot.docs) {
          final int successPoint = successPointDoc['uSuccessPoint'] ?? 0;
          totalSuccessPoint += successPoint;
        }

        if (userName != null) {
          final Map<String, dynamic> userWithPoint = {
            'userName': userName,
            'successPoint': totalSuccessPoint,
          };
          userNamesWithPoints.add(userWithPoint);
        }
      }

      userNamesWithPoints
          .sort((a, b) => b['successPoint'].compareTo(a['successPoint']));

      return userNamesWithPoints;
    } catch (e) {
      print('Error fetching user names with points: $e');
      return [];
    }
  }
}
