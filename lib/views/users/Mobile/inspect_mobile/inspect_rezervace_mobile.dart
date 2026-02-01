import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/inspect_mobile/inspect_kadernicky_ukon_mobile.dart';
import 'package:rezervacni_system_maturita/widgets/delete_alert_dialog.dart';
import 'package:rezervacni_system_maturita/widgets/map_card.dart';

class InspectRezervaceMobile extends StatelessWidget {
  final Rezervace rezervace;
  final Function(String) deleteRezervace;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingsFontSize;

  const InspectRezervaceMobile({
    super.key,
    required this.rezervace,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingsFontSize,
    required this.deleteRezervace,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Consts.background,
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
                          fontSize: mobileHeadingsFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: IconButton(
                          onPressed: () async {
                            bool? dialogResult = await showDialog(
                              context: context,
                              builder: (context) => DeleteAlertDialog(
                                alertText:
                                    "Do you really want to delete this reservation?",
                                normalTextFontSize: mobileFontSize,
                                h2FontSize: mobileSmallerHeadingsFontSize,
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
                            size: 20.h,
                          ),
                        ),
                      ),
                      Positioned(
                        //? Leading
                        left: 10,
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: Icon(Icons.arrow_back, size: 20.h),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                _basicInfo(
                  mobileSmallerHeadingsFontSize,
                  mobileFontSize,
                  mobileSmallerFontSize,
                  rezervace,
                  context,
                ),
                _hairdresser(
                  mobileSmallerHeadingsFontSize,
                  mobileFontSize,
                  mobileSmallerFontSize,
                  rezervace,
                  context,
                ),
                _location(
                  mobileSmallerHeadingsFontSize,
                  mobileFontSize,
                  mobileSmallerFontSize,
                  rezervace,
                  context,
                ),
                SizedBox(height: 20.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: mobileFontSize),
                    children: [
                      TextSpan(
                        text: "Note: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: rezervace.poznamkaUzivatele),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _location(
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
    Rezervace rezervace,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Location:",
          style: TextStyle(
            fontSize: smallHeadingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        MapCard(lokace: rezervace.kadernik.lokace, width: 800.w, height: 300.h),
        SizedBox(height: 10.h),
        Text(
          rezervace.kadernik.lokace.nazev,
          style: TextStyle(
            fontSize: normalTextFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
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
    );
  }

  Widget _hairdresser(
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
    Rezervace rezervace,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Hairdresser:",
          style: TextStyle(
            fontSize: smallHeadingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          rezervace.kadernik.getFullNameString(),
          style: TextStyle(fontSize: normalTextFontSize),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
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
      ],
    );
  }

  Widget _basicInfo(
    double smallHeadingFontSize,
    double normalTextFontSize,
    double smallerTextFontSize,
    Rezervace rezervace,
    BuildContext context,
  ) {
    ScrollController scrollerController = ScrollController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Basic info:",
          style: TextStyle(
            fontSize: smallHeadingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
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
        SizedBox(height: 10.h),
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

        SizedBox(height: 10.h),
        Text(
          "Services:",
          style: TextStyle(
            fontSize: smallHeadingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
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
                      builder: (context) => InspectKadernickyUkonMobile(
                        mobileFontSize: mobileFontSize,
                        mobileSmallerFontSize: mobileSmallerFontSize,
                        mobileHeadingsFontSize: mobileHeadingsFontSize,
                        mobileSmallerHeadingsFontSize:
                            mobileSmallerHeadingsFontSize,
                        kadernickyUkon: ukon,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
