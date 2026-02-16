import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/views/login.dart';
import 'package:rezervacni_system_maturita/widgets/email_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/password_textbox.dart';

class SignupDesktop extends StatefulWidget {
  const SignupDesktop({super.key});

  @override
  State<SignupDesktop> createState() => _SignupDesktopState();
}

class _SignupDesktopState extends State<SignupDesktop> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = 5.h;
    final double horizontalPadding = 20.w;

    final double smallerFontSize = Consts.smallerFS.sp;
    final double h1FontSize = Consts.h1FS.sp;
    final double h2FontSize = Consts.h2FS.sp;

    return Center(
      //? SingleChildScroolView zajišťuje, že nikdy nebude něco přetékat přes okraj při zmenšování
      child: SingleChildScrollView(
        child: Container(
          width: 375.0.w,
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
                  "Registrace",
                  style: TextStyle(
                    fontSize: h1FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Zaregistrujte se a rezervujte si svůj první haircut!",
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
                PasswordTextbox(
                  context: context,
                  verticalPadding: verticalPadding,
                  horizontalPadding: horizontalPadding,
                  hintText: "repeat password",
                  passwordController: _repeatPasswordController,
                ),
                SizedBox(height: 5.h),
                _signupButton(
                  context,
                  verticalPadding,
                  horizontalPadding,
                  h2FontSize,
                ),
                _loginRedirect(
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

  Widget _signupButton(
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
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: 40.h,
          ),
        ),
        child: Text(
          "Registrovat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_emailController.text.isEmpty) {
      ToastClass.showToastSnackbar(message: "Musíte zadat email.");
      return;
    }

    if (_passwordController.text.isEmpty) {
      ToastClass.showToastSnackbar(message: "Musíte zadat heslo.");
      return;
    }

    if (_passwordController.text.length < 6) {
      ToastClass.showToastSnackbar(
        message: "Heslo musí mít minimálně 6 znaků.",
      );
      return;
    }

    if (_repeatPasswordController.text != _passwordController.text) {
      ToastClass.showToastSnackbar(message: "Hesla se musí shodovat.");
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
          Text("Již máte účet? ", style: TextStyle(fontSize: smallerFontSize)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              "Přihlásit se",
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
