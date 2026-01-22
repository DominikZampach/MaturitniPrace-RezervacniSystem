import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/views/admin/locations/edit_location.dart';
import 'package:rezervacni_system_maturita/widgets/map_card.dart';

class LocationCardAdmin extends StatefulWidget {
  Lokace lokace;
  final Function(Lokace) saveLokace;
  final Function(String) deleteLokace;
  LocationCardAdmin({
    super.key,
    required this.lokace,
    required this.saveLokace,
    required this.deleteLokace,
  });

  @override
  State<LocationCardAdmin> createState() => _LocationCardAdminState();
}

class _LocationCardAdminState extends State<LocationCardAdmin> {
  @override
  Widget build(BuildContext context) {
    double captionFontSize = 9.sp;
    double mainNameFontSize = 12.sp;

    return GestureDetector(
      onTap: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) => EditLocationDialog(
            lokace: widget.lokace,
            saveLokace: widget.saveLokace,
            deleteLokace: widget.deleteLokace,
          ),
        );
      }, //TODO
      child: Card(
        elevation: 4,
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
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lokace.nazev,
                            style: TextStyle(
                              fontSize: mainNameFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.lokace.adresa,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: captionFontSize,
                            ),
                          ),
                          Text(
                            widget.lokace.mesto,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: captionFontSize,
                            ),
                          ),
                          Text(
                            widget.lokace.psc,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: captionFontSize,
                            ),
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
                            child: MapCard(
                              key: ValueKey(
                                "${widget.lokace.latitude}_${widget.lokace.longitude}",
                              ),
                              lokace: widget.lokace,
                              width: 60.w,
                              height: 60.h,
                              initialZoom: 12,
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
      ),
    );
  }
}
