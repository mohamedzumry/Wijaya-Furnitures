import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/firebase_service.dart';
import '../../models/user/registration_result.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<bool> authenticateUsers(String emailAddress, String password) async {
    try {
      final credential = await _firebaseService.firebaseAuth
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      if (credential.user!.email == emailAddress &&
          credential.user!.uid.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<UserCredential> handleGoogleSignIn() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    final UserCredential user =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    return user;
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // try {
    //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    //   if (googleUser != null) {
    //     await googleUser.authentication;
    //   } else {
    //     throw Exception('Google Sign In Failed');
    //   }
    // } catch (error) {
    //   debugPrint('Error signing in with Google: $error');
    // }
  }

  Future<RegistrationResult> sendPasswordResetEmail(String emailAddress) async {
    try {
      await _firebaseService.firebaseAuth
          .sendPasswordResetEmail(email: emailAddress);

      return const RegistrationResult(status: RegistrationStatus.success);
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'Error sending password reset email';
      }
      return RegistrationResult(
          status: RegistrationStatus.error, errorMessage: errorMessage);
    }
  }

  Future<RegistrationResult> registerUser(
      String emailAddress, String password) async {
    try {
      final credential = await _firebaseService.firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);

      if (credential.user!.email == emailAddress &&
          credential.user!.uid.isNotEmpty) {
        return const RegistrationResult(status: RegistrationStatus.success);
      } else {
        return const RegistrationResult(status: RegistrationStatus.error);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
        default:
          errorMessage = 'Error creating user';
      }
      return RegistrationResult(
          status: RegistrationStatus.error, errorMessage: errorMessage);
    }
  }
}
