import 'package:edri/survey01_forms/survey01_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';

class S01InspectorDetailsForm extends StatefulWidget {
  const S01InspectorDetailsForm({Key? key}) : super(key: key);

  @override
  State<S01InspectorDetailsForm> createState() => _S01InspectorDetailsFormState();
}

class _S01InspectorDetailsFormState extends State<S01InspectorDetailsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController inspIDCtl = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController coordsCtl = TextEditingController();
  bool isLoadingLocation = false;

  @override
  void initState() {
    dateCtl.text = DateTime.now().toIso8601String().substring(0, 10);
    timeCtl.text = DateTime.now().toIso8601String().substring(11, 16);
    GetIt.I<Survey01Data>().inspDate = dateCtl.text;
    GetIt.I<Survey01Data>().inspTime = timeCtl.text;

    super.initState();
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: "Please enable location services");
        return null;
      }
    }

    PermissionStatus permissionGranted;
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Fluttertoast.showToast(msg: "Please grant access to location data");
        return null;
      }
    }
    if (permissionGranted == PermissionStatus.deniedForever) {
      Fluttertoast.showToast(msg: "Please grant access to location data in app settings");
      return null;
    }

    LocationData locationData;
    locationData = await location.getLocation();
    return locationData;
  }

  Widget buildGetLocationButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoadingLocation = true;
        });
        LocationData? location = await getLocation();
        if (location != null) {
          coordsCtl.text = "${location.latitude!.toStringAsFixed(5)}, ${location.longitude!.toStringAsFixed(5)}";
          GetIt.I<Survey01Data>().coords = coordsCtl.text;
        }
        setState(() {
          isLoadingLocation = false;
        });
      },
      child: Visibility(
        visible: !isLoadingLocation,
        replacement: SizedBox(
          width: Theme.of(context).textTheme.button!.fontSize,
          height: Theme.of(context).textTheme.button!.fontSize,
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        child: const Text("Get Location"),
      ),
    );
  }

  TextFormField buildCoords() {
    return TextFormField(
      readOnly: true,
      controller: coordsCtl,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.location_on),
        labelText: "GPS Position",
      ),
    );
  }

  TextFormField buildInspID() {
    return TextFormField(
      onChanged: (val) {
        GetIt.I<Survey01Data>().inspID = val;
      },
      controller: inspIDCtl,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.person),
        labelText: "Inspector ID",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      // siddharth: why scrollbar
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AutofillGroup(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Column(
                children: [
                  buildInspID(),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (val) {},
                    readOnly: true,
                    controller: dateCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.date_range),
                      labelText: "Inspector Date",
                    ),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      // siddharth: why request focus
                      // FocusScope.of(context).requestFocus(FocusNode());
                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        dateCtl.text = date.toIso8601String().substring(0, 10);
                        GetIt.I<Survey01Data>().inspDate = dateCtl.text;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    readOnly: true,
                    controller: timeCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.lock_clock),
                      labelText: "Inspection Time",
                    ),
                    onTap: () async {
                      TimeOfDay time = TimeOfDay.now();
                      // FocusScope.of(context).requestFocus(new FocusNode());
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );

                      // siddharth: why picked != time
                      if (picked != null && picked != time) {
                        // can ignore this prblem because localisation shouldn't change across this async gap
                        // ignore: use_build_context_synchronously
                        timeCtl.text = picked.format(context);
                        GetIt.I<Survey01Data>().inspTime = timeCtl.text;
                        setState(() {
                          time = picked;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'cant be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  buildGetLocationButton(),
                  const SizedBox(height: 20),
                  buildCoords(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
