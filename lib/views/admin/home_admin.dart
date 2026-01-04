import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/views/admin/bodies_widget_tree_admin.dart';
import 'package:rezervacni_system_maturita/widgets/side_navbar.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
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
                isAdmin: true, //? Informace pro widget, že chci adminskou verzi
              ),
              Expanded(
                child: WidgetTreeBodiesAdmin(
                  selectedIndex: selectedIndex,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
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
