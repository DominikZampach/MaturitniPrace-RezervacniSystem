import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';

class EditHairdresserDialog extends StatefulWidget {
  final Kadernik kadernik;
  final List<Lokace> listAllLokace;
  final List<KadernickyUkon> listAllKadernickeUkony;
  final Function(Kadernik) onChanged;
  late List<KadernickyUkon> listKadernickeUkonySCenami;

  EditHairdresserDialog({
    super.key,
    required this.kadernik,
    required this.listAllLokace,
    required this.listAllKadernickeUkony,
    required this.onChanged,
  }) {
    listKadernickeUkonySCenami = [];
    for (String id in kadernik.ukonyCeny.keys) {
      KadernickyUkon ukon = listAllKadernickeUkony
          .where((item) => item.id == id)
          .first;
      ukon.cena = kadernik.ukonyCeny[id]!;
      listKadernickeUkonySCenami.add(ukon);
    }
  }

  @override
  State<EditHairdresserDialog> createState() => _EditHairdresserDialogState();
}

class _EditHairdresserDialogState extends State<EditHairdresserDialog> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController prezdivkaNameController = TextEditingController();
  final TextEditingController odkazFotografieController =
      TextEditingController();
  final TextEditingController popisekController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.kadernik.jmeno;
    lastNameController.text = widget.kadernik.prijmeni;
    prezdivkaNameController.text = widget.kadernik.prezdivka;
    odkazFotografieController.text = widget.kadernik.odkazFotografie;
    popisekController.text = widget.kadernik.popisek;
    emailController.text = widget.kadernik.email;
    mobileController.text = widget.kadernik.telefon;
  }

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = 15.sp;
    final double smallHeadingFontSize = 13.sp;
    final double normalTextFontSize = 11.sp;
    final double smallerTextFontSize = 10.sp;

    return Dialog(
      backgroundColor: Consts.background,
      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.9,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),

      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Edit this hairdresser:",
                  style: TextStyle(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "First name:  ",
                          controller: firstNameController,
                          spacingGap: 10,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Nickname:   ",
                          controller: prezdivkaNameController,
                          spacingGap: 10,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Last name:  ",
                          controller: lastNameController,
                          spacingGap: 10,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Email:          ",
                          controller: emailController,
                          spacingGap: 10,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 200.w,
                          leftAlignment: true,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Phone:         ",
                          controller: mobileController,
                          spacingGap: 10,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Description:",
                          controller: popisekController,
                          spacingGap: 10,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 200.w,
                          leftAlignment: true,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CarouselPhoto(
                          url: odkazFotografieController.text,
                          height: 200.h,
                          width: 145.w,
                        ),
                        SizedBox(height: 10.h),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Photo:     ",
                          controller: odkazFotografieController,
                          spacingGap: 10,
                          fontSize: smallerTextFontSize,
                          textBoxWidth: 200.w,
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Consts.secondary,
                                ),
                                fixedSize: WidgetStatePropertyAll(
                                  Size(100.w, 30.h),
                                ),
                              ),
                              child: Text(
                                "Test Photo",
                                style: TextStyle(
                                  fontSize: smallerTextFontSize,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 30.w),
                            ElevatedButton(
                              onPressed: () {
                                if (odkazFotografieController.text.isNotEmpty) {
                                  widget.kadernik.odkazFotografie =
                                      odkazFotografieController.text;
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Consts.secondary,
                                ),
                                fixedSize: WidgetStatePropertyAll(
                                  Size(75.w, 30.h),
                                ),
                              ),
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: smallerTextFontSize,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  label: Text(
                    "Save data",
                    style: TextStyle(
                      fontSize: normalTextFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                    fixedSize: WidgetStatePropertyAll(Size(100.w, 40.h)),
                  ),
                  icon: Icon(
                    Icons.save,
                    size: normalTextFontSize,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
