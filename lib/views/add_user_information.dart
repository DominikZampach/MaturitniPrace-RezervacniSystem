import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/home.dart';
import 'package:rezervacni_system_maturita/widgets/bookmycut_logo.dart';
import 'package:rezervacni_system_maturita/widgets/information_textbox_label_up.dart';
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
          final bool isMobile = constraints.maxWidth < 800;

          final double mobileFontSize = 40.sp;
          final double mobileSmallerFontSize = 35.sp;
          final double mobileHeadingsFontSize = 55.sp;
          final double mobileSmallerHeadingFontSize = 50.sp;

          //? Desktop View
          if (!isMobile) {
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 500.0.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
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
                        _saveInformationsButton(context, 15, 30, 16.sp),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          //? Mobile view
          else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.h),
                child: Column(
                  children: [
                    BookMyCutLogo(size: 100.h),
                    SizedBox(height: 30.h),
                    Text(
                      "Welcome, let's enter basic informations\nabout you:",
                      style: TextStyle(
                        fontSize: mobileHeadingsFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    InformationTextboxLabelUp(
                      context: context,
                      verticalPadding: 8.h,
                      textUp: "Name:",
                      controller: nameController,
                      spacingGap: 5.h,
                      alignOnLeft: true,
                      fontSize: mobileFontSize,
                      smallerFontSize: mobileSmallerFontSize,
                      textBoxWidth: 700.w,
                    ),
                    InformationTextboxLabelUp(
                      context: context,
                      verticalPadding: 8.h,
                      textUp: 'Last name:',
                      spacingGap: 5.h,
                      controller: surnameController,
                      alignOnLeft: true,
                      fontSize: mobileFontSize,
                      smallerFontSize: mobileSmallerFontSize,
                      textBoxWidth: 700.w,
                    ),
                    InformationTextboxLabelUp(
                      context: context,
                      verticalPadding: 8.h,
                      textUp: "Mobile:",
                      spacingGap: 5.h,
                      controller: mobileController,
                      alignOnLeft: true,
                      fontSize: mobileFontSize,
                      smallerFontSize: mobileSmallerFontSize,
                      textBoxWidth: 700.w,
                    ),
                    SizedBox(height: 20.h),
                    _saveInformationsButton(context, 10.h, 0, mobileFontSize),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _saveInformationsButton(
    BuildContext context,
    double verticalPadding,
    double horizontalPadding,
    double fontSize,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: ElevatedButton(
        onPressed: () async {
          //? Kontrola zadaných informací
          if (nameController.text.trim().isEmpty ||
              surnameController.text.trim().isEmpty ||
              mobileController.text.trim().isEmpty) {
            ToastClass.showToastSnackbar(
              message: "You need to enter all informations!",
            );
            return;
          }

          DatabaseService dbService = DatabaseService();
          await dbService.createNewUzivatel(
            nameController.text,
            surnameController.text,
            mobileController.text,
          );
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
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
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
