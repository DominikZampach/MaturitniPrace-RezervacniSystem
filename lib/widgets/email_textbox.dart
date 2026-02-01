import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

class EmailTextbox extends StatelessWidget {
  final BuildContext context;
  final double verticalPadding;
  final double horizontalPadding;
  final TextEditingController emailController;
  double? fontSize;

  EmailTextbox({
    super.key,
    required this.context,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.emailController,
    this.fontSize,
  }) {
    fontSize ??= Consts.h2FS.sp;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          filled: true,
          hintText: 'example@gmail.com',
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
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize),
      ),
    );
  }
}
