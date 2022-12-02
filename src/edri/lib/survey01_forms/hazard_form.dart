import 'package:flutter/material.dart';
import '../util.dart';

class Hazard extends StatefulWidget {
  const Hazard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HazardState createState() => _HazardState();
}

class _HazardState extends State<Hazard> {
  List<Pair<bool, String>> hazardOptions = [
    Pair(false, "Liquefaction"),
    Pair(false, "Rockfall"),
    Pair(false, "Fire"),
    Pair(false, "Landslide"),
  ];
  String selectedHazards = "";

  void setSelectedHazards() {
    selectedHazards = "";
    for (var opt in hazardOptions) {
      if (opt.a) {
        selectedHazards += "${opt.b}, ";
      }
    }
    if (selectedHazards.length > 2) {
      selectedHazards = selectedHazards.substring(0, selectedHazards.length - 2);
    } else {
      selectedHazards = "None";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.all(20),
          title: Text(
            "Collateral",
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            selectedHazards,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          children: List.generate(hazardOptions.length, (index) {
            return CheckboxListTile(
              title: Text(hazardOptions[index].b),
              value: hazardOptions[index].a,
              onChanged: (val) {
                setState(() {
                  hazardOptions[index].a = val ?? false;
                  setSelectedHazards();
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
