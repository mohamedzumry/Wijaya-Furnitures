import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  factory FirebaseService() {
    return _instance;
  }

  Future<void> savePdfMetadata(String fileName, String downloadUrl) async {
    await FirebaseFirestore.instance.collection('pdf_metadata').add({
      'filename': fileName,
      'downloadUrl': downloadUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  FirebaseService._internal();
}
