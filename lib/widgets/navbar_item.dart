import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

class NavbarItem extends StatelessWidget {
  final double verticalPadding;
  final String text;
  final bool isSelected;
  final VoidCallback onClick;
  double? fontSize;

  NavbarItem({
    super.key,
    required this.verticalPadding,
    required this.text,
    required this.isSelected,
    required this.onClick,
    this.fontSize,
  }) {
    fontSize ??= Consts.h3FS.sp;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: 0,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors
            .click, //? Změna kurzoru, aby to uživatele nemátlo
        child: GestureDetector(
          onTap: onClick,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
