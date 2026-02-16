import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/sort_kadernici.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/filters_dialog_desktop.dart';
import 'package:rezervacni_system_maturita/widgets/hairdresser_card.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class BrowseBody extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final Uzivatel uzivatel;
  const BrowseBody({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.uzivatel,
  });

  @override
  State<BrowseBody> createState() => _BrowseBodyState();
}

class _BrowseBodyState extends State<BrowseBody> {
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
            child: Text(
              "Error occured while trying to load data from database!",
            ),
          );
        }

        final double smallerButtonFontSize = Consts.smallerFS.sp;
        final double h1FontSize = Consts.h1FS.sp;
        final double h2FontSize = Consts.h2FS.sp;

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

        print(
          "Počet kadeřníků v listKadernikuListView: ${listKadernikuProZobrazeni.length}",
        );

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
                  "Our Hairdressers",
                  style: TextStyle(
                    fontSize: h1FontSize,
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
                              size: smallerButtonFontSize,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Sort by: $currentSort",
                              style: TextStyle(
                                fontSize: smallerButtonFontSize,
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
                                  //TODO
                                  final Filters? updatedFilters =
                                      await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FiltersDialogDesktop(
                                              filters: currentFilters,
                                              allLokace: allLokace,
                                            ),
                                      );
                                  if (updatedFilters != null) {
                                    setState(() {
                                      currentFilters = updatedFilters;
                                    });
                                  }
                                },
                                child: Text(
                                  "Filters",
                                  style: TextStyle(
                                    fontSize: smallerButtonFontSize,
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
                                  "Delete filters",
                                  style: TextStyle(
                                    fontSize: smallerButtonFontSize,
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
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.w,
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 5.5,
                              ),
                          itemCount: listKadernikuProZobrazeni.length,
                          itemBuilder: (BuildContext context, int index) {
                            HairdresserCard card = HairdresserCard(
                              kadernik: listKadernikuProZobrazeni[index],
                              vsechnaHodnoceni: listAllHodnoceni,
                              uzivatel: widget.uzivatel,
                            );
                            return card;
                          },
                        )
                      : Center(
                          child: Text(
                            "No hairdresser matches your filters!",
                            style: TextStyle(
                              fontSize: h2FontSize,
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
