import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'util.dart';

class SurveyCard extends StatelessWidget {
  final int surveyNumber;

  const SurveyCard({Key? key, required this.surveyNumber}) : super(key: key);

  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(20.0));

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/survey", arguments: [surveyNumber]);
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          child: Row(
            children: [
              // ignore: unnecessary_brace_in_string_interps
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: imageSize,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset("assets/images/surveyImage${surveyNumber}.png"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  surveyTitles[surveyNumber],
                  style: Theme.of(context).textTheme.subtitle1,
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
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          SurveyCard(
            surveyNumber: 1,
          ),
          SurveyCard(
            surveyNumber: 2,
          ),
          SurveyCard(
            surveyNumber: 3,
          ),
        ],
      ),
    );
  }
}
