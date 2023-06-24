import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthhub/model/user_model.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUp(UserModel user) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      User? firebaseUser = result.user;
      
      // Update user profile with display name
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(user.name);
      }

      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
