import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/views/bodies/browse_body.dart';
import 'package:rezervacni_system_maturita/views/bodies/dashboard_body.dart';
import 'package:rezervacni_system_maturita/views/bodies/reservations_body.dart';
import 'package:rezervacni_system_maturita/views/bodies/settings_body.dart';

class MainBody extends StatefulWidget {
  final int selectedIndex;
  const MainBody({super.key, required this.selectedIndex});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex == 0) {
      return DashboardBody();
    } else if (widget.selectedIndex == 1) {
      return ReservationsBody();
    } else if (widget.selectedIndex == 2) {
      return BrowseBody();
    } else if (widget.selectedIndex == 3) {
      return SettingsBody();
    } else {
      return Text("Error");
    }
  }
}
