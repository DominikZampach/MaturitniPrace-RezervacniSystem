import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/views/admin/bodies_admin/actions_body_admin.dart';
import 'package:rezervacni_system_maturita/views/admin/bodies_admin/hairdressers_body_admin.dart';
import 'package:rezervacni_system_maturita/views/admin/bodies_admin/locations_body_admin.dart';
import 'package:rezervacni_system_maturita/views/admin/bodies_admin/reservations_body_admin.dart';
import 'package:rezervacni_system_maturita/views/admin/bodies_admin/users_body_admin.dart';

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
      return HairdressersBodyAdmin(
        screenWidth: widget.screenWidth,
        screenHeight: widget.screenHeight,
      );
    } else if (widget.selectedIndex == 1) {
      return LocationsBodyAdmin(
        screenWidth: widget.screenWidth,
        screenHeight: widget.screenHeight,
      );
    } else if (widget.selectedIndex == 2) {
      return ActionsBodyAdmin(
        screenWidth: widget.screenWidth,
        screenHeight: widget.screenHeight,
      );
    } else if (widget.selectedIndex == 3) {
      return ReservationsBodyAdmin(
        screenWidth: widget.screenWidth,
        screenHeight: widget.screenHeight,
      );
    } else if (widget.selectedIndex == 4) {
      return UsersBodyAdmin(
        screenWidth: widget.screenWidth,
        screenHeight: widget.screenHeight,
      );
    } else {
      return Text("Error");
    }
  }
}
