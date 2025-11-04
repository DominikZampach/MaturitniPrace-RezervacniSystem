import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/bookmycut_logo.dart';
import 'package:rezervacni_system_maturita/widgets/navbar_item.dart';
import 'package:rezervacni_system_maturita/widgets/side_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onNavbarItemSelected(int index) {
    //? Callback funkce, kterou pošlu HomePage->Navbar->Navbar_Item, aby se po kliknutí změnil index tady!
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constrains) {
          double width = constrains.maxWidth;
          double height = constrains.maxHeight;

          final double verticalPadding = 10;
          final double horizontalPadding = 10;

          return Row(
            children: [
              SideNavbar(
                width: width,
                verticalPadding: verticalPadding,
                horizontalPadding: horizontalPadding,
                selectedIndex: selectedIndex,
                onItemSelect: onNavbarItemSelected,
              ),
              _body(),
            ],
          );
        },
      ),
      appBar: AppBar(
        leading: null,
        toolbarHeight: 0,
      ), // Pouze na odstranění šipky zpět
    );
  }

  Expanded _body() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DatabaseService dbService = DatabaseService();
                    await dbService.getUser();
                  },
                  child: Text("TEST Database"),
                ),
                Text("Nigga"),
              ],
            ),
            Column(),
          ],
        ),
      ),
    );
  }
}
