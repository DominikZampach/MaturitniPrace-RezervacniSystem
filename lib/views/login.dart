import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/views/signup.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/login_desktop.dart';
import 'package:rezervacni_system_maturita/widgets/email_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/password_textbox.dart';

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
            return Text("TODO");
          } else {
            return LoginDesktop();
          }
        },
      ),
    );
  }
}
