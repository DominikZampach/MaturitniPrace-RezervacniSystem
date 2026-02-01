import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/views/admin/users/inspect_user_admin.dart';

class UserCardAdmin extends StatefulWidget {
  final Uzivatel uzivatel;
  final bool centerText;
  const UserCardAdmin({
    super.key,
    required this.uzivatel,
    this.centerText = false,
  });

  @override
  State<UserCardAdmin> createState() => _UserCardAdminState();
}

class _UserCardAdminState extends State<UserCardAdmin> {
  @override
  Widget build(BuildContext context) {
    double captionFontSize = Consts.smallerFS.sp;
    double mainNameFontSize = Consts.normalFS.sp;

    return GestureDetector(
      onTap: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) =>
              InspectUserAdmin(uzivatel: widget.uzivatel),
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
              crossAxisAlignment: widget.centerText
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.uzivatel.prijmeni} ${widget.uzivatel.jmeno}",
                  style: TextStyle(
                    fontSize: mainNameFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  widget.uzivatel.telefon,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: captionFontSize,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  widget.uzivatel.email,
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
