import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/select_actions_dialog.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/select_photos_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/my_multiselect.dart';

class CreateHairdresserDialog extends StatefulWidget {
  final List<Lokace> listAllLokace;
  final List<KadernickyUkon> listAllKadernickeUkony;
  final Function(Kadernik) onCreated;
  const CreateHairdresserDialog({
    super.key,
    required this.listAllLokace,
    required this.listAllKadernickeUkony,
    required this.onCreated,
  });

  @override
  State<CreateHairdresserDialog> createState() =>
      _CreateHairdresserDialogState();
}

class _CreateHairdresserDialogState extends State<CreateHairdresserDialog> {
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

  late Map<String, int> ukonySCenami;

  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late TimeOfDay lunchTime;
  late List<String> selectedDays;

  late List<String> photosUrls;

  final List<String> multiselectDropdownDayOptions = [
    "Pondělí",
    "Úterý",
    "Středa",
    "Čtvrtek",
    "Pátek",
    "Sobota",
    "Neděle",
  ];

  @override
  void initState() {
    super.initState();
    //? Nastavení hodnot
    selectedLokace = null;
    ukonySCenami = <String, int>{};
    startTime = TimeOfDay(hour: 8, minute: 0);
    endTime = TimeOfDay(hour: 16, minute: 0);
    lunchTime = TimeOfDay(hour: 12, minute: 0);
    selectedDays = [];
    photosUrls = [];
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    prezdivkaNameController.dispose();
    odkazFotografieController.dispose();
    popisekController.dispose();
    emailController.dispose();
    mobileController.dispose();
    delkaObedovePauzyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = Consts.h2FS.sp;
    final double normalTextFontSize = Consts.normalFS.sp;
    final double smallerTextFontSize = Consts.smallerFS.sp;

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
                  "Přidat kadeřníka",
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
                          textInFront: "Křestní jméno:",
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
                          textInFront: "Přezdívka:",
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
                          textInFront: "Příjmení:",
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
                          textInFront: "Telefon:",
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
                          textInFront: "Popis:",
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
                        odkazFotografieController.text.isNotEmpty
                            ? CarouselPhoto(
                                url: odkazFotografieController.text,
                                height: 200.h,
                                width: 145.w,
                              )
                            : Placeholder(
                                child: SizedBox(height: 200.h, width: 145.w),
                              ),
                        SizedBox(height: 10.h),
                        InformationTextbox(
                          context: context,
                          verticalPadding: 10.h,
                          horizontalPadding: 5.w,
                          textInFront: "Foto:",
                          controller: odkazFotografieController,
                          spacingGap: _spacingGap,
                          fontSize: smallerTextFontSize,
                          textBoxWidth: 200.w,
                          maxLines: 3,
                          labelWidth: _labelWidthRightColumn,
                        ),
                        _testPhotoButton(smallerTextFontSize),
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
                            "Vyberte úkony:",
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
                                photosUrls: photosUrls,
                                updateCallback: (newPhotosUrls) =>
                                    photosUrls = newPhotosUrls,
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
                            "Foto práce:",
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
                          textInFront: "Doba obědové pauzy (min):",
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
                ElevatedButton(
                  onPressed: () => createNewKadernik(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                    fixedSize: WidgetStatePropertyAll(Size(200.w, 40.h)),
                  ),
                  child: Text(
                    "Vytvořit nového kadeřníka",
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
      ),
    );
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
              "Pracovní dny:",
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
              whenEmpty: "Vyberte dny...",
              selectedValuesStyle: TextStyle(fontSize: 0),
              separator: ", ",
              childBuilder: (selectedValues) {
                String text;
                if (selectedValues.isNotEmpty) {
                  text = "Vybráno dnů: ${selectedValues.length}";
                } else {
                  text = "Vyberte dny...";
                }
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 3.h,
                    horizontal: 10.w,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: normalTextFontSize),
                  ),
                );
              },
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
              "Lokace:",
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
              "Obědová pauza:",
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
                ToastClass.showToastSnackbar(message: "Neplatný čas.");
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
              "Konec pracovní doby:",
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
                ToastClass.showToastSnackbar(message: "Neplatný čas.");
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
              "Začátek pracovní doby:",
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
                ToastClass.showToastSnackbar(message: "Neplatný čas.");
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

  ElevatedButton _testPhotoButton(double smallerTextFontSize) {
    return ElevatedButton(
      onPressed: () {
        //? SetState pro aktualizaci stránky
        setState(() {});
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Consts.secondary),
        fixedSize: WidgetStatePropertyAll(Size(100.w, 30.h)),
      ),
      child: Text(
        "Test fotografie",
        style: TextStyle(fontSize: smallerTextFontSize, color: Colors.black),
      ),
    );
  }

  void createNewKadernik() async {
    //? Kontrola VŠECH možných výjimek a možností, že bude něco prázdné
    if (firstNameController.text.isNotEmpty &&
        prezdivkaNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        popisekController.text.isNotEmpty &&
        (selectedLokace != null) &&
        delkaObedovePauzyController.text.isNotEmpty &&
        odkazFotografieController.text.isNotEmpty &&
        selectedDays.isNotEmpty &&
        ukonySCenami.isNotEmpty) {
      Kadernik newKadernik = Kadernik(
        id: "",
        jmeno: firstNameController.text,
        prezdivka: prezdivkaNameController.text,
        prijmeni: lastNameController.text,
        odkazFotografie: odkazFotografieController.text,
        popisek: popisekController.text,
        telefon: mobileController.text,
        email: emailController.text,
        pracovniDny: "",
        zacatekPracovniDoby: Kadernik.getStringFromTimeOfDay(startTime),
        konecPracovniDoby: Kadernik.getStringFromTimeOfDay(endTime),
        casObedovePrestavky: Kadernik.getStringFromTimeOfDay(lunchTime),
        lokace: selectedLokace!,
        delkaObedovePrestavky: int.parse(delkaObedovePauzyController.text),
        ukonyCeny: ukonySCenami,
        odkazyFotografiiPrace: photosUrls,
      );
      newKadernik.saveNewWorkingDays(selectedDays);

      DatabaseService dbService = DatabaseService();

      Kadernik newKadernikWithId =
          await dbService.createNewKadernik(newKadernik) as Kadernik;
      widget.onCreated(newKadernikWithId);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastClass.showToastSnackbar(message: "Musíte zadat všechny údaje!");
    }
  }
}
