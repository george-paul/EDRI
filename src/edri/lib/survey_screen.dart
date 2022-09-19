import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyScreenState createState() => _SurveyScreenState();
}

const dummyTabsLength = 10;

class _SurveyScreenState extends State<SurveyScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Tab> tabs = List.generate(dummyTabsLength, (index) {
    return Tab(
      text: "Step ${index + 1}",
    );
  });
  List<Widget> tabViews = List.generate(dummyTabsLength, (index) {
    return Center(
      child: Text(
        "Step ${index + 1}",
        style: const TextStyle(fontSize: 40),
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dummyTabsLength,
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
