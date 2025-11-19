import 'package:cloud_firestore/cloud_firestore.dart';

class Hodnoceni {
  late String id, idUzivatele, idKadernika;
  late String jmenoUzivatele;
  late int ciselneHodnoceni;
  late String slovniHodnoceni;
  late DateTime datumVytvoreni;

  Hodnoceni({
    required this.id,
    required this.idUzivatele,
    required this.jmenoUzivatele,
    required this.idKadernika,
    required this.ciselneHodnoceni,
    required this.slovniHodnoceni,
    required this.datumVytvoreni,
  });

  Hodnoceni.fromJson(Map<String, Object?> json)
    : this(
        id: json["ID_hodnoceni"]! as String,
        idUzivatele: json["id_uzivatele"]! as String,
        jmenoUzivatele: json["Jmeno_uzivatele"]! as String,
        idKadernika: json["id_kadernika"]! as String,
        ciselneHodnoceni: json["Ciselne_hodnoceni"]! as int,
        slovniHodnoceni: json["Slovni_hodnoceni"]! as String,
        datumVytvoreni: (json["Datum_hodnoceni"]! as Timestamp).toDate(),
      );

  Map<String, Object?> toJson() {
    return {
      "ID_hodnoceni": id,
      "id_uzivatele": idUzivatele,
      "Jmeno_uzivatele": jmenoUzivatele,
      "id_kadernika": idKadernika,
      "Ciselne_hodnoceni": ciselneHodnoceni,
      "Slovni_hodnoceni": slovniHodnoceni,
      "Datum_hodnoceni": datumVytvoreni,
    };
  }
}
