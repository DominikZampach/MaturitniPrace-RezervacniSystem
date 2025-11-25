import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';

class AddUserInformationPage extends StatefulWidget {
  const AddUserInformationPage({super.key});

  @override
  State<AddUserInformationPage> createState() => _AddUserInformationPageState();
}

class _AddUserInformationPageState extends State<AddUserInformationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool smallerWidth = constraints.maxWidth < 800;

          //? Tohle dělá to, že když je šířka menší než 800px, tak ten bílý container bude přes celou obrazovku jakoby
          final double containerWidth = smallerWidth
              ? constraints.maxWidth
              : 500.0.w;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: smallerWidth
                      ? BorderRadius.zero
                      : BorderRadius.circular(20.r),
                  boxShadow: smallerWidth
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
                      InformationTextbox(
                        context: context,
                        verticalPadding: 8.h,
                        horizontalPadding: 5.w,
                        textInFront: "Name:",
                        controller: nameController,
                        spacingGap: 40.w,
                      ),
                      InformationTextbox(
                        context: context,
                        verticalPadding: 8.h,
                        horizontalPadding: 5.w,
                        textInFront: "Last name:",
                        spacingGap: 10.w,
                        controller: surnameController,
                      ),
                      InformationTextbox(
                        context: context,
                        verticalPadding: 8.h,
                        horizontalPadding: 5.w,
                        textInFront: "Mobile:",
                        spacingGap: 39.w,
                        controller: mobileController,
                      ),
                      SizedBox(height: 30.h),
                      _saveInformationsButton(context, 15, 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /*
  Widget _gender() {
    //TODO
    return;
  }

  Widget _mobile() {
    //TODO
    return;
  }
  */

  Widget _saveInformationsButton(
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
            horizontal: 30.h,
          ),
        ),
        child: Text(
          "Save Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
