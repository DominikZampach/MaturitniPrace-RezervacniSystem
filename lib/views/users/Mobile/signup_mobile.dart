import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/views/login.dart';
import 'package:rezervacni_system_maturita/widgets/bookmycut_logo.dart';
import 'package:rezervacni_system_maturita/widgets/email_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/password_textbox.dart';

class SignupMobile extends StatefulWidget {
  const SignupMobile({super.key});

  @override
  State<SignupMobile> createState() => _SignupMobileState();
}

class _SignupMobileState extends State<SignupMobile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double mobileFontSize = Consts.normalFSM.sp;
    final double mobileSmallerFontSize = Consts.smallerFSM.sp;
    final double mobileHeadingsFontSize = Consts.h1FSM.sp;

    final double verticalPadding = 10.h;
    final double horizontalPadding = 10.w;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.all(10.h),
        child: Column(
          children: [
            BookMyCutLogo(size: 100.h),
            SizedBox(height: 30.h),
            Text(
              "Register now",
              style: TextStyle(
                fontSize: mobileHeadingsFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Create an account and book your first cut!",
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
            PasswordTextbox(
              context: context,
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
              hintText: "repeat password",
              passwordController: _repeatPasswordController,
              fontSize: mobileFontSize,
            ),
            _signupButton(
              context,
              verticalPadding,
              horizontalPadding,
              mobileFontSize,
            ),
            _loginRedirect(
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

  Widget _signupButton(
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
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: 40.h,
          ),
        ),
        child: Text(
          "Sign up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: normalFontSize,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_emailController.text.isEmpty) {
      ToastClass.showToastSnackbar(message: "You need to write your email");
      return;
    }

    if (_passwordController.text.isEmpty) {
      ToastClass.showToastSnackbar(message: "You need to write password");
      return;
    }

    if (_passwordController.text.length < 6) {
      ToastClass.showToastSnackbar(
        message: "Password should be at least 6 characters",
      );
      return;
    }

    if (_repeatPasswordController.text != _passwordController.text) {
      ToastClass.showToastSnackbar(
        message: "The password must be same in both textboxes",
      );
      return;
    }

    await AuthService().registerEmailPassword(
      email: _emailController.text,
      password: _passwordController.text,
      context: context,
    );
  }

  Widget _loginRedirect(
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
            "Already have an account? ",
            style: TextStyle(fontSize: smallerFontSize),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              "Login",
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
