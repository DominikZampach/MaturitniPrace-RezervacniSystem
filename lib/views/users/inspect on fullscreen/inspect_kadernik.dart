import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';

class InspectKadernik extends StatefulWidget {
  final Kadernik kadernik;
  final double hodnoceniKadernika;
  final int pocetHodnoceniKadernika;

  const InspectKadernik({
    super.key,
    required this.kadernik,
    required this.hodnoceniKadernika,
    required this.pocetHodnoceniKadernika,
  });

  @override
  State<InspectKadernik> createState() => _InspectKadernikState();
}

class _InspectKadernikState extends State<InspectKadernik> {
  final double headingFontSize = 15.sp;
  final double smallHeadingFontSize = 13.sp;
  final double normalTextFontSize = 11.sp;

  late Future<List<KadernickyUkon>> kadernickeUkonySCenamiFuture;

  @override
  void initState() {
    super.initState();
    kadernickeUkonySCenamiFuture = widget.kadernik
        .getAllKadernickyUkonAndPrice();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: kadernickeUkonySCenamiFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error při načítání dat: ${snapshot.error}");
          return const Center(
            child: Text(
              "Error occured while trying to load data from database!",
            ),
          );
        }

        return Dialog(
          backgroundColor: Consts.background,
          alignment: Alignment.center,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10.r),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),

          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _nameDescriptionFavouriteStarStack(),

                  SizedBox(height: 30.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          //color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _services(snapshot.data!),
                                  _rating(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          //color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
                              _kaderniksPhoto(),
                              SizedBox(height: 20.h),
                              Text(
                                "Location:",
                                style: TextStyle(
                                  fontSize: headingFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                widget.kadernik.lokace.nazev,
                                style: TextStyle(
                                  fontSize: normalTextFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Address:",
                                style: TextStyle(
                                  fontSize: normalTextFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${widget.kadernik.lokace.adresa}\n${widget.kadernik.lokace.psc}-${widget.kadernik.lokace.mesto}",
                                style: TextStyle(fontSize: normalTextFontSize),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: () {
                                  //TODO!
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Consts.secondary,
                                  ),
                                ),
                                child: Text(
                                  "Book now",
                                  style: TextStyle(
                                    fontSize: smallHeadingFontSize,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _kaderniksPhoto() {
    return SizedBox(
      width: 160.w,
      height: 300.h,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10.r),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.network(widget.kadernik.odkazFotografie),
        ),
      ),
    );
  }

  Expanded _services(List<KadernickyUkon> kadernickeUkonySCenami) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Services:",
              style: TextStyle(
                fontSize: smallHeadingFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                itemCount: kadernickeUkonySCenami.length,
                itemBuilder: (context, index) {
                  final ukon = kadernickeUkonySCenami[index];

                  return ListTile(
                    title: Text(
                      ukon.nazev,
                      style: TextStyle(fontSize: normalTextFontSize),
                    ),
                    trailing: Text(
                      "${ukon.cena} Kč",
                      style: TextStyle(fontSize: normalTextFontSize),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _rating() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rating:",
              style: TextStyle(
                fontSize: smallHeadingFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Average rating: ${widget.hodnoceniKadernika}",
              style: TextStyle(fontSize: normalTextFontSize),
            ),
            Text(
              "Number of reviews: ${widget.pocetHodnoceniKadernika}",
              style: TextStyle(fontSize: normalTextFontSize),
            ),
          ],
        ),
      ),
    );
  }

  Text _description() {
    return Text(
      widget.kadernik.popisek,
      style: TextStyle(
        fontSize: normalTextFontSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  SizedBox _nameDescriptionFavouriteStarStack() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                widget.kadernik.getFullNameString(),
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              _description(),
            ],
          ),

          //TODO: Změnit na fungující Favourite button, který bude závislý na tom, pokud uživatel má tohoto kadeřníka ve Favourites!
          //? Widget Positioned umístí child podle určených parametrů (tady right = 0) na pozici ve Stacku
          _favouriteStar(),
        ],
      ),
    );
  }

  Positioned _favouriteStar() {
    return Positioned(
      right: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // TODO: Implementovat logiku pro přidání do oblíbených
            print("Kliknuto na oblíbené");
          },
          child: Icon(
            Icons
                .star_border, // Zde pak můžete měnit Icons.star vs Icons.star_border
            color: Colors.amber,
            size: 30.w,
          ),
        ),
      ),
    );
  }
}
