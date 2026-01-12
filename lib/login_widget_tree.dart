import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/admin/home_admin.dart';
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
          return const Login();
        }

        print(
          "Auth Email: ${snapshot.data!.email}\nAuth UID: ${snapshot.data!.uid}",
        );

        //? Uživatel je přihlášen -> ověření pokud není admin
        if ((snapshot.data!.email == Consts.ADMIN_EMAIL) &&
            (snapshot.data!.uid == Consts.ADMIN_UID)) {
          return const HomePageAdmin();
        }

        //? Uživatel je přihlášen a zároveň to není admin -> potřebujeme ověřit, jestli existuje jeho dokument
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
