import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

class Uzivatel {
  late String userUID;
  late String jmeno, prijmeni, email, telefon;
  late List<String> oblibeniKadernici;

  Uzivatel({
    required this.userUID,
    required this.jmeno,
    required this.prijmeni,
    required this.email,
    required this.telefon,
    required this.oblibeniKadernici,
  });

  Uzivatel.fromJson(String userUID, Map<String, Object?> json)
    : this(
        userUID: userUID,
        jmeno: json["Jmeno_uzivatele"]! as String,
        prijmeni: json["Prijmeni_uzivatele"]! as String,
        email: json["Email_uzivatele"]! as String,
        telefon: json["TelefonniCislo_uzivatele"]! as String,
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
      "IDs_OblibeniKadernici": oblibeniKadernici,
    };
  }

  Future<List<Kadernik>> getOblibeniKadernici() async {
    List<Kadernik> kadernici = [];
    DatabaseService dbService = DatabaseService();
    for (String id in oblibeniKadernici) {
      kadernici.add(await dbService.getKadernik(id));
    }
    return kadernici;
  }

  bool isKadernikFavourite(String kadernikId) {
    if (oblibeniKadernici.contains(kadernikId)) {
      return true;
    }
    return false;
  }
}
