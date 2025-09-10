import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/firebase_options.dart';
import 'package:rezervacni_system_maturita/login_widget_tree.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: "main",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080), //Velikost testovacího zařízení
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Rezervační systém kadeřnictví",
          theme: ThemeData(
            fontFamily: "Noto Sans",
            useMaterial3: true,
            colorScheme: Consts.colorScheme,
          ),
          home: LoginWidgetTree(),
        );
      },
    );
  }
}
