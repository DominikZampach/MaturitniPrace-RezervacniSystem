import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/action_card.dart';

class SelectActionsDialog extends StatefulWidget {
  final List<KadernickyUkon> listAllKadernickeUkony;
  final Map<String, int> ukonyCenyKadernika;

  late List<KadernickyUkon> listAllMaleKadernickeUkony;
  late List<KadernickyUkon> listAllFemaleKadernickeUkony;

  SelectActionsDialog({
    super.key,
    required this.listAllKadernickeUkony,
    required this.ukonyCenyKadernika,
  }) {
    listAllFemaleKadernickeUkony = [];
    listAllMaleKadernickeUkony = [];

    for (KadernickyUkon ukon in listAllKadernickeUkony) {
      if (ukon.typStrihuPodlePohlavi == "male") {
        listAllMaleKadernickeUkony.add(ukon);
      } else {
        listAllFemaleKadernickeUkony.add(ukon);
      }
    }
  }

  @override
  State<SelectActionsDialog> createState() => _SelectActionsDialogState();
}

class _SelectActionsDialogState extends State<SelectActionsDialog> {
  final double headingFontSize = 15.sp;
  final double smallHeadingFontSize = 13.sp;
  final double normalTextFontSize = 11.sp;
  final double smallerTextFontSize = 10.sp;

  //? Toto bude callback funkce, která se zavolá v ActionCard kdykoliv se změní ať už to, jestli uživatel tento úkon dělá nebo při změně ceny
  dynamic onChanged(String ukonId, bool status, int price) {
    if (status == false) {
      //? Admin nechce tento úkon u tohoto kadeřníka a pokud je zároveň v Map, tak se smaže
      if (widget.ukonyCenyKadernika.containsKey(ukonId)) {
        setState(() {
          widget.ukonyCenyKadernika.remove(ukonId);
        });
      }
    }

    if (status == true) {
      //? Admin chce tento úkon -> testuji jestli už je v Map a měním cenu nebo přidávám do Map i s cenou
      setState(() {
        widget.ukonyCenyKadernika[ukonId] = price;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

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

      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Select actions and set prices:",
                  style: TextStyle(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Male actions:",
                style: TextStyle(
                  fontSize: smallHeadingFontSize,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.h),
              _listViewUkony(widget.listAllMaleKadernickeUkony),
              SizedBox(height: 10.h),
              Text(
                "Female actions:",
                style: TextStyle(
                  fontSize: smallHeadingFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              _listViewUkony(widget.listAllFemaleKadernickeUkony),
            ],
          ),
        ),
      ),
    );
  }

  Center _listViewUkony(List<KadernickyUkon> kadernickeUkony) {
    return Center(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: kadernickeUkony.length,
        itemBuilder: (context, index) {
          var ukon = kadernickeUkony[index];

          return ActionCard(
            ukon: ukon,
            price: widget.ukonyCenyKadernika[ukon.id] ?? 0,
            isSelected: widget.ukonyCenyKadernika.containsKey(ukon.id),
            fontSize: smallerTextFontSize,
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
