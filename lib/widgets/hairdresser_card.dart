import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/views/users/inspect%20on%20fullscreen/inspect_kadernik.dart';

class HairdresserCard extends StatelessWidget {
  final Kadernik kadernik;
  final List<Hodnoceni> vsechnaHodnoceni;
  late final List<Hodnoceni> kadernikovaHodnoceni;
  late final double hodnoceniKadernika;

  HairdresserCard({
    super.key,
    required this.kadernik,
    required this.vsechnaHodnoceni,
  }) {
    double hodnoceniMezipocet = 0;
    List<Hodnoceni> kadernikovaHodnoceniMezipromenna = [];
    for (Hodnoceni hodnoceni in vsechnaHodnoceni) {
      if (hodnoceni.idKadernika == kadernik.id) {
        kadernikovaHodnoceniMezipromenna.add(hodnoceni);
        hodnoceniMezipocet += hodnoceni.ciselneHodnoceni;
      }
    }

    //? Výpočet průměrného hodnocení
    hodnoceniMezipocet =
        hodnoceniMezipocet / kadernikovaHodnoceniMezipromenna.length;
    hodnoceniKadernika = zaokrouhliHodnoceni(hodnoceniMezipocet);

    //? Uložení hodnot do globální proměnné
    kadernikovaHodnoceni = kadernikovaHodnoceniMezipromenna;
  }

  double captionFontSize = 9.sp;
  double mainNameFontSize = 12.sp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final dialogResult = await showDialog(
          context: context,
          builder: (BuildContext context) => InspectKadernik(
            kadernik: kadernik,
            hodnoceniKadernika: hodnoceniKadernika,
            pocetHodnoceniKadernika: kadernikovaHodnoceni.length,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Consts.background,
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kadernik.getFullNameString(),
                          style: TextStyle(
                            fontSize: mainNameFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          kadernik.popisek,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: captionFontSize,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_pin, size: captionFontSize),
                        Text(
                          "${kadernik.lokace.nazev}, ${kadernik.lokace.mesto}",
                          style: TextStyle(fontSize: captionFontSize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10.r),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.network(kadernik.odkazFotografie),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      "Avg. Rating: $hodnoceniKadernika*",
                      style: TextStyle(fontSize: captionFontSize),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //? Metoda, která zaokrouhlí hodnocení na půlbody (Takže např.: 3,1 zaokrouhlí na 3, ale od 3,25 to zaokrouhlí na 3,5)
  double zaokrouhliHodnoceni(double hodnoceni) {
    double dvojnasobek = hodnoceni * 2;

    double zaokrouhlenyDvojnasobek = dvojnasobek.roundToDouble();
    double zaokrouhleneHodnoceni = zaokrouhlenyDvojnasobek / 2;

    return zaokrouhleneHodnoceni;
  }
}
