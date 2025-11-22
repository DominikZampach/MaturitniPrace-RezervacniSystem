class Hodnoceni {
  late String id, idUzivatele, idKadernika;
  late int ciselneHodnoceni; // 1 - 10

  Hodnoceni({
    required this.id,
    required this.idUzivatele,
    required this.idKadernika,
    required this.ciselneHodnoceni,
  });

  Hodnoceni.fromJson(Map<String, Object?> json)
    : this(
        id: json["ID_hodnoceni"]! as String,
        idUzivatele: json["id_uzivatele"]! as String,
        idKadernika: json["id_kadernika"]! as String,
        ciselneHodnoceni: json["Ciselne_hodnoceni"]! as int,
      );

  Map<String, Object?> toJson() {
    return {
      "ID_hodnoceni": id,
      "id_uzivatele": idUzivatele,
      "id_kadernika": idKadernika,
      "Ciselne_hodnoceni": ciselneHodnoceni,
    };
  }
}
