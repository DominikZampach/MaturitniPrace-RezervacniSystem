import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/hairdresser_card.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class BrowseBody extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const BrowseBody({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<BrowseBody> createState() => _BrowseBodyState();
}

class _BrowseBodyState extends State<BrowseBody> {
  late Future<_NactenaData> futureLogika;

  @override
  void initState() {
    super.initState();
    //? Tohle zajistí, aby se to provedlou pouze 1x, ne při každém setState()
    futureLogika = _nacteniDat();
  }

  Future<_NactenaData> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<Kadernik> listAllKadernici = await dbService.getAllKadernici();
    final List<Hodnoceni> listAllHodnoceni = await dbService.getAllHodnoceni();

    return _NactenaData(
      listAllHodnoceni: listAllHodnoceni,
      listAllKadernici: listAllKadernici,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLogika,
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

        final double reservationCardFontSize = 11.sp;
        final double buttonFontSize = 12.sp;
        final double h1FontSize = 18.sp;
        final double h2FontSize = 15.sp;

        final List<Kadernik> listAllKadernici = snapshot.data!.listAllKadernici;
        final List<Hodnoceni> listAllHodnoceni =
            snapshot.data!.listAllHodnoceni;

        //TODO: Tenhle list se bude měnit podle vybraných filtrů, řazení, ...
        List<Kadernik> listKadernikuProZobrazeni = [];
        listKadernikuProZobrazeni.addAll(listAllKadernici);

        listKadernikuProZobrazeni.addAll(listAllKadernici);
        listKadernikuProZobrazeni.addAll(listAllKadernici);

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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    "Our Hairdressers",
                    style: TextStyle(
                      fontSize: h1FontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.h,
                      childAspectRatio: 5.5,
                    ),
                    itemCount: listKadernikuProZobrazeni.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HairdresserCard(
                        kadernik: listKadernikuProZobrazeni[index],
                        vsechnaHodnoceni: listAllHodnoceni,
                      );
                    },
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
