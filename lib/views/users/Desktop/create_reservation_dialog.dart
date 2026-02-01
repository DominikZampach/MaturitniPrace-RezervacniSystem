import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/createReservation.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/my_multiselect.dart';

class CreateReservationDialog extends StatefulWidget {
  //? Default hodnoty pro Book Now
  final String? defaultKadernikId;
  final String? defaultLokaceId;
  const CreateReservationDialog({
    super.key,
    this.defaultKadernikId,
    this.defaultLokaceId,
  });

  @override
  State<CreateReservationDialog> createState() =>
      _CreateReservationDialogState();
}

class _CreateReservationDialogState extends State<CreateReservationDialog> {
  late Future<CreateReservationLogic> futureLogika;

  String? _dropdownValueLokace;
  String? _dropdownValueKadernik;
  String? _radioValueType;
  String? _dropdownValueCasRezervace;

  List<KadernickyUkon> _selectedUkonyObjects = [];
  List<String> _selectedUkonyStrings = [];

  List<Kadernik> _dropdownOptionsKadernik = [];
  List<String> _dropdownOptionsUkony = [];
  List<String> _dropdownOptionsCasyRezervace = [];

  Map<String, KadernickyUkon> _ukonStringToObjectMap = {};

  int totalPrice = 0;
  int totalTime = 0;

