import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

class AddUserInformationPage extends StatefulWidget {
  const AddUserInformationPage({super.key});

  @override
  State<AddUserInformationPage> createState() => _AddUserInformationPageState();
}

class _AddUserInformationPageState extends State<AddUserInformationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool wide = constraints.maxWidth < 800;

          // Tohle dělá to, že když je šířka menší než 800px, tak ten bílý container bude přes celou obrazovku jakoby
          final double loginContainerWidth = wide
              ? constraints.maxWidth
              : 500.0.w;
          final double loginContainerHeight = wide
              ? constraints.maxHeight
              : 500.0.h;

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
                      "Welcome, let's enter basic informations\nabout you:",
                      style: TextStyle(
                        fontSize: 23.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    _saveInformationsButton(
                      context,
                      verticalPadding,
                      horizontalPadding,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _saveInformationsButton(
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: 40.h,
          ),
        ),
        child: Text(
          "Save",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
