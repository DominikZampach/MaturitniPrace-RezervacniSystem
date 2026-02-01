import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/models/uzivatel.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';
import 'package:rezervacni_system_maturita/views/admin/users/user_card_admin.dart';

class UsersBodyAdmin extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const UsersBodyAdmin({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<UsersBodyAdmin> createState() => _UsersBodyAdminState();
}

class _UsersBodyAdminState extends State<UsersBodyAdmin> {
  late Future<List<Uzivatel>> futureLogika;

  Future<List<Uzivatel>> _nacteniDat() async {
    DatabaseService dbService = DatabaseService();

    final List<Uzivatel> allUsersWithoutAdmin = await dbService
        .getAllUsersWithouAdmin();

    return allUsersWithoutAdmin;
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

        final List<Uzivatel> listAllUsers = snapshot.data!;
        //? Sežazení podle přijmení
        listAllUsers.sort((a, b) => a.prijmeni.compareTo(b.prijmeni));

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
                  "All Users",
                  style: TextStyle(
                    fontSize: h1FontSize,
                    fontWeight: FontWeight.bold,
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
                    itemCount: listAllUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserCardAdmin card = UserCardAdmin(
                        uzivatel: listAllUsers[index],
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
