import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/minimap_from_adress.dart';

class DashboardBody extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const DashboardBody({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  Future<_NactenaData> nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final Uzivatel uzivatel = await dbService.getUzivatel();
    print("Načtený uživatel: ${uzivatel.toJson()}");
    final Rezervace? rezervace = await dbService.getNearestRezervace();
    print("Načtená rezervace: $rezervace");

    return _NactenaData(uzivatel: uzivatel, rezervace: rezervace);
  }

  @override
  Widget build(BuildContext context) {
    //? Builder, který zajistí, že se načtou data o uživateli před
    return FutureBuilder<_NactenaData>(
      future: nacteniDat(),
      builder: (context, snapshot) {
        print("Snapshot data: ${snapshot.data}");
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

        final Uzivatel uzivatel = snapshot.data!.uzivatel;
        final Rezervace? nearestRezervace = snapshot.data!.rezervace;

        return Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _welcomeText(uzivatel),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NextAppointmentColumn(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      nearestRezervace: nearestRezervace,
                    ),
                    NextAppointmentLocationColumn(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      nearestRezervace: nearestRezervace,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _welcomeText(Uzivatel uzivatel) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Text(
        "Welcome, ${uzivatel.jmeno} ${uzivatel.prijmeni}",
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NextAppointmentColumn extends StatelessWidget {
  const NextAppointmentColumn({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.nearestRezervace,
  });

  final double screenHeight;
  final double screenWidth;
  final Rezervace? nearestRezervace;

  @override
  Widget build(BuildContext context) {
    //? Kontrola, pokud uživatel má nějakou budoucí rezervaci
    if (nearestRezervace != null) {
      return Container(
        color: Consts.background.withValues(alpha: 0.6),
        height: screenHeight * 0.8,
        width: screenWidth * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Next appointment",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17.sp),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Date: "),
                    Text(nearestRezervace!.getDayMonthYearString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Time: "),
                    Text(nearestRezervace!.getHourMinuteString()),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Actions:"),
                      for (KadernickyUkon ukon
                          in nearestRezervace!.kadernickeUkony)
                        Text(ukon.nazev),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("Hairdresser:"),
                      Text(nearestRezervace!.kadernik.getFullNameString()),
                      Placeholder(
                        child: SizedBox(
                          width: screenWidth * 0.15,
                          height: screenHeight * 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "Click here to see full reservation...",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15.sp,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      );
    }

    //? Toto se zobrazí, pokud uživatel nemá žádnou budoucí rezervaci
    return Container(
      color: Consts.background.withValues(alpha: 0.6),
      height: screenHeight * 0.8,
      width: screenWidth * 0.4,
      child: Center(child: Text("You have no upcoming reservation.")),
    );
  }
}

class NextAppointmentLocationColumn extends StatelessWidget {
  const NextAppointmentLocationColumn({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.nearestRezervace,
  });

  final double screenHeight;
  final double screenWidth;
  final Rezervace? nearestRezervace;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Consts.background.withValues(alpha: 0.6),
      height: screenHeight * 0.8,
      width: screenWidth * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Next appointment location",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17.sp),
          ),
          _mapCard(),
          Column(
            children: [
              Text("Address:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${nearestRezervace!.kadernik.lokace.adresa} "),
                  Text(nearestRezervace!.kadernik.lokace.mesto),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${nearestRezervace!.kadernik.lokace.psc} "),
                  Text(nearestRezervace!.kadernik.lokace.mesto),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text("Contact:"),
              Text("Telefonní číslo"),
              Text("email@email.com"),
            ],
          ),
        ],
      ),
    );
  }

  Card _mapCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      elevation: 2,
      child: SizedBox(
        width: screenWidth * 0.35,
        height: screenHeight * 0.5,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(10.r),
          child: MinimapFromAdress(
            latitude: nearestRezervace!.kadernik.lokace.latitude,
            longitude: nearestRezervace!.kadernik.lokace.longitude,
          ),
        ),
      ),
    );
  }
}

class _NactenaData {
  final Uzivatel uzivatel;
  final Rezervace? rezervace;

  _NactenaData({required this.uzivatel, required this.rezervace});
}
