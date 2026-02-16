import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/getAvgRating.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/inspect_mobile/inspect_kadernik_mobile.dart';

class HairdresserCardMobile extends StatefulWidget {
  Kadernik kadernik;
  final List<Hodnoceni> vsechnaHodnoceni;
  late List<Hodnoceni> kadernikovaHodnoceni;
  final Uzivatel? uzivatel;
  late double hodnoceniKadernika;
  late double hodnoceniSoucet;
  late int pocetHodnoceniKadernika;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingsFontSize;

  HairdresserCardMobile({
    super.key,
    required this.kadernik,
    required this.vsechnaHodnoceni,
    this.uzivatel,
    required this.kadernikovaHodnoceni,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingsFontSize,
  }) {
    final result = getAvgRating(vsechnaHodnoceni, kadernik);

    hodnoceniKadernika = result[0] as double;
    hodnoceniSoucet = result[1] as double;
    pocetHodnoceniKadernika = result[2] as int;
    kadernikovaHodnoceni = result[3] as List<Hodnoceni>;
  }

  @override
  State<HairdresserCardMobile> createState() => _HairdresserCardMobileState();
}

class _HairdresserCardMobileState extends State<HairdresserCardMobile> {
  dynamic onChangedUserVersion(
    double hodnoceniKadernikaChanged,
    double hodnoceniSoucetChanged,
    int pocetHodnoceniChanged,
    String? idToDelete,
    Hodnoceni? hodnoceniToAdd,
  ) {
    setState(() {
      widget.hodnoceniKadernika = hodnoceniKadernikaChanged;
      widget.hodnoceniSoucet = hodnoceniSoucetChanged;
      widget.pocetHodnoceniKadernika = pocetHodnoceniChanged;
      if (idToDelete != null) {
        widget.kadernikovaHodnoceni.removeWhere(
          (item) => item.id == idToDelete,
        );
      }
      if (hodnoceniToAdd != null) {
        widget.kadernikovaHodnoceni.add(hodnoceniToAdd);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double captionFontSize = widget.mobileFontSize - 5.sp;
    double ratingFontSize = widget.mobileFontSize - 7.sp;

    return GestureDetector(
      onTap: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) => InspectKadernikMobile(
            kadernik: widget.kadernik,
            hodnoceniKadernika: widget.hodnoceniKadernika,
            pocetHodnoceniKadernika: widget.kadernikovaHodnoceni.length,
            uzivatel: widget.uzivatel!,
            hodnoceniKadernikaSoucetVsechnHodnoceni: widget.hodnoceniSoucet,
            onChanged: onChangedUserVersion,
            mobileFontSize: widget.mobileFontSize,
            mobileSmallerFontSize: widget.mobileSmallerFontSize,
            mobileHeadingsFontSize: widget.mobileHeadingsFontSize,
            mobileSmallerHeadingsFontSize: widget.mobileSmallerHeadingsFontSize,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Consts.background,
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.kadernik.getFullNameString(),
                          style: TextStyle(
                            fontSize: widget.mobileFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.kadernik.popisek,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: captionFontSize,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_pin, size: captionFontSize),
                        Text(
                          "${widget.kadernik.lokace.nazev}, ${widget.kadernik.lokace.mesto}",
                          style: TextStyle(fontSize: captionFontSize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10.r),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CachedNetworkImage(
                            imageUrl: widget.kadernik.odkazFotografie,
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      "Hodnocení:\n${widget.hodnoceniKadernika}*",
                      style: TextStyle(fontSize: ratingFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
