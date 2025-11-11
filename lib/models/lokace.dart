class Lokace {
  late String id, nazev, odkazGoogleMaps, adresa, mesto;
  late int psc;

  Lokace({
    required this.id,
    required this.nazev,
    required this.odkazGoogleMaps,
    required this.adresa,
    required this.mesto,
    required this.psc,
  });

  Lokace.fromJson(Map<String, Object?> json)
    : this(
        id: json["ID_lokace"]! as String,
        nazev: json["Nazev_lokace"]! as String,
        odkazGoogleMaps: json["Odkaz_lokace"]! as String,
        adresa: json["Adresa_lokace"]! as String,
        mesto: json["Mesto_lokace"]! as String,
        psc: json["PSC_lokace"]! as int,
      );

  Map<String, Object?> toJson() {
    return {
      "ID_lokace": id,
      "Nazev_lokace": nazev,
      "Odkaz_lokace": odkazGoogleMaps,
      "Adresa_lokace": adresa,
      "Mesto_lokace": mesto,
      "PSC_lokace": psc,
    };
  }
}
