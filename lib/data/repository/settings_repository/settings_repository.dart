import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:furniture_shop_wijaya/data/service/firebase/firebase_service.dart';

class SettingsRepository {
  // final FirebaseService _firebaseService = FirebaseService();
  // late String adminPassword;

  // Create a reference to the Firestore collection
  final CollectionReference adminPasswords =
      FirebaseFirestore.instance.collection('app-settings');

  Future<String> getAdminPassword() async {
    // FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;

    try {
      // Get the document snapshot
      DocumentSnapshot snapshot =
          await adminPasswords.doc('special_passwords').get();

      // Access the data in the document
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Access the admin_password field
      String adminPassword = data['admin_password'];

      return adminPassword;
    } catch (e) {
      debugPrint('Error getting admin password: $e');
      return e.toString();
    }

    // final adminPasswordDocRef =
    //     firebaseFirestore.collection('app-settings').doc('special_passwords');
    // adminPasswordDocRef.get().then(
    //   (DocumentSnapshot doc) {
    //     final adminPasswordDoc = doc.data() as Map<String, dynamic>;
    //     adminPassword = adminPasswordDoc['admin_password'];
    //   },
    //   onError: (e) => debugPrint("Error getting document: $e"),
    // );
    // return adminPassword;
  }
}
