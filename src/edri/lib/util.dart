library util;

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

const List<String> surveyTitles = [
  "Survey 00",
  "Survey 01",
  "Survey 02",
  "Survey 03",
];

class Pair<T1, T2> {
  T1 a;
  T2 b;

  Pair(this.a, this.b);
}


// class Util {
//   static void greenDBG(String err) {
//     debugPrint("\x1B[32m $err \x1B[0m");
//   }

//   static void redDBG(String err) {
//     debugPrint("\x1B[31m $err \x1B[0m");
//   }

//   static void yellowDBG(String err) {
//     debugPrint("\x1B[33m $err \x1B[0m");
//   }

//   static Color changeBrightness(Color c, double factor) {
//     Color newC = c;
//     newC = newC.withRed((newC.red * factor).toInt());
//     newC = newC.withGreen((newC.green * factor).toInt());
//     newC = newC.withBlue((newC.blue * factor).toInt());
//     return newC;
//   }

//   static bool isDarkTheme(BuildContext context) {
//     if (Theme.of(context).brightness == Brightness.dark) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   static List<String> surveyTitles = [
//     "Survey 01",
//     "Survey 02",
//     "Survey 03",
//   ];
// }