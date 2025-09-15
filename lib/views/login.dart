import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/views/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final double loginContainerWidth = 375.w;
  final double loginContainerHeight = 375.h;

  final double verticalPadding = 10.h;
  final double horizontalPadding = 30.h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: loginContainerWidth,
          height: loginContainerHeight,
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
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
                _emailTextbox(context, verticalPadding, horizontalPadding),
                _passwordTextbox(context, verticalPadding, horizontalPadding),
                _loginButton(context, verticalPadding, horizontalPadding),
                _signUpRedirect(context, verticalPadding, horizontalPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextbox(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          filled: true,
          hintText: 'example@gmail.com',
          hintStyle: TextStyle(fontWeight: FontWeight.w200, fontSize: 15.sp),
          fillColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
      ),
    );
  }

  Widget _passwordTextbox(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          filled: true,
          hintText: "password",
          hintStyle: TextStyle(fontWeight: FontWeight.w200, fontSize: 15.sp),
          fillColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        obscureText: true,
        obscuringCharacter: "*",
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
      ),
    );
  }

  Widget _loginButton(
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
          ToastClass.showToastSnackbar(message: "U clicked on log in");
        },
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
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _signUpRedirect(
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
          Text("Are you new here? ", style: TextStyle(fontSize: 10.sp)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            child: Text(
              "Create an account",
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
