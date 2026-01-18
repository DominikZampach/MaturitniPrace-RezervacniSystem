import 'package:flutter/material.dart';
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

  List<KadernickyUkon> kadernickeUkonySCenami = [];

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

  Map<String, dynamic> toJson() {
    return {
      "ID_kadernika": id,
      "Jmeno_kadernika": jmeno,
      "Prezdivka_kadernika": prezdivka,
      "Prijmeni_kadernika": prijmeni,
      "OdkazFotografie_kadernika": odkazFotografie,
      "Popisek_kadernika": popisek,
      "Telefon_kadernika": telefon,
      "Email_kadernika": email,
      "PracovniDny_kadernika": pracovniDny,
      "ZacatekPracovniDoby_kadernika": zacatekPracovniDoby,
      "KonecPracovniDoby_kadernika": konecPracovniDoby,
      "CasObedovePrestavky_kadernika": casObedovePrestavky,
      "DelkaObedovePrestavkyMinuty_kadernika": delkaObedovePrestavky,
      "id_lokace": lokace.id,
      "Map_IdsUkonyCena": ukonyCeny,
      "OdkazyFotografiiPrace_kadernika": odkazyFotografiiPrace,
    };
  }

  String getFullNameString() {
    return "$jmeno \"$prezdivka\" $prijmeni";
  }

  Future<List<KadernickyUkon>> getAllKadernickyUkonAndPrice() async {
    //? Pokud už tato metoda byla volána, tak nepotřebujeme znova zjišťovat data a prostě si vezmeme ty, co jsou uložené v objektu
    if (kadernickeUkonySCenami.isNotEmpty) {
      return kadernickeUkonySCenami;
    }

    List<Future<KadernickyUkon>> kadernickeUkonyFutures = [];
    List<KadernickyUkon> kadernickeUkonyList = [];
    List<KadernickyUkon> kadernickeUkonyListSCenami = [];

    DatabaseService dbService = DatabaseService();

    for (var ukonId in ukonyCeny.keys) {
      kadernickeUkonyFutures.add(dbService.getKadernickyUkon(ukonId));
    }

    kadernickeUkonyList = await Future.wait(kadernickeUkonyFutures);

    for (KadernickyUkon ukon in kadernickeUkonyList) {
      ukon.cena = ukonyCeny[ukon.id]!;
      kadernickeUkonyListSCenami.add(ukon);
    }

    kadernickeUkonySCenami = kadernickeUkonyListSCenami;

    print("Kadeřnické ukony list s cenami: $kadernickeUkonyListSCenami");
    return kadernickeUkonyListSCenami;
  }

  //? Konvertuje na normální list s celými názvy, jako je Monday, Tuesday, ...
  List<String> getListOfWorkingDays() {
    const Map<String, String> dny = {
      "1": "Monday",
      "2": "Tuesday",
      "3": "Wednesday",
      "4": "Thursday",
      "5": "Friday",
      "6": "Saturday",
      "7": "Sunday",
    };

    List<String> pracovniDnySplit = pracovniDny.split(',');

    List<String> listPracovnichDnuCeleNazvy = [];
    for (var den in pracovniDnySplit) {
      if (dny.containsKey(den)) {
        listPracovnichDnuCeleNazvy.add(dny[den]!);
      }
    }

    return listPracovnichDnuCeleNazvy;
  }

  //? Konvertuje zpět na string s čísly a uloží jej do proměnné tady
  void saveNewWorkingDays(List<String> newPracovniDny) {
    const Map<String, String> dny = {
      "Monday": "1",
      "Tuesday": "2",
      "Wednesday": "3",
      "Thursday": "4",
      "Friday": "5",
      "Saturday": "6",
      "Sunday": "7",
    };

    String newPracovniDnyString = "";
    for (var den in newPracovniDny) {
      newPracovniDnyString += "${dny[den]},";
    }

    if (newPracovniDnyString.isNotEmpty) {
      newPracovniDnyString = newPracovniDnyString.substring(
        0,
        newPracovniDnyString.length - 1,
      );
    }

    print(newPracovniDnyString);
    pracovniDny = newPracovniDnyString;
  }

  static TimeOfDay getTimeOfDay(String time) {
    var splitedTime = time.split(':');
    int hours = int.parse(splitedTime[0]);
    int minutes = int.parse(splitedTime[1]);

    return TimeOfDay(hour: hours, minute: minutes);
  }

  static String getStringFromTimeOfDay(TimeOfDay time) {
    String formattedTime =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    return formattedTime;
  }
}