  DateTime? selectedDate;

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //? Tohle zajistí, aby se to provedlou pouze 1x, ne při každém setState()
    futureLogika = _nacteniDat();
  }

  Future<CreateReservationLogic> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    //? Optimalizace výkonu
    final results = await Future.wait([
      dbService.getAllKadernici(),
      dbService.getAllKadernickeUkony(),
      dbService.getAllFutureRezervace(),
    ]);

    final List<Kadernik> listAllKadernik = results[0] as List<Kadernik>;
    final List<KadernickyUkon> listAllKadernickyUkon =
        results[1] as List<KadernickyUkon>;
    final List<Rezervace> listAllFutureRezervace =
        results[2] as List<Rezervace>;

    CreateReservationLogic logika = CreateReservationLogic(
      listAllKadernik: listAllKadernik,
      listAllKadernickyUkon: listAllKadernickyUkon,
      listAllFutureRezervace: listAllFutureRezervace,
    );

    return logika;
  }

  void _updateUkony(CreateReservationLogic logika) {
    if (_dropdownValueKadernik != null && _radioValueType != null) {
      _ukonStringToObjectMap = logika
          .getKadernickeUkonyByKadernikAndGenderWithPriceMap(
            _dropdownValueKadernik!,
            _radioValueType!,
          );

      // Možnosti pro DropDownMultiSelect jsou jen klíče (řetězce)
      _dropdownOptionsUkony = _ukonStringToObjectMap.keys.toList();

      // Filtrování vybraných objektů: ponecháme jen ty, které jsou stále v možnostech
      Set<String> validIds = _ukonStringToObjectMap.values
          .map((u) => u.id)
          .toSet();
      _selectedUkonyObjects = _selectedUkonyObjects
          .where((ukon) => validIds.contains(ukon.id))
          .toList();
      _selectedUkonyStrings = _selectedUkonyObjects
          .map((u) => u.toString())
          .toList();

      totalPrice = 0;
      totalTime = 0;

      if (_selectedUkonyObjects.isNotEmpty) {
        for (KadernickyUkon ukon in _selectedUkonyObjects) {
          totalPrice += ukon.cena;
          totalTime += ukon.delkaMinuty;
        }
        _dropdownOptionsCasyRezervace = logika.findAvailableTimes(
          _dropdownValueKadernik!,
          totalTime,
          selectedDate,
        );
      }
    } else {
      _ukonStringToObjectMap = {};
      _dropdownOptionsUkony = [];
      _selectedUkonyObjects = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = Consts.h2FS.sp;
    final double normalTextFontSize = Consts.normalFS.sp;

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
            if (widget.defaultKadernikId != null &&
                widget.defaultLokaceId != null) {
              //? Jedná se o Book Now = nastavíme default hodnoty na tohoto kadeřníka + lokaci
              _dropdownValueLokace = widget.defaultLokaceId!;
              _dropdownOptionsKadernik = snapshot.data!
                  .getAllKadernikFromLokace(widget.defaultLokaceId!);
              _dropdownValueKadernik = widget.defaultKadernikId;
            } else {
              //? Použijeme hodnotu prvního prvku jako výchozí
              Lokace prvniLokace = snapshot.data!.listAllLokace.first;
              _dropdownValueLokace = prvniLokace.id;
              _dropdownOptionsKadernik = snapshot.data!
                  .getAllKadernikFromLokace(prvniLokace.id);
              _dropdownValueKadernik = _dropdownOptionsKadernik.first.id;
            }
          }

          _radioValueType ??= "Male";

          _updateUkony(snapshot.data!);

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Create Reservation",
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Důležité pro Dialog
                      children: [
                        _buildRowItem(
                          caption: "Hair salon:",
                          widget: _dropdownButtonLokace(
                            snapshot,
                            normalTextFontSize,
                          ),
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Hairdresser:",
                          widget: _dropdownButtonKadernik(
                            snapshot,
                            normalTextFontSize,
                          ),
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Cut type:",
                          widget: _radioGroupGender(
                            snapshot,
                            normalTextFontSize,
                          ),
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Actions:",
                          widget: SizedBox(
                            width: 300,
                            height: 70,
                            child: _multiDropdownButtonUkony(
                              normalTextFontSize,
                            ),
                          ),
                          verticalSpacing:
                              0, // Nechceme extra mezeru uvnitř Boxu
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Estimated price:",
                          widget: _textTotalPrice(normalTextFontSize),
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Estimated length of all actions:",
                          widget: _textTotalTime(normalTextFontSize),
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Select available date:",
                          widget: _elevatedButtonDatum(
                            snapshot,
                            context,
                            normalTextFontSize,
                          ),
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Select available time:",
                          widget: _dropdownButtonCas(normalTextFontSize),
                          normalTextFontSize: normalTextFontSize,
                        ),

                        _buildRowItem(
                          caption: "Note:",
                          widget: _textFieldNote(normalTextFontSize),
                          normalTextFontSize: normalTextFontSize,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    _elevatedButtonCreate(snapshot.data!, headingFontSize),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ElevatedButton _elevatedButtonCreate(
    CreateReservationLogic logika,
    double headingFontSize,
  ) {
    return ElevatedButton(
      onPressed: () async {
        if ((_dropdownValueLokace != null) &&
            (_selectedUkonyObjects.isNotEmpty) &&
            (selectedDate != null) &&
            (_dropdownValueCasRezervace != null)) {
          bool uspesneVytvoreni = await logika.createRezervace(
            _dropdownValueKadernik!,
            _selectedUkonyObjects,
            selectedDate!,
            _dropdownValueCasRezervace!,
            totalTime,
            totalPrice,
            _noteController.text,
          );

          if (uspesneVytvoreni) {
            //? Vracím true, abych si pak v kódu mohl zjistit že jsem vytvořil novou rezervaci a je potřeba rebuildnout view
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Consts.colorScheme.primaryContainer,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          "Create",
          style: TextStyle(fontSize: headingFontSize, color: Colors.black),
        ),
      ),
    );
  }

  Container _textFieldNote(double normalTextFontSize) {
    return Container(
      width: 220.w,
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: TextField(
        controller: _noteController,
        maxLines: 1,
        decoration: InputDecoration.collapsed(hintText: ""),
        maxLength: 40,
        style: TextStyle(fontSize: normalTextFontSize),
      ),
    );
  }

  DropdownButton<String> _dropdownButtonCas(double normalTextFontSize) {
    return DropdownButton(
      value: _dropdownValueCasRezervace,
      borderRadius: BorderRadius.circular(15.r),
      underline: null,
      items: [
        for (String cas in _dropdownOptionsCasyRezervace)
          DropdownMenuItem<String>(
            value: cas,
            child: Text(cas, style: TextStyle(fontSize: normalTextFontSize)),
          ),
      ],
      onChanged: (String? newValue) {
        setState(() {
          _dropdownValueCasRezervace = newValue;
          //_updateUkony(snapshot.data!);
        });
      },
    );
  }

  ElevatedButton _elevatedButtonDatum(
    AsyncSnapshot<CreateReservationLogic> snapshot,
    BuildContext context,
    double normalTextFontSize,
  ) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime today = DateTime.now();
        final Kadernik kadernik = snapshot.data!.getKadernikById(
          _dropdownValueKadernik!,
        )!;

        DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(today.year, today.month, today.day + 1),
          lastDate: DateTime(today.year + 1, today.month, today.day),
          initialDatePickerMode: DatePickerMode.day,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          locale: Locale('cs', ''),
          selectableDayPredicate: (DateTime day) {
            //? Kontrola, že si uživatel nevybral nevalidní den
            if (kadernik.pracovniDny.contains(day.weekday.toString())) {
              return true;
            }
            return false;
          },
        );

        if (pickedDate == null) {
          selectedDate = null;
        }

        setState(() {
          selectedDate = pickedDate;
        });

        _dropdownOptionsCasyRezervace = snapshot.data!.findAvailableTimes(
          _dropdownValueKadernik!,
          totalTime,
          selectedDate,
        );
        print(_dropdownOptionsCasyRezervace);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Consts.background),
      ),
      child: Text(
        selectedDate == null
            ? "Select date"
            : "${selectedDate!.day}.${selectedDate!.month}",
        style: TextStyle(fontSize: normalTextFontSize, color: Colors.black),
        textAlign: TextAlign.left,
      ),
    );
  }

  Text _textTotalTime(double normalTextFontSize) {
    return Text(
      "$totalTime min",
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _textTotalPrice(double normalTextFontSize) {
    return Text(
      "$totalPrice Kč",
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _multiDropdownButtonUkony(double normalTextFontSize) {
    return SizedBox(
      width: 1000,
      height: 60,
      child: DropDownMultiSelect<String>(
        options: _dropdownOptionsUkony,
        onChanged: (List<String> selectedStrings) {
          setState(() {
            // Zde převedeme stringy zpět na objekty pomocí mapování
            _selectedUkonyObjects = selectedStrings
                .where((s) => _ukonStringToObjectMap.containsKey(s))
                .map((s) => _ukonStringToObjectMap[s]!)
                .toList();

            totalPrice = 0;
            _dropdownValueCasRezervace = null;

            if (_selectedUkonyObjects.isNotEmpty) {
              for (KadernickyUkon ukon in _selectedUkonyObjects) {
                totalPrice += ukon.cena;
              }
            }
          });
        },
        selectedValues: _selectedUkonyStrings,
        childBuilder: (selectedValues) {
          String text;
          if (selectedValues.isNotEmpty) {
            text = "Selected ${selectedValues.length} actions";
          } else {
            text = "Select actions...";
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
            child: Text(
              text,
              style: TextStyle(
                fontSize: normalTextFontSize,
                fontWeight: FontWeight.w300,
              ),
            ),
          );
        },
      ),
    );
  }

  RadioGroup<String> _radioGroupGender(
    AsyncSnapshot<CreateReservationLogic> snapshot,
    double normalTextFontSize,
  ) {
    return RadioGroup<String>(
      groupValue: _radioValueType,
      onChanged: (String? value) {
        setState(() {
          _radioValueType = value;
          _updateUkony(snapshot.data!);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Radio<String>(value: "Male"),
              Text("Male", style: TextStyle(fontSize: normalTextFontSize)),
            ],
          ),
          SizedBox(width: 20.w),
          Row(
            children: [
              Radio<String>(value: "Female"),
              Text("Female", style: TextStyle(fontSize: normalTextFontSize)),
            ],
          ),
        ],
      ),
    );
  }

  DropdownButton<String> _dropdownButtonKadernik(
    AsyncSnapshot<CreateReservationLogic> snapshot,
    double normalTextFontSize,
  ) {
    return DropdownButton(
      value: _dropdownValueKadernik,
      borderRadius: BorderRadius.circular(15.r),
      underline: null,
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
          _updateUkony(snapshot.data!);
        });
      },
    );
  }

  DropdownButton<String> _dropdownButtonLokace(
    AsyncSnapshot<CreateReservationLogic> snapshot,
    double normalTextFontSize,
  ) {
    return DropdownButton(
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
          _dropdownOptionsKadernik = snapshot.data!.getAllKadernikFromLokace(
            newValue!,
          );
          _dropdownValueKadernik = _dropdownOptionsKadernik.first.id;

          _updateUkony(snapshot.data!);
        });
      },
    );
  }

  Widget _buildRowItem({
    required String caption,
    required Widget widget,
    required double normalTextFontSize,
    double horizontalSpacing = 10.0, // Mezera mezi popiskem a widgetem
    double verticalSpacing = 20.0, // Mezera pod celým řádkem
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: verticalSpacing.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 250.w,
            child: Align(
              alignment: Alignment.centerRight,
              child: _captionText(caption, normalTextFontSize),
            ),
          ),

          SizedBox(width: horizontalSpacing.w),
          SizedBox(
            width: 300.w,
            child: Align(alignment: Alignment.centerLeft, child: widget),
          ),
        ],
      ),
    );
  }

  Text _captionText(String text, double normalTextFontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
