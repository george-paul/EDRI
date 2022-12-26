import 'package:flutter/material.dart';
import '../util.dart';

class ExposureForm extends StatefulWidget {
  const ExposureForm({Key? key}) : super(key: key);

  @override
  _ExposureFormState createState() => _ExposureFormState();
}

class _ExposureFormState extends State<ExposureForm> {
  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));

  //
  // ----------------------------- Importance Selector -----------------------------
  //
  List<Pair<bool, String>> importanceOptions = [
    Pair(false, "Residence"),
    Pair(false, "Office"),
    Pair(false, "Commercial"),
  ];
  int selectedImportance = 0;

  Widget buildImportanceSelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Zone Factor",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          importanceOptions[selectedImportance].b,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(importanceOptions.length, (index) {
          return RadioListTile(
            title: Text(importanceOptions[index].b),
            groupValue: selectedImportance,
            value: index,
            onChanged: (val) {
              setState(() {
                selectedImportance = val as int;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // ----------------------------- Floor Space Index -----------------------------
  //
  TextEditingController fsiCtl = TextEditingController();

  // TODO: deal with inability to parseint
  Widget buildFSIField() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FSI (Floor Space Index)",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter a number",
              ),
              controller: fsiCtl,
            ),
          ],
        ),
      ),
    );
  }

  //
  // ----------------------------- Floor Space Index (allowed) -----------------------------
  //
  TextEditingController fsiAllowableCtl = TextEditingController();

  // TODO: deal with inability to parseint
  Widget buildFSIAllowableField() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FSI (Floor Space Index) Allowable",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter a number",
              ),
              controller: fsiAllowableCtl,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildImportanceSelector(),
            const SizedBox(height: 20),
            buildFSIField(),
            const SizedBox(height: 20),
            buildFSIAllowableField(),
          ],
        ),
      ),
    );
  }
}
