import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'survey01_forms/survey01_forms.dart';

import 'util.dart';

class SurveyScreen extends StatefulWidget {
  final int surveyNumber;

  const SurveyScreen({Key? key, required this.surveyNumber}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Widget> tabViews = [];

  List<Tab> tabs = [];

  @override
  void initState() {
    switch (widget.surveyNumber) {
      case 1:
        tabViews = [
          const InspectorDetails(),
          const FirstForm(),
        ];
        break;
      case 2:
        tabViews = [
          const InspectorDetails(),
          const FirstForm(),
        ];
        break;
      case 3:
        tabViews = [
          const InspectorDetails(),
          const FirstForm(),
        ];
        break;
      default:
    }

    tabs = List.generate(tabViews.length, (index) {
      return Tab(
        text: "Step ${index + 1}",
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
