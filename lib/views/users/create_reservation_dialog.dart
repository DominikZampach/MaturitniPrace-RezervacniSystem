import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/createReservation.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class CreateReservationDialog extends StatefulWidget {
  const CreateReservationDialog({super.key});

  @override
  State<CreateReservationDialog> createState() =>
      _CreateReservationDialogState();
}

class _CreateReservationDialogState extends State<CreateReservationDialog> {
  final double headingFontSize = 15.sp;
  final double normalTextFontSize = 11.sp;

  late Future<CreateReservationLogic> futureLogika;

  String? _dropdownValueLokace;
  String? _dropdownValueKadernik;
  String? _radioValueType;

  List<Kadernik> _dropdownOptionsKadernik = [];

  @override
  void initState() {
    super.initState();
    futureLogika = _nacteniDat();
  }

  Future<CreateReservationLogic> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<Kadernik> listAllKadernik = await dbService.getAllKadernici();
    final List<KadernickyUkon> listAllKadernickyUkon = await dbService
        .getAllKadernickeUkony();
    final List<Rezervace> listAllFutureRezervace = await dbService
        .getAllFutureRezervace();

    CreateReservationLogic logika = CreateReservationLogic(
      listAllKadernik: listAllKadernik,
      listAllKadernickyUkon: listAllKadernickyUkon,
      listAllFutureRezervace: listAllFutureRezervace,
    );

    return logika;
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Idk jestli to chci Dialog nebo Dialog.fullscreen (ještě se musím rozhodnout)
    return Dialog(
      backgroundColor: Consts.background,
      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),

      child: FutureBuilder(
        future: futureLogika,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error při načítání dat: ${snapshot.error}");
            return const Center(
              child: Text(
                "Error occured while trying to load data from database!",
              ),
            );
          }

          if (_dropdownValueLokace == null &&
              snapshot.data != null &&
              snapshot.data!.listAllLokace.isNotEmpty) {
            //? Použijeme hodnotu prvního prvku jako výchozí
            Lokace prvniLokace = snapshot.data!.listAllLokace.first;
            _dropdownValueLokace = prvniLokace.id;
            _dropdownOptionsKadernik = snapshot.data!.getAllKadernikFromLokace(
              prvniLokace.id,
            );
            _dropdownValueKadernik = _dropdownOptionsKadernik.first.id;
          }

          _radioValueType ??= "Male";

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                spacing: 15.h,

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create Reservation",
                    style: TextStyle(
                      fontSize: headingFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 30,
                        children: [
                          _captionText("Hair salon:"),
                          _captionText("Hairdresser:"),
                          _captionText("Cut type:"),
                          _captionText("Actions:"),

                          _captionText("Estimated length of all actions:"),
                          _captionText("Estimated price:"),
                          _captionText("Select available date and time:"),
                          _captionText("Note:"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 9,
                        children: [
                          DropdownButton(
                            value: _dropdownValueLokace,
                            borderRadius: BorderRadius.circular(15.r),
                            underline: null,
                            items: [
                              for (Lokace lokace
                                  in snapshot.data!.listAllLokace)
                                DropdownMenuItem<String>(
                                  value: lokace.id,
                                  child: Text(
                                    "${lokace.nazev} - ${lokace.mesto}",
                                    style: TextStyle(
                                      fontSize: normalTextFontSize,
                                    ),
                                  ),
                                ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                _dropdownValueLokace = newValue;
                                _dropdownOptionsKadernik = snapshot.data!
                                    .getAllKadernikFromLokace(newValue!);
                                _dropdownValueKadernik =
                                    _dropdownOptionsKadernik.first.id;
                              });
                            },
                          ),
                          DropdownButton(
                            value: _dropdownValueKadernik,
                            borderRadius: BorderRadius.circular(15.r),
                            underline: null,
                            items: [
                              for (Kadernik kadernik
                                  in _dropdownOptionsKadernik)
                                DropdownMenuItem<String>(
                                  value: kadernik.id,
                                  child: Text(
                                    "${kadernik.jmeno} ${kadernik.prijmeni}",
                                    style: TextStyle(
                                      fontSize: normalTextFontSize,
                                    ),
                                  ),
                                ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                _dropdownValueKadernik = newValue;
                              });
                            },
                          ),
                          RadioGroup<String>(
                            groupValue: _radioValueType,
                            onChanged: (String? value) {
                              setState(() {
                                _radioValueType = value;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(value: "Male"),
                                    Text(
                                      "Male",
                                      style: TextStyle(
                                        fontSize: normalTextFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                Row(
                                  children: [
                                    Radio<String>(value: "Female"),
                                    Text(
                                      "Female",
                                      style: TextStyle(
                                        fontSize: normalTextFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          /*
                          DropdownButton(
                            value: _dropdownValueType,
                            borderRadius: BorderRadius.circular(15.r),
                            underline: null,
                            items: [
                              DropdownMenuItem<String>(
                                value: _dropdownValueType,
                                child: Text(
                                  "Male",
                                  style: TextStyle(
                                    fontSize: normalTextFontSize,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                _dropdownValueKadernik = newValue;
                              });
                            },
                          ),
                          */
                        ],
                      ),
                    ],
                  ),
                  /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      Text(
                        "Hair salon:",
                        style: TextStyle(
                          fontSize: normalTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton(
                        value: _dropdownValueLokace,
                        borderRadius: BorderRadius.circular(15.r),
                        underline: null,
                        items: [
                          for (Lokace lokace in snapshot.data!.listAllLokace)
                            DropdownMenuItem<String>(
                              value: lokace.id,
                              child: Text(
                                "${lokace.nazev} - ${lokace.mesto}",
                                style: TextStyle(fontSize: normalTextFontSize),
                              ),
                            ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValueLokace = newValue;
                            _dropdownOptionsKadernik = snapshot.data!
                                .getAllKadernikFromLokace(newValue!);
                            _dropdownValueKadernik =
                                _dropdownOptionsKadernik.first.id;
                          });
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,

                    children: [
                      Text(
                        "Hairdresser:",
                        style: TextStyle(
                          fontSize: normalTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton(
                        value: _dropdownValueKadernik,
                        items: [
                          for (Kadernik kadernik in _dropdownOptionsKadernik)
                            DropdownMenuItem<String>(
                              value: kadernik.id,
                              child: Text(
                                "${kadernik.jmeno} ${kadernik.prijmeni}",
                                style: TextStyle(fontSize: normalTextFontSize),
                              ),
                            ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValueKadernik = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  */
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Text _captionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
