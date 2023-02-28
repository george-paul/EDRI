import 'package:edri/survey01_forms/survey01_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../util.dart';

class S01GroundShakingForm extends StatefulWidget {
  const S01GroundShakingForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _S01GroundShakingFormState createState() => _S01GroundShakingFormState();
}

class _S01GroundShakingFormState extends State<S01GroundShakingForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));

  //
  // -------------------------------------- Collateral Damage --------------------------------------
  //

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
      selectedHazards = "None";
    }
  }

  ExpansionTileCard buildCollatDamageSelector(BuildContext context) {
    return ExpansionTileCard(
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
              GetIt.I<Survey01Data>().hazardOptions[index] = val ?? false;
              setState(() {
                hazardOptions[index].a = val ?? false;
                setSelectedHazards();
                GetIt.I<Survey01Data>().selectedHazards = selectedHazards;
              });
            },
          );
        }),
      ),
    );
  }

  //
  // -------------------------------------- Zone Factor --------------------------------------
  //
  List<Pair<bool, String>> zoneFactorOptions = [
    Pair(false, "Zone-II"),
    Pair(false, "Zone-III"),
    Pair(false, "Zone-IV"),
    Pair(false, "Zone-V"),
  ];
  int? selectedZoneFactor;

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
          (selectedZoneFactor != null) ? zoneFactorOptions[selectedZoneFactor!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(zoneFactorOptions.length, (index) {
          return RadioListTile(
            title: Text(zoneFactorOptions[index].b),
            groupValue: selectedZoneFactor,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().zoneFactor = val as int;
              setState(() {
                selectedZoneFactor = val;
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
    Pair(false, "Hard Rock"),
    Pair(false, "Medium Soil"),
    Pair(false, "Soft Soil"),
  ];
  int? selectedSoilType;

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
          (selectedSoilType != null) ? soilTypeOptions[selectedSoilType!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(soilTypeOptions.length, (index) {
          return RadioListTile(
            title: Text(soilTypeOptions[index].b),
            groupValue: selectedSoilType,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().soilType = val as int;
              setState(() {
                selectedSoilType = val;
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) {
                int? parsedInt = int.tryParse(val);
                if (parsedInt != null) {
                  GetIt.I<Survey01Data>().numberOfStoreys = parsedInt;
                }
              },
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

  // call with index == -1 to take an extra picture
  void takeStructureViewPicture(int index) async {
    final XFile? xImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xImg == null) {
      Fluttertoast.showToast(msg: "Could not take image");
      return;
    }

    // for non FLRB pictures
    if (index == -1) {
      GetIt.I<Survey01Data>().pictures.add(null);
      index = extraPictureNumber + 4;
    }

    GetIt.I<Survey01Data>().pictures[index] = xImg;

    if (index <= 3) {
      GetIt.I<Survey01Data>().picturesTaken[index] = true;
      setState(() {
        hasTakenPicture[index] = true;
      });
    } else {
      // extra picture
      GetIt.I<Survey01Data>().extraPicturesNumber++;
      setState(() {
        extraPictureNumber++;
      });
    }
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

  //                              T      L      R      B
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

  //
  // -------------------------------------- Extra Pictures --------------------------------------
  //

  int extraPictureNumber = 0;

  Widget buildExtraPictures() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text("Number of extra views added: ", style: Theme.of(context).textTheme.headline6),
                ),
                const SizedBox(width: 20),
                Text(extraPictureNumber.toString(), style: Theme.of(context).textTheme.headline6),
                const SizedBox(width: 60),
                FloatingActionButton(
                  onPressed: () {
                    takeStructureViewPicture(-1);
                  },
                  child: const Icon(Icons.camera_enhance_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // -------------------------------------- Build --------------------------------------
  //

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildCollatDamageSelector(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 40.0, 20.0, 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Ground Shaking", style: Theme.of(context).textTheme.headline5),
              ),
            ),
            buildZoneFactor(),
            const SizedBox(height: 20),
            buildSoilType(),
            const SizedBox(height: 20),
            buildNumberOfStoreys(),
            const SizedBox(height: 20),
            buildViewsOfStructure(),
            const SizedBox(height: 20),
            buildExtraPictures(),
          ],
        ),
      ),
    );
  }
}
