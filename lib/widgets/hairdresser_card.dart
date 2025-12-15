import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';

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
      onTap: () {
        //TODO
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
              flex: 2,
              child: Container(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
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
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SizedBox(
                        height: 80.h,
                        child: ClipOval(
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Image.network(kadernik.odkazFotografie),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Avg. Rating: $hodnoceniKadernika*",
                      style: TextStyle(fontSize: captionFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        /*
        child: ListTile(
          title: Text(
            "${kadernik.jmeno} \"${kadernik.prezdivka}\" ${kadernik.prijmeni}",
          ),
          subtitle: Text(
            "${kadernik.popisek}\n\n\n\n\n${kadernik.lokace.nazev} - ${kadernik.lokace.mesto}",
          ),
          trailing: SizedBox(
            height: 500.h,
            width: 100.w,
            child: ClipRRect(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.network(kadernik.odkazFotografie),
              ),
            ),
          ),
          onTap: () {
            //TODO
          },
        ),
        */
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
