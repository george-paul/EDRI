import 'package:flutter/material.dart';
import '../util.dart';

class HazardForm extends StatefulWidget {
  const HazardForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HazardFormState createState() => _HazardFormState();
}

class _HazardFormState extends State<HazardForm> {
  List<Pair<bool, String>> hazardOptions = [
    Pair(false, "Liquefaction"),
    Pair(false, "Rockfall"),
    Pair(false, "Fire"),
    Pair(false, "Landslide"),
  ];
  String selectedHazards = "None Selected";

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
      selectedHazards = "None Selected";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ExpansionTileCard(
            borderRadius: 20,
            child: ExpansionTile(
              initiallyExpanded: true,
              tilePadding: const EdgeInsets.all(20),
              title: Text(
                "Collateral Damage",
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
          ),
        ),
      ],
    );
  }
}
