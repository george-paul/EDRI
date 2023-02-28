library util;

// refactor this file and split up functzons
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';

void greenDBG(String err) {
  debugPrint("\x1B[32m $err \x1B[0m");
}

void redDBG(String err) {
  debugPrint("\x1B[31m $err \x1B[0m");
}

void yellowDBG(String err) {
  debugPrint("\x1B[33m $err \x1B[0m");
}

Color changeBrightness(Color c, double factor) {
  Color newC = c;
  newC = newC.withRed((newC.red * factor).toInt());
  newC = newC.withGreen((newC.green * factor).toInt());
  newC = newC.withBlue((newC.blue * factor).toInt());
  return newC;
}

bool isDarkTheme(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
}

class Pair<T1, T2> {
  T1 a;
  T2 b;

  Pair(this.a, this.b);
}

// custom class to round corners of an expansion tile
class ExpansionTileCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  const ExpansionTileCard({Key? key, required this.child, required this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius br = BorderRadius.all(Radius.circular(borderRadius));

    return ClipRRect(
      borderRadius: br,
      child: Material(
        elevation: 1,
        child: child,
      ),
    );
  }
}

void triggerDownload({required List<int> bytes, required String downloadName}) {
  // Encode our file in base64
  final base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor = AnchorElement(href: 'data:application/octet-stream;base64,$base64')..target = 'blank';
  anchor.download = downloadName;
  // trigger download
  document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}
