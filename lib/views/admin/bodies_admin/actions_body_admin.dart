import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/kadernicky_ukon.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/admin/actions/create_action.dart';
import 'package:rezervacni_system_maturita/views/admin/actions/action_card_admin.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class ActionsBodyAdmin extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const ActionsBodyAdmin({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<ActionsBodyAdmin> createState() => _ActionsBodyAdminState();
}

class _ActionsBodyAdminState extends State<ActionsBodyAdmin> {
  late Future<List<KadernickyUkon>> futureLogika;

  Future<List<KadernickyUkon>> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<KadernickyUkon> listAllKadernickeUkony = await dbService
        .getAllKadernickeUkony();

    return listAllKadernickeUkony;
  }

  @override
  void initState() {
    super.initState();
    futureLogika = _nacteniDat();
  }

  @override
  void dispose() {
    super.dispose();
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

        final double cardFontSize = 11.sp;
        final double buttonFontSize = 12.sp;
        final double smallerButtonFontSize = 10.sp;
        final double h1FontSize = 18.sp;
        final double h2FontSize = 15.sp;

        List<KadernickyUkon> listAllKadernickeUkony = snapshot.data!;

        List<KadernickyUkon> listAllMaleKadernickeUkony = [];
        List<KadernickyUkon> listAllFemaleKadernickeUkony = [];

        //? Aktualizace listů s dámskými/pánskými actions
        void updateGenderLists() {
          listAllMaleKadernickeUkony = listAllKadernickeUkony
              .where((x) => x.typStrihuPodlePohlavi == "male")
              .toList();
          listAllFemaleKadernickeUkony = listAllKadernickeUkony
              .where((x) => x.typStrihuPodlePohlavi == "female")
              .toList();
          listAllMaleKadernickeUkony.sort((a, b) => a.nazev.compareTo(b.nazev));
          listAllFemaleKadernickeUkony.sort(
            (a, b) => a.nazev.compareTo(b.nazev),
          );
        }

        updateGenderLists();

        dynamic saveUkon(KadernickyUkon updatedUkon) async {
          DatabaseService dbService = DatabaseService();
          await dbService.updateUkon(updatedUkon);

          int ukonId = listAllKadernickeUkony.indexWhere(
            (item) => item.id == updatedUkon.id,
          );

          setState(() {
            listAllKadernickeUkony[ukonId] = updatedUkon;
            updateGenderLists();
          });
        }

        dynamic deleteUkon(String ukonId) async {
          DatabaseService dbService = DatabaseService();
          int lokaceIndex = listAllKadernickeUkony.indexWhere(
            (item) => item.id == ukonId,
          );
          await dbService.deleteKadernickyUkon(ukonId);

          setState(() {
            listAllKadernickeUkony.removeAt(lokaceIndex);
            updateGenderLists();
          });
        }

        dynamic addUkon(KadernickyUkon ukonBezId) async {
          DatabaseService dbService = DatabaseService();
          KadernickyUkon? ukonWithId = await dbService.createNewKadernickyUkon(
            ukonBezId,
          );
          if (ukonWithId != null) {
            setState(() {
              listAllKadernickeUkony.add(ukonWithId);
              updateGenderLists();
            });
          }
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
                  "All Actions",
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
                          CreateActionDialog(addUkon: addUkon),
                    );
                  },
                  label: Text(
                    "Add Action",
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
                //? Zobrazení pánských střihů + aktivit
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 150.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "All Male Actions",
                          style: TextStyle(
                            fontSize: h2FontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                          childAspectRatio: 7,
                        ),
                        itemCount: listAllMaleKadernickeUkony.length,
                        itemBuilder: (BuildContext context, int index) {
                          ActionCardAdmin card = ActionCardAdmin(
                            ukon: listAllMaleKadernickeUkony[index],
                            saveUkon: saveUkon,
                            deleteUkon: deleteUkon,
                          );
                          return card;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 150.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "All Female Actions",
                          style: TextStyle(
                            fontSize: h2FontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                          childAspectRatio: 7,
                        ),
                        itemCount: listAllFemaleKadernickeUkony.length,
                        itemBuilder: (BuildContext context, int index) {
                          ActionCardAdmin card = ActionCardAdmin(
                            ukon: listAllFemaleKadernickeUkony[index],
                            saveUkon: saveUkon,
                            deleteUkon: deleteUkon,
                          );
                          return card;
                        },
                      ),
                    ],
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
