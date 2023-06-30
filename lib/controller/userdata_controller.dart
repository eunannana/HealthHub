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
}
