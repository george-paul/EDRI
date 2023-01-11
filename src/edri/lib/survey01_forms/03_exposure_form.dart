import 'package:edri/survey01_forms/survey01_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../util.dart';

class ExposureForm extends StatefulWidget {
  const ExposureForm({Key? key}) : super(key: key);

  @override
  _ExposureFormState createState() => _ExposureFormState();
}

class _ExposureFormState extends State<ExposureForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));

  //
  // ----------------------------- Importance Selector -----------------------------
  //
  List<Pair<bool, String>> importanceOptions = [
    Pair(false, "Residence"),
    Pair(false, "Office"),
    Pair(false, "Commercial"),
  ];
  int? selectedImportance;

  Widget buildImportanceSelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Importance",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          (selectedImportance != null) ? importanceOptions[selectedImportance!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(importanceOptions.length, (index) {
          return RadioListTile(
            title: Text(importanceOptions[index].b),
            groupValue: selectedImportance,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().importance = val as int;
              setState(() {
                selectedImportance = val;
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
              onChanged: (val) {
                double? parsed = double.tryParse(val);
                if (parsed != null) {
                  GetIt.I<Survey01Data>().fsi = parsed;
                }
              },
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
              onChanged: (val) {
                double? parsed = double.tryParse(val);
                if (parsed != null) {
                  greenDBG(parsed.toString());
                  GetIt.I<Survey01Data>().fsiAllowable = parsed;
                }
              },
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
    super.build(context);
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
