import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavbarItem extends StatelessWidget {
  final double verticalPadding;
  final String text;
  final bool isSelected;
  const NavbarItem({
    super.key,
    required this.verticalPadding,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}
