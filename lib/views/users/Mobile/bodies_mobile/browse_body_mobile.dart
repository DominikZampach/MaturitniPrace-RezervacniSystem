import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/sort_kadernici.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/filters_dialog_desktop.dart';
import 'package:rezervacni_system_maturita/widgets/filters_dialog_mobile.dart';
import 'package:rezervacni_system_maturita/widgets/hairdresser_card.dart';
import 'package:rezervacni_system_maturita/widgets/hairdresser_card_mobile.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class BrowseBodyMobile extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final Uzivatel uzivatel;

  final double mobileFontSize;
  final double mobileSmallerFontSize;
  final double mobileHeadingsFontSize;
  final double mobileSmallerHeadingFontSize;

  const BrowseBodyMobile({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.uzivatel,
    required this.mobileFontSize,
    required this.mobileSmallerFontSize,
    required this.mobileHeadingsFontSize,
    required this.mobileSmallerHeadingFontSize,
  });

  @override
  State<BrowseBodyMobile> createState() => _BrowseBodyMobileState();
}

class _BrowseBodyMobileState extends State<BrowseBodyMobile> {
  late String currentSort = "A-Z";
  List<Kadernik> listKadernikuProZobrazeni = [];
  final List<Lokace> allLokace = [];

  final Filters defaultFilters = Filters(
    showOnlyFavourite: false,
    minimalRating: 0,
    lokaceId: null,
  );

  //? Proměnné pro filtraci + default hodnoty
  Filters currentFilters = Filters(
    showOnlyFavourite: false,
    minimalRating: 0,
    lokaceId: null,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<_NactenaData> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    //? Optimalizace
    final results = await Future.wait([
      dbService.getAllKadernici(),
      dbService.getAllHodnoceni(),
    ]);

    final List<Kadernik> listAllKadernici = results[0] as List<Kadernik>;
    final List<Hodnoceni> listAllHodnoceni = results[1] as List<Hodnoceni>;

    final Set<String> unikatniLokaceIds = {};

    for (Kadernik kadernik in listAllKadernici) {
      final String lokaceId = kadernik.lokace.id;

      if (unikatniLokaceIds.add(lokaceId)) {
        //? Metoda .add() v datovém typu Set vrací true, pokud prvek byl přidán (byl unikátní)
        allLokace.add(kadernik.lokace);
      }
    }

    return _NactenaData(
      listAllHodnoceni: listAllHodnoceni,
      listAllKadernici: listAllKadernici,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _nacteniDat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.hasError) {
          print("Error při načítání dat: ${snapshot.error}");
          return const Center(
            child: Text("Naskytla se chyba při načítání dat z databáze!"),
          );
        }

        final List<Kadernik> listAllKadernici = snapshot.data!.listAllKadernici;
        final List<Hodnoceni> listAllHodnoceni =
            snapshot.data!.listAllHodnoceni;

        //? Vrátí upravený list podle filtrů
        listKadernikuProZobrazeni = SortKadernici.getFilteredList(
          listAllKadernici,
          listAllHodnoceni,
          currentFilters,
          widget.uzivatel,
        );

        //? Řazení podle vybraného parametru
        if (currentSort == "A-Z") {
          listKadernikuProZobrazeni = SortKadernici.sortByNameAZ(
            listKadernikuProZobrazeni,
          );
        } else {
          listKadernikuProZobrazeni = SortKadernici.sortByNameZA(
            listKadernikuProZobrazeni,
          );
        }

        return Container(
          color: Colors.white,
          height: widget.screenHeight,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "Naši kadeřníci",
                  style: TextStyle(
                    fontSize: widget.mobileHeadingsFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                if (currentSort == "A-Z") {
                                  currentSort = "Z-A";
                                } else if (currentSort == "Z-A") {
                                  currentSort = "A-Z";
                                }
                              });
                            },
                            icon: Icon(
                              Icons.swap_vert,
                              size: widget.mobileSmallerFontSize,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Řazení: $currentSort",
                              style: TextStyle(
                                fontSize: widget.mobileSmallerFontSize,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          right: 0,
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final Filters?
                                  updatedFilters = await showDialog(
                                    context: context,
                                    builder: (context) => FiltersDialogMobile(
                                      filters: currentFilters,
                                      allLokace: allLokace,
                                      headingFontSize:
                                          widget.mobileHeadingsFontSize,
                                      smallHeadingFontSize:
                                          widget.mobileSmallerHeadingFontSize,
                                      normalTextFontSize: widget.mobileFontSize,
                                    ),
                                  );

                                  if (updatedFilters != null) {
                                    setState(() {
                                      currentFilters = updatedFilters;
                                    });
                                  }
                                },
                                child: Text(
                                  "Filtrování",
                                  style: TextStyle(
                                    fontSize: widget.mobileSmallerFontSize,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.red.shade100,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    currentFilters = Filters(
                                      showOnlyFavourite:
                                          defaultFilters.showOnlyFavourite,
                                      minimalRating:
                                          defaultFilters.minimalRating,
                                      lokaceId: defaultFilters.lokaceId,
                                    );
                                  });
                                },
                                child: Text(
                                  "Smazat filtry",
                                  style: TextStyle(
                                    fontSize: widget.mobileSmallerFontSize,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: listKadernikuProZobrazeni.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 20.w,
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: listKadernikuProZobrazeni.length,
                          itemBuilder: (BuildContext context, int index) {
                            HairdresserCardMobile card = HairdresserCardMobile(
                              kadernik: listKadernikuProZobrazeni[index],
                              vsechnaHodnoceni: listAllHodnoceni,
                              uzivatel: widget.uzivatel,
                              mobileFontSize: widget.mobileFontSize,
                              mobileHeadingsFontSize:
                                  widget.mobileHeadingsFontSize,
                              mobileSmallerFontSize:
                                  widget.mobileSmallerFontSize,
                              mobileSmallerHeadingsFontSize:
                                  widget.mobileSmallerHeadingFontSize,
                              kadernikovaHodnoceni: [],
                            );
                            return card;
                          },
                        )
                      : Center(
                          child: Text(
                            "Žádní kadeřnící vyhovující vašemu filtrování!",
                            style: TextStyle(
                              fontSize: widget.mobileSmallerHeadingFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NactenaData {
  final List<Kadernik> listAllKadernici;
  final List<Hodnoceni> listAllHodnoceni;
  const _NactenaData({
    required this.listAllHodnoceni,
    required this.listAllKadernici,
  });
}
