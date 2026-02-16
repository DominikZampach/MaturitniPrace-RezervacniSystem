import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
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
    final double normalTextFontSize = Consts.normalFS.sp;
    final double smallerTextFontSize = Consts.smallerFS.sp;
    final double h1FontSize = Consts.h1FS.sp;
    final double h2FontSize = Consts.h2FS.sp;

    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Nastavení",
                style: TextStyle(
                  fontSize: h1FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "Údaje o Vás",
                style: TextStyle(
                  fontSize: h2FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InformationTextbox(
                context: context,
                verticalPadding: 10.h,
                horizontalPadding: 0,
                textInFront: "Křestní jméno:",
                controller: _firstNameController,
                spacingGap: 15,
                fontSize: normalTextFontSize,
                textBoxWidth: 200.w,
                labelWidth: 80.w,
              ),
              InformationTextbox(
                context: context,
                verticalPadding: 10.h,
                horizontalPadding: 0,
                textInFront: "Příjmení:",
                controller: _lastNameController,
                spacingGap: 15,
                fontSize: normalTextFontSize,
                textBoxWidth: 200.w,
                labelWidth: 80.w,
              ),
              InformationTextbox(
                context: context,
                verticalPadding: 10.h,
                horizontalPadding: 0,
                textInFront: "Telefon:",
                controller: _mobileController,
                spacingGap: 15,
                fontSize: normalTextFontSize,
                textBoxWidth: 200.w,
                labelWidth: 80.w,
              ),
              SizedBox(height: 5.h),
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

                  ToastClass.showToastSnackbar(message: "Údaje uloženy.");
                  widget.onChanged(widget.uzivatel);
                  await DatabaseService().updateUzivatel(widget.uzivatel);
                },
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(80.w, 40.h)),
                  backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                ),
                child: Text(
                  "Uložit",
                  style: TextStyle(
                    fontSize: normalTextFontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                "Podpora",
                style: TextStyle(
                  fontSize: h2FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Pokud naleznete nějaký technický problém nebo\nbug, kontaktujte mě na:",
                style: TextStyle(fontSize: smallerTextFontSize),
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              SelectableText.rich(
                style: TextStyle(fontSize: smallerTextFontSize),
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
                style: TextStyle(fontSize: smallerTextFontSize),
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Telefon: ",
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
                  fixedSize: WidgetStatePropertyAll(Size(80.w, 40.h)),
                  backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                ),
                child: Text(
                  "Odhlásit",
                  style: TextStyle(
                    fontSize: normalTextFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
