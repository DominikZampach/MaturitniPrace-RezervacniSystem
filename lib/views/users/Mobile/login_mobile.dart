import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/views/signup.dart';
import 'package:rezervacni_system_maturita/widgets/bookmycut_logo.dart';
import 'package:rezervacni_system_maturita/widgets/email_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/password_textbox.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double mobileFontSize = Consts.normalFSM.sp;
    final double mobileSmallerFontSize = Consts.smallerFSM.sp;
    final double mobileHeadingsFontSize = Consts.h1FSM.sp;

    final double verticalPadding = 10.h;
    final double horizontalPadding = 10.w;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BookMyCutLogo(size: 100.h),
            SizedBox(height: 30.h),
            Text(
              "Login",
              style: TextStyle(
                fontSize: mobileHeadingsFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: mobileSmallerFontSize),
            ),
            EmailTextbox(
              context: context,
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
              emailController: _emailController,
              fontSize: mobileFontSize,
            ),
            PasswordTextbox(
              context: context,
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
              hintText: "password",
              passwordController: _passwordController,
              fontSize: mobileFontSize,
            ),
            _loginButton(
              context,
              verticalPadding,
              horizontalPadding,
              mobileFontSize,
            ),
            _signUpRedirect(
              context,
              verticalPadding,
              horizontalPadding,
              mobileSmallerFontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
    double normalFontSize,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          "Log in",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: normalFontSize,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_emailController.text.isEmpty) {
      ToastClass.showToastSnackbar(message: "You need to write your email");
      return;
    }

    if (_passwordController.text.isEmpty) {
      ToastClass.showToastSnackbar(message: "You need to write password");
      return;
    }

    await AuthService().loginEmailPassword(
      email: _emailController.text,
      password: _passwordController.text,
      context: context,
    );
  }

  Widget _signUpRedirect(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
    double smallerFontSize,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Are you new here? ",
            style: TextStyle(fontSize: smallerFontSize),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Signup(),
                ), //TODO: Musím v SignUpPage udělat to stejné co s Login (odkazovat na toto a tam až vybrat podle šířky obrazovky vhodný přístup pomocí LayoutBuilderu)
              );
            },
            child: Text(
              "Create an account",
              style: TextStyle(
                fontSize: smallerFontSize,
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
