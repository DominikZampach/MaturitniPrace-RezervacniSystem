import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/logic/showToast.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/widgets/bookmycut_logo.dart';
import 'package:rezervacni_system_maturita/widgets/navbar_item.dart';

class SideNavbarMobileDrawer extends StatelessWidget {
  final double width;
  final double verticalPadding;
  final int selectedIndex;
  final Function(int) onItemSelect;
  const SideNavbarMobileDrawer({
    super.key,
    required this.width,
    required this.verticalPadding,
    required this.selectedIndex,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    double mobileFontSize = Consts.normalFSM.sp;
    double logoSize = 300.w;
    double containerPadding = 5.h;

    return SizedBox(
      height: double.infinity,
      width: width,
      child: Container(
        color: Consts.background,
        padding: EdgeInsets.all(containerPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BookMyCutLogo(
                  size: logoSize,
                  clickFunction: () {
                    ToastClass.showToastSnackbar(
                      message: "You clicked on logo",
                    );
                  },
                ),
                SizedBox(height: 10.h),
                NavbarItem(
                  verticalPadding: verticalPadding,
                  text: "Dashboard",
                  fontSize: mobileFontSize,
                  isSelected: selectedIndex == 0,
                  onClick: () => onItemSelect(0),
                ),
                NavbarItem(
                  verticalPadding: verticalPadding,
                  text: "Reservations",
                  fontSize: mobileFontSize,
                  isSelected: selectedIndex == 1,
                  onClick: () => onItemSelect(1),
                ),
                NavbarItem(
                  verticalPadding: verticalPadding,
                  text: "Browse",
                  fontSize: mobileFontSize,
                  isSelected: selectedIndex == 2,
                  onClick: () => onItemSelect(2),
                ),
              ],
            ),
            NavbarItem(
              verticalPadding: verticalPadding,
              text: "Settings",
              fontSize: mobileFontSize,
              isSelected: selectedIndex == 3,
              onClick: () => onItemSelect(3),
            ),
          ],
        ),
      ),
    );
  }
}
