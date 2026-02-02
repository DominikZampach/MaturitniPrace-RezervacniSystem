import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_rezervace.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/map_card.dart';

class DashboardBody extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final Uzivatel uzivatel;

  const DashboardBody({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.uzivatel,
  });

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
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

        final double normalFontSize = Consts.normalFS.sp;
        final double h1FontSize = Consts.h1FS.sp;
        final double h2FontSize = Consts.h2FS.sp;

        final Rezervace? nearestRezervace = snapshot.data;

        if (nearestRezervace != null) {
          return Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 20.h),
                  _welcomeText(widget.uzivatel, true, h1FontSize),
                  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NextAppointmentColumn(
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        nearestRezervace: nearestRezervace,
                        h2FontSize: h2FontSize,
                        normalFontSize: normalFontSize,
                      ),
                      NextAppointmentLocationColumn(
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        nearestRezervace: nearestRezervace,
                        h2FontSize: h2FontSize,
                        normalFontSize: normalFontSize,
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
                      _welcomeText(widget.uzivatel, false, h1FontSize),
                      SizedBox(height: widget.screenHeight * 0.5),
                      Text(
                        "You've got no reservations incoming, go book some!",
                        style: TextStyle(
                          fontSize: h2FontSize,
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

  Padding _welcomeText(Uzivatel uzivatel, bool wantPadding, double h1FontSize) {
    return Padding(
      padding: wantPadding
          ? EdgeInsets.only(left: 25.w)
          : EdgeInsetsGeometry.all(0),
      child: Text(
        "Welcome, ${uzivatel.jmeno} ${uzivatel.prijmeni}",
        style: TextStyle(fontSize: h1FontSize, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NextAppointmentColumn extends StatefulWidget {
  const NextAppointmentColumn({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.nearestRezervace,
    required this.h2FontSize,
    required this.normalFontSize,
  });

  final double screenHeight;
  final double screenWidth;
  final Rezervace? nearestRezervace;

  final double h2FontSize;
  final double normalFontSize;

  @override
  State<NextAppointmentColumn> createState() => _NextAppointmentColumnState();
}

class _NextAppointmentColumnState extends State<NextAppointmentColumn> {
  @override
  Widget build(BuildContext context) {
    dynamic deleteRezervace(String rezervaceId) async {
      DatabaseService dbService = DatabaseService();

      await dbService.deleteRezervace(rezervaceId);
      setState(() {});
    }

    return Container(
      color: Consts.background.withValues(alpha: 0.6),
      width: widget.screenWidth * 0.4,
      constraints: BoxConstraints(minHeight: widget.screenHeight * 0.8),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Text(
            "Next appointment",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: widget.h2FontSize,
            ),
          ),
          SizedBox(height: 20.h),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Date: ",
                    style: TextStyle(fontSize: widget.normalFontSize),
                  ),
                  Text(
                    widget.nearestRezervace!.getDayMonthYearString(),
                    style: TextStyle(fontSize: widget.normalFontSize),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Time: ",
                    style: TextStyle(fontSize: widget.normalFontSize),
                  ),
                  Text(
                    widget.nearestRezervace!.getHourMinuteString(),
                    style: TextStyle(fontSize: widget.normalFontSize),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
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
                      style: TextStyle(
                        fontSize: widget.normalFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.nearestRezervace!.kadernik.getFullNameString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: widget.normalFontSize),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Actions:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: widget.normalFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (KadernickyUkon ukon
                        in widget.nearestRezervace!.kadernickeUkony)
                      Text(
                        ukon.nazev,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: widget.normalFontSize),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.h),
                child: SizedBox(
                  width: widget.screenWidth * 0.2,
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
                            Icon(Icons.error, size: 30.h),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => InspectRezervace(
                    rezervace: widget.nearestRezervace!,
                    deleteRezervace: deleteRezervace,
                  ),
                );
              },
              child: Text(
                "Click here to see full reservation...",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: widget.h2FontSize,
                  decoration: TextDecoration.underline,
                ),
              ),
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
    required this.h2FontSize,
    required this.normalFontSize,
  });

  final double screenHeight;
  final double screenWidth;
  final Rezervace? nearestRezervace;

  final double h2FontSize;
  final double normalFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Consts.background.withValues(alpha: 0.6),
      constraints: BoxConstraints(minHeight: screenHeight * 0.8),
      width: screenWidth * 0.4,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text(
            "Next appointment location",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: h2FontSize),
          ),
          SizedBox(height: 10.h),
          MapCard(
            lokace: nearestRezervace!.kadernik.lokace,
            width: screenWidth * 0.35,
            height: screenHeight * 0.40,
          ),
          SizedBox(height: 10.h),
          Column(
            children: [
              Text(
                "Address:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: normalFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nearestRezervace!.kadernik.lokace.nazev,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nearestRezervace!.kadernik.lokace.adresa,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${nearestRezervace!.kadernik.lokace.psc} ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                  Text(
                    nearestRezervace!.kadernik.lokace.mesto,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: normalFontSize),
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
                  fontSize: normalFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Phone: ${nearestRezervace!.kadernik.telefon}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: normalFontSize),
              ),
              Text(
                "Mail: ${nearestRezervace!.kadernik.email}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: normalFontSize),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
