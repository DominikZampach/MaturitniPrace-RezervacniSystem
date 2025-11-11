import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

class Uzivatel {
  late String userUID;
  late String jmeno, prijmeni, email, telefon;
  late bool povoleneNotifikace;
  late List<String> oblibeniKadernici;
  late bool jeMuz;

  Uzivatel({
    required this.userUID,
    required this.jmeno,
    required this.prijmeni,
    required this.email,
    required this.telefon,
    required this.povoleneNotifikace,
    required this.jeMuz,
    required this.oblibeniKadernici,
  });

  Uzivatel.fromJson(String userUID, Map<String, Object?> json)
    : this(
        userUID: userUID,
        jmeno: json["Jmeno_uzivatele"]! as String,
        prijmeni: json["Prijmeni_uzivatele"]! as String,
        email: json["Email_uzivatele"]! as String,
        telefon: json["TelefonniCislo_uzivatele"]! as String,
        povoleneNotifikace: json["PovoleneNotifikace"]! as bool,
        jeMuz: json["Pohlavi_uzivatele"] == "male" ? true : false,
        oblibeniKadernici: (json["IDs_OblibeniKadernici"]! as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );

  Map<String, Object?> toJson() {
    return {
      "Jmeno_uzivatele": jmeno,
      "Prijmeni_uzivatele": prijmeni,
      "Email_uzivatele": email,
      "TelefonniCislo_uzivatele": telefon,
      "PovoleneNotifikace": povoleneNotifikace,
      "Pohlavi_uzivatele": jeMuz ? "male" : "female",
      "IDs_OblibeniKadernici": oblibeniKadernici,
    };
  }

  Future<List<Kadernik>> getOblibeniKadernici() async {
    List<Kadernik> kadernici = List.empty();
    DatabaseService dbService = DatabaseService();
    for (String id in oblibeniKadernici) {
      kadernici.add(await dbService.getKadernik(id));
    }
    return kadernici;
  }
}
