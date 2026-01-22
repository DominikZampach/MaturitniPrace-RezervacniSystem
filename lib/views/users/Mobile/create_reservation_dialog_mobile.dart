import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiselect/multiselect.dart';
import 'package:rezervacni_system_maturita/logic/createReservation.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

class CreateReservationDialogMobile extends StatefulWidget {
  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingFontSize;
  //? Default hodnoty pro Book Now
  final String? defaultKadernikId;
  final String? defaultLokaceId;

  const CreateReservationDialogMobile({
    super.key,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingFontSize,
    this.defaultKadernikId,
    this.defaultLokaceId,
  });

  @override
  State<CreateReservationDialogMobile> createState() =>
      _CreateReservationDialogMobileState();
}

class _CreateReservationDialogMobileState
    extends State<CreateReservationDialogMobile> {
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
    return Dialog.fullscreen(
      backgroundColor: Consts.background,

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
                padding: EdgeInsets.all(5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),

                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: AlignmentGeometry.center,
                        children: [
                          Text(
                            "Create Reservation",
                            style: TextStyle(
                              fontSize: widget.mobileHeadingsFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            left: 10,
                            child: GestureDetector(
                              onTap: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(),
                              child: Icon(Icons.arrow_back, size: 20.h),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildColumnItem(
                          caption: "Hair salon:",
                          widget: _dropdownButtonLokace(
                            snapshot,
                            widget.mobileSmallerFontSize,
                          ),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Hairdresser:",
                          widget: _dropdownButtonKadernik(
                            snapshot,
                            widget.mobileSmallerFontSize,
                          ),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Cut type:",
                          widget: _radioGroupGender(
                            snapshot,
                            widget.mobileSmallerFontSize,
                          ),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Actions:",
                          widget: SizedBox(
                            width: 300,
                            height: 70,
                            child: _multiDropdownButtonUkony(
                              widget.mobileSmallerFontSize,
                            ),
                          ),
                          verticalSpacing: 20.h,
                          textFontSize: widget.mobileFontSize,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Estimated price:",
                          widget: _textTotalPrice(widget.mobileSmallerFontSize),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Estimated length of all actions:",
                          widget: _textTotalTime(widget.mobileSmallerFontSize),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Select available date:",
                          widget: _elevatedButtonDatum(
                            snapshot,
                            context,
                            widget.mobileSmallerFontSize,
                          ),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Select available time:",
                          widget: _dropdownButtonCas(
                            widget.mobileSmallerFontSize,
                          ),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),

                        _buildColumnItem(
                          caption: "Note:",
                          widget: _textFieldNote(
                            widget.mobileSmallerFontSize,
                            700.w,
                          ),
                          textFontSize: widget.mobileFontSize,
                          verticalSpacing: 10.h,
                          width: 700.w,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    _elevatedButtonCreate(
                      snapshot.data!,
                      widget.mobileSmallerHeadingFontSize,
                    ),

                    SizedBox(height: 40.h),
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

  Container _textFieldNote(double normalTextFontSize, double width) {
    return Container(
      width: width,
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

  DropDownMultiSelect<String> _multiDropdownButtonUkony(double fontSize) {
    return DropDownMultiSelect<String>(
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
          child: Text(text, style: TextStyle(fontSize: fontSize)),
        );
      },
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
    double textFontSize,
  ) {
    return DropdownButton(
      value: _dropdownValueKadernik,
      borderRadius: BorderRadius.circular(15.r),
      alignment: Alignment.center,
      items: [
        for (Kadernik kadernik in _dropdownOptionsKadernik)
          DropdownMenuItem<String>(
            value: kadernik.id,
            alignment: Alignment.center,
            child: Text(
              "${kadernik.jmeno} ${kadernik.prijmeni}",
              style: TextStyle(fontSize: textFontSize),
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
    double textFontSize,
  ) {
    return DropdownButton(
      value: _dropdownValueLokace,
      borderRadius: BorderRadius.circular(15.r),
      underline: null,
      alignment: Alignment.center,
      items: [
        for (Lokace lokace in snapshot.data!.listAllLokace)
          DropdownMenuItem<String>(
            value: lokace.id,
            alignment: Alignment.center,
            child: Text(
              lokace.nazev,
              style: TextStyle(fontSize: textFontSize),
              textAlign: TextAlign.center,
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

  Widget _buildColumnItem({
    required String caption,
    required Widget widget,
    required double textFontSize,
    required double width,
    double verticalSpacing = 10,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: verticalSpacing),
          Container(
            width: width,
            alignment: Alignment.center,
            child: _captionText(caption, textFontSize),
          ),
          SizedBox(height: 2.h),
          Container(width: width, alignment: Alignment.center, child: widget),
          SizedBox(height: verticalSpacing),
        ],
      ),
    );
  }

  Text _captionText(String text, double textFontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: textFontSize, fontWeight: FontWeight.bold),
    );
  }
}
