import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/add_user_information.dart';
import 'package:rezervacni_system_maturita/views/users/home.dart';
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
        bool uzivatelExist = await DatabaseService()
            .doesUzivatelDocumentExist();
        if (uzivatelExist) {
          //? Provede se, pokud dokument uživatele již existuje, není potřeba nic nastavovat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(),
            ),
          );
        } else {
          //? Ukáže se uživateli okno s vynuceným nastavením osobních údajů
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddUserInformationPage(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      print("FirebaseAuthException caught: ${e.code}, ${e.message}");

      switch (e.code) {
        case 'invalid-credential':
          message = "Invalid login.";
          break;
        case 'too-many-requests':
          message = "Too many requests. Please try it later.";
          break;
        default:
          message = "An unknown error occurred: ${e.message}";
      }

      ToastClass.showToastSnackbar(message: message);
    }
  }

  Future<void> registerEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (context.mounted) {
        //? Ukáže se uživateli okno s vynuceným nastavením osobních údajů
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AddUserInformationPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      print("FirebaseAuthException caught: ${e.code}, ${e.message}");

      switch (e.code) {
        case 'email-already-in-use':
          message = "The email address is already in use by another account.";
          break;
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        case 'operation-not-allowed':
          message = "Email/Password accounts are not enabled.";
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
