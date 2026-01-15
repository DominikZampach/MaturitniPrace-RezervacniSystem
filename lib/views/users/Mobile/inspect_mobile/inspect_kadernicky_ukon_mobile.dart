import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';

class InspectKadernickyUkonMobile extends StatelessWidget {
  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingsFontSize;
  final KadernickyUkon kadernickyUkon;

  const InspectKadernickyUkonMobile({
    super.key,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingsFontSize,
    required this.kadernickyUkon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Consts.background,
      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
        minWidth: MediaQuery.of(context).size.width * 0.9,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),

      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  kadernickyUkon.nazev,
                  style: TextStyle(
                    fontSize: mobileHeadingsFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  kadernickyUkon.popis,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: mobileFontSize,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Cut type: ${kadernickyUkon.getTypStrihu()}",
                  style: TextStyle(fontSize: mobileFontSize),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Duration: ${kadernickyUkon.delkaMinuty} min",
                  style: TextStyle(fontSize: mobileFontSize),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Photos:",
                  style: TextStyle(
                    fontSize: mobileSmallerHeadingsFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                CarouselSlider.builder(
                  itemCount: kadernickyUkon.odkazyFotografiiPrikladu.length,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.5,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    aspectRatio: 9 / 16,
                    disableCenter: true,
                    autoPlay:
                        kadernickyUkon.odkazyFotografiiPrikladu.length != 1
                        ? true
                        : false,
                    enableInfiniteScroll:
                        kadernickyUkon.odkazyFotografiiPrikladu.length != 1
                        ? true
                        : false,
                    autoPlayInterval: Duration(seconds: 5),
                  ),
                  itemBuilder: (context, itemIndex, page) => CarouselPhoto(
                    url: kadernickyUkon.odkazyFotografiiPrikladu[itemIndex],
                    height: MediaQuery.of(context).size.height * 0.49,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
