import 'package:flutter/material.dart';
import 'package:rezervacni_system_maturita/services/database_service.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseService().getUser();
                  },
                  child: Text("TEST Database"),
                ),
              ],
            ),
            Column(),
          ],
        ),
      ),
    );
  }
}
