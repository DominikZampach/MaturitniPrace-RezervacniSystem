import 'package:rezervacni_system_maturita/logic/getAvgRating.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/widgets/filters_dialog.dart';

class SortKadernici {
  //? Řázení abecedně podle jména vzestupně (a-z):
  static List<Kadernik> sortByNameAZ(List<Kadernik> list) {
    list.sort((a, b) => a.jmeno.toLowerCase().compareTo(b.jmeno.toLowerCase()));
    return list;
  }

  //? Řazení abecedně podle jména sestupně (z-a):
  static List<Kadernik> sortByNameZA(List<Kadernik> list) {
    list.sort((a, b) => b.jmeno.toLowerCase().compareTo(a.jmeno.toLowerCase()));
    return list;
  }

  static List<Kadernik> getFilteredList(
    List<Kadernik> allKadernici,
    List<Hodnoceni> allHodnoceni,
    Filters currentFilters,
    Uzivatel uzivatel,
  ) {
    return allKadernici.where((kadernik) {
      //? 1. Filtr Oblíbené
      if (currentFilters.showOnlyFavourite &&
          !uzivatel.isKadernikFavourite(kadernik.id)) {
        return false;
      }

      //? 2. Filtr Lokace
      if (currentFilters.lokaceId != null &&
          kadernik.lokace.id != currentFilters.lokaceId) {
        return false;
      }

      //? 3. Filtr Hodnocení
      double rating = getAvgRating(allHodnoceni, kadernik)[0] as double;
      if (rating < currentFilters.minimalRating) {
        return false;
      }

      return true;
    }).toList();
  }
}
