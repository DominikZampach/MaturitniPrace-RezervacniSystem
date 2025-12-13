import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/create_reservation_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/reservation_card.dart';

class ReservationsBody extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const ReservationsBody({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<ReservationsBody> createState() => _ReservationsBodyState();
}

class _ReservationsBodyState extends State<ReservationsBody> {
  Future<_NactenaData> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<Rezervace> historicalRezervace = await dbService
        .getAllPastRezervaceOfCurrentUser();
    final List<Rezervace> futureRezervace = await dbService
        .getAllFutureRezervaceOfCurrentUser();

    return _NactenaData(
      historicalRezervace: historicalRezervace,
      futureRezervace: futureRezervace,
    );
  }

  @override
  Widget build(BuildContext context) {
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

        final double reservationCardFontSize = 11.sp;
        final double buttonFontSize = 12.sp;
        final double h1FontSize = 18.sp;
        final double h2FontSize = 15.sp;

        final double leftPaddingH2 = 19.w;

        final List<Rezervace> futureRezervace = snapshot.data!.futureRezervace;
        final List<Rezervace> historicalRezervace =
            snapshot.data!.historicalRezervace;

        return Container(
          color: Colors.white,
          height: widget.screenHeight,
          width: double.infinity,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: _headingAndButtonRow(
                  context,
                  h1FontSize,
                  buttonFontSize,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: leftPaddingH2, bottom: 10.h),
                child: Text(
                  "Upcoming",
                  style: TextStyle(
                    fontSize: h2FontSize,
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
                  fontSize: reservationCardFontSize,
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
                    fontSize: h2FontSize,
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
                  fontSize: reservationCardFontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row _headingAndButtonRow(
    BuildContext context,
    double headingFontSize,
    double buttonFontSize,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //? Tento opacity object je vytvořený, abych měl vycentrovaný text :)
        IgnorePointer(
          child: Opacity(
            opacity: 0,
            child: _createReservationButton(context, buttonFontSize),
          ),
        ),

        Text(
          "Your Reservations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headingFontSize,
          ),
          textAlign: TextAlign.center,
        ),

        _createReservationButton(context, buttonFontSize),
      ],
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
          builder: (BuildContext context) => CreateReservationDialog(),
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
