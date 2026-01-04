import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/services/auth_service.dart';
import 'package:rezervacni_system_maturita/widgets/bookmycut_logo.dart';
import 'package:rezervacni_system_maturita/widgets/navbar_item.dart';

class SideNavbar extends StatelessWidget {
  final double width;
  final double verticalPadding;
  final double horizontalPadding;
  final int selectedIndex;
  final Function(int) onItemSelect;
  final bool isAdmin;

  const SideNavbar({
    super.key,
    required this.width,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.selectedIndex,
    required this.onItemSelect,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    //? Zobrazení adminského side_navbaru
    if (isAdmin) {
      return SizedBox(
        height: double.infinity,
        width: width * 0.12,
        child: Container(
          color: Consts.background,
          padding: EdgeInsets.all(width * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BookMyCutLogo(
                    size: 75.w,
                    clickFunction: () {
                      ToastClass.showToastSnackbar(
                        message: "You clicked on logo",
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  NavbarItem(
                    verticalPadding: 10,
                    text: "Hairdressers",
                    isSelected: selectedIndex == 0,
                    onClick: () => onItemSelect(0),
                  ),
                  NavbarItem(
                    verticalPadding: 10,
                    text: "Locations",
                    isSelected: selectedIndex == 1,
                    onClick: () => onItemSelect(1),
                  ),
                  NavbarItem(
                    verticalPadding: 10,
                    text: "Actions",
                    isSelected: selectedIndex == 2,
                    onClick: () => onItemSelect(2),
                  ),
                  NavbarItem(
                    verticalPadding: 10,
                    text: "Reservations",
                    isSelected: selectedIndex == 3,
                    onClick: () => onItemSelect(3),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().logout(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Consts.error.withValues(alpha: 0.7),
                  ),
                  fixedSize: WidgetStatePropertyAll(Size(80.w, 40.h)),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black, fontSize: 13.sp),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: double.infinity,
      width: width * 0.12,
      child: Container(
        color: Consts.background,
        padding: EdgeInsets.all(width * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BookMyCutLogo(
                  size: 75.w,
                  clickFunction: () {
                    ToastClass.showToastSnackbar(
                      message: "You clicked on logo",
                    );
                  },
                ),
                SizedBox(height: 20),
                NavbarItem(
                  verticalPadding: 10,
                  text: "Dashboard",
                  isSelected: selectedIndex == 0,
                  onClick: () => onItemSelect(0),
                ),
                NavbarItem(
                  verticalPadding: 10,
                  text: "Reservations",
                  isSelected: selectedIndex == 1,
                  onClick: () => onItemSelect(1),
                ),
                NavbarItem(
                  verticalPadding: 10,
                  text: "Browse",
                  isSelected: selectedIndex == 2,
                  onClick: () => onItemSelect(2),
                ),
              ],
            ),
            NavbarItem(
              verticalPadding: verticalPadding,
              text: "Settings",
              isSelected: selectedIndex == 3,
              onClick: () => onItemSelect(3),
            ),
          ],
        ),
      ),
    );
  }
}
