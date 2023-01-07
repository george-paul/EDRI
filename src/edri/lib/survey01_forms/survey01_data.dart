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
  int fsi = -1;
  int fsiAllowable = -1;

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
}
