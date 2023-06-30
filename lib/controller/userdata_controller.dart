// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
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
}