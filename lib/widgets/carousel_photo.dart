import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselPhoto extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  const CarouselPhoto({
    super.key,
    required this.url,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10.r),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.contain, //.contain
          httpHeaders: {
            "Access-Control-Allow-Origin": "*",
            "User-Agent": "Mozilla/5.0...",
          },
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error, size: 30.h),
        ),
      ),
    );
  }
}
