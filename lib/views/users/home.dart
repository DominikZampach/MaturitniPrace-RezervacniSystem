import 'package:firebase_core_web/firebase_core_web_interop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/views/users/Desktop/bodies/bodies_widget_tree.dart';
import 'package:rezervacni_system_maturita/views/users/Mobile/bodies_mobile/bodies_widget_tree_mobile.dart';
import 'package:rezervacni_system_maturita/widgets/side_navbar.dart';
import 'package:rezervacni_system_maturita/widgets/side_navbar_mobile_drawer.dart';

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
    return LayoutBuilder(
      builder: (context, constrains) {
        double screenWidth = constrains.maxWidth;
        double screenHeight = constrains.maxHeight;
        bool isMobile = constrains.maxWidth < 800;

        final double verticalPadding = 10;
        final double horizontalPadding = 10;

        final double appBarTitleFontSize = 40.sp;

        Widget body;
        AppBar appBar;
        Drawer? drawer;

        if (isMobile) {
          body = scaffoldBodyMobile(screenWidth, screenHeight);
          appBar = _appBarMobile(appBarTitleFontSize);
          drawer = _drawer_mobile(verticalPadding, context);
        } else {
          body = _scaffoldBodyDesktop(
            screenWidth,
            verticalPadding,
            horizontalPadding,
            screenHeight,
          );
          appBar = _appBarDesktop();
          drawer = null;
        }

        return Scaffold(body: body, appBar: appBar, drawer: drawer);
      },
    );
  }

  Drawer _drawer_mobile(double verticalPadding, BuildContext context) {
    return Drawer(
      child: SideNavbarMobileDrawer(
        width: 400.w,
        verticalPadding: verticalPadding,
        selectedIndex: selectedIndex,
        onItemSelect: (index) {
          onNavbarItemSelected(index);
          Navigator.pop(context); // Zavře Drawer po kliknutí
        },
      ),
    );
  }

  Expanded scaffoldBodyMobile(double screenWidth, double screenHeight) {
    return Expanded(
      child: BodiesWidgetTreeMobile(
        selectedIndex: selectedIndex,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      ),
    );
  }

  Row _scaffoldBodyDesktop(
    double screenWidth,
    double verticalPadding,
    double horizontalPadding,
    double screenHeight,
  ) {
    return Row(
      children: [
        SideNavbar(
          width: screenWidth,
          verticalPadding: verticalPadding,
          horizontalPadding: horizontalPadding,
          selectedIndex: selectedIndex,
          onItemSelect: onNavbarItemSelected,
        ),
        Expanded(
          child: BodiesWidgetTreeDesktop(
            selectedIndex: selectedIndex,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
        ),
      ],
    );
  }

  AppBar _appBarDesktop() {
    return AppBar(
      leading: null,
      toolbarHeight: 0, //? Pouze na odstranění šipky zpět
    );
  }

  AppBar _appBarMobile(double fontSize) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "BookMyCut",
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
