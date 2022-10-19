import 'package:flutter/material.dart';

class InspectorDetails extends StatefulWidget {
  const InspectorDetails({Key? key}) : super(key: key);

  @override
  State<InspectorDetails> createState() => _InspectorDetailsState();
}

class _InspectorDetailsState extends State<InspectorDetails> {
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person), hintText: "Enter Inspector ID", labelText: "Inspector ID"),
                ),
                TextFormField(
                  readOnly: true,
                  controller: dateCtl,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.date_range), hintText: "Enter Inspection Date", labelText: "Inspector Date"),
                  onTap: () async {
                    DateTime? date = DateTime(1900);
                    FocusScope.of(context).requestFocus(new FocusNode());
                    date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));

                    dateCtl.text = date.toString();
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: timeCtl,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock_clock), hintText: "Enter Inspection Time", labelText: "Inspection Time"),
                  onTap: () async {
                    TimeOfDay time = TimeOfDay.now();
                    FocusScope.of(context).requestFocus(new FocusNode());

                    TimeOfDay? picked = await showTimePicker(context: context, initialTime: time);
                    if (picked != null && picked != time) {
                      timeCtl.text = picked.toString(); // add this line.
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
    );
  }
}
