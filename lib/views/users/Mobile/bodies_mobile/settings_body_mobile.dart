import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/information_textbox_label_up.dart';

class SettingsBodyMobile extends StatefulWidget {
  final Uzivatel uzivatel;
  final double screenWidth;
  final double screenHeight;
  final Function(Uzivatel) onChanged;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingFontSize;

  const SettingsBodyMobile({
    super.key,
    required this.uzivatel,
    required this.screenWidth,
    required this.screenHeight,
    required this.onChanged,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingFontSize,
  });

  @override
  State<SettingsBodyMobile> createState() => _SettingsBodyMobileState();
}

class _SettingsBodyMobileState extends State<SettingsBodyMobile> {
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
    return Container(
      color: Colors.white,
      height: widget.screenHeight,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //idk
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Settings",
              style: TextStyle(
                fontSize: widget.mobileHeadingsFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "User informations",
              style: TextStyle(
                fontSize: widget.mobileSmallerHeadingFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            InformationTextboxLabelUp(
              context: context,
              verticalPadding: 5.h,
              textUp: "First name",
              controller: _firstNameController,
              spacingGap: 5.h,
              fontSize: widget.mobileFontSize,
              smallerFontSize: widget.mobileSmallerFontSize,
              textBoxWidth: 800.w,
              alignOnLeft: true,
            ),
            InformationTextboxLabelUp(
              context: context,
              verticalPadding: 5.h,
              textUp: "Last name",
              controller: _lastNameController,
              spacingGap: 5.h,
              fontSize: widget.mobileFontSize,
              smallerFontSize: widget.mobileSmallerFontSize,
              textBoxWidth: 800.w,
              alignOnLeft: true,
            ),
            InformationTextboxLabelUp(
              context: context,
              verticalPadding: 5.h,
              textUp: "Mobile",
              controller: _mobileController,
              spacingGap: 5.h,
              fontSize: widget.mobileFontSize,
              smallerFontSize: widget.mobileSmallerFontSize,
              textBoxWidth: 800.w,
              alignOnLeft: true,
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () async {
                if (_firstNameController.text.isNotEmpty &&
                    _firstNameController.text != widget.uzivatel.jmeno) {
                  widget.uzivatel.jmeno = _firstNameController.text;
                }

                if (_lastNameController.text.isNotEmpty &&
                    _lastNameController.text != widget.uzivatel.prijmeni) {
                  widget.uzivatel.prijmeni = _lastNameController.text;
                }

                if (_mobileController.text.isNotEmpty &&
                    _mobileController.text != widget.uzivatel.telefon) {
                  widget.uzivatel.telefon = _mobileController.text;
                }

                ToastClass.showToastSnackbar(message: "Successfully saved.");
                widget.onChanged(widget.uzivatel);
                await DatabaseService().updateUzivatel(widget.uzivatel);
              },
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(250.w, 40.h)),
                backgroundColor: WidgetStatePropertyAll(Consts.secondary),
              ),
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: widget.mobileFontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Text(
              "Support",
              style: TextStyle(
                fontSize: widget.mobileSmallerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "If you find any bug or technical problem,\nplease let me know through one of following methods:",
              style: TextStyle(fontSize: widget.mobileSmallerFontSize),
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            SelectableText.rich(
              style: TextStyle(fontSize: widget.mobileSmallerFontSize),
              TextSpan(
                children: [
                  TextSpan(
                    text: "Email: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "dominik.zampach@seznam.cz"),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            SelectableText.rich(
              style: TextStyle(fontSize: widget.mobileSmallerFontSize),
              TextSpan(
                children: [
                  TextSpan(
                    text: "Phone: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "+420 732 683 400"),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            ElevatedButton(
              onPressed: () async {
                //? Logout
                await AuthService().logout(context);
              },
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(300.w, 40.h)),
                backgroundColor: WidgetStatePropertyAll(Consts.secondary),
              ),
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: widget.mobileSmallerHeadingFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
