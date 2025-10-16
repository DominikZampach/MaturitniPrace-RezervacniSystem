import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/firebase_options.dart';
import 'package:rezervacni_system_maturita/login_widget_tree.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(Firebase.apps);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(980, 776), //Velikost testovacího zařízení
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: true,
          title: "BookMyCut",
          theme: ThemeData(
            fontFamily: "Noto Sans",
            useMaterial3: true,
            colorScheme: Consts.colorScheme,
          ),
          initialRoute: '/',
          routes: {},
          home: child,
        );
      },
      child: LoginWidgetTree(),
    );
  }
}
