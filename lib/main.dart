import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rezervacni_system_maturita/firebase_options.dart';
import 'package:rezervacni_system_maturita/login_widget_tree.dart';
import 'package:rezervacni_system_maturita/models/consts.dart';
import 'package:rezervacni_system_maturita/widgets/loading_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LoadingWidget()); //? Dočasná aplikace s loaderem

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(Firebase.apps);

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(980, 776), //Velikost testovacího zařízení
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: (old, data) => old.size != data.size, //RebuildFactors.all
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: true,
          title: "BookMyCut",
          theme: ThemeData(
            //? Font jsem smazal možná dát nový, teď už funkční?
            useMaterial3: true,
            colorScheme: Consts.colorScheme,
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('cs', ''), Locale('en', '')],
          locale: Locale("cs", ''),
          home: child,
        );
      },
      child: LoginWidgetTree(),
    );
  }
}
