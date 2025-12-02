import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

class CreateReservationDialog extends StatelessWidget {
  const CreateReservationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    //? Idk jestli to chci Dialog nebo Dialog.fullscreen (ještě se musím rozhodnout)
    return Dialog(
      backgroundColor: Consts.background,

      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),

      child: Column(
        children: [
          Text("Test"),
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
        ],
      ),
    );
  }
}
