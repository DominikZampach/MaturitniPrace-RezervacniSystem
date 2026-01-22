import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/services/map_service.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/map_card.dart';

class CreateLocationDialog extends StatefulWidget {
  final Function(Lokace) addLokace;
  const CreateLocationDialog({super.key, required this.addLokace});

  @override
  State<CreateLocationDialog> createState() => _CreateLocationDialogState();
}

class _CreateLocationDialogState extends State<CreateLocationDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pscController = TextEditingController();
  late double latitudeMap = 0;
  late double longitudeMap = 0;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    pscController.dispose();
    super.dispose();
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

    final double verticalPadding = 10.h;
    final double horizontalPadding = 5.w;

    final double mapWidth = 300.w;
    final double mapHeight = 300.h;

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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Create new location:",
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
                          verticalPadding: verticalPadding,
                          horizontalPadding: horizontalPadding,
                          textInFront: "Name:",
                          controller: nameController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 200.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: verticalPadding,
                          horizontalPadding: horizontalPadding,
                          textInFront: "Address:",
                          controller: addressController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 200.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: verticalPadding,
                          horizontalPadding: horizontalPadding,
                          textInFront: "City:",
                          controller: cityController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 200.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                        ),
                        InformationTextbox(
                          context: context,
                          verticalPadding: verticalPadding,
                          horizontalPadding: horizontalPadding,
                          textInFront: "PSC:",
                          controller: pscController,
                          spacingGap: _spacingGap,
                          fontSize: normalTextFontSize,
                          textBoxWidth: 125.w,
                          leftAlignment: true,
                          labelWidth: _labelWidth,
                          onlyNumbers: true,
                        ),
                      ],
                    ),
                    //? Tady bude ukázání mapy s tlačítkem Test, po kterém se aktualizuje mapa podle adresy zadané adminem (aby si mohl zkontrolovat správnost adresy)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        MapCard(
                          //? Key donutí widget se překreslit, pokud se změní string uvnitř
                          key: ValueKey("${latitudeMap}_$longitudeMap"),
                          //? Vždy tvořím novou Lokaci pouze s LatLng, abych nepřepisoval hodnoty ve widget.lokace (pro případ že admin neuloží změny)
                          lokace: Lokace(
                            id: "",
                            nazev: "",
                            adresa: "",
                            mesto: "",
                            psc: "",
                            latitude: latitudeMap,
                            longitude: longitudeMap,
                          ),
                          width: mapWidth,
                          height: mapHeight,
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isNotEmpty &&
                                cityController.text.isNotEmpty &&
                                pscController.text.isNotEmpty) {
                              _updateLatLong();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Consts.secondary,
                            ),
                          ),
                          child: Text(
                            "Test Map",
                            style: TextStyle(
                              fontSize: normalTextFontSize,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () => createLokace(),
                  label: Text(
                    "Create location",
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createLokace() async {
    if (nameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        pscController.text.isNotEmpty &&
        latitudeMap != 0 &&
        longitudeMap != 0) {
      Lokace newLokaceWithoutId = Lokace(
        id: "",
        nazev: nameController.text,
        adresa: addressController.text,
        mesto: cityController.text,
        psc: pscController.text,
        latitude: latitudeMap,
        longitude: longitudeMap,
      );

      await widget.addLokace(newLokaceWithoutId);
      ToastClass.showToastSnackbar(message: "New location created");
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastClass.showToastSnackbar(
        message: "You must enter all information and test map!",
      );
    }
  }

  //? Tato metoda bere hodnoty z TextBoxů a znovavykresluje mapu
  void _updateLatLong() async {
    var newLatLong = await MapService.getGeocodeMapyCZ(
      addressController.text,
      pscController.text,
    );
    setState(() {
      if (newLatLong != null) {
        latitudeMap = newLatLong.latitude;
        longitudeMap = newLatLong.longitude;
        ToastClass.showToastSnackbar(message: "Location updated");
      } else {
        ToastClass.showToastSnackbar(
          message: "Error while trying to get Mapy.cz informations",
        );
      }
    });
  }
}
