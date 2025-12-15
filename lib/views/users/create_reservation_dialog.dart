import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiselect/multiselect.dart';
import 'package:rezervacni_system_maturita/logic/createReservation.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
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

          _updateUkony(snapshot.data!);

          return Center(
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
                        widget: _dropdownButtonLokace(snapshot),
                      ),

                      _buildRowItem(
                        caption: "Hairdresser:",
                        widget: _dropdownButtonKadernik(snapshot),
                      ),

                      _buildRowItem(
                        caption: "Cut type:",
                        widget: _radioGroupGender(snapshot),
                      ),

                      _buildRowItem(
                        caption: "Actions:",
                        widget: SizedBox(
                          width: 300,
                          height: 70,
                          child: _multiDropdownButtonUkony(),
                        ),
                        verticalSpacing: 0, // Nechceme extra mezeru uvnitř Boxu
                      ),

                      _buildRowItem(
                        caption: "Estimated price:",
                        widget: _textTotalPrice(),
                      ),

                      _buildRowItem(
                        caption: "Estimated length of all actions:",
                        widget: _textTotalTime(),
                      ),

                      _buildRowItem(
                        caption: "Select available date:",
                        widget: _elevatedButtonDatum(snapshot, context),
                      ),

                      _buildRowItem(
                        caption: "Select available time:",
                        widget: _dropdownButtonCas(),
                      ),

                      _buildRowItem(caption: "Note:", widget: _textFieldNote()),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  _elevatedButtonCreate(snapshot.data!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ElevatedButton _elevatedButtonCreate(CreateReservationLogic logika) {
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
            Navigator.of(context).pop(true);
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

  Container _textFieldNote() {
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

  DropdownButton<String> _dropdownButtonCas() {
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

  Text _textTotalTime() {
    return Text(
      "$totalTime min",
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _textTotalPrice() {
    return Text(
      "$totalPrice Kč",
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  SizedBox _multiDropdownButtonUkony() {
    return SizedBox(
      width: 300,
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
        whenEmpty: "Select actions..",
        selectedValuesStyle: TextStyle(fontSize: 0),
        separator: "\n",
      ),
    );
  }

  RadioGroup<String> _radioGroupGender(
    AsyncSnapshot<CreateReservationLogic> snapshot,
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
              child: _captionText(caption),
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
