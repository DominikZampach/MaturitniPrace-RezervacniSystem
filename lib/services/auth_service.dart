import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/add_user_information.dart';
import 'package:rezervacni_system_maturita/views/admin/home_admin.dart';
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
        DatabaseService dbService = DatabaseService();
        bool isUserAdmin = await dbService.isUserAdmin();
        if (isUserAdmin) {
          //? Provede se, pokud uživatel je admin
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomePageAdmin(),
            ),
          );
          return; //? Return aby aplikace nepokračovala a nezobrazila mi AddUserInformationPage
        }

        bool uzivatelExist = await dbService.doesUzivatelDocumentExist();
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
              builder: (BuildContext context) => AddUserInformationPage(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      print("FirebaseAuthException caught: ${e.code}, ${e.message}");

      switch (e.code) {
        case 'invalid-credential':
          message = "Nesprávné heslo nebo přihlašovací jméno.";
          break;
        case 'too-many-requests':
          message = "Moc požadavků na přihlášení. Zkuste to později.";
          break;
        default:
          message = "Neznámý error: ${e.message}";
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
            builder: (BuildContext context) => AddUserInformationPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      print("FirebaseAuthException caught: ${e.code}, ${e.message}");

      switch (e.code) {
        case 'email-already-in-use':
          message = "Tato emailová adresa je již použitá.";
          break;
        case 'invalid-email':
          message = "Tato emailová adresy není validní.";
          break;
        case 'operation-not-allowed':
          message = "Přihlašování pomocí emailu s heslem není povolené.";
          break;
        default:
          message = "Neznámý error: ${e.message}";
      }

      ToastClass.showToastSnackbar(message: message);
    } catch (e) {
      ToastClass.showToastSnackbar(message: "Neznámý error: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    await _firebaseAuth.signOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
