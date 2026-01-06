import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';

class SelectActionsDialog extends StatefulWidget {
  final List<KadernickyUkon> listAllKadernickeUkony;
  final Map<String, dynamic>?
  ukonyCenyKadernika; //? Pokud toto bude null, tak to znamena ze se jedna o noveho kadernika
  const SelectActionsDialog({
    super.key,
    required this.listAllKadernickeUkony,
    this.ukonyCenyKadernika,
  });

  @override
  State<SelectActionsDialog> createState() => _SelectActionsDialogState();
}

class _SelectActionsDialogState extends State<SelectActionsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Consts.background,
      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.67,
        minWidth: MediaQuery.of(context).size.width * 0.4,
        maxWidth: MediaQuery.of(context).size.width * 0.4,
        maxHeight: MediaQuery.of(context).size.height * 0.67,
      ),

      child: SingleChildScrollView(),
    );
  }
}
