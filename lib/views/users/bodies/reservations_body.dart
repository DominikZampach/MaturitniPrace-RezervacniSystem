import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/reservation_card.dart';

class ReservationsBody extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const ReservationsBody({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  Future<_NactenaData> nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<Rezervace> historicalRezervace = await dbService
        .getAllPastRezervace();
    final List<Rezervace> futureRezervace = await dbService
        .getAllFutureRezervace();

    return _NactenaData(
      historicalRezervace: historicalRezervace,
      futureRezervace: futureRezervace,
    );

    return _NactenaData(historicalRezervace: [], futureRezervace: []);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nacteniDat(),
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
          height: screenHeight,
          width: double.infinity,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: _headingAndButtonRow(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, bottom: 20.h),
                child: Text(
                  "Upcoming",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ...futureRezervace.map(
                (rezervace) => ReservationCard(
                  key: ValueKey(rezervace.id),
                  rezervace: rezervace,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, bottom: 20.h, top: 20.h),
                child: Text(
                  "History",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ...historicalRezervace.map(
                (rezervace) => ReservationCard(
                  key: ValueKey(rezervace.id),
                  rezervace: rezervace,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row _headingAndButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //? Tento opacity object je vytvořený, abych měl vycentrovaný text :)
        IgnorePointer(
          child: Opacity(
            opacity: 0,
            child: ElevatedButton.icon(
              onPressed: () {},
              label: Text(
                "Create Reservation",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: Icon(Icons.add),
            ),
          ),
        ),

        Text(
          "Your Reservations",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          textAlign: TextAlign.center,
        ),

        ElevatedButton.icon(
          onPressed: () {},
          label: Text(
            "Create Reservation",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: Icon(Icons.add, color: Colors.black),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Consts.secondary),
          ),
        ),
      ],
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
