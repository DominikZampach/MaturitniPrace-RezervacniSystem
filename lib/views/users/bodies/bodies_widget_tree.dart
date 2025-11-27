import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/browse_body.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/dashboard_body.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/reservations_body.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/settings_body.dart';

class MainBody extends StatefulWidget {
  final int selectedIndex;
  final double screenWidth;
  final double screenHeight;
  const MainBody({
    super.key,
    required this.selectedIndex,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex == 0) {
      return DashboardBody(
        screenHeight: widget.screenHeight,
        screenWidth: widget.screenWidth,
      );
    } else if (widget.selectedIndex == 1) {
      return ReservationsBody(
        screenHeight: widget.screenHeight,
        screenWidth: widget.screenWidth,
      );
    } else if (widget.selectedIndex == 2) {
      return BrowseBody();
    } else if (widget.selectedIndex == 3) {
      return SettingsBody();
    } else {
      return Text("Error");
    }
  }
}
