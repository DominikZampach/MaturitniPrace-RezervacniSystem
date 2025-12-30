import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';

class SettingsBody extends StatefulWidget {
  final Uzivatel uzivatel;
  final double screenWidth;
  final double screenHeight;
  final Function(Uzivatel) onChanged;

  const SettingsBody({
    super.key,
    required this.uzivatel,
    required this.screenWidth,
    required this.screenHeight,
    required this.onChanged,
  });

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.uzivatel.jmeno;
    _lastNameController.text = widget.uzivatel.prijmeni;
    _mobileController.text = widget.uzivatel.telefon;
  }

  @override
  Widget build(BuildContext context) {
    final double normalTextFontSize = 12.sp;
    final double smallerTextFontSize = 10.sp;
    final double h1FontSize = 18.sp;
    final double h2FontSize = 15.sp;

    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: h1FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "Change user informations:",
                style: TextStyle(
                  fontSize: h2FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InformationTextbox(
                context: context,
                verticalPadding: 10.h,
                horizontalPadding: 0,
                textInFront: "First name:",
                controller: _firstNameController,
                spacingGap: 10,
                fontSize: normalTextFontSize,
                textBoxWidth: 200.w,
              ),
              InformationTextbox(
                context: context,
                verticalPadding: 10.h,
                horizontalPadding: 0,
                textInFront: "Last name:",
                controller: _lastNameController,
                spacingGap: 10,
                fontSize: normalTextFontSize,
                textBoxWidth: 200.w,
              ),
              InformationTextbox(
                context: context,
                verticalPadding: 10.h,
                horizontalPadding: 0,
                textInFront: "       Mobile:",
                controller: _mobileController,
                spacingGap: 10,
                fontSize: normalTextFontSize,
                textBoxWidth: 200.w,
              ),
              SizedBox(height: 5.h),
              ElevatedButton(
                onPressed: () {
                  //TODO
                },
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(80.w, 40.h)),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: normalTextFontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
