import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';

class ReservationCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final Rezervace rezervace;
  const ReservationCard({
    super.key,
    required this.rezervace,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 18.w, right: 18.w, top: 10.h, bottom: 10.h),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      child: SizedBox(
        height: screenHeight * 0.1,
        width: screenWidth * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getActionsString()),
                Text(
                  "${rezervace.getDayMonthYearString()} - ${rezervace.getHourMinuteString()}",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${rezervace.kadernik.getFullNameString()} - ${rezervace.kadernik.lokace.nazev}",
                ),
                Text(
                  "${rezervace.celkovaCena} Kč",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getActionsString() {
    String actions = "";
    for (KadernickyUkon ukon in rezervace.kadernickeUkony) {
      actions = "$actions ${ukon.nazev} + ";
    }
    actions = actions.substring(0, actions.length - 3);
    return actions;
  }
}
