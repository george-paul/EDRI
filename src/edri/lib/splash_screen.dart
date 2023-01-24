import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(20.0));

  late FirebaseAuth auth;

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox.expand(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, (auth.currentUser == null) ? "/login_screen" : "/survey_selection");
          },
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Spacer(flex: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight / 6,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Image.asset("assets/images/surveyImage1.png"),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      height: screenHeight / 6,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Image.asset("assets/images/surveyImage2.png"),
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 1),
                Text(
                  "EDRI",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: "Arvo",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(flex: 1),
                SizedBox(
                  height: screenHeight / 6,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset("assets/images/surveyImage3.png"),
                  ),
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
