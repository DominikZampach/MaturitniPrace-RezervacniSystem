import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/login_desktop.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/login_mobile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;

          if (isMobile) {
            return LoginMobile();
          } else {
            return LoginDesktop();
          }
        },
      ),
    );
  }
}
