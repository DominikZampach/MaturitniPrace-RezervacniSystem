import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/views/login.dart';
import 'package:rezervacni_system_maturita/widgets/email_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/password_textbox.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool wide = constraints.maxWidth < 800;

          // Tohle dělá to, že když je šířka menší než 800px, tak ten bílý container bude přes celou obrazovku jakoby
          final double loginContainerWidth = wide
              ? constraints.maxWidth
              : 375.0.w;
          final double loginContainerHeight = wide
              ? constraints.maxHeight
              : 460.0.h;

          final double verticalPadding = 10;
          final double horizontalPadding = 30;

          return Center(
            child: Container(
              width: loginContainerWidth,
              height: loginContainerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: wide
                    ? BorderRadius.zero
                    : BorderRadius.circular(20.r),
                boxShadow: wide
                    ? null
                    : [
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
                      "Register now",
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
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
                    _signupButton(context, verticalPadding, horizontalPadding),
                    _loginRedirect(context, verticalPadding, horizontalPadding),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _signupButton(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_emailController.text.isEmpty) {
            ToastClass.showToastSnackbar(
              message: "You need to write your email",
            );
            return;
          }

          if (_passwordController.text.isEmpty) {
            ToastClass.showToastSnackbar(message: "You need to write password");
            return;
          }

          if (_repeatPasswordController.text != _passwordController.text) {
            ToastClass.showToastSnackbar(
              message: "The password must be same in both textboxes",
            );
          }

          //TODO: Implement register logic into auth_service.dart
        },
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
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _loginRedirect(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Already have an account? ", style: TextStyle(fontSize: 10.sp)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 10.sp,
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
