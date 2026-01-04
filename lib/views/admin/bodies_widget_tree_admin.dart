import 'package:flutter/material.dart';

class WidgetTreeBodiesAdmin extends StatefulWidget {
  final int selectedIndex;
  final double screenWidth;
  final double screenHeight;

  const WidgetTreeBodiesAdmin({
    super.key,
    required this.selectedIndex,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<WidgetTreeBodiesAdmin> createState() => _WidgetTreeBodiesAdminState();
}

class _WidgetTreeBodiesAdminState extends State<WidgetTreeBodiesAdmin> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex == 0) {
      return Text("Hairdressers");
    } else if (widget.selectedIndex == 1) {
      return Text("Locations");
    } else if (widget.selectedIndex == 2) {
      return Text("Actions");
    } else if (widget.selectedIndex == 3) {
      return Text("Reservations");
    } else {
      return Text("Error");
    }
  }
}
