import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationTextbox extends StatelessWidget {
  final BuildContext context;
  final double verticalPadding;
  final double horizontalPadding;
  final String textInFront;
  final TextEditingController controller;
  final double spacingGap;
  double? fontSize;
  double? textBoxWidth;
  bool? leftAlignment;
  int? maxLines;
  final double? labelWidth;

  InformationTextbox({
    super.key,
    required this.context,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.textInFront,
    required this.controller,
    required this.spacingGap,
    this.fontSize,
    this.textBoxWidth,
    this.leftAlignment,
    this.maxLines,
    this.labelWidth,
  }) {
    //? Nastavení defaultních hodnot pokud uživatel specifická data
    fontSize ??= 15.sp;
    textBoxWidth ??= 300.w;
    leftAlignment ??= false;
    maxLines ??= 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: leftAlignment!
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width:
                labelWidth, //? Tohle zajišťuje aby se text ukazoval vždy stejně daleko od TextFieldu
            child: Text(
              textInFront,
              style: TextStyle(fontSize: fontSize, fontStyle: FontStyle.normal),
            ),
          ),
          SizedBox(width: spacingGap),
          SizedBox(
            width: textBoxWidth,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: fontSize,
              ),

              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }
}
