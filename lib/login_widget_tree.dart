import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/login.dart';
import 'package:rezervacni_system_maturita/views/users/add_user_information.dart';
import 'package:rezervacni_system_maturita/views/users/home.dart';

class LoginWidgetTree extends StatelessWidget {
  const LoginWidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        //? Uživatel není přihlášen -> ukaž login
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        //? Uživatel je přihlášen -> potřebujeme ověřit, jestli existuje jeho dokument
        return FutureBuilder<bool>(
          future: DatabaseService().doesUzivatelDocumentExist(),
          builder: (context, userInfoSnapshot) {
            //? Načítání Firestore
            if (!userInfoSnapshot.hasData) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final hasUserDocument = userInfoSnapshot.data!;

            if (hasUserDocument) {
              return const HomePage();
            } else {
              return const AddUserInformationPage();
            }
          },
        );
      },
    );
  }
}
