import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/widgets/delete_alert_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/widgets/map_card.dart';
import 'package:rezervacni_system_maturita/views/admin/users/user_card_admin.dart';

class InspectReservationAdmin extends StatelessWidget {
  final Rezervace rezervace;
  final Function(String) deleteRezervace;
  const InspectReservationAdmin({
    super.key,
    required this.rezervace,
    required this.deleteRezervace,
  });

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = Consts.h2FS.sp;
    final double smallHeadingFontSize = Consts.h3FS.sp;
    final double normalTextFontSize = Consts.normalFS.sp;
    final double smallerTextFontSize = Consts.smallerFS.sp;

    return FutureBuilder(
      future: DatabaseService().getUserById(rezervace.idUzivatele),
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

        final Uzivatel uzivatelRezervace = snapshot.data!;

        return Dialog(
          backgroundColor: Consts.background,
          alignment: Alignment.center,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10.r),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),

          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: AlignmentGeometry.center,
                        children: [
                          Text(
                            "Reservation - ${rezervace.getDayMonthYearString()}",
                            style: TextStyle(
                              fontSize: headingFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () async {
                                bool? dialogResult = await showDialog(
                                  context: context,
                                  builder: (context) => DeleteAlertDialog(
                                    alertText:
                                        "Do you really want to delete this reservation?",
                                  ),
                                );

                                if (dialogResult == true) {
                                  await deleteRezervace(rezervace.id);

                                  if (context.mounted) {
                                    //? Vracím true, abych poslal znamení pro reload mateřské stránky
                                    Navigator.of(context).pop(true);
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _basicInfo(
                          smallHeadingFontSize,
                          normalTextFontSize,
                          smallerTextFontSize,
                          rezervace,
                          context,
                        ),
                        _hairdresserAndUser(
                          smallHeadingFontSize,
                          normalTextFontSize,
                          smallerTextFontSize,
                          rezervace,
                          uzivatelRezervace,
                          context,
                        ),
                        _location(
                          smallHeadingFontSize,
                          normalTextFontSize,
                          smallerTextFontSize,
                          rezervace,
                          context,
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 60.w),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: normalTextFontSize),
                            children: [
                              TextSpan(
                                text: "Note: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: rezervace.poznamkaUzivatele),
                            ],
                          ),
                        ),
                      ),
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

  Expanded _location(
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
    Rezervace rezervace,
    BuildContext context,
  ) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Location:",
            style: TextStyle(
              fontSize: smallHeadingFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          MapCard(
            lokace: rezervace.kadernik.lokace,
            width: 300.w,
            height: 300.h,
          ),
          SizedBox(height: 20.h),
          Text(
            rezervace.kadernik.lokace.nazev,
            style: TextStyle(
              fontSize: normalTextFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Address:",
            style: TextStyle(
              fontSize: normalTextFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "${rezervace.kadernik.lokace.adresa}\n${rezervace.kadernik.lokace.psc} ${rezervace.kadernik.lokace.mesto}",
            style: TextStyle(
              fontSize: normalTextFontSize,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Expanded _hairdresserAndUser(
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
    Rezervace rezervace,
    Uzivatel uzivatel,
    BuildContext context,
  ) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Hairdresser:",
            style: TextStyle(
              fontSize: smallHeadingFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            rezervace.kadernik.getFullNameString(),
            style: TextStyle(fontSize: normalTextFontSize),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.3,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10.r),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CachedNetworkImage(
                  imageUrl: rezervace.kadernik.odkazFotografie,
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
          SizedBox(height: 20.h),
          Text(
            "User:",
            style: TextStyle(
              fontSize: smallHeadingFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          UserCardAdmin(uzivatel: uzivatel, centerText: true),
          /*
          SizedBox(height: 10.h),
          Text(
            "${uzivatel.jmeno} ${uzivatel.prijmeni}\nEmail: ${uzivatel.email}\nMobile:${uzivatel.telefon}",
            style: TextStyle(fontSize: normalTextFontSize),
            textAlign: TextAlign.center,
          ),
          */
        ],
      ),
    );
  }

  Expanded _basicInfo(
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
    Rezervace rezervace,
    BuildContext context,
  ) {
    ScrollController scrollerController = ScrollController();

    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Basic info:",
            style: TextStyle(
              fontSize: smallHeadingFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: normalTextFontSize),
              children: [
                TextSpan(
                  text: "Date: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: rezervace.getDayMonthYearString()),
              ],
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: normalTextFontSize),
              children: [
                TextSpan(
                  text: "Time: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: rezervace.getHourMinuteString()),
              ],
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: normalTextFontSize),
              children: [
                TextSpan(
                  text: "Cut duration: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "${rezervace.delkaTrvani} min"),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: normalTextFontSize),
              children: [
                TextSpan(
                  text: "Price: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "${rezervace.celkovaCena} Kč"),
              ],
            ),
          ),

          SizedBox(height: 50.h),
          Text(
            "Services:",
            style: TextStyle(
              fontSize: smallHeadingFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Scrollbar(
              controller: scrollerController,
              thumbVisibility: true,
              trackVisibility: false,
              thickness: 7.w,
              radius: Radius.circular(10.r),
              child: ListView.builder(
                controller: scrollerController,
                itemCount: rezervace.kadernickeUkony.length,
                itemBuilder: (context, index) {
                  final ukon = rezervace.kadernickeUkony[index];
                  return ListTile(
                    title: Text(ukon.nazev, textAlign: TextAlign.center),
                    titleTextStyle: TextStyle(fontSize: normalTextFontSize),
                    titleAlignment: ListTileTitleAlignment.center,
                    subtitle: Text(
                      "Typ: ${ukon.getTypStrihu()}",
                      textAlign: TextAlign.center,
                    ),
                    subtitleTextStyle: TextStyle(
                      fontSize: smallerTextFontSize,
                      fontStyle: FontStyle.italic,
                    ),
                    onTap: () {
                      //? Otevření Dialogu, kde budou informace a fotky úkonu
                      final dialogResult = showDialog(
                        context: context,
                        builder: (context) =>
                            InspectKadernickyUkon(kadernickyUkon: ukon),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
