import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MinimapFromAdress extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double initialZoom;
  const MinimapFromAdress({
    super.key,
    required this.latitude,
    required this.longitude,
    this.initialZoom = 16.0,
  });

  @override
  State<MinimapFromAdress> createState() => _MinimapFromAdressState();
}

class _MinimapFromAdressState extends State<MinimapFromAdress> {
  LatLng? point;

  @override
  void initState() {
    super.initState();
    setState(() {
      point = LatLng(widget.latitude, widget.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: point!,
        initialZoom: widget.initialZoom,
        //TODO - pohrát si s nastavením
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: point!,
              width: 40,
              height: 40,
              child: Icon(Icons.place),
            ),
          ],
        ),
      ],
    );
  }
}
