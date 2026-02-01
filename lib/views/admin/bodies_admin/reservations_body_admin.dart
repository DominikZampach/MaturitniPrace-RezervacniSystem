import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/views/admin/reservations/reservation_card_admin.dart';

class ReservationsBodyAdmin extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const ReservationsBodyAdmin({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<ReservationsBodyAdmin> createState() => _ReservationsBodyAdminState();
}

class _ReservationsBodyAdminState extends State<ReservationsBodyAdmin> {
  late Future<List<Rezervace>> futureLogika;

  Future<List<Rezervace>> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<Rezervace> allFutureRezervace = await dbService
        .getAllFutureRezervace();

    return allFutureRezervace;
  }

  @override
  void initState() {
    super.initState();
    futureLogika = _nacteniDat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLogika,
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

        final double h1FontSize = Consts.h1FS.sp;

        final List<Rezervace> listAllFutureRezervace = snapshot.data!;
        listAllFutureRezervace.sort(
          (a, b) => a.datumCasRezervace.compareTo(b.datumCasRezervace),
        );

        dynamic deleteRezervace(String rezervaceId) async {
          DatabaseService dbService = DatabaseService();
          int rezervaceIndex = listAllFutureRezervace.indexWhere(
            (item) => item.id == rezervaceId,
          );
          await dbService.deleteRezervace(rezervaceId);

          setState(() {
            listAllFutureRezervace.removeAt(rezervaceIndex);
          });
        }

        return Container(
          color: Colors.white,
          height: widget.screenHeight,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "All Future Reservations",
                  style: TextStyle(
                    fontSize: h1FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 150.w,
                    vertical: 10.h,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.h,
                      childAspectRatio: 6.7,
                    ),
                    itemCount: listAllFutureRezervace.length,
                    itemBuilder: (BuildContext context, int index) {
                      ReservationCardAdmin card = ReservationCardAdmin(
                        rezervace: listAllFutureRezervace[index],
                        deleteRezervace: deleteRezervace,
                      );
                      return card;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
