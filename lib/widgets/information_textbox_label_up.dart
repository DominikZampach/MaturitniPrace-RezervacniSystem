import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationTextboxLabelUp extends StatelessWidget {
  final BuildContext context;
  final double verticalPadding;
  final String textUp;
  final TextEditingController controller;
  final double spacingGap;
  final bool alignOnLeft;

  double? fontSize;
  double? smallerFontSize;
  double? textBoxWidth;
  int? maxLines;

  InformationTextboxLabelUp({
    super.key,
    required this.context,
    required this.verticalPadding,
    required this.textUp,
    required this.controller,
    required this.spacingGap,
    this.smallerFontSize,
    this.fontSize,
    this.textBoxWidth,
    this.alignOnLeft = false,
  }) {
    fontSize ??= 15.sp;
    textBoxWidth ??= 300.w;
    maxLines ??= 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: alignOnLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            textUp,
            style: TextStyle(
              fontSize: smallerFontSize,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: spacingGap),
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
