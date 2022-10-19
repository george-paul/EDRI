import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'forms.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Widget> tabViews = [
    const InspectorDetails(),
    const FirstForm(),
  ];

  List<Tab> tabs = [];

  @override
  void initState() {
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
          title: const Text("EDRI"),
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
