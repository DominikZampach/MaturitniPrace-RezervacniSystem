import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_rezervace.dart';

class ReservationCard extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final Rezervace rezervace;
  final double fontSize;
  final Function(String) deleteRezervace;
  const ReservationCard({
    super.key,
    required this.rezervace,
    required this.screenWidth,
    required this.screenHeight,
    required this.fontSize,
    required this.deleteRezervace,
  });

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => InspectRezervace(
            rezervace: widget.rezervace,
            deleteRezervace: widget.deleteRezervace,
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
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
            height: widget.screenHeight * 0.10,
            width: widget.screenWidth * 0.6,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getActionsString(),
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "${widget.rezervace.getDayMonthYearString()} - ${widget.rezervace.getHourMinuteString()}",
                        style: TextStyle(fontSize: widget.fontSize),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.rezervace.kadernik.getFullNameString()} - ${widget.rezervace.kadernik.lokace.nazev}",
                        style: TextStyle(fontSize: widget.fontSize),
                      ),
                      Text(
                        "${widget.rezervace.celkovaCena} Kč",
                        style: TextStyle(
                          fontSize: widget.fontSize,
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
