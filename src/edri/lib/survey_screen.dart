import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'util.dart';
import 'survey01_forms/survey01_export.dart';

class SurveyScreen extends StatefulWidget {
  final int surveyNumber;

  const SurveyScreen({Key? key, required this.surveyNumber}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<Widget> tabViews = [];
  List<String> tabTitles = [];

  List<Tab> tabs = [];

  @override
  void initState() {
    switch (widget.surveyNumber) {
      case 1:
        tabViews = [
          const InspectorDetailsForm(),
          const HazardForm(),
          const GroundShakingForm(),
          const ExposureForm(),
          const VulnerabilityForm(),
        ];
        tabTitles = [
          "Inspector Details",
          "Hazard",
          "Ground Shaking",
          "Exposure",
          "Vulnerability",
        ];
        break;
      case 2:
        tabViews = [];
        tabTitles = [];
        break;
      case 3:
        tabViews = [];
        tabTitles = [];
        break;
      default:
    }

    tabs = List.generate(tabViews.length, (index) {
      return Tab(
        text: tabTitles[index],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("EDRI - ${surveyTitles[widget.surveyNumber]}"),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut();
                Fluttertoast.showToast(msg: "Signed Out.");
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }
}
