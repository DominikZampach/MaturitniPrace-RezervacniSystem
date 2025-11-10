class KadernickyUkon {
  late String nazev;
  late int delkaMinuty;
  late String popis;
  late List<String> odkazyFotografiiPrikladu;

  KadernickyUkon({
    required this.nazev,
    required this.delkaMinuty,
    required this.popis,
    required this.odkazyFotografiiPrikladu,
  });

  KadernickyUkon.fromJson(Map<String, Object?> json)
    : this(
        nazev: json["Nazev_ukonu"]! as String,
        delkaMinuty: json["DelkaMinuty_ukonu"]! as int,
        popis: json["Popis_ukonu"]! as String,
        odkazyFotografiiPrikladu:
            (json["OdkazyFotografii_Ukonu"]! as List<dynamic>)
                .map((e) => e as String)
                .toList(),
      );

  Map<String, Object?> toJson() {
    return {
      "Nazev_ukonu": nazev,
      "DelkaMinuty_ukonu": delkaMinuty,
      "Popis_ukonu": popis,
      "OdkazyFotografii_Ukonu": odkazyFotografiiPrikladu,
    };
  }
}
