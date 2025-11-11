import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

class Rezervace {
  //? Nepotřebuji ani idUzivatele zapisovat, budu si brát už filtrované rezervace pouze tohoto uživatele!
  late String id;
  late Kadernik kadernik;
  late List<KadernickyUkon> kadernickeUkony;
  late DateTime datumCasRezervace;
  late int delkaTrvani, celkovaCena;
  late String poznamkaAdmina, poznamkaUzivatele;
  late DateTime datumCasVytvoreniRezervace;

  Rezervace({
    required this.id,
    required this.kadernik,
    required this.kadernickeUkony,
    required this.datumCasRezervace,
    required this.delkaTrvani,
    required this.poznamkaAdmina,
    required this.poznamkaUzivatele,
    required this.datumCasVytvoreniRezervace,
    required this.celkovaCena,
  });

  static Future<Rezervace> fromJson(Map<String, Object?> json) async {
    //? Řešení s použitím async + await pro získání objektů z databází
    final kadernik = await DatabaseService().getKadernik(
      json["id_kadernika"]! as String,
    );

    final kadernickeUkony = await convertToListOfKadernickeUkony(
      (json["ids_ukony"]! as List).cast<String>(),
    );

    return Rezervace(
      id: json["ID_rezervace"]! as String,
      kadernik: kadernik,
      kadernickeUkony: kadernickeUkony,
      datumCasRezervace: (json["DatumCas_rezervace"]! as Timestamp).toDate(),
      delkaTrvani: json["DelkaTrvaniMinuty_rezervace"]! as int,
      poznamkaAdmina: json["PoznamkaAdmina"]! as String,
      poznamkaUzivatele: json["PoznamkaUzivatele"]! as String,
      datumCasVytvoreniRezervace:
          (json["DatumCasVytvoreni_rezervace"]! as Timestamp).toDate(),
      celkovaCena: json["CelkovaCena_rezervace"]! as int,
    );
  }

  Map<String, Object?> toJson() {
    //TODO
    return {
      "ID_rezervace": id,
      "id_kadernika": kadernik.id,
      "ids_ukony": getKadernickeUkonyIdsFromListOfKadernickeUkony(),
      "DatumCas_rezervace": datumCasRezervace,
      "DelkaTrvaniMinuty_rezervace": delkaTrvani,
      "PoznamkaAdmina": poznamkaAdmina,
      "PoznamkaUzivatele": poznamkaUzivatele,
      "DatumCasVytvoreni_rezervace": datumCasVytvoreniRezervace,
      "CelkovaCena_rezervace": celkovaCena,
    };
  }

  static Future<List<KadernickyUkon>> convertToListOfKadernickeUkony(
    List<String> idsKadernickeUkony,
  ) async {
    List<KadernickyUkon> kadernickeUkony = List.empty();
    for (String id in idsKadernickeUkony) {
      kadernickeUkony.add(await DatabaseService().getKadernickyUkon(id));
    }
    return kadernickeUkony;
  }

  List<String> getKadernickeUkonyIdsFromListOfKadernickeUkony() {
    List<String> idsKadernickeUkony = List.empty();
    for (KadernickyUkon ukon in kadernickeUkony) {
      idsKadernickeUkony.add(ukon.id);
    }
    return idsKadernickeUkony;
  }
}
