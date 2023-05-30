import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:edri/save_results/save_results_base.dart';
import 'package:pdf/widgets.dart' as pw;

class SaveResults extends AbstractSaveResults {
  @override
  Future<void> save(pw.Document pdf, String timeString, List<XFile?> pictures) async {
    //
    //----------------------------- Save PDF -----------------------------
    //
    Directory saveDir = await Directory("/storage/emulated/0/Download/EDRIreports").create();
    File file = await File("${saveDir.path}/${timeString}_EDRIReport.pdf").create();
    await file.writeAsBytes(await pdf.save());

    //
    //----------------------------- Save Images -----------------------------
    //
    for (int index = 0; index < pictures.length; index++) {
      XFile xImg = pictures[index]!;
      String fileLabel = "";
      switch (index) {
        case 0:
          fileLabel = "Front";
          break;
        case 1:
          fileLabel = "Left";
          break;
        case 2:
          fileLabel = "Right";
          break;
        case 3:
          fileLabel = "Back";
          break;
        default:
          fileLabel = "Extra${index - 3}";
      }
      File file = await File("${saveDir.path}/${timeString}_StructureView$fileLabel.png").create();
      await file.writeAsBytes(await xImg.readAsBytes());
    }
  }
}
