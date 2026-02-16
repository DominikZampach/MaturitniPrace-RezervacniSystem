//TODO: Udělat Widget na základě AlertDialogu, který bude brát informace jako text, který se ukáže (např. Are you sure you want to delete this reservation?) a bude vracet true pokud to projde a false pokud uživatel dá Cancel nebo odejde z dialogu (tím se nastaví hodnota null, kterou musím ošetřit!)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

class DeleteAlertDialog extends StatefulWidget {
  final String alertText;
  final double? normalTextFontSize;
  final double? h2FontSize;
  const DeleteAlertDialog({
    super.key,
    required this.alertText,
    this.normalTextFontSize,
    this.h2FontSize,
  });

  @override
  State<DeleteAlertDialog> createState() => _DeleteAlertDialogState();
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  @override
  Widget build(BuildContext context) {
    double normalTextFontSize = widget.normalTextFontSize == null
        ? Consts.normalFS.sp
        : widget.normalTextFontSize!;
    final double h2FontSize = widget.h2FontSize == null
        ? Consts.h2FS.sp
        : widget.h2FontSize!;

    return AlertDialog(
      title: Text(
        "Potvrzení smazání",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: h2FontSize),
        textAlign: TextAlign.center,
      ),
      titlePadding: EdgeInsetsGeometry.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      content: Text(
        widget.alertText,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: normalTextFontSize,
        ),
        textAlign: TextAlign.center,
      ),
      alignment: AlignmentGeometry.center,
      elevation: 3,
      scrollable: true,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () {
            //? Vracím hodnotu true a zavírám okno
            Navigator.of(context).pop(true);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Consts.error.withValues(alpha: 0.7),
            ),
          ),
          child: Text(
            "Smazat",
            style: TextStyle(
              fontSize: normalTextFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            //? Vracím hodnotu false
            Navigator.of(context).pop(false);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Consts.secondary),
          ),
          child: Text(
            "Zrušit",
            style: TextStyle(
              fontSize: normalTextFontSize,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
