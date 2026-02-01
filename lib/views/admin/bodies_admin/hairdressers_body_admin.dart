import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/hodnoceni.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/kadernik.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/create_hairdresser.dart';
import 'package:rezervacni_system_maturita/widgets/hairdresser_card.dart';
import 'package:rezervacni_system_maturita/views/admin/hairdressers/hairdresser_card_admin.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class HairdressersBodyAdmin extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const HairdressersBodyAdmin({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<HairdressersBodyAdmin> createState() => _HairdressersBodyAdminState();
}

class _HairdressersBodyAdminState extends State<HairdressersBodyAdmin> {
  late Future<_NactenaData> futureLogika;

  Future<_NactenaData> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final results = await Future.wait([
      dbService.getAllKadernici(),
      dbService.getAllLokace(),
      dbService.getAllKadernickeUkony(),
    ]);

    final List<Kadernik> listAllKadernici = results[0] as List<Kadernik>;
    final List<Lokace> listAllLokace = results[1] as List<Lokace>;
    final List<KadernickyUkon> listAllKadernickyUkony =
        results[2] as List<KadernickyUkon>;

    return _NactenaData(
      listAllKadernici: listAllKadernici,
      listAllLokace: listAllLokace,
      listAllKadernickeUkony: listAllKadernickyUkony,
    );
  }

  @override
  void initState() {
    super.initState();
    //? Tohle zajistí, aby se to provedlou pouze 1x, ne při každém setState()
    futureLogika = _nacteniDat();
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

        final double buttonFontSize = Consts.normalFS.sp;
        final double h1FontSize = Consts.h1FS.sp;

        final List<Kadernik> listAllKadernici = snapshot.data!.listAllKadernici;
        final List<Lokace> listAllLokace = snapshot.data!.listAllLokace;
        final List<KadernickyUkon> listAllKadernickeUkony =
            snapshot.data!.listAllKadernickeUkony;

        dynamic saveKadernik(Kadernik updatedKadernik) async {
          DatabaseService dbService = DatabaseService();
          await dbService.updateKadernik(updatedKadernik);

          int kadernikIndex = listAllKadernici.indexWhere(
            (item) => item.id == updatedKadernik.id,
          );

          setState(() {
            listAllKadernici[kadernikIndex] = updatedKadernik;
          });
        }

        dynamic deleteKadernik(String id) async {
          DatabaseService dbService = DatabaseService();
          int kadernikIndex = listAllKadernici.indexWhere(
            (item) => item.id == id,
          );
          await dbService.deleteKadernik(id);
          setState(() {
            listAllKadernici.removeAt(kadernikIndex);
          });
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
                  "All Hairdressers",
                  style: TextStyle(
                    fontSize: h1FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    final dialogResult = await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          CreateHairdresserDialog(
                            listAllLokace: listAllLokace,
                            listAllKadernickeUkony: listAllKadernickeUkony,
                            onCreated: (newKadernik) => setState(() {
                              listAllKadernici.add(newKadernik);
                            }),
                          ),
                    );
                  },
                  label: Text(
                    "Add Hairdresser",
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      color: Colors.black,
                    ),
                  ),
                  icon: Icon(Icons.add, color: Colors.black),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Consts.secondary),
                  ),
                ),
                SizedBox(height: 10.h),
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
                    itemCount: listAllKadernici.length,
                    itemBuilder: (BuildContext context, int index) {
                      HairdresserCardAdmin card = HairdresserCardAdmin(
                        kadernik: listAllKadernici[index],
                        listAllKadernickeUkony: listAllKadernickeUkony,
                        listAllLokace: listAllLokace,
                        saveKadernik: saveKadernik,
                        deleteKadernik: deleteKadernik,
                      );
                      return card;
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
  final List<Lokace> listAllLokace;
  final List<KadernickyUkon> listAllKadernickeUkony;

  const _NactenaData({
    required this.listAllKadernici,
    required this.listAllLokace,
    required this.listAllKadernickeUkony,
  });
}
