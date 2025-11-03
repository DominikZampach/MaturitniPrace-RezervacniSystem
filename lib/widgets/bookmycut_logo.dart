import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookMyCutLogo extends StatelessWidget {
  final double size;
  final VoidCallback? clickFunction;

  final String logoPath = "assets/icons/LogoBookMyCut.svg";

  const BookMyCutLogo({super.key, required this.size, this.clickFunction});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: clickFunction ?? () {},
        child: SvgPicture.asset(
          logoPath,
          height: size,
          semanticsLabel: "BookMyCut logo",
        ),
      ),
    );
  }
}
