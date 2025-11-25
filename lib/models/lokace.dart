class Lokace {
  late String id, nazev, adresa, mesto, psc;
  late double latitude, longitude;

  Lokace({
    required this.id,
    required this.nazev,
    required this.adresa,
    required this.mesto,
    required this.psc,
    required this.latitude,
    required this.longitude,
  });

  Lokace.fromJson(Map<String, Object?> json)
    : this(
        id: json["ID_lokace"]! as String,
        nazev: json["Nazev_lokace"]! as String,
        adresa: json["Adresa_lokace"]! as String,
        mesto: json["Mesto_lokace"]! as String,
        psc: json["PSC_lokace"]! as String,
        latitude: json["Latitude_lokace"]! as double,
        longitude: json["Longitude_lokace"]! as double,
      );

  Map<String, Object?> toJson() {
    return {
      "ID_lokace": id,
      "Nazev_lokace": nazev,
      "Adresa_lokace": adresa,
      "Mesto_lokace": mesto,
      "PSC_lokace": psc,
      "Latitude_lokace": latitude,
      "Longitude_lokace": longitude,
    };
  }
}
