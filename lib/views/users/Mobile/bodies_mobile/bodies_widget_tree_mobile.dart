import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/bodies_mobile/dashboard_body_mobile.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class BodiesWidgetTreeMobile extends StatefulWidget {
  final int selectedIndex;
  final double screenWidth;
  final double screenHeight;
  const BodiesWidgetTreeMobile({
    super.key,
    required this.selectedIndex,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<BodiesWidgetTreeMobile> createState() => _BodiesWidgetTreeMobileState();
}

class _BodiesWidgetTreeMobileState extends State<BodiesWidgetTreeMobile> {
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

        Uzivatel soucasnyUzivatel = snapshot.data!;

        if (widget.selectedIndex == 0) {
          return DashboardBodyMobile(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            uzivatel: soucasnyUzivatel,
          );
        } else if (widget.selectedIndex == 1) {
          return Text("Reservations");
        } else if (widget.selectedIndex == 2) {
          return Text("Browse");
        } else if (widget.selectedIndex == 3) {
          return Text("Settings");
          /*
          return SettingsBody(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            uzivatel: soucasnyUzivatel,
            onChanged: (updatedUzivatel) {
              setState(() {
                soucasnyUzivatel = updatedUzivatel;
              });
            },
          );
          */
        } else {
          return Text("Error");
        }
      },
    );
  }
}
