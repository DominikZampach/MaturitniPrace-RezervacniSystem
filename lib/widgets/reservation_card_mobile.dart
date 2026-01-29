import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_rezervace.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/inspect_mobile/inspect_rezervace_mobile.dart';

class ReservationCardMobile extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final Rezervace rezervace;
  final Function(String) deleteRezervace;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingsFontSize;

  const ReservationCardMobile({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.rezervace,
    required this.mobileSmallerFontSize,
    required this.mobileFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingsFontSize,
    required this.deleteRezervace,
  });

  @override
  State<ReservationCardMobile> createState() => _ReservationCardMobileState();
}

class _ReservationCardMobileState extends State<ReservationCardMobile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => InspectRezervaceMobile(
            rezervace: widget.rezervace,
            mobileFontSize: widget.mobileFontSize,
            mobileSmallerFontSize: widget.mobileSmallerFontSize,
            mobileHeadingsFontSize: widget.mobileHeadingsFontSize,
            mobileSmallerHeadingsFontSize: widget.mobileSmallerHeadingsFontSize,
            deleteRezervace: widget.deleteRezervace,
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(
          left: 25.w,
          right: 25.w,
          top: 10.h,
          bottom: 10.h,
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10.r),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: SizedBox(
            height: widget.screenHeight * 0.1,
            width: widget.screenWidth * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: widget.screenWidth * 0.5,
                        child: Text(
                          _getActionsString(),
                          style: TextStyle(
                            fontSize: widget.mobileSmallerFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: false,
                        ),
                      ),
                      SizedBox(
                        width: widget.screenWidth * 0.4,
                        child: Text(
                          "${widget.rezervace.getDayMonthYearString()} - ${widget.rezervace.getHourMinuteString()}",
                          style: TextStyle(
                            fontSize: widget.mobileSmallerFontSize,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.rezervace.kadernik.getFullNameString()} - ${widget.rezervace.kadernik.lokace.nazev}",
                        style: TextStyle(
                          fontSize: widget.mobileSmallerFontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      Text(
                        "${widget.rezervace.celkovaCena} Kč",
                        style: TextStyle(
                          fontSize: widget.mobileSmallerFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getActionsString() {
    String actions = "";
    for (KadernickyUkon ukon in widget.rezervace.kadernickeUkony) {
      actions += "${ukon.nazev} + ";
    }
    actions = actions.substring(0, actions.length - 3);
    return actions;
  }
}
