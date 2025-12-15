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

  Future<_NactenaData> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final Uzivatel uzivatel = await dbService.getUzivatel();
    final Rezervace? rezervace = await dbService
        .getNearestRezervaceOfCurrentUser();

    return _NactenaData(uzivatel: uzivatel, rezervace: rezervace);
  }

  @override
  Widget build(BuildContext context) {
    //? Builder, který zajistí, že se načtou data o uživateli před
    return FutureBuilder<_NactenaData>(
      future: _nacteniDat(),
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

        if (nearestRezervace != null) {
          return Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _welcomeText(uzivatel, true),
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
        } else {
          //? Toto se provede pokud nebude nalezena jakákoliv rezervace
          return Flexible(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _welcomeText(uzivatel, false),
                      SizedBox(height: screenHeight * 0.5),
                      Text(
                        "You've got no reservations incoming, go book some!",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Padding _welcomeText(Uzivatel uzivatel, bool wantPadding) {
    return Padding(
      padding: wantPadding
          ? EdgeInsets.only(left: 20.w)
          : EdgeInsetsGeometry.all(0),
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
                  Text("Date: ", style: TextStyle(fontSize: 12.sp)),
                  Text(
                    nearestRezervace!.getDayMonthYearString(),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Time: ", style: TextStyle(fontSize: 12.sp)),
                  Text(
                    nearestRezervace!.getHourMinuteString(),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Hairdresser:",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      nearestRezervace!.kadernik.getFullNameString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),

                    SizedBox(height: screenHeight * 0.1),

                    Text(
                      "Actions:",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    for (KadernickyUkon ukon
                        in nearestRezervace!.kadernickeUkony)
                      Text(
                        ukon.nazev,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.h),
                child: SizedBox(
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.4,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10.r),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Image.network(
                        nearestRezervace!.kadernik.odkazFotografie,
                      ),
                    ),
                  ),
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
              Text(
                "Address:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${nearestRezervace!.kadernik.lokace.adresa} ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${nearestRezervace!.kadernik.lokace.psc} ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  Text(
                    nearestRezervace!.kadernik.lokace.mesto,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Contact:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
              Text(
                "Phone: ${nearestRezervace!.kadernik.telefon}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
              Text(
                "Mail: ${nearestRezervace!.kadernik.email}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
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
        height: screenHeight * 0.45,
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
