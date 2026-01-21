import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/services/map_service.dart';
import 'package:rezervacni_system_maturita/widgets/informations_textbox.dart';
import 'package:rezervacni_system_maturita/widgets/map_card.dart';

class EditLocationDialog extends StatefulWidget {
  final Lokace lokace;
  final Function(Lokace) saveLokace;
  final Function(String) deleteLokace;
  const EditLocationDialog({
    super.key,
    required this.lokace,
    required this.saveLokace,
    required this.deleteLokace,
  });

  @override
  State<EditLocationDialog> createState() => _EditLocationDialogState();
}

class _EditLocationDialogState extends State<EditLocationDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pscController = TextEditingController();
  late double latitudeMap;
  late double longitudeMap;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.lokace.nazev;
    addressController.text = widget.lokace.adresa;
    cityController.text = widget.lokace.mesto;
    pscController.text = widget.lokace.psc;
    latitudeMap = widget.lokace.latitude;
    longitudeMap = widget.lokace.longitude;
  }

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
        minHeight: MediaQuery.of(context).size.height * 0.9,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
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
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Edit this location:",
                        style: TextStyle(
                          fontSize: headingFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: GestureDetector(
                          child: Icon(
                            Icons.delete,
                            size: 20.w,
                            color: Colors.red,
                          ),
                          onTap: () => _deleteLokace(),
                        ),
                      ),
                    ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteLokace() {
    /*
    TODO: Udělat logiku, která zkontroluje že žádný kadeřník tuto lokaci již nemá nastavenou (pokud jo, adminovi to napíše že musí u všech kadeřníků musí změnit tuto lokaci) - ideálně udělat nějakou bool metodu v DatabaseService
    ? Pokud to projde, tak smaže lokaci z databáze a zavolá widget.deleteLokace() s ID lokace
    */
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
