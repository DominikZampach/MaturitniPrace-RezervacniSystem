import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';

List<dynamic> getAvgRating(
  List<Hodnoceni> vsechnaHodnoceni,
  Kadernik kadernik,
) {
  int pocetHodnoceniKadernika = 0;
  double hodnoceniSoucet = 0;
  double hodnoceniKadernika;

  List<Hodnoceni> kadernikovaHodnoceniMezipromenna = [];
  for (Hodnoceni hodnoceni in vsechnaHodnoceni) {
    if (hodnoceni.idKadernika == kadernik.id) {
      kadernikovaHodnoceniMezipromenna.add(hodnoceni);
      hodnoceniSoucet += hodnoceni.ciselneHodnoceni;
    }
  }

  //? Výpočet průměrného hodnocení
  pocetHodnoceniKadernika = kadernikovaHodnoceniMezipromenna.length;
  double hodnoceniPrumer = hodnoceniSoucet / pocetHodnoceniKadernika;
  hodnoceniKadernika = zaokrouhliHodnoceni(hodnoceniPrumer);

  return [
    hodnoceniKadernika,
    hodnoceniSoucet,
    pocetHodnoceniKadernika,
    kadernikovaHodnoceniMezipromenna,
  ];
}

//? Metoda, která zaokrouhlí hodnocení na půlbody (Takže např.: 3,1 zaokrouhlí na 3, ale od 3,25 to zaokrouhlí na 3,5)
double zaokrouhliHodnoceni(double hodnoceni) {
  double dvojnasobek = hodnoceni * 2;

  double zaokrouhlenyDvojnasobek = dvojnasobek.roundToDouble();
  double zaokrouhleneHodnoceni = zaokrouhlenyDvojnasobek / 2;

  return zaokrouhleneHodnoceni;
}
