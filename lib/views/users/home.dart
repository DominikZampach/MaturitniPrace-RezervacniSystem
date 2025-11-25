import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/views/users/bodies/bodies_widget_tree.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constrains) {
          double screenWidth = constrains.maxWidth;
          double screenHeight = constrains.maxHeight;

          final double verticalPadding = 10;
          final double horizontalPadding = 10;

          return Row(
            children: [
              SideNavbar(
                width: screenWidth,
                verticalPadding: verticalPadding,
                horizontalPadding: horizontalPadding,
                selectedIndex: selectedIndex,
                onItemSelect: onNavbarItemSelected,
              ),
              MainBody(
                selectedIndex: selectedIndex,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            ],
          );
        },
      ),
      appBar: AppBar(
        leading: null,
        toolbarHeight: 0,
      ), //? Pouze na odstranění šipky zpět
    );
  }
}
