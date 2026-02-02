import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/views/signup.dart';
import 'package:rezervacni_system_maturita/widgets/email_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/password_textbox.dart';

class LoginDesktop extends StatefulWidget {
  const LoginDesktop({super.key});

  @override
  State<LoginDesktop> createState() => _LoginDesktopState();
}

class _LoginDesktopState extends State<LoginDesktop> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = 5.h;
    final double horizontalPadding = 20.w;

    final double smallerFontSize = Consts.smallerFS.sp;
    final double normalFontSize = Consts.normalFS.sp;
    final double h1FontSize = Consts.h1FS.sp;
    final double h2FontSize = Consts.h2FS.sp;

    return Center(
      //? SingleChildScroolView zajišťuje, že nikdy nebude něco přetékat přes okraj při zmenšování
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withValues(alpha: 0.2),
                blurRadius: 5.r,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: h1FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: smallerFontSize),
                ),
                EmailTextbox(
                  context: context,
                  verticalPadding: verticalPadding,
                  horizontalPadding: horizontalPadding,
                  emailController: _emailController,
                ),
                PasswordTextbox(
                  context: context,
                  verticalPadding: verticalPadding,
                  horizontalPadding: horizontalPadding,
                  hintText: "password",
                  passwordController: _passwordController,
                ),
                SizedBox(height: 5.h),
                _loginButton(
                  context,
                  verticalPadding,
                  horizontalPadding,
                  h2FontSize,
                ),
                _signUpRedirect(
                  context,
                  verticalPadding,
                  horizontalPadding,
                  smallerFontSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
    double fontSize,
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
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: 40.h,
          ),
        ),
        child: Text(
          "Log in",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
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
                MaterialPageRoute(builder: (context) => Signup()),
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
