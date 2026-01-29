import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_rezervace.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/inspect_mobile/inspect_rezervace_mobile.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/map_card.dart';

class DashboardBodyMobile extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final Uzivatel uzivatel;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingFontSize;

  const DashboardBodyMobile({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.uzivatel,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingFontSize,
  });

  @override
  State<DashboardBodyMobile> createState() => _DashboardBodyMobileState();
}

class _DashboardBodyMobileState extends State<DashboardBodyMobile> {
  Future<Rezervace?> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final Rezervace? nearestRezervace = await dbService
        .getNearestRezervaceOfCurrentUser();

    return nearestRezervace;
  }

  @override
  Widget build(BuildContext context) {
    //? Builder, který zajistí, že se načtou data o uživateli před

    return FutureBuilder(
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

        final Rezervace? nearestRezervace = snapshot.data;

        dynamic deleteRezervace(String rezervaceId) async {
          DatabaseService dbService = DatabaseService();

          await dbService.deleteRezervace(rezervaceId);
          setState(() {});
        }

        if (nearestRezervace != null) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _welcomeText(widget.uzivatel, widget.mobileHeadingsFontSize),
                  Column(
                    children: [
                      NextAppointmentColumnMobile(
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        nearestRezervace: nearestRezervace,
                        mobileFontSize: widget.mobileFontSize,
                        mobileSmallerHeadingSize:
                            widget.mobileSmallerHeadingFontSize,
                      ),
                      NextAppointmentLocationColumnMobile(
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        nearestRezervace: nearestRezervace,
                        mobileFontSize: widget.mobileFontSize,
                        mobileSmallerFontSize: widget.mobileSmallerFontSize,
                        mobileHeadingsFontSize: widget.mobileHeadingsFontSize,
                        mobileSmallerHeadingSize:
                            widget.mobileSmallerHeadingFontSize,
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
                      _welcomeText(
                        widget.uzivatel,
                        widget.mobileHeadingsFontSize,
                      ),
                      SizedBox(height: widget.screenHeight * 0.5),
                      Text(
                        "You've got no reservations incoming, go book some!",
                        style: TextStyle(
                          fontSize: widget.mobileHeadingsFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
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

  Text _welcomeText(Uzivatel uzivatel, double mobileHeadingSize) {
    return Text(
      "Welcome, ${uzivatel.jmeno} ${uzivatel.prijmeni}",
      style: TextStyle(
        fontSize: mobileHeadingSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class NextAppointmentColumnMobile extends StatefulWidget {
  const NextAppointmentColumnMobile({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.nearestRezervace,
    required this.mobileFontSize,
    required this.mobileSmallerHeadingSize,
  });

  final double screenHeight;
  final double screenWidth;
  final Rezervace? nearestRezervace;
  final double mobileFontSize;
  final double mobileSmallerHeadingSize;

  @override
  State<NextAppointmentColumnMobile> createState() =>
      _NextAppointmentColumnMobileState();
}

class _NextAppointmentColumnMobileState
    extends State<NextAppointmentColumnMobile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.h),
        Text(
          "Next appointment",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: widget.mobileSmallerHeadingSize,
          ),
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Date: ",
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
                Text(
                  widget.nearestRezervace!.getDayMonthYearString(),
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Time: ",
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
                Text(
                  widget.nearestRezervace!.getHourMinuteString(),
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Text(
              "Hairdresser:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.mobileFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.nearestRezervace!.kadernik.getFullNameString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: widget.mobileFontSize),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: SizedBox(
                width: widget.screenWidth * 0.9,
                height: widget.screenHeight * 0.4,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10.r),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CachedNetworkImage(
                      imageUrl:
                          widget.nearestRezervace!.kadernik.odkazFotografie,
                      httpHeaders: {
                        "Access-Control-Allow-Origin": "*",
                        "User-Agent": "Mozilla/5.0...",
                      },
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, size: 50.h),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5.h),

            Text(
              "Actions:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.mobileFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (KadernickyUkon ukon
                in widget.nearestRezervace!.kadernickeUkony)
              Text(
                ukon.nazev,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: widget.mobileFontSize),
              ),
          ],
        ),
      ],
    );
  }
}

class NextAppointmentLocationColumnMobile extends StatefulWidget {
  const NextAppointmentLocationColumnMobile({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.nearestRezervace,
    required this.mobileFontSize,
    required this.mobileSmallerHeadingSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
  });

  final double screenHeight;
  final double screenWidth;
  final Rezervace? nearestRezervace;
  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingSize;

  @override
  State<NextAppointmentLocationColumnMobile> createState() =>
      _NextAppointmentLocationColumnMobileState();
}

class _NextAppointmentLocationColumnMobileState
    extends State<NextAppointmentLocationColumnMobile> {
  @override
  Widget build(BuildContext context) {
    dynamic deleteRezervace(String rezervaceId) async {
      DatabaseService dbService = DatabaseService();

      await dbService.deleteRezervace(rezervaceId);
      setState(() {});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.h),
        Text(
          "Next appointment location",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: widget.mobileSmallerHeadingSize,
          ),
        ),
        SizedBox(height: 10.h),
        MapCard(
          lokace: widget.nearestRezervace!.kadernik.lokace,
          width: widget.screenWidth * 0.9,
          height: widget.screenHeight * 0.4,
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Text(
              "Address:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.mobileFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.nearestRezervace!.kadernik.lokace.nazev,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.nearestRezervace!.kadernik.lokace.adresa,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.nearestRezervace!.kadernik.lokace.psc} ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
                Text(
                  widget.nearestRezervace!.kadernik.lokace.mesto,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: widget.mobileFontSize),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Text(
              "Contact:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.mobileFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Phone: ${widget.nearestRezervace!.kadernik.telefon}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: widget.mobileFontSize),
            ),
            Text(
              "Mail: ${widget.nearestRezervace!.kadernik.email}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: widget.mobileFontSize),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => InspectRezervaceMobile(
                  rezervace: widget.nearestRezervace!,
                  mobileFontSize: widget.mobileFontSize,
                  mobileSmallerFontSize: widget.mobileSmallerFontSize,
                  mobileHeadingsFontSize: widget.mobileHeadingsFontSize,
                  mobileSmallerHeadingsFontSize:
                      widget.mobileSmallerHeadingSize,
                  deleteRezervace: deleteRezervace,
                ),
              );
            },
            child: Text(
              "Click here to see full reservation...",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: widget.mobileSmallerHeadingSize,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
