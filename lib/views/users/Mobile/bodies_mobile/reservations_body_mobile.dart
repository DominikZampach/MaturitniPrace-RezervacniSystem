import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/create_reservation_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/reservation_card.dart';

class ReservationsBodyMobile extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingFontSize;

  const ReservationsBodyMobile({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingFontSize,
  });

  @override
  State<ReservationsBodyMobile> createState() => _ReservationsBodyMobileState();
}

class _ReservationsBodyMobileState extends State<ReservationsBodyMobile> {
  Future<_NactenaData> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<KadernickyUkon> vsechnyUkony = await dbService
        .getAllKadernickeUkony();

    //? Future.wait provádí různé operace najednou! - zkracuje loading
    //TODO: Furt je potřeba ještě optimalizovat načítání!
    final results = await Future.wait([
      dbService.getAllPastRezervaceOfCurrentUser(vsechnyUkony: vsechnyUkony),
      dbService.getAllFutureRezervaceOfCurrentUser(vsechnyUkony: vsechnyUkony),
    ]);
    final List<Rezervace> historicalRezervace = results[0];
    final List<Rezervace> futureRezervace = results[1];

    return _NactenaData(
      historicalRezervace: historicalRezervace,
      futureRezervace: futureRezervace,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double leftPaddingH2 = 19.w;

    return FutureBuilder(
      future: _nacteniDat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.hasError) {
          print("Error při načítání dat: ${snapshot.error}");
          return const Center(
            child: Text(
              "Error occured while trying to load data from database!",
            ),
          );
        }

        final List<Rezervace> futureRezervace = snapshot.data!.futureRezervace;
        final List<Rezervace> historicalRezervace =
            snapshot.data!.historicalRezervace;

        return Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Text(
                  "Your Reservations",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.mobileHeadingsFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                /*
                child: _headingAndButtonRow(
                  context,
                  h1FontSize,
                  buttonFontSize,
                ),
                */
              ),
              SizedBox(height: 10.h),
              _createReservationButton(context, widget.mobileFontSize),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: leftPaddingH2, bottom: 10.h),
                child: Text(
                  "Upcoming",
                  style: TextStyle(
                    fontSize: widget.mobileSmallerHeadingFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ...futureRezervace.map(
                (rezervace) => ReservationCard(
                  key: ValueKey(rezervace.id),
                  rezervace: rezervace,
                  screenWidth: widget.screenWidth,
                  screenHeight: widget.screenHeight,
                  fontSize: widget.mobileSmallerFontSize,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: leftPaddingH2,
                  bottom: 10.h,
                  top: 20.h,
                ),
                child: Text(
                  "History",
                  style: TextStyle(
                    fontSize: widget.mobileSmallerHeadingFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ...historicalRezervace.map(
                (rezervace) => ReservationCard(
                  key: ValueKey(rezervace.id),
                  rezervace: rezervace,
                  screenWidth: widget.screenWidth,
                  screenHeight: widget.screenHeight,
                  fontSize: widget.mobileSmallerFontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ElevatedButton _createReservationButton(
    BuildContext context,
    double fontSize,
  ) {
    return ElevatedButton.icon(
      onPressed: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) =>
              CreateReservationDialog(), //TODO: Mobilní verze!
        );
        if (dialogResult) {
          //? Provede se pouze pokud bylo vráceno true - to se děje pouze když uživatel vytvoří novou rezervace
          setState(() {});
        }
      },
      label: Text(
        "Create Reservation",
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(Icons.add, color: Colors.black),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Consts.secondary),
      ),
    );
  }
}

class _NactenaData {
  final List<Rezervace> historicalRezervace;
  final List<Rezervace> futureRezervace;

  _NactenaData({
    required this.historicalRezervace,
    required this.futureRezervace,
  });
}
