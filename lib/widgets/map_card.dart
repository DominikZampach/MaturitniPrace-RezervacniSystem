import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/widgets/minimap_from_adress.dart';

class MapCard extends StatelessWidget {
  final Lokace lokace;
  final double width;
  final double height;
  final double initialZoom;
  const MapCard({
    super.key,
    required this.lokace,
    required this.width,
    required this.height,
    this.initialZoom = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      elevation: 2,
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(10.r),
          child: MinimapFromAdress(
            latitude: lokace.latitude,
            longitude: lokace.longitude,
            initialZoom: initialZoom,
          ),
        ),
      ),
    );
  }
}
