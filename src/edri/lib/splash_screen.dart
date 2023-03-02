import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
            color: Colors.deepOrange.shade300,
            child: Column(
              children: [
                const Spacer(flex: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight / 6,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Image.asset("assets/images/inai.png"),
                      ),
                    ),
                    const SizedBox(width: 50),
                    SizedBox(
                      height: screenHeight / 6,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Image.asset(
                          "assets/images/ihub.png",
                          // height: screenHeight / 6,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                Text(
                  "EDRI",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: "Arvo",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(flex: 2),
                SizedBox(
                  height: screenHeight / 6,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset(
                      "assets/images/iiit.png",
                      height: screenHeight / 6,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                const Text("Tap to continue"),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
