import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/rezervace.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

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

    selectedKadernik = getKadernikById(kadernikId);

    if (selectedKadernik == null) {
      return {};
    }

    //TODO: Nesmí být nikdy název 2x stejný jméno
    for (KadernickyUkon ukon in listAllKadernickyUkon) {
      for (String ukonId in selectedKadernik.ukonyCeny.keys) {
        if (ukon.id == ukonId &&
            ukon.typStrihuPodlePohlavi == gender.toLowerCase()) {
          final int? cena = selectedKadernik.ukonyCeny[ukonId];

          if (cena != null) {
            ukon.cena = cena;
            ukonyMap[ukon.toString()] = ukon;
          }
        }
      }
    }

    return ukonyMap;
  }

  Kadernik? getKadernikById(String kadernikId) {
    for (Kadernik kadernik in listAllKadernik) {
      if (kadernik.id == kadernikId) {
        return kadernik;
      }
    }
    return null;
  }

  //? Metoda pro vytvoření dostupných časů kadeřníka
  //TODO: Přepsat?
  List<String> findAvailableTimes(
    String kadernikId,
    int totalTime,
    DateTime? selectedDate,
  ) {
    Kadernik kadernik = getKadernikById(kadernikId)!;
    List<Rezervace> listRezervaciKadernikaUrcityDen = [];
    List<DateTime> dostupneCasy = [];
    Duration rezervaceDuration = Duration(minutes: totalTime);

    if (selectedDate == null) {
      return [];
    }

    DateTime pouzeDatumSelectedDate = _clearMilliseconds(
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
    );

    for (Rezervace rezervace in listAllFutureRezervace) {
      DateTime pouzeDatumRezervace = _clearMilliseconds(
        DateTime(
          rezervace.datumCasRezervace.year,
          rezervace.datumCasRezervace.month,
          rezervace.datumCasRezervace.day,
        ),
      );
      if ((rezervace.kadernik.id == kadernik.id) &&
          (pouzeDatumRezervace.isAtSameMomentAs(pouzeDatumSelectedDate))) {
        listRezervaciKadernikaUrcityDen.add(rezervace);
      }
    }

    List<String> rozdelenyZacatekPracovniDoby = kadernik.zacatekPracovniDoby
        .split(':');
    List<String> rozdelenyKonecPracovniDoby = kadernik.konecPracovniDoby.split(
      ':',
    );

    //? První možný čas rezervace
    DateTime prvniCas = _clearMilliseconds(
      DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(rozdelenyZacatekPracovniDoby[0]),
        int.parse(rozdelenyZacatekPracovniDoby[1]),
      ),
    );

    //? Poslední možný čas rezervace
    DateTime posledniCas = _clearMilliseconds(
      DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(rozdelenyKonecPracovniDoby[0]),
        int.parse(rozdelenyKonecPracovniDoby[1]),
      ),
    ).subtract(rezervaceDuration);

    Duration desetMinutDuration = Duration(minutes: 10);
    DateTime cas = prvniCas;

    while (cas.isBefore(posledniCas) || cas.isAtSameMomentAs(posledniCas)) {
      dostupneCasy.add(cas);
      cas = cas.add(desetMinutDuration);
    }

    //? Teď bych měl mít všechny dostupné časy, je na čase začít dávát pryč ty, co jsou již rezervované

    List<_TimeInterval> obsazeneIntervaly = [];
    for (Rezervace rezervace in listRezervaciKadernikaUrcityDen) {
      DateTime bookedStart = _clearMilliseconds(rezervace.datumCasRezervace);
      DateTime bookedEnd = bookedStart.add(
        Duration(minutes: rezervace.delkaTrvani),
      );
      obsazeneIntervaly.add(_TimeInterval(bookedStart, bookedEnd));
    }

    List<String> rozdelenyZacatekObeda = kadernik.casObedovePrestavky.split(
      ':',
    );

    DateTime obedStart = _clearMilliseconds(
      DateTime(
        pouzeDatumSelectedDate.year,
        pouzeDatumSelectedDate.month,
        pouzeDatumSelectedDate.day,
        int.parse(rozdelenyZacatekObeda[0]),
        int.parse(rozdelenyZacatekObeda[1]),
      ),
    );

    DateTime obedKonec = obedStart.add(
      Duration(minutes: kadernik.delkaObedovePrestavky),
    );

    obsazeneIntervaly.add(_TimeInterval(obedStart, obedKonec));

    List<String> dostupneCasyStrings = [];

    for (DateTime potencialniStart in dostupneCasy) {
      DateTime potencialniKonec = potencialniStart.add(rezervaceDuration);

      bool isConflict = false;

      for (_TimeInterval interval in obsazeneIntervaly) {
        DateTime bookedStart = interval.start;
        DateTime bookedEnd = interval.end;

        //? Zjišťujeme, kdy je zde konflikt (nová rezervace by zasahovala do již vytvořené nebo do obědové přestávky)
        bool isSeparate =
            (potencialniKonec.isBefore(bookedStart) ||
                potencialniKonec.isAtSameMomentAs(bookedStart)) ||
            (potencialniStart.isAfter(bookedEnd) ||
                potencialniStart.isAtSameMomentAs(bookedEnd));

        // Pokud NENÍ oddělený, JE to konflikt.
        if (!isSeparate) {
          isConflict = true;
          break;
        }
      }

      if (!isConflict) {
        String formatovanyCas =
            "${potencialniStart.hour.toString().padLeft(2, '0')}:${potencialniStart.minute.toString().padLeft(2, '0')}";
        dostupneCasyStrings.add(formatovanyCas);
      }
    }
    return dostupneCasyStrings;
  }

  //? Pomocná funkce
  DateTime _clearMilliseconds(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
  }

  Future<bool> createRezervace(
    String kadernikId,
    List<KadernickyUkon> ukony,
    DateTime datum,
    String cas,
    int delkaTrvani,
    int celkovaCena,
    String? note,
  ) async {
    Kadernik kadernik = getKadernikById(kadernikId)!;

    List<String> rozdelenyCas = cas.split(':');

    DateTime datumCasRezervace = DateTime(
      datum.year,
      datum.month,
      datum.day,
      int.parse(rozdelenyCas[0]),
      int.parse(rozdelenyCas[1]),
      0,
      0,
      0,
    );

    DateTime now = DateTime.now();

    note ??= "";

    Rezervace novaRezervace = Rezervace(
      id: "Nutný přepsat",
      kadernik: kadernik,
      kadernickeUkony: ukony,
      datumCasRezervace: datumCasRezervace,
      delkaTrvani: delkaTrvani,
      poznamkaUzivatele: note,
      datumCasVytvoreniRezervace: now,
      celkovaCena: celkovaCena,
      idUzivatele:
          AuthService().currentUser!.uid, //? Idk jestli bude fungovat!!
    );

    DatabaseService dbService = DatabaseService();

    bool uspesnost = await dbService.createNewRezervace(novaRezervace);

    return uspesnost;
  }
}

//? Pomocná třída pro lepší práci
class _TimeInterval {
  final DateTime start;
  final DateTime end;

  _TimeInterval(this.start, this.end);
}
