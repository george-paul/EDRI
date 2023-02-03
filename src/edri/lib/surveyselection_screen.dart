import 'package:edri/survey01_forms/survey01_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'global_data.dart';

class SurveyCard extends StatelessWidget {
  final int surveyNumber;

  const SurveyCard({Key? key, required this.surveyNumber}) : super(key: key);

  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(20.0));

  void getItSetup() {
    GetIt.I<GlobalData>().surveyNumber = surveyNumber;
    if (GetIt.I.isRegistered<Survey01Data>()) {
      GetIt.I.unregister<Survey01Data>();
    }
    GetIt.I.registerSingleton<Survey01Data>(Survey01Data());
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () {
          getItSetup();
          Navigator.pushNamed(context, "/survey", arguments: [surveyNumber]);
        },
        child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          child: Row(
            children: [
              // ignore: unnecessary_brace_in_string_interps
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: imageSize,
                  width: imageSize,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset(
                      "assets/images/surveyImage$surveyNumber.png",
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    surveyTitles[surveyNumber],
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurveySelectionScreen extends StatelessWidget {
  const SurveySelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Survey"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut();
                Fluttertoast.showToast(msg: "Signed Out.");
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: const [
          SurveyCard(
            surveyNumber: 0,
          ),
          SurveyCard(
            surveyNumber: 1,
          ),
          SurveyCard(
            surveyNumber: 2,
          ),
        ],
      ),
    );
  }
}
