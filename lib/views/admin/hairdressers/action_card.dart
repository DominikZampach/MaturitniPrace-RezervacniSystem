import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';

class ActionCard extends StatefulWidget {
  final KadernickyUkon ukon;
  final double fontSize;
  int price;
  bool isSelected;
  final Function(String, bool, int) onChanged;

  ActionCard({
    super.key,
    required this.ukon,
    required this.price,
    required this.isSelected,
    required this.fontSize,
    required this.onChanged,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isSelected) {
      textController.text = widget.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Consts.secondary,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Positioned(
              left: 0,
              child: Checkbox(
                value: widget.isSelected,
                onChanged: (value) {
                  widget.isSelected = !widget.isSelected;
                  if (value == false) {
                    textController.text = "";
                  }
                  widget.onChanged(
                    widget.ukon.id,
                    widget.isSelected,
                    widget.price,
                  );
                },
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  //TODO: Možná přidat možnost rovnou upravovat tento úkon
                },
                child: Text(
                  widget.ukon.nazev,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Row(
                children: [
                  SizedBox(
                    width: 45.w,
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      readOnly: !widget.isSelected,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      style: TextStyle(fontSize: widget.fontSize),
                      onChanged: (value) {
                        widget.price = int.parse(value);
                        widget.onChanged(
                          widget.ukon.id,
                          widget.isSelected,
                          widget.price,
                        );
                      },
                    ),
                  ),
                  Text("Kč", style: TextStyle(fontSize: widget.fontSize)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
