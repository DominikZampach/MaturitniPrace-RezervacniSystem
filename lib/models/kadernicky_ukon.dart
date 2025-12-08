class KadernickyUkon {
  late String id;
  late String nazev;
  late int delkaMinuty;
  late String popis;
  late String typStrihuPodlePohlavi;
  late List<String> odkazyFotografiiPrikladu;
  late double cena;

  KadernickyUkon({
    required this.id,
    required this.nazev,
    required this.delkaMinuty,
    required this.popis,
    required this.typStrihuPodlePohlavi,
    required this.odkazyFotografiiPrikladu,
  });

  static KadernickyUkon fromJson(Map<String, Object?> json) {
    return KadernickyUkon(
      id: json["ID_ukonu"]! as String,
      nazev: json["Nazev_ukonu"]! as String,
      delkaMinuty: json["DelkaMinuty_ukonu"]! as int,
      popis: json["Popis_ukonu"]! as String,
      typStrihuPodlePohlavi: json["TypStrihu_ukonu"]! as String,
      odkazyFotografiiPrikladu:
          (json["OdkazyFotografii_Ukonu"]! as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      "ID_ukonu": id,
      "Nazev_ukonu": nazev,
      "DelkaMinuty_ukonu": delkaMinuty,
      "Popis_ukonu": popis,
      "TypStrihu_ukonu": typStrihuPodlePohlavi,
      "OdkazyFotografii_Ukonu": odkazyFotografiiPrikladu,
    };
  }

  @override
  String toString() {
    return "$nazev - $cena Kč";
  }
}
