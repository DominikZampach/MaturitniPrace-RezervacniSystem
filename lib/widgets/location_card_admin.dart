import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';

class LocationCardAdmin extends StatefulWidget {
  Lokace lokace;
  final Function(Lokace) saveLokace;
  final Function(String) deleteLokace;
  LocationCardAdmin({
    super.key,
    required this.lokace,
    required this.saveLokace,
    required this.deleteLokace,
  });

  @override
  State<LocationCardAdmin> createState() => _LocationCardAdminState();
}

class _LocationCardAdminState extends State<LocationCardAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
