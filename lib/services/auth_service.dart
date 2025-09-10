import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/views/home.dart';
import 'package:rezervacni_system_maturita/views/login.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> loginEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      print("FirebaseAuthException caught: ${e.code}, ${e.message}");

      switch (e.code) {
        case 'user-not-found':
          message = "User not found.";
          break;
        case 'wrong-password':
          message = "You entered wrong password.";
          break;
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        default:
          message = "An unknown error occurred: ${e.message}";
      }

      ToastClass.showToastSnackbar(message: message);
    } catch (e) {
      ToastClass.showToastSnackbar(message: "An unexpected error occurred: $e");
    }
  }

  /*
  Future<void> loginGoogle(BuildContext context) async {
    try {
      await _firebaseAuth.signInWithRedirect(GoogleAuthProvider());

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ToastClass.showToastSnackbar(message: e.message!);
    }
  }
  */

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
