import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';

class CreateReservationLogic {
  final List<Kadernik> listAllKadernik;
  final List<KadernickyUkon> listAllKadernickyUkon;
  final List<Rezervace> listAllFutureRezervace;

  //? Toto získám z projití všech kadeřníků - každý kadeřník má objekt Lokace!
  List<Lokace> listAllLokace = [];

  CreateReservationLogic({
    required this.listAllKadernik,
    required this.listAllKadernickyUkon,
    required this.listAllFutureRezervace,
  }) {
    //? Kód pro získání všech lokací s kadeřníkem

    //? Set - datový typ, který se používá při zajištění unikátnosti
    final Set<String> unikatniLokaceIds = {};
    final List<Lokace> nalezeneLokace = [];

    for (Kadernik kadernik in listAllKadernik) {
      final String lokaceId = kadernik.lokace.id;

      if (unikatniLokaceIds.add(lokaceId)) {
        //? Metoda .add() v datovém typu Set vrací true, pokud prvek byl přidán (byl unikátní)
        nalezeneLokace.add(kadernik.lokace);
        //print("Přidaná unikátní lokace $lokaceId");
      }
    }

    listAllLokace = nalezeneLokace;
  }

  List<Kadernik> getAllKadernikFromLokace(String lokaceId) {
    List<Kadernik> listKadernik = [];
    for (Kadernik kadernik in listAllKadernik) {
      if (kadernik.lokace.id == lokaceId) {
        listKadernik.add(kadernik);
      }
    }
    return listKadernik;
  }

  Map<String, KadernickyUkon> getKadernickeUkonyByKadernikAndGenderWithPriceMap(
    String kadernikId,
    String gender,
  ) {
    Kadernik? selectedKadernik;
    //? Mapa pro uložení: String (pro UI) -> KadernickyUkon (pro logiku)
    Map<String, KadernickyUkon> ukonyMap = {};

    for (Kadernik kadernik in listAllKadernik) {
      if (kadernik.id == kadernikId) {
        selectedKadernik = kadernik;
        break;
      }
    }

    if (selectedKadernik == null) {
      return {};
    }

    //TODO: Nesmí být nikdy název 2x stejný jméno
    for (KadernickyUkon ukon in listAllKadernickyUkon) {
      for (String ukonId in selectedKadernik.ukonyCeny.keys) {
        if (ukon.id == ukonId &&
            ukon.typStrihuPodlePohlavi == gender.toLowerCase()) {
          final double? cena = selectedKadernik.ukonyCeny[ukonId] as double?;

          if (cena != null) {
            ukon.cena = cena;
            ukonyMap[ukon.toString()] = ukon;
          }
        }
      }
    }

    return ukonyMap;
  }
}
