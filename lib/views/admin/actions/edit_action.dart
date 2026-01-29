import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/select_photos_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/delete_alert_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';

class EditActionDialog extends StatefulWidget {
  final KadernickyUkon kadernickyUkon;
  final Function(KadernickyUkon) saveUkon;
  final Function(String) deleteUkon;
  const EditActionDialog({
    super.key,
    required this.kadernickyUkon,
    required this.saveUkon,
    required this.deleteUkon,
  });

  @override
  State<EditActionDialog> createState() => _EditActionDialogState();
}

class _EditActionDialogState extends State<EditActionDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  late String? selectedGender;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.kadernickyUkon.nazev;
    descriptionController.text = widget.kadernickyUkon.popis;
    durationController.text = widget.kadernickyUkon.delkaMinuty.toString();

    selectedGender = widget.kadernickyUkon.typStrihuPodlePohlavi;
  }

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
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Edit this action:",
                        style: TextStyle(
                          fontSize: headingFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            child: Icon(
                              Icons.delete,
                              size: 20.w,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              bool? dialogResult = await showDialog(
                                context: context,
                                builder: (context) => DeleteAlertDialog(
                                  alertText:
                                      "Do you really want to delete this action?",
                                ),
                              );
                              if (dialogResult == true) {
                                _deleteUkon();
                                return;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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
                        photosUrls:
                            widget.kadernickyUkon.odkazyFotografiiPrikladu,
                        updateCallback: (photosUrls) => setState(() {
                          widget.kadernickyUkon.odkazyFotografiiPrikladu =
                              photosUrls;
                        }),
                      ),
                    );
                    if (result != null) {
                      widget.kadernickyUkon.odkazyFotografiiPrikladu = result;
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
                  onPressed: () => _updateUkon(),
                  label: Text(
                    "Save",
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

  void _deleteUkon() async {
    await widget.deleteUkon(widget.kadernickyUkon.id);
    ToastClass.showToastSnackbar(message: "Action deleted");

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _updateUkon() async {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        durationController.text.isNotEmpty &&
        (selectedGender != null)) {
      widget.kadernickyUkon.nazev = nameController.text;
      widget.kadernickyUkon.popis = descriptionController.text;
      widget.kadernickyUkon.delkaMinuty = int.parse(durationController.text);
      widget.kadernickyUkon.typStrihuPodlePohlavi = selectedGender!;

      widget.saveUkon(widget.kadernickyUkon);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastClass.showToastSnackbar(message: "You must enter all informations");
    }
  }
}
