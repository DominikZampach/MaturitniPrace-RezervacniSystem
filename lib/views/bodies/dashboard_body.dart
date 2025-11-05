import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  Future<List<Object?>> nacteniDat() async {
    List<Object?> nacteneObjekty = [];

    nacteneObjekty.add(await DatabaseService().getUzivatel());
    //? Tady pak můžu přidat další věci, které se mají načíst při spuštění této obrazovky!s

    return nacteneObjekty;
  }

  @override
  Widget build(BuildContext context) {
    //? Builder, který zajistí, že se načtou data o uživateli před
    return FutureBuilder(
      future: nacteniDat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error occured while trying to load data from database!",
            ),
          );
        } else {
          final List<Object?> data = snapshot.data as List<Object?>;
          final Uzivatel uzivatel = data[0] as Uzivatel;
          return Expanded(
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Hello, ${uzivatel.jmeno} ${uzivatel.prijmeni}.",
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
