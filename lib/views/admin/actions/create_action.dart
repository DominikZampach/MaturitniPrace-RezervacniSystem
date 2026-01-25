import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/select_photos_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';

class CreateActionDialog extends StatefulWidget {
  final Function(KadernickyUkon) addUkon;
  const CreateActionDialog({super.key, required this.addUkon});

  @override
  State<CreateActionDialog> createState() => _CreateActionDialogState();
}

class _CreateActionDialogState extends State<CreateActionDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  String? selectedGender;
  List<String> examplePhotos = [];

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = 15.sp;
    final double smallHeadingFontSize = 13.sp;
    final double normalTextFontSize = 11.sp;
    final double smallerTextFontSize = 10.sp;

    final double _labelWidth = 75.w;
    final double _spacingGap = 10.w;

    final double verticalPadding = 10.h;
    final double horizontalPadding = 5.w;

    final List<DropdownMenuItem<String>> dropdownGenderOptions = [
      DropdownMenuItem(
        value: "male",
        child: Text("Male", style: TextStyle(fontSize: smallerTextFontSize)),
      ),
      DropdownMenuItem(
        value: "female",
        child: Text("Female", style: TextStyle(fontSize: smallerTextFontSize)),
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
        minHeight: MediaQuery.of(context).size.height * 0.5,
        minWidth: MediaQuery.of(context).size.width * 0.6,
        maxWidth: MediaQuery.of(context).size.width * 0.7,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),

      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Create new action:",
                  style: TextStyle(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                InformationTextbox(
                  context: context,
                  verticalPadding: verticalPadding,
                  horizontalPadding: horizontalPadding,
                  textInFront: "Name:",
                  controller: nameController,
                  spacingGap: _spacingGap,
                  fontSize: normalTextFontSize,
                  textBoxWidth: 300.w,
                  labelWidth: _labelWidth,
                ),
                InformationTextbox(
                  context: context,
                  verticalPadding: verticalPadding,
                  horizontalPadding: horizontalPadding,
                  textInFront: "Description:",
                  controller: descriptionController,
                  spacingGap: _spacingGap,
                  fontSize: normalTextFontSize,
                  textBoxWidth: 300.w,
                  labelWidth: _labelWidth,
                  maxLines: 2,
                ),
                InformationTextbox(
                  context: context,
                  verticalPadding: verticalPadding,
                  horizontalPadding: horizontalPadding,
                  textInFront: "Duration (minutes):",
                  controller: durationController,
                  spacingGap: _spacingGap,
                  fontSize: normalTextFontSize,
                  textBoxWidth: 300.w,
                  labelWidth: _labelWidth,
                  onlyNumbers: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Cut type:",
                      style: TextStyle(fontSize: normalTextFontSize),
                    ),
                    SizedBox(width: _spacingGap),
                    DropdownButton(
                      items: dropdownGenderOptions,
                      alignment: AlignmentGeometry.center,
                      value: selectedGender,
                      onChanged: (String? item) => setState(() {
                        selectedGender = item;
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => SelectPhotosDialog(
                        photosUrls: examplePhotos,
                        updateCallback: (photosUrls) => setState(() {
                          examplePhotos = photosUrls;
                        }),
                      ),
                    );
                    if (result != null) {
                      examplePhotos = result;
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                    fixedSize: WidgetStatePropertyAll(Size(120.w, 40.h)),
                  ),
                  child: Text(
                    "Photos:",
                    style: TextStyle(
                      fontSize: normalTextFontSize,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () => createUkon(),
                  label: Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: normalTextFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(
                    Icons.save,
                    color: Colors.black,
                    size: normalTextFontSize,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                    fixedSize: WidgetStatePropertyAll(Size(100.w, 40.h)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createUkon() async {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        durationController.text.isNotEmpty &&
        (selectedGender != null)) {
      KadernickyUkon newUkonWithoutID = KadernickyUkon(
        id: "",
        nazev: nameController.text,
        delkaMinuty: int.parse(durationController.text),
        popis: descriptionController.text,
        typStrihuPodlePohlavi: selectedGender!,
        odkazyFotografiiPrikladu: examplePhotos,
      );

      await widget.addUkon(newUkonWithoutID);
      ToastClass.showToastSnackbar(message: "New action created");
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastClass.showToastSnackbar(
        message: "You must enter all information (and ideally add photos)",
      );
    }
  }
}
