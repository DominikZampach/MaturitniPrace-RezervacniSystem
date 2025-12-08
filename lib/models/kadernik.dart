import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

class Kadernik {
  late String id,
      jmeno,
      prezdivka,
      prijmeni,
      odkazFotografie,
      popisek,
      pracovniDny,
      zacatekPracovniDoby,
      konecPracovniDoby,
      casObedovePrestavky,
      telefon,
      email;
  late Lokace lokace;
  late int delkaObedovePrestavky;
  late Map<String, int> ukonyCeny;
  late List<String> odkazyFotografiiPrace;

  Kadernik({
    required this.id,
    required this.jmeno,
    required this.prezdivka,
    required this.prijmeni,
    required this.odkazFotografie,
    required this.popisek,
    required this.telefon,
    required this.email,
    required this.pracovniDny,
    required this.zacatekPracovniDoby,
    required this.konecPracovniDoby,
    required this.casObedovePrestavky,
    required this.lokace,
    required this.delkaObedovePrestavky,
    required this.ukonyCeny,
    required this.odkazyFotografiiPrace,
  });

  static Future<Kadernik> fromJson(Map<String, Object?> json) async {
    final Lokace lokace = await DatabaseService().getLokace(
      json["id_lokace"]! as String,
    );

    return Kadernik(
      id: json["ID_kadernika"]! as String,
      jmeno: json["Jmeno_kadernika"]! as String,
      prezdivka: json["Prezdivka_kadernika"]! as String,
      prijmeni: json["Prijmeni_kadernika"]! as String,
      odkazFotografie: json["OdkazFotografie_kadernika"]! as String,
      popisek: json["Popisek_kadernika"]! as String,
      telefon: json["Telefon_kadernika"]! as String,
      email: json["Email_kadernika"]! as String,
      pracovniDny: json["PracovniDny_kadernika"]! as String,
      zacatekPracovniDoby: json["ZacatekPracovniDoby_kadernika"]! as String,
      konecPracovniDoby: json["KonecPracovniDoby_kadernika"]! as String,
      casObedovePrestavky: json["CasObedovePrestavky_kadernika"]! as String,
      lokace: lokace,
      delkaObedovePrestavky:
          json["DelkaObedovePrestavkyMinuty_kadernika"]! as int,
      ukonyCeny: Map<String, int>.from(
        json["Map_IdsUkonyCena"]! as Map<String, dynamic>,
      ), //! Nevím, pokud bude fungovat!
      odkazyFotografiiPrace:
          (json["OdkazyFotografiiPrace_kadernika"]! as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );
  }

  String getFullNameString() {
    return "$jmeno '$prezdivka' $prijmeni";
  }

  Map<KadernickyUkon, double> getAllKadernickyUkonAndPrice() {
    //TODO
    return {};
  }
}
