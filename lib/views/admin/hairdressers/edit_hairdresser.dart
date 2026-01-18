import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiselect/multiselect.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/select_actions_dialog.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/select_photos_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';

class EditHairdresserDialog extends StatefulWidget {
  final Kadernik? kadernik;
  final List<Lokace> listAllLokace;
  final List<KadernickyUkon> listAllKadernickeUkony;
  final Function(Kadernik) onChanged;
  late List<KadernickyUkon> listKadernickeUkonySCenami;

  EditHairdresserDialog({
    super.key,
    this.kadernik,
    required this.listAllLokace,
    required this.listAllKadernickeUkony,
    required this.onChanged,
  }) {
    if (kadernik != null) {
      listKadernickeUkonySCenami = [];
      for (String id in kadernik!.ukonyCeny.keys) {
        KadernickyUkon ukon = listAllKadernickeUkony
            .where((item) => item.id == id)
            .first;
        ukon.cena = kadernik!.ukonyCeny[id]!;
        listKadernickeUkonySCenami.add(ukon);
      }
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
  final TextEditingController delkaObedovePauzyController =
      TextEditingController();

  late Lokace? selectedLokace;
  late List<DropdownMenuItem<Lokace>> dropdownLokaceValues;

  late Map<String, dynamic> ukonySCenami;

  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late TimeOfDay lunchTime;
  late List<String> selectedDays;

  final List<String> multiselectDropdownDayOptions = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.kadernik != null) {
      //? Pokud se jedná o edit, ne o create
      firstNameController.text = widget.kadernik!.jmeno;
      lastNameController.text = widget.kadernik!.prijmeni;
      prezdivkaNameController.text = widget.kadernik!.prezdivka;
      odkazFotografieController.text = widget.kadernik!.odkazFotografie;
      popisekController.text = widget.kadernik!.popisek;
      emailController.text = widget.kadernik!.email;
      mobileController.text = widget.kadernik!.telefon;
      delkaObedovePauzyController.text = widget.kadernik!.delkaObedovePrestavky
          .toString();

      selectedLokace = widget.listAllLokace
          .where((item) => item.id == widget.kadernik!.lokace.id)
          .first;
      ukonySCenami = widget.kadernik!.ukonyCeny;

      startTime = Kadernik.getTimeOfDay(widget.kadernik!.zacatekPracovniDoby);
      endTime = Kadernik.getTimeOfDay(widget.kadernik!.konecPracovniDoby);
      lunchTime = Kadernik.getTimeOfDay(widget.kadernik!.casObedovePrestavky);

      selectedDays = widget.kadernik!.getListOfWorkingDays();
    } else {
      //? Nastavení hodnot když se jedná o create nového kadeřníka
      selectedLokace = null;
      ukonySCenami = {};
      startTime = TimeOfDay(hour: 8, minute: 0);
      endTime = TimeOfDay(hour: 16, minute: 0);
      lunchTime = TimeOfDay(hour: 12, minute: 0);
      selectedDays = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = 15.sp;
    final double smallHeadingFontSize = 13.sp;
    final double normalTextFontSize = 11.sp;
    final double smallerTextFontSize = 10.sp;

    final double _labelWidth = 75.w;
    final double _labelWidthRightColumn = 30.w;
    final double _spacingGap = 10.w;

    final double _multiselectWidth = 180.w;
    final double _multiselectHeight = 40.h;

    dropdownLokaceValues = [
      for (var lokace in widget.listAllLokace)
        DropdownMenuItem<Lokace>(
          value: lokace,
          child: Text(
            lokace.nazev,
            style: TextStyle(fontSize: normalTextFontSize),
            textAlign: TextAlign.center,
          ),
        ),
    ];

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "First name:",
                          controller: firstNameController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Nickname:",
                          controller: prezdivkaNameController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Last name:",
                          controller: lastNameController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Email:",
                          controller: emailController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 200.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Phone:",
                          controller: mobileController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Description:",
                          controller: popisekController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 200.w,
                          leftAlignment: true,
                          maxLines: 2,
                          labelWidth: _labelWidth,
                        ),
                        _locationDropdown(
                          _labelWidth,
                          normalTextFontSize,
                          _spacingGap,
                        ),
                        _startTime(
                          _labelWidth,
                          normalTextFontSize,
                          _spacingGap,
                          context,
                          smallerTextFontSize,
                        ),
                        _endTime(
                          _labelWidth,
                          normalTextFontSize,
                          _spacingGap,
                          context,
                          smallerTextFontSize,
                        ),
                        _lunchTime(
                          _labelWidth,
                          normalTextFontSize,
                          _spacingGap,
                          context,
                          smallerTextFontSize,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
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
                          textInFront: "Photo:",
                          controller: odkazFotografieController,
                          spacingGap: _spacingGap,
                          fontSize: smallerTextFontSize,
                          textBoxWidth: 200.w,
                          maxLines: 3,
                          labelWidth: _labelWidthRightColumn,
                        ),
                        _testPhotoAndSavePhotoButtons(smallerTextFontSize),
                        SizedBox(height: 15.h),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) => SelectActionsDialog(
                                listAllKadernickeUkony:
                                    widget.listAllKadernickeUkony,
                                ukonyCenyKadernika: ukonySCenami,
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Consts.secondary,
                            ),
                            fixedSize: WidgetStatePropertyAll(
                              Size(120.w, 40.h),
                            ),
                          ),
                          child: Text(
                            "Select actions:",
                            style: TextStyle(
                              fontSize: normalTextFontSize,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) => SelectPhotosDialog(
                                photosUrls:
                                    widget.kadernik!.odkazyFotografiiPrace,
                                updateCallback: (photosUrls) => setState(() {
                                  widget.kadernik!.odkazyFotografiiPrace =
                                      photosUrls;
                                }),
                              ),
                            );
                            if (result != null) {
                              widget.kadernik!.odkazyFotografiiPrace = result;
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Consts.secondary,
                            ),
                            fixedSize: WidgetStatePropertyAll(
                              Size(120.w, 40.h),
                            ),
                          ),
                          child: Text(
                            "Work Photos:",
                            style: TextStyle(
                              fontSize: normalTextFontSize,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Lunch break length (min):",
                          controller: delkaObedovePauzyController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 100.w,
                          leftAlignment: true,
                          maxLines: 1,
                          labelWidth: _labelWidth,
                          onlyNumbers: true,
                        ),
                        _workingDays(
                          _labelWidth,
                          normalTextFontSize,
                          _spacingGap,
                          _multiselectHeight,
                          _multiselectWidth,
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _updateKadernik(),
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

  void _updateKadernik() {
    if (widget.kadernik != null) {
      widget.kadernik!.jmeno = firstNameController.text;
      widget.kadernik!.prezdivka = prezdivkaNameController.text;
      widget.kadernik!.prijmeni = lastNameController.text;
      widget.kadernik!.email = emailController.text;
      widget.kadernik!.telefon = mobileController.text;
      widget.kadernik!.popisek = popisekController.text;

      if (selectedLokace != null) {
        widget.kadernik!.lokace = selectedLokace!;
      } else {
        ToastClass.showToastSnackbar(message: "You must select valid Location");
        return;
      }

      widget.kadernik!.zacatekPracovniDoby = Kadernik.getStringFromTimeOfDay(
        startTime,
      );
      widget.kadernik!.konecPracovniDoby = Kadernik.getStringFromTimeOfDay(
        endTime,
      );
      widget.kadernik!.casObedovePrestavky = Kadernik.getStringFromTimeOfDay(
        lunchTime,
      );
      widget.kadernik!.delkaObedovePrestavky = int.parse(
        delkaObedovePauzyController.text,
      );

      widget.kadernik!.odkazFotografie = odkazFotografieController.text;

      widget.kadernik!.ukonyCeny = ukonySCenami as Map<String, int>;

      //? Fotografie prací se propisují automaticky

      widget.kadernik!.saveNewWorkingDays(selectedDays);

      widget.onChanged(widget.kadernik!);

      Navigator.of(context).pop();
    }
  }

  Padding _workingDays(
    double _labelWidth,
    double normalTextFontSize,
    double _spacingGap,
    double _multiselectHeight,
    double _multiselectWidth,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text(
              "Working days:",
              style: TextStyle(fontSize: normalTextFontSize),
            ),
          ),
          SizedBox(width: _spacingGap),
          SizedBox(
            height: _multiselectHeight,
            width: _multiselectWidth,
            child: DropDownMultiSelect<String>(
              options: multiselectDropdownDayOptions,
              selectedValues: selectedDays,
              onChanged: (List<String> newSelectedDays) {
                //? Seřazení aby to šlo od Monday do Sunday
                newSelectedDays.sort(
                  (a, b) => multiselectDropdownDayOptions
                      .indexOf(a)
                      .compareTo(multiselectDropdownDayOptions.indexOf(b)),
                );

                setState(() {
                  selectedDays = newSelectedDays;
                });
              },
              whenEmpty: "Select days..",
              selectedValuesStyle: TextStyle(fontSize: 0),
              separator: ", ",
            ),
          ),
        ],
      ),
    );
  }

  Padding _locationDropdown(
    double _labelWidth,
    double normalTextFontSize,
    double _spacingGap,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text(
              "Location:",
              style: TextStyle(fontSize: normalTextFontSize),
            ),
          ),
          SizedBox(width: _spacingGap),
          DropdownButton<Lokace?>(
            alignment: AlignmentGeometry.center,
            value: selectedLokace,
            items: dropdownLokaceValues,
            onChanged: (var item) => setState(() {
              selectedLokace = item;
            }),
          ),
        ],
      ),
    );
  }

  Padding _lunchTime(
    double _labelWidth,
    double normalTextFontSize,
    double _spacingGap,
    BuildContext context,
    double smallerTextFontSize,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text(
              "Lunch Break:",
              style: TextStyle(fontSize: normalTextFontSize),
            ),
          ),
          SizedBox(width: _spacingGap),
          ElevatedButton(
            onPressed: () async {
              TimeOfDay? resultTime = await showTimePicker(
                context: context,
                initialTime: lunchTime,
              );

              if ((resultTime != null) &&
                  (resultTime.isAfter(startTime)) &&
                  (resultTime.isBefore(endTime))) {
                setState(() {
                  lunchTime = resultTime;
                });
              } else {
                ToastClass.showToastSnackbar(message: "Invalid time");
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Consts.secondary),
            ),
            child: Text(
              "${lunchTime.hour}:${lunchTime.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: smallerTextFontSize,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _endTime(
    double _labelWidth,
    double normalTextFontSize,
    double _spacingGap,
    BuildContext context,
    double smallerTextFontSize,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text(
              "Closing Time:",
              style: TextStyle(fontSize: normalTextFontSize),
            ),
          ),
          SizedBox(width: _spacingGap),
          ElevatedButton(
            onPressed: () async {
              TimeOfDay? resultTime = await showTimePicker(
                context: context,
                initialTime: endTime,
              );

              if ((resultTime != null) &&
                  (resultTime.isAfter(startTime)) &&
                  (resultTime.isAfter(lunchTime))) {
                setState(() {
                  endTime = resultTime;
                });
              } else {
                ToastClass.showToastSnackbar(message: "Invalid time");
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Consts.secondary),
            ),
            child: Text(
              "${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: smallerTextFontSize,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _startTime(
    double _labelWidth,
    double normalTextFontSize,
    double _spacingGap,
    BuildContext context,
    double smallerTextFontSize,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text(
              "Open Time:",
              style: TextStyle(fontSize: normalTextFontSize),
            ),
          ),
          SizedBox(width: _spacingGap),
          ElevatedButton(
            onPressed: () async {
              TimeOfDay? resultTime = await showTimePicker(
                context: context,
                initialTime: startTime ?? TimeOfDay(hour: 8, minute: 0),
              );

              if ((resultTime != null) &&
                  (resultTime.isBefore(endTime)) &&
                  (resultTime.isBefore(lunchTime))) {
                setState(() {
                  startTime = resultTime;
                });
              } else {
                ToastClass.showToastSnackbar(message: "Invalid time");
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Consts.secondary),
            ),
            child: Text(
              "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: smallerTextFontSize,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _testPhotoAndSavePhotoButtons(double smallerTextFontSize) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {});
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Consts.secondary),
            fixedSize: WidgetStatePropertyAll(Size(100.w, 30.h)),
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
              //TODO
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Consts.secondary),
            fixedSize: WidgetStatePropertyAll(Size(75.w, 30.h)),
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
    );
  }
}
