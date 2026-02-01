import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/widgets/carousel_photo.dart';

class InspectKadernickyUkon extends StatelessWidget {
  final KadernickyUkon kadernickyUkon;
  const InspectKadernickyUkon({super.key, required this.kadernickyUkon});

  @override
  Widget build(BuildContext context) {
    final double headingFontSize = Consts.h2FS.sp;
    final double smallHeadingFontSize = Consts.h3FS.sp;
    final double normalTextFontSize = Consts.normalFS.sp;

    return Dialog(
      backgroundColor: Consts.background,
      alignment: Alignment.center,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
        minWidth: MediaQuery.of(context).size.width * 0.4,
        maxWidth: MediaQuery.of(context).size.width * 0.4,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                    fontSize: headingFontSize,
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
                    fontSize: normalTextFontSize,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Cut type: ${kadernickyUkon.getTypStrihu()}",
                  style: TextStyle(fontSize: normalTextFontSize),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Duration: ${kadernickyUkon.delkaMinuty} min",
                  style: TextStyle(fontSize: normalTextFontSize),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Photos:",
                  style: TextStyle(
                    fontSize: smallHeadingFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                CarouselSlider.builder(
                  itemCount: kadernickyUkon.odkazyFotografiiPrikladu.length,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.3,
                    viewportFraction: 0.66,
                    initialPage: 0,
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
                    height: MediaQuery.of(context).size.height * 0.28,
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
