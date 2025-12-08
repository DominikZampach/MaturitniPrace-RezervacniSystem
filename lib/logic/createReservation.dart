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

  List<String> getKadernickeUkonyByKadernikAndGenderWithPrice(
    String kadernikId,
    String gender,
  ) {
    Kadernik? selectedKadernik;
    List<String> ukonyIds = [];

    for (Kadernik kadernik in listAllKadernik) {
      if (kadernik.id == kadernikId) {
        selectedKadernik = kadernik;
        break;
      }
    }

    if (selectedKadernik == null) {
      print("Kadeřník nenalezen.");
      return [];
    }

    for (KadernickyUkon ukon in listAllKadernickyUkon) {
      for (String id in selectedKadernik.ukonyCeny.keys) {
        if (ukon.id == id &&
            ukon.typStrihuPodlePohlavi == gender.toLowerCase()) {
          KadernickyUkon selectedUkon = ukon;
          //selectedUkon.cena = selectedKadernik.ukonyCeny["id"] as double;
          ukonyIds.add(selectedUkon.id);
        }
      }
    }

    print("Nalezené kadeřnické úkony:");
    for (String ukon in ukonyIds) {
      print("$ukon");
    }

    return ukonyIds;
  }
}
