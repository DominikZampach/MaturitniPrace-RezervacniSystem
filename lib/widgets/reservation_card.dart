import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/views/users/create_reservation_dialog.dart';

class ReservationCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final Rezervace rezervace;
  final double fontSize;
  const ReservationCard({
    super.key,
    required this.rezervace,
    required this.screenWidth,
    required this.screenHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, //TODO: Tady bude Navigator.Push té celostránkové rezervace
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
        child: SizedBox(
          height: screenHeight * 0.10,
          width: screenWidth * 0.6,
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
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "${rezervace.getDayMonthYearString()} - ${rezervace.getHourMinuteString()}",
                      style: TextStyle(fontSize: fontSize),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${rezervace.kadernik.getFullNameString()} - ${rezervace.kadernik.lokace.nazev}",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      "${rezervace.celkovaCena} Kč",
                      style: TextStyle(
                        fontSize: fontSize,
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
    );
  }

  String _getActionsString() {
    String actions = "";
    for (KadernickyUkon ukon in rezervace.kadernickeUkony) {
      actions += "${ukon.nazev} + ";
    }
    actions = actions.substring(0, actions.length - 3);
    return actions;
  }
}
