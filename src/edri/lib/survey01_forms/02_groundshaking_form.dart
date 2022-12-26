import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import '../camera_screen.dart';
import '../util.dart';

class GroundShakingForm extends StatefulWidget {
  const GroundShakingForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GroundShakingFormState createState() => _GroundShakingFormState();
}

class _GroundShakingFormState extends State<GroundShakingForm> {
  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));

  //
  // -------------------------------------- Zone Factor --------------------------------------
  //
  List<Pair<bool, String>> zoneFactorOptions = [
    Pair(false, "None"),
    Pair(false, "Zone-II"),
    Pair(false, "Zone-III"),
    Pair(false, "Zone-IV"),
    Pair(false, "Zone-V"),
  ];
  int selectedZoneFactor = 0;

  Widget buildZoneFactor() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Zone Factor",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          zoneFactorOptions[selectedZoneFactor].b,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(zoneFactorOptions.length, (index) {
          return RadioListTile(
            title: Text(zoneFactorOptions[index].b),
            groupValue: selectedZoneFactor,
            value: index,
            onChanged: (val) {
              setState(() {
                selectedZoneFactor = val as int;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // -------------------------------------- Soil Type --------------------------------------
  //
  List<Pair<bool, String>> soilTypeOptions = [
    Pair(false, "None"),
    Pair(false, "Hard Rock"),
    Pair(false, "Medium Soil"),
    Pair(false, "Soft Soil"),
  ];
  int selectedSoilType = 0;

  Widget buildSoilType() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Soil Type",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          soilTypeOptions[selectedSoilType].b,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(soilTypeOptions.length, (index) {
          return RadioListTile(
            title: Text(soilTypeOptions[index].b),
            groupValue: selectedSoilType,
            value: index,
            onChanged: (val) {
              setState(() {
                selectedSoilType = val as int;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // -------------------------------------- Number of Storeys --------------------------------------
  //
  TextEditingController storeysCtl = TextEditingController();

  Widget buildNumberOfStoreys() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Number of storeys",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter a number",
              ),
              controller: storeysCtl,
            ),
          ],
        ),
      ),
    );
  }

  //
  // -------------------------------------- Views Of Structure --------------------------------------
  //
  void takeStructureViewPicture(int index) async {
    // TODO: save picture file
    final imgFile = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
    setState(() {
      hasTakenPicture[index] = true;
    });
  }

  Widget cameraButtonIcon({required bool isTicked}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.camera_alt),
        Align(
          alignment: Alignment.bottomRight,
          child: Visibility(
            visible: isTicked,
            child: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  //--------------------------    T      L      R      B
  List<bool> hasTakenPicture = [false, false, false, false];

  Widget buildViewsOfStructure() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Views of the Structure", style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(0);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[0]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(1);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[1]),
                ),
                const Icon(
                  Icons.business_outlined,
                  size: 54,
                ),
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(2);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[2]),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(3);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[3]),
                ),
              ],
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
            buildZoneFactor(),
            const SizedBox(height: 20),
            buildSoilType(),
            const SizedBox(height: 20),
            buildNumberOfStoreys(),
            const SizedBox(height: 20),
            buildViewsOfStructure(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
