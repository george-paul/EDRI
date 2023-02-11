import 'package:edri/global_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'survey01_forms/survey01_export.dart';

class SurveyScreen extends StatefulWidget {
  final int surveyNumber;

  const SurveyScreen({Key? key, required this.surveyNumber}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> with SingleTickerProviderStateMixin {
  List<Widget> tabViews = [];
  List<String> tabTitles = [];

  List<Tab> tabs = [];

  @override
  void initState() {
    tabViews = [
      const S01InspectorDetailsForm(),
      const S01GroundShakingForm(),
      const S01ExposureForm(),
      const S01VulnerabilityForm(),
      const S01SubmitForm(),
    ];
    tabTitles = [
      "Inspector Details",
      "Hazard",
      "Exposure",
      "Vulnerability",
      "Submit",
    ];

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
        child: Builder(builder: (context) {
          // close keyboard on tab change
          final TabController tabController = DefaultTabController.of(context)!;
          tabController.addListener(() {
            FocusManager.instance.primaryFocus?.unfocus();
          });

          // build
          return Scaffold(
            appBar: AppBar(
              title: Text("EDRI - ${surveyTitles[widget.surveyNumber]}"),
              bottom: TabBar(
                isScrollable: true,
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: tabViews,
            ),
          );
        }),
      ),
    );
  }
}
