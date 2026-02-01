import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/bodies_mobile/browse_body_mobile.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/bodies_mobile/dashboard_body_mobile.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/bodies_mobile/reservations_body_mobile.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/bodies_mobile/settings_body_mobile.dart';
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

        if (!snapshot.hasData || snapshot.data == null) {
          return const LoadingWidget();
        }

        Uzivatel soucasnyUzivatel = snapshot.data!;

        final double mobileFontSize = 40.sp;
        final double mobileSmallerFontSize = 35.sp;
        final double mobileHeadingsFontSize = 55.sp;
        final double mobileSmallerHeadingFontSize = 50.sp;

        if (widget.selectedIndex == 0) {
          return DashboardBodyMobile(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            uzivatel: soucasnyUzivatel,
            mobileFontSize: mobileFontSize,
            mobileSmallerFontSize: mobileSmallerFontSize,
            mobileHeadingsFontSize: mobileHeadingsFontSize,
            mobileSmallerHeadingFontSize: mobileSmallerHeadingFontSize,
          );
        } else if (widget.selectedIndex == 1) {
          return ReservationsBodyMobile(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            mobileFontSize: mobileFontSize,
            mobileSmallerFontSize: mobileSmallerFontSize,
            mobileHeadingsFontSize: mobileHeadingsFontSize,
            mobileSmallerHeadingFontSize: mobileSmallerHeadingFontSize,
          );
        } else if (widget.selectedIndex == 2) {
          return BrowseBodyMobile(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            uzivatel: soucasnyUzivatel,
            mobileFontSize: mobileFontSize,
            mobileSmallerFontSize: mobileSmallerFontSize,
            mobileHeadingsFontSize: mobileHeadingsFontSize,
            mobileSmallerHeadingFontSize: mobileSmallerHeadingFontSize,
          );
        } else if (widget.selectedIndex == 3) {
          return SettingsBodyMobile(
            uzivatel: soucasnyUzivatel,
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            mobileFontSize: mobileFontSize,
            mobileSmallerFontSize: mobileSmallerFontSize,
            mobileHeadingsFontSize: mobileHeadingsFontSize,
            mobileSmallerHeadingFontSize: mobileSmallerHeadingFontSize,
            onChanged: (updatedUzivatel) {
              setState(() {
                soucasnyUzivatel = updatedUzivatel;
              });
            },
          );
        } else {
          return Text("Error");
        }
      },
    );
  }
}
