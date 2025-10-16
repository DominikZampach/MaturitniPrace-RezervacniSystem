import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/widgets/bookmycut_logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constrains) {
          double width = constrains.maxWidth;
          double height = constrains.maxHeight;

          final double verticalPadding = 10;
          final double horizontalPadding = 10;

          return Row(
            children: [
              _sideNavbar(width, verticalPadding, horizontalPadding),
              _body(),
            ],
          );
        },
      ),
    );
  }

  Expanded _body() {
    return Expanded(child: Container(color: Colors.white));
  }

  SizedBox _sideNavbar(
    double width,
    double verticalPadding,
    double horizontalPadding,
  ) {
    return SizedBox(
      height: double.infinity,
      width: width * 0.15,
      child: Container(
        color: Consts.background,
        padding: EdgeInsets.all(width * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BookMyCutLogo(
              size: 75.w,
              clickFunction: () {
                ToastClass.showToastSnackbar(message: "You clicked on logo");
              },
            ),
          ],
        ),
      ),
    );
  }
}
