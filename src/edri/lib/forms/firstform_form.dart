import 'package:flutter/material.dart';

class FirstForm extends StatefulWidget {
  const FirstForm({Key? key}) : super(key: key);

  @override
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
