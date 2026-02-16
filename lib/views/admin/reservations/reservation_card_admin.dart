import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/views/admin/reservations/inspect_reservation_admin.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/inspect/inspect_rezervace.dart';
import 'package:rezervacni_system_maturita/widgets/delete_alert_dialog.dart';

class ReservationCardAdmin extends StatefulWidget {
  final Rezervace rezervace;
  final Function(String) deleteRezervace;
  const ReservationCardAdmin({
    super.key,
    required this.rezervace,
    required this.deleteRezervace,
  });

  @override
  State<ReservationCardAdmin> createState() => _ReservationCardAdminState();
}

class _ReservationCardAdminState extends State<ReservationCardAdmin> {
  @override
  Widget build(BuildContext context) {
    double captionFontSize = Consts.smallerFS.sp;
    double mainNameFontSize = Consts.normalFS.sp;

    return InkWell(
      onTap: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) => InspectReservationAdmin(
            rezervace: widget.rezervace,
            deleteRezervace: widget.deleteRezervace,
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Consts.background,
          ),

          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.rezervace.getDayMonthYearString()} - ${widget.rezervace.getHourMinuteString()}",
                      style: TextStyle(
                        fontSize: mainNameFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Kadeřník: ${widget.rezervace.kadernik.jmeno} ${widget.rezervace.kadernik.prijmeni}",
                      style: TextStyle(fontSize: captionFontSize),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Úkony: ${widget.rezervace.getKadernickeUkonyString()}",
                      style: TextStyle(fontSize: captionFontSize),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    bool? dialogResult = await showDialog(
                      context: context,
                      builder: (context) => DeleteAlertDialog(
                        alertText: "Opravdu chcete smazat tuto rezervaci?",
                      ),
                    );
                    if (dialogResult == true) {
                      widget.deleteRezervace(widget.rezervace.id);
                      return;
                    }
                  },
                  icon: Icon(Icons.delete, size: 20.w, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
