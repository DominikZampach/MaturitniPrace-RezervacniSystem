import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/browse_body.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/dashboard_body.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/reservations_body.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/settings_body.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

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
  Future<Uzivatel> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final Uzivatel soucasnyUzivatel = await dbService.getUzivatel();

    return soucasnyUzivatel;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _nacteniDat(),
      builder: (context, snapshot) {
        print("Snapshot data: ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.hasError) {
          print("Error při načítání dat: ${snapshot.error}");
          return const Center(
            child: Text(
              "Error occured while trying to load data from database!",
            ),
          );
        }

        final Uzivatel soucasnyUzivatel = snapshot.data!;

        if (widget.selectedIndex == 0) {
          return DashboardBody(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            uzivatel: soucasnyUzivatel,
          );
        } else if (widget.selectedIndex == 1) {
          return ReservationsBody(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
          );
        } else if (widget.selectedIndex == 2) {
          return BrowseBody(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            uzivatel: soucasnyUzivatel,
          );
        } else if (widget.selectedIndex == 3) {
          return SettingsBody();
        } else {
          return Text("Error");
        }
      },
    );
  }
}
