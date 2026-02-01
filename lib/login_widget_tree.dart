import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/add_user_information.dart';
import 'package:rezervacni_system_maturita/views/admin/home_admin.dart';
import 'package:rezervacni_system_maturita/views/login.dart';
import 'package:rezervacni_system_maturita/views/users/home.dart';

class LoginWidgetTree extends StatelessWidget {
  const LoginWidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        //? Uživatel není přihlášen -> ukaž login
        if (!snapshot.hasData || snapshot.data == null) {
          return const Login();
        }

        //? Print pro kontrolu při vývoji
        print(
          "Auth Email: ${snapshot.data!.email}\nAuth UID: ${snapshot.data!.uid}",
        );

        //? Uživatel je přihlášen -> ověření pokud není admin (používáme konstanty ze souboru Consts.dart)
        if ((snapshot.data!.email == Consts.ADMIN_EMAIL) &&
            (snapshot.data!.uid == Consts.ADMIN_UID)) {
          return const HomePageAdmin();
        }

        //? Uživatel je přihlášen a zároveň to není admin -> potřebujeme ověřit, jestli existuje jeho uživatelský dokument
        return FutureBuilder<bool>(
          future: DatabaseService().doesUzivatelDocumentExist(),
          builder: (context, userInfoSnapshot) {
            debugPrint("Stav připojení: ${userInfoSnapshot.connectionState}");
            debugPrint("Má data: ${userInfoSnapshot.hasData}");

            if (userInfoSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (userInfoSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Chyba databáze: ${userInfoSnapshot.error}"),
                ),
              );
            }

            final bool hasUserDocument = userInfoSnapshot.data ?? false;

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
