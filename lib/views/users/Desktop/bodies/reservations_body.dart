import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/create_reservation_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/reservation_card.dart';
import 'package:rezervacni_system_maturita/widgets/reservation_card_mobile.dart';

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
    return FutureBuilder(
      future: _nacteniDat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.hasError) {
          print("Error při načítání dat: ${snapshot.error}");
          return const Center(
            child: Text("Naskytla se chyba při načítání dat z databáze!"),
          );
        }

        final double reservationCardFontSize = Consts.smallerFS.sp;
        final double buttonFontSize = Consts.normalFS.sp;
        final double h1FontSize = Consts.h1FS.sp;
        final double h2FontSize = Consts.h2FS.sp;

        final double leftPaddingH2 = 19.w;

        final List<Rezervace> futureRezervace = snapshot.data!.futureRezervace;
        final List<Rezervace> historicalRezervace =
            snapshot.data!.historicalRezervace;

        dynamic deleteRezervace(String rezervaceId) async {
          DatabaseService dbService = DatabaseService();
          int rezervaceIndex = futureRezervace.indexWhere(
            (item) => item.id == rezervaceId,
          );
          await dbService.deleteRezervace(rezervaceId);

          if (rezervaceIndex == -1) {
            //? To znamená že to není v ve futureListu, ale v historical
            rezervaceIndex = historicalRezervace.indexWhere(
              (item) => item.id == rezervaceId,
            );
            setState(() {
              historicalRezervace.removeAt(rezervaceIndex);
            });
          } else {
            setState(() {
              futureRezervace.removeAt(rezervaceIndex);
            });
          }
        }

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
                  "Nadcházející",
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
                  deleteRezervace: deleteRezervace,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: leftPaddingH2,
                  bottom: 10.h,
                  top: 20.h,
                ),
                child: Text(
                  "Historie",
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
                  deleteRezervace: deleteRezervace,
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
          "Vaše rezervace",
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
        "Vytvořit rezervaci",
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
