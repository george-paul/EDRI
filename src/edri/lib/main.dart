import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    );
    darkTheme = darkTheme.copyWith(scaffoldBackgroundColor: Colors.black);
    // darkTheme = darkTheme.copyWith(tabBarTheme:TabBarTheme());
    ThemeData lightTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange.shade700,
        brightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: darkTheme,
      theme: lightTheme,
      home: (auth.currentUser == null) ? const LoginScreen() : const SurveySelectionScreen(),
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
