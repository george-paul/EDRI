import 'package:edri/util.dart';

class Survey01Data {
  // form 00
  String inspID = "";
  String inspDate = "";
  String inspTime = "";

  // form 01
  List<bool> hazardOptions = [false, false, false, false];

  // form 02
  int zoneFactor = -1;
  int soilType = -1;
  int numberOfStoreys = -1;
  List<bool> picturesTaken = [false, false, false, false];

  // form 03
  int importance = -1;
  double fsi = -1;
  double fsiAllowable = -1;

  void testPrint() {
    greenDBG(inspID);
    greenDBG(inspDate);
    greenDBG(inspTime);
    greenDBG("---");
    greenDBG(hazardOptions.toString());
    greenDBG("---");
    greenDBG(zoneFactor.toString());
    greenDBG(soilType.toString());
    greenDBG(numberOfStoreys.toString());
    greenDBG(picturesTaken.toString());
    greenDBG("---");
    greenDBG(importance.toString());
    greenDBG(fsi.toString());
    greenDBG(fsiAllowable.toString());
  }

  double calcEDRI() {
    //
    //----------------------------- Hazard -----------------------------
    //

    if (!List.of(<int>[1, 2, 3, 4]).contains(zoneFactor)) throw Exception("Invalid Zone Factor");
    // ----------------------- Zone -- II -- III -- IV -- V
    double valZ = List.of(<double>[0, 0.10, 0.16, 0.24, 0.36])[zoneFactor];

    if (!List.of(<int>[1, 2, 3]).contains(soilType)) throw Exception("Invalid Soil Factor");
    // ------------------ Soil Type -- hard - med - soft
    double valSta = List.of(<double>[0, 1.0, 1.33, 1.67])[soilType];

    // TODO: What is N (subbed in 10 for now)
    double hb = valZ * ((2.5 < (20 / 10) * valSta) ? 2.5 : (20 / 10) * valSta);

    //
    //----------------------------- Exposure -----------------------------
    //

    if (!List.of(<int>[1, 2, 3]).contains(importance)) throw Exception("Invalid Importance");
    // ----------------- Importance -- res - off - com
    double valImp = List.of(<double>[0, 1.0, 1.25, 1.5])[importance];
    double eb = valImp * fsi;

    return 0;
  }
}
