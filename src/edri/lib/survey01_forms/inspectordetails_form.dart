import 'package:flutter/material.dart';

class InspectorDetails extends StatefulWidget {
  const InspectorDetails({Key? key}) : super(key: key);

  @override
  State<InspectorDetails> createState() => _InspectorDetailsState();
}

class _InspectorDetailsState extends State<InspectorDetails> {
  TextEditingController inspIDCtl = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();

  @override
  void initState() {
    dateCtl.text = DateTime.now().toIso8601String().substring(0, 10);
    timeCtl.text = DateTime.now().toIso8601String().substring(11, 16);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: inspIDCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      labelText: "Inspector ID",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
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
                        timeCtl.text = picked.format(context);
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
