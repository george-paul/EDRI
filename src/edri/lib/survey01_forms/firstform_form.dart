import 'package:flutter/material.dart';

class FirstForm extends StatefulWidget {
  const FirstForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FirstFormState createState() => _FirstFormState();
}

class _FirstFormState extends State<FirstForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("New Form"),
      ),
    );
  }
}
