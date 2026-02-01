import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/models/lokace.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/views/admin/locations/create_location.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/views/admin/locations/location_card_admin.dart';

class LocationsBodyAdmin extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const LocationsBodyAdmin({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<LocationsBodyAdmin> createState() => _LocationsBodyAdminState();
}

class _LocationsBodyAdminState extends State<LocationsBodyAdmin> {
  late Future<List<Lokace>> futureLogika;

  Future<List<Lokace>> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<Lokace> listAllLokace = await dbService.getAllLokace();

    return listAllLokace;
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

        final double buttonFontSize = Consts.normalFS.sp;
        final double h1FontSize = Consts.h1FS.sp;

        final List<Lokace> listAllLokace = snapshot.data!;

        dynamic saveLokace(Lokace updatedLokace) async {
          DatabaseService dbService = DatabaseService();
          await dbService.updateLokace(updatedLokace);

          int lokaceId = listAllLokace.indexWhere(
            (item) => item.id == updatedLokace.id,
          );

          setState(() {
            listAllLokace[lokaceId] = updatedLokace;
          });
        }

        dynamic deleteLokace(String lokaceId) async {
          DatabaseService dbService = DatabaseService();
          int lokaceIndex = listAllLokace.indexWhere(
            (item) => item.id == lokaceId,
          );
          await dbService.deleteLokace(lokaceId);

          setState(() {
            listAllLokace.removeAt(lokaceIndex);
          });
        }

        dynamic addLokace(Lokace lokaceBezId) async {
          DatabaseService dbService = DatabaseService();
          Lokace? lokaceWithId = await dbService.createNewLokace(lokaceBezId);
          if (lokaceWithId != null) {
            setState(() {
              listAllLokace.add(lokaceWithId);
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
                  "All Locations",
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
                          CreateLocationDialog(addLokace: addLokace),
                    );
                  },
                  label: Text(
                    "Add Location",
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
                    horizontal: 150.w,
                    vertical: 10.h,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.h,
                      childAspectRatio: 6.7,
                    ),
                    itemCount: listAllLokace.length,
                    itemBuilder: (BuildContext context, int index) {
                      LocationCardAdmin card = LocationCardAdmin(
                        lokace: listAllLokace[index],
                        saveLokace: saveLokace,
                        deleteLokace: deleteLokace,
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
