import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';

class ActionCard extends StatefulWidget {
  final KadernickyUkon ukon;
  final double fontSize;
  final int price;
  final bool isSelected;
  final Function(String, bool, int) onChanged;

  const ActionCard({
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
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
      text: widget.isSelected && widget.price > 0
          ? widget.price.toString()
          : "",
    );
  }

  @override
  void didUpdateWidget(covariant ActionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (!widget.isSelected) {
        textController.text = "";
      } else if (widget.price > 0) {
        textController.text = widget.price.toString();
      }
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
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
                  bool newStatus = value ?? false;

                  if (!newStatus) {
                    textController.clear();
                  }

                  widget.onChanged(widget.ukon.id, newStatus, widget.price);
                },
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  bool newStatus = !widget.isSelected;
                  if (!newStatus) {
                    textController.clear();
                  }
                  widget.onChanged(widget.ukon.id, newStatus, widget.price);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    widget.ukon.nazev,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Row(
                children: [
                  SizedBox(
                    width: 50.w,
                    child: TextField(
                      controller: textController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      enabled: widget.isSelected,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 2.w,
                        ),
                        isDense: true,
                        hintText: "0",
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      style: TextStyle(fontSize: widget.fontSize),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          widget.onChanged(widget.ukon.id, true, 0);
                          return;
                        }

                        int? parsedPrice = int.tryParse(value);
                        if (parsedPrice != null) {
                          widget.onChanged(widget.ukon.id, true, parsedPrice);
                        }
                      },
                    ),
                  ),
                  Text("Kč", style: TextStyle(fontSize: widget.fontSize)),
                  SizedBox(width: 5.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
