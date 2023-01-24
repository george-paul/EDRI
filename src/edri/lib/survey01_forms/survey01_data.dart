import 'dart:io';

import 'package:edri/global_data.dart';
import 'package:edri/util.dart';
import 'package:edri/vulnerability_data.dart' as vuln;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Survey01Data {
  // form 00
  String inspID = "";
  String inspDate = "";
  String inspTime = "";

  // form 01
  List<bool> hazardOptions = [false, false, false, false];
  String selectedHazards = "None";

  // form 02
  int zoneFactor = -1;
  int soilType = -1;
  int numberOfStoreys = -1;
  List<bool> picturesTaken = [false, false, false, false];

  // form 03
  int importance = -1;
  double fsi = -1;
  double fsiAllowable = -1;

  // form 04
  static const List<String> ecoVulnElementMask = ["00000000", "11111111", "11111110"];
  static const List<String> lifeVulnElementMask = ["0000000", "1111111", "1110110"];
  List<bool> ecoCheckboxes = [];
  List<bool> lifeCheckboxes = [];

  // form 05
  // bool isLoading = false;

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

  void calcEDRI() async {
    final surveyNumber = GetIt.I<GlobalData>().surveyNumber;

    //
    //----------------------------- Hazard -----------------------------
    //

    if (zoneFactor > 3) {
      Fluttertoast.showToast(msg: "Invalid Zone Factor $zoneFactor");
      return;
    }
    // ----------------------- Zone -- II -- III -- IV -- V
    double valZ = List.of(<double>[0.10, 0.16, 0.24, 0.36])[zoneFactor];
    final stringZoneFactor = List.of(<String>["Zone II", "Zone III", "Zone IV", "Zone V"])[zoneFactor];

    if (soilType > 2) {
      Fluttertoast.showToast(msg: "Invalid Soil Factor");
      return;
    }
    // ------------------ Soil Type -- hard - med - soft
    double valSta = List.of(<double>[1.0, 1.33, 1.67])[soilType];
    final stringSoilType = List.of(<String>["Hard Soil", "Medium Soil", "Soft Soil"])[soilType];

    // TODO: What is N (subbed in 10 for now)
    double hb = valZ * ((2.5 < (20 / 10) * valSta) ? 2.5 : (20 / 10) * valSta);

    //
    //----------------------------- Exposure -----------------------------
    //

    if (importance > 2) {
      Fluttertoast.showToast(msg: "Invalid Importance");
      return;
    }
    // ----------------- Importance -- res - off - com
    double valImp = List.of(<double>[1.0, 1.25, 1.5])[importance];
    double eb = valImp * fsi;

    //
    //----------------------------- Vulnerability -----------------------------
    //
    double vbl = vuln.isLifeThreatening(lifeCheckboxes, lifeVulnElementMask[surveyNumber]);
    double vbe = vuln.economicLoss(ecoCheckboxes, ecoVulnElementMask[surveyNumber]);
    List<vuln.VulnElement> ecoElements =
        vuln.getFormVulnElements(vuln.possibleEconomic, ecoVulnElementMask[surveyNumber]);
    String selectedEco = "";
    for (int i = 0; i < ecoElements.length; i++) {
      if (!ecoCheckboxes[i] && ecoElements[i].runtimeType == vuln.VulnQuestion) {
        selectedEco += "${ecoElements[i].text},\n";
      }
    }
    selectedEco = selectedEco.substring(0, selectedEco.length - 2);
    List<vuln.VulnElement> lifeElements =
        vuln.getFormVulnElements(vuln.possibleLifeThreatening, lifeVulnElementMask[surveyNumber]);
    String selectedLife = "";
    for (int i = 0; i < lifeElements.length; i++) {
      if (!lifeCheckboxes[i] && lifeElements[i].runtimeType == vuln.VulnQuestion) {
        selectedLife += "${lifeElements[i].text},\n";
      }
    }
    selectedLife = selectedLife.substring(0, selectedLife.length - 2);

    //
    //----------------------------- create PDF -----------------------------
    //
    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.base().copyWith(
        header1: pw.TextStyle(
          font: pw.Font.helveticaBold(),
          fontSize: 24,
        ),
        header5: pw.TextStyle(
          font: pw.Font.helveticaOblique(),
          fontSize: 12,
        ),
        defaultTextStyle: pw.TextStyle(
          font: pw.Font.courier(),
          fontSize: 13,
        ),
      ),
    );

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Watermark.text(
                "Earthquake Disaster Risk Index",
                style: pw.TextStyle.defaultStyle().copyWith(color: const PdfColor.fromInt(0x00dbdbdb)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(0.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "EDRI REPORT",
                        style: pw.Theme.of(context).header1,
                      ),
                    ),
                    // pw.SizedBox(height: 20),
                    pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "Generated at $inspTime on $inspDate",
                        textAlign: pw.TextAlign.center,
                        style: pw.Theme.of(context).header5,
                      ),
                    ),
                    pw.SizedBox(height: 50),
                    pw.Table.fromTextArray(
                      headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0x05ad7863)),
                      headerStyle: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
                      data: [
                        ["Specification", "Value"],
                        ["Collateral Damage", selectedHazards],
                        ["Seismic Zone", stringZoneFactor],
                        ["Soil Type", stringSoilType],
                        ["Number of Storeys", numberOfStoreys.toString()],
                        // --- insert spectral shape here ---
                        ["Structure Importance", importance.toString()],
                        ["Floor Space Index of the Structure (FSI)", fsi.toString()],
                        ["Economic Loss Factors", selectedEco],
                        ["Life Threatening Factors", selectedLife],
                        ["Total EDRI", (hb * eb).toString()],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    //
    //----------------------------- Save PDF -----------------------------
    //
    String timeString = DateTime.now().toIso8601String().substring(0, 19).replaceAll(RegExp(r"\D"), "");

    Directory saveDir = await Directory('/storage/emulated/0/Download/EDRIreports').create();
    File file = await File('${saveDir.path}/${timeString}_EDRIReport.pdf').create();
    await file.writeAsBytes(await pdf.save());

    Fluttertoast.showToast(msg: "Generated PDF at Downloads");
  }
}
