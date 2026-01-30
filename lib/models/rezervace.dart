import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

class Rezervace {
  late String id;
  late Kadernik kadernik;
  late List<KadernickyUkon> kadernickeUkony;
  late DateTime datumCasRezervace;
  late int delkaTrvani, celkovaCena;
  late String poznamkaUzivatele;
  late DateTime datumCasVytvoreniRezervace;
  late String idUzivatele;

  Rezervace({
    required this.id,
    required this.kadernik,
    required this.kadernickeUkony,
    required this.datumCasRezervace,
    required this.delkaTrvani,
    required this.poznamkaUzivatele,
    required this.datumCasVytvoreniRezervace,
    required this.celkovaCena,
    required this.idUzivatele,
  });

  static Future<Rezervace> fromJson(
    Map<String, Object?> json, {
    List<KadernickyUkon> vsechnyUkony = const [],
  }) async {
    //? Řešení s použitím async + await pro získání objektů z databází
    final kadernik = await DatabaseService().getKadernik(
      json["id_kadernika"]! as String,
    );

    List<KadernickyUkon> kadernickeUkony;

    kadernickeUkony = await convertToListOfKadernickeUkony(
      (json["ids_ukony"]! as List).cast<String>(),
      vsechnyUkony,
    );

    return Rezervace(
      id: json["ID_rezervace"]! as String,
      kadernik: kadernik,
      kadernickeUkony: kadernickeUkony,
      datumCasRezervace: (json["DatumCas_rezervace"]! as Timestamp).toDate(),
      delkaTrvani: json["DelkaTrvaniMinuty_rezervace"]! as int,
      poznamkaUzivatele: json["PoznamkaUzivatele"]! as String,
      datumCasVytvoreniRezervace:
          (json["DatumCasVytvoreni_rezervace"]! as Timestamp).toDate(),
      celkovaCena: json["CelkovaCena_rezervace"]! as int,
      idUzivatele: json["id_uzivatele"]! as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "ID_rezervace": id,
      "id_kadernika": kadernik.id,
      "id_uzivatele": AuthService().currentUser!.uid,
      "ids_ukony": getKadernickeUkonyIdsFromListOfKadernickeUkony(),
      "DatumCas_rezervace": datumCasRezervace,
      "DelkaTrvaniMinuty_rezervace": delkaTrvani,
      "PoznamkaUzivatele": poznamkaUzivatele,
      "DatumCasVytvoreni_rezervace": datumCasVytvoreniRezervace,
      "CelkovaCena_rezervace": celkovaCena,
    };
  }

  static Future<List<KadernickyUkon>> convertToListOfKadernickeUkony(
    List<String> idsKadernickeUkony,
    List<KadernickyUkon> vsechnyUkony,
  ) async {
    DatabaseService dbService = DatabaseService();
    KadernickyUkon ukon;
    List<KadernickyUkon> kadernickeUkony = [];

    if (vsechnyUkony.isEmpty) {
      for (String id in idsKadernickeUkony) {
        ukon = await dbService.getKadernickyUkon(id);
        print("Proveden požadavek na získání kadeřnického úkonu $id");
        kadernickeUkony.add(ukon);
      }
    } else {
      //? Tohle se stane když .fromJson dostane list všech Kadeřnických úkonů - snižuje to náročnost na databázi
      for (String id in idsKadernickeUkony) {
        for (KadernickyUkon kadernickyUkon in vsechnyUkony) {
          if (id == kadernickyUkon.id) {
            kadernickeUkony.add(kadernickyUkon);
          }
        }
      }
    }

    print("Počet kadeřnických úkonů v rezervaci: ${kadernickeUkony.length}");
    return kadernickeUkony;
  }

  List<String> getKadernickeUkonyIdsFromListOfKadernickeUkony() {
    List<String> idsKadernickeUkony = [];
    for (KadernickyUkon ukon in kadernickeUkony) {
      idsKadernickeUkony.add(ukon.id);
    }
    return idsKadernickeUkony;
  }

  String getDayMonthYearString() {
    return DateFormat('d.M.yyyy').format(datumCasRezervace);
  }

  String getHourMinuteString() {
    return DateFormat('HH:mm').format(datumCasRezervace);
  }

  String getKadernickeUkonyString() {
    String text = "";
    for (KadernickyUkon ukon in kadernickeUkony) {
      text = "$text + ${ukon.nazev}";
    }
    return text.substring(3);
  }
}
