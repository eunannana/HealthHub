import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthhub/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel?> createUserWithEmailAndPassword(String email,
      String password, String name, DateTime dob, String gender) async {
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
        await usersCollection.doc(newUser.uId).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      print('Error registering user: $e');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;

      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
