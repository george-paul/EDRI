import 'package:edri/global_data.dart';
import 'package:edri/survey01_forms/survey01_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

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
      // -------------- Survey 01 --------------
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
      // -------------- Survey 02 --------------
      case 2:
        tabViews = [];
        tabTitles = [];
        break;
      // -------------- Survey 03 --------------
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
    return WillPopScope(
      onWillPop: () async {
        if (GetIt.I<GlobalData>().cameraOpen) {
          return false;
        } else {
          return true;
        }
      },
      child: DefaultTabController(
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () {
              GetIt.I<Survey01Data>().testPrint();
            },
          ),
        ),
      ),
    );
  }
}
