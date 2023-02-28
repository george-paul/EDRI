import 'package:edri/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'global_data.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // getIt setup
  GetIt.I.registerSingleton<GlobalData>(GlobalData());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    ThemeData darkTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange.shade900,
        brightness: Brightness.dark,
      ),
    ).copyWith(
      scaffoldBackgroundColor: Colors.black,
    );
    // darkTheme = darkTheme.copyWith(scaffoldBackgroundColor: Colors.black);
    // darkTheme = darkTheme.copyWith(tabBarTheme:TabBarTheme());
    ThemeData lightTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange.shade500,
        brightness: Brightness.light,
      ),
    ).copyWith(
      canvasColor: Colors.deepOrange.shade50,
      cardColor: Colors.deepOrange.shade50,
    );

    return MaterialApp(
      title: 'EDRI',
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const SplashScreen(),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/survey_selection": (context) => const SurveySelectionScreen(),
      },
      // Routes with Paramaters
      onGenerateRoute: (settings) {
        if (settings.name == "/survey") {
          // give arguments as (surveyNumber)
          final List<int> args = settings.arguments as List<int>;
          final int sNo = args[0];
          return MaterialPageRoute(builder: (_) => SurveyScreen(surveyNumber: sNo));
        } else {
          return MaterialPageRoute(
              builder: (_) => (auth.currentUser == null) ? const LoginScreen() : const SurveySelectionScreen());
        }
      },
    );
  }
}
