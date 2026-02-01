import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/views/admin/actions/edit_action.dart';

class ActionCardAdmin extends StatefulWidget {
  KadernickyUkon ukon;
  final Function(KadernickyUkon) saveUkon;
  final Function(String) deleteUkon;
  ActionCardAdmin({
    super.key,
    required this.ukon,
    required this.saveUkon,
    required this.deleteUkon,
  });

  @override
  State<ActionCardAdmin> createState() => _ActionCardAdminState();
}

class _ActionCardAdminState extends State<ActionCardAdmin> {
  @override
  Widget build(BuildContext context) {
    double captionFontSize = 9.sp;
    double mainNameFontSize = 12.sp;

    return GestureDetector(
      onTap: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) => EditActionDialog(
            kadernickyUkon: widget.ukon,
            saveUkon: widget.saveUkon,
            deleteUkon: widget.deleteUkon,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ukon.nazev,
                  style: TextStyle(
                    fontSize: mainNameFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  widget.ukon.popis,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: captionFontSize,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Type: ${widget.ukon.getTypStrihu()}",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: captionFontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
