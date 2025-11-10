import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class DashboardBody extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const DashboardBody({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  Future<List<Object?>> nacteniDat() async {
    List<Object?> nacteneObjekty = [];

    nacteneObjekty.add(await DatabaseService().getUzivatel());
    //? Tady pak můžu přidat další věci, které se mají načíst při spuštění této obrazovky!s

    return nacteneObjekty;
  }

  @override
  Widget build(BuildContext context) {
    //? Builder, který zajistí, že se načtou data o uživateli před
    return FutureBuilder(
      future: nacteniDat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error occured while trying to load data from database!",
            ),
          );
        } else {
          final List<Object?> data = snapshot.data as List<Object?>;
          final Uzivatel uzivatel = data[0] as Uzivatel;
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
                      ),
                      NextAppointmentLocationColumn(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
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

class NextAppointmentLocationColumn extends StatelessWidget {
  const NextAppointmentLocationColumn({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

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
          Placeholder(
            child: SizedBox(
              width: screenWidth * 0.35,
              height: screenHeight * 0.5,
            ),
          ),
          Column(
            children: [
              Text("Address:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Adresa 123"), Text("Město")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("000 00"), Text("Město")],
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
}

class NextAppointmentColumn extends StatelessWidget {
  const NextAppointmentColumn({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

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
                children: [Text("Date: "), Text("01.01.2000")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Time: "), Text("00:00")],
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
                    Text("xxx"),
                    Text("xxx"),
                    Text("xxx"),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text("Hairdresser:"),
                    Text("Name Nickname Surname"),
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
}
