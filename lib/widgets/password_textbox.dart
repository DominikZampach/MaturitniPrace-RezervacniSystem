import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordTextbox extends StatelessWidget {
  final BuildContext context;
  final double verticalPadding;
  final double horizontalPadding;
  final String hintText;
  final TextEditingController passwordController;
  double? fontSize;

  PasswordTextbox({
    super.key,
    required this.context,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.hintText,
    required this.passwordController,
    this.fontSize,
  }) {
    fontSize ??= 15.sp;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: TextField(
        controller: passwordController,
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: fontSize,
            color: Colors.black.withValues(alpha: 0.5),
          ),
          fillColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        obscureText: true,
        obscuringCharacter: "*",
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize),
      ),
    );
  }
}
