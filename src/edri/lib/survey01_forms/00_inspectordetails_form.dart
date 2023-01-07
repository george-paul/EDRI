import 'package:edri/survey01_forms/survey01_data.dart';
import 'package:edri/util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InspectorDetailsForm extends StatefulWidget {
  const InspectorDetailsForm({Key? key}) : super(key: key);

  @override
  State<InspectorDetailsForm> createState() => _InspectorDetailsFormState();
}

class _InspectorDetailsFormState extends State<InspectorDetailsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController inspIDCtl = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();

  @override
  void initState() {
    dateCtl.text = DateTime.now().toIso8601String().substring(0, 10);
    timeCtl.text = DateTime.now().toIso8601String().substring(11, 16);
    GetIt.I<Survey01Data>().inspDate = dateCtl.text;
    GetIt.I<Survey01Data>().inspTime = timeCtl.text;

    super.initState();
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
                  TextFormField(
                    onChanged: (val) {
                      GetIt.I<Survey01Data>().inspID = val;
                    },
                    controller: inspIDCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      labelText: "Inspector ID",
                    ),
                  ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
