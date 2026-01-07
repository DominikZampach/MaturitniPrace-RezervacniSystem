import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/edit_hairdresser.dart';

class HairdresserCardAdmin extends StatefulWidget {
  Kadernik kadernik;
  final List<Lokace> listAllLokace;
  final List<KadernickyUkon> listAllKadernickeUkony;
  final Function(Kadernik) onChangedKadernik;
  HairdresserCardAdmin({
    super.key,
    required this.kadernik,
    required this.listAllLokace,
    required this.listAllKadernickeUkony,
    required this.onChangedKadernik,
  });

  @override
  State<HairdresserCardAdmin> createState() => _HairdresserCardAdminState();
}

class _HairdresserCardAdminState extends State<HairdresserCardAdmin> {
  dynamic onChangedAdminVersion(Kadernik kadernikChanged) {
    setState(() {
      widget.kadernik = kadernikChanged;
    });
    widget.onChangedKadernik(
      kadernikChanged,
    ); //? Vyvolám změnu i v samotném listu na Homepage - Hairdressers
  }

  @override
  Widget build(BuildContext context) {
    double captionFontSize = 9.sp;
    double mainNameFontSize = 12.sp;

    return GestureDetector(
      onTap: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) => EditHairdresserDialog(
            kadernik: widget.kadernik,
            listAllLokace: widget.listAllLokace,
            listAllKadernickeUkony: widget.listAllKadernickeUkony,
            onChanged: onChangedAdminVersion,
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
                            fontSize: mainNameFontSize,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10.r),
                        child: FittedBox(
                          fit: BoxFit.cover,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
