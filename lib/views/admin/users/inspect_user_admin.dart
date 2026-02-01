import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/admin/reservations/inspect_reservation_admin.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class InspectUserAdmin extends StatefulWidget {
  final Uzivatel uzivatel;
  const InspectUserAdmin({super.key, required this.uzivatel});

  @override
  State<InspectUserAdmin> createState() => _InspectUserAdminState();
}

class _InspectUserAdminState extends State<InspectUserAdmin> {
  @override
  Widget build(BuildContext context) {
    final double headingFontSize = Consts.h2FS.sp;
    final double smallHeadingFontSize = Consts.h3FS.sp;
    final double normalTextFontSize = Consts.normalFS.sp;

    return FutureBuilder(
      future: DatabaseService().getAllRezervaceOfUser(widget.uzivatel.userUID),
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

        final List<Rezervace> rezervaceUzivatele = snapshot.data!;

        dynamic deleteRezervace(String rezervaceId) async {
          DatabaseService dbService = DatabaseService();
          int rezervaceIndex = rezervaceUzivatele.indexWhere(
            (item) => item.id == rezervaceId,
          );
          await dbService.deleteRezervace(rezervaceId);

          setState(() {
            rezervaceUzivatele.removeAt(rezervaceIndex);
          });
        }

        return Dialog(
          backgroundColor: Consts.background,
          alignment: Alignment.center,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10.r),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.4,
            minWidth: MediaQuery.of(context).size.width * 0.4,
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),

          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.uzivatel.jmeno} ${widget.uzivatel.prijmeni}",
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      children: [
                        Text(
                          "Basic information",
                          style: TextStyle(
                            fontSize: smallHeadingFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Name: ${widget.uzivatel.jmeno}",
                          style: TextStyle(fontSize: normalTextFontSize),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Surname: ${widget.uzivatel.prijmeni}",
                          style: TextStyle(fontSize: normalTextFontSize),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Phone: ${widget.uzivatel.telefon}",
                          style: TextStyle(fontSize: normalTextFontSize),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Email: ${widget.uzivatel.email}",
                          style: TextStyle(fontSize: normalTextFontSize),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Column(
                      children: [
                        Text(
                          "Reservations",
                          style: TextStyle(
                            fontSize: smallHeadingFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ListView.builder(
                            itemCount: rezervaceUzivatele.length,
                            itemBuilder: (context, index) {
                              final Rezervace rezervace =
                                  rezervaceUzivatele[index];
                              return ListTile(
                                title: Text(
                                  "${rezervace.getDayMonthYearString()} - ${rezervace.getHourMinuteString()}",
                                  textAlign: TextAlign.center,
                                ),
                                titleTextStyle: TextStyle(
                                  fontSize: normalTextFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                                subtitle: Text(
                                  "Hairdresser: ${rezervace.kadernik.jmeno} \"${rezervace.kadernik.prezdivka}\" ${rezervace.kadernik.prijmeni}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: normalTextFontSize,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        InspectReservationAdmin(
                                          rezervace: rezervace,
                                          deleteRezervace: deleteRezervace,
                                        ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
