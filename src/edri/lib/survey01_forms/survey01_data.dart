import 'dart:io';
import 'dart:math';
import 'package:edri/global_data.dart';
import 'package:edri/util.dart';
import 'package:edri/vulnerability_data.dart' as vuln;
import 'package:flutter/material.dart';
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

  pw.BoxDecoration borderBoxDecoration(int color, double width) {
    return pw.BoxDecoration(
      border: pw.TableBorder(
        top: pw.BorderSide(color: PdfColor.fromInt(color), width: width),
        bottom: pw.BorderSide(color: PdfColor.fromInt(color), width: width),
        left: pw.BorderSide(color: PdfColor.fromInt(color), width: width),
        right: pw.BorderSide(color: PdfColor.fromInt(color), width: width),
      ),
    );
  }

  void calcEDRI() async {
    const precisionDigits = 3;
    final surveyNumber = GetIt.I<GlobalData>().surveyNumber;

    //
    //----------------------------- Hazard -----------------------------
    //

    if (zoneFactor > 3) {
      Fluttertoast.showToast(msg: "Invalid Zone Factor $zoneFactor");
      return;
    }
    // ----------------------- Zone -- II -- III -- IV -- V
    double valZone = List.of(<double>[0.10, 0.16, 0.24, 0.36])[zoneFactor];
    final stringZoneFactor = List.of(<String>["Zone II", "Zone III", "Zone IV", "Zone V"])[zoneFactor];

    if (soilType > 2) {
      Fluttertoast.showToast(msg: "Invalid Soil Factor");
      return;
    }
    // ------------------ Soil Type -- hard - med - soft
    double valSoilType = List.of(<double>[1.0, 1.33, 1.67])[soilType];
    final stringSoilType = List.of(<String>["Hard Soil", "Medium Soil", "Soft Soil"])[soilType];

    double valSpectral = min(20 / numberOfStoreys, 2.5);

    double hazardVal = valZone * valSoilType * valSpectral;

    //
    //----------------------------- Structure Views -----------------------------
    //

    // if (picturesTaken.any((element) => !element)) {
    //   Fluttertoast.showToast(msg: "Complete structure view photographs");
    //   return;
    // }

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // final topImage = await File("${appDocDir.path}/StructureView${0.toString()}").readAsBytes();
    // final topView = pw.MemoryImage(topImage);
    // final leftImage = await File("${appDocDir.path}/StructureView${1.toString()}").readAsBytes();
    // final leftView = pw.MemoryImage(leftImage);
    // final rightImage = await File("${appDocDir.path}/StructureView${2.toString()}").readAsBytes();
    // final rightView = pw.MemoryImage(rightImage);
    // final bottomImage = await File("${appDocDir.path}/StructureView${3.toString()}").readAsBytes();
    // final bottomView = pw.MemoryImage(bottomImage);

    //
    //----------------------------- Exposure -----------------------------
    //

    if (importance > 2) {
      Fluttertoast.showToast(msg: "Invalid Importance");
      return;
    }
    // ----------------- Importance -- res - off - com
    double valImp = List.of(<double>[1.0, 1.25, 1.5])[importance];
    double exposureVal = valImp * fsi;

    //
    //----------------------------- Vulnerability -----------------------------
    //
    List<vuln.VulnElement> ecoElements = vuln.getFormVulnElements(vuln.possibleEconomic, surveyNumber);
    String selectedEco = "";
    for (int i = 0; i < ecoElements.length; i++) {
      if (ecoCheckboxes[i] && ecoElements[i].runtimeType == vuln.VulnQuestion) {
        selectedEco += "> ${ecoElements[i].text}\n";
      }
    }
    if (selectedEco.trim().isEmpty) selectedEco = "None";
    List<vuln.VulnElement> lifeElements = vuln.getFormVulnElements(vuln.possibleLifeThreatening, surveyNumber);
    String selectedLife = "";
    for (int i = 0; i < lifeElements.length; i++) {
      if (lifeCheckboxes[i] && lifeElements[i].runtimeType == vuln.VulnQuestion) {
        selectedLife += "> ${lifeElements[i].text}\n";
      }
    }
    if (selectedLife.trim().isEmpty) selectedLife = "None";

    double lifeThreateningCountVal = vuln.isLifeThreatening(lifeCheckboxes, surveyNumber);
    double economicLossVal = vuln.economicLoss(ecoCheckboxes, surveyNumber);

    //
    //----------------------------- Total EDRI -----------------------------
    //

    double actualRisk = hazardVal * exposureVal * economicLossVal;
    exposureVal = valImp * fsiAllowable;
    double allowableRisk = hazardVal * exposureVal * 1;
    double riskValue;
    if (lifeThreateningCountVal > 0) {
      riskValue = 1;
    } else {
      riskValue = actualRisk / allowableRisk;
    }

    //
    //----------------------------- create PDF -----------------------------
    //
    final pageTheme = pw.PageTheme(
      buildBackground: ((context) {
        return pw.Watermark.text(
          "Rapid Visual Screening",
          style: pw.TextStyle.defaultStyle().copyWith(color: const PdfColor.fromInt(0x00dbdbdb)),
        );
      }),
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.base().copyWith(
        header1: pw.TextStyle(
          font: pw.Font.helveticaBold(),
          fontSize: 24,
        ),
        header2: pw.TextStyle(
          font: pw.Font.helveticaOblique(),
          fontSize: 15,
        ),
        header5: pw.TextStyle(
          font: pw.Font.helveticaOblique(),
          fontSize: 12,
        ),
        defaultTextStyle: pw.TextStyle(
          font: pw.Font.helvetica(),
          fontSize: 13,
        ),
      ),
    );

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return [
            pw.Column(
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
                    "Generated at $inspTime on $inspDate by $inspID",
                    textAlign: pw.TextAlign.center,
                    style: pw.Theme.of(context).header5,
                  ),
                ),
                pw.SizedBox(height: 50),
                pw.Table.fromTextArray(
                  border: null,
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0x05ad7863),
                    border: borderBoxDecoration(0xff000000, 1.0).border,
                  ),
                  headerStyle: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
                  cellDecoration: (index, data, rowNum) {
                    if (rowNum == 1 && index == 1) {
                      // Possible Collateral Damage
                      if (selectedHazards != "None") {
                        int red = Colors.red.shade400.value;
                        return borderBoxDecoration(red, 3.0);
                      }
                    }
                    if (rowNum == 9 && index == 1) {
                      // Life Threatening
                      if (lifeThreateningCountVal > 0) {
                        int red = Colors.red.shade400.value;
                        return borderBoxDecoration(red, 3.0);
                      }
                    }
                    // default style
                    return borderBoxDecoration(0xff000000, 1.0);
                  },
                  data: [
                    /*  0 */ ["Specification", "Value"],
                    /*  1 */ [
                      "Possible Collateral Damage (The presence of these is a cause for concern)",
                      selectedHazards
                    ],
                    /*  2 */ ["Seismic Zone", stringZoneFactor],
                    /*  3 */ ["Soil Type", stringSoilType],
                    /*  4 */ ["Number of Storeys", numberOfStoreys.toString()],
                    /*  5 */ ["Spectral Shape", valSpectral.toString()],
                    /*  6 */ ["Structure Importance", importance.toString()],
                    /*  7 */ ["Floor Space Index of the Structure (FSI)", fsi.toString()],
                    /*  8 */ ["Economic Loss Factors", (selectedEco == "") ? "None" : selectedEco],
                    /*  9 */ [
                      "Life Threatening Factors (The presence of these is cause for concern)",
                      (selectedLife == "") ? "None" : selectedLife
                    ],
                    /* 10 */ ["Actual Risk", actualRisk.toStringAsFixed(precisionDigits)],
                    /* 11 */ ["Allowable Risk", allowableRisk.toStringAsFixed(precisionDigits)],
                    /* 12 */ ["Risk Value", riskValue.toStringAsFixed(precisionDigits)],
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    // ------------------------------------- structure views -------------------------------------
    // pdf.addPage(
    //   pw.Page(
    //     pageTheme: pageTheme,
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         children: [
    //           pw.Text("Structure Views: ", style: pw.Theme.of(context).header2),
    //           pw.Expanded(
    //             child: pw.GridView(
    //               crossAxisCount: 3,
    //               children: [
    //                 pw.Container(width: 100),
    //                 pw.Image(topView, width: 100),
    //                 pw.Container(width: 100),
    //                 pw.Image(leftView, width: 100),
    //                 pw.Container(width: 100),
    //                 pw.Image(rightView, width: 100),
    //                 pw.Container(width: 100),
    //                 pw.Image(bottomView, width: 100),
    //                 pw.Container(width: 100),
    //               ],
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    // );

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
