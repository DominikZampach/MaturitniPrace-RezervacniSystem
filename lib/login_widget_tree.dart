//? First WidgetTree that will appear, it checks, if User is logged in or not, if not, it will pop out LoginPage and if he is logged in, it will hop onto HomePage

import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/views/home.dart';
import 'package:rezervacni_system_maturita/views/login.dart';

class LoginWidgetTree extends StatefulWidget {
  const LoginWidgetTree({super.key});

  @override
  State<LoginWidgetTree> createState() => _LoginWidgetTreeState();
}

class _LoginWidgetTreeState extends State<LoginWidgetTree> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          print(
            snapshot.data,
          ); // For testing, I will need to identify which user is being logged
          return LoginPage();
        }
      },
    );
  }
}
