import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:edri/save_results/save_results_base.dart';

class SaveResults extends AbstractSaveResults {
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

  @override
  Future<void> save(pw.Document pdf, String timeString, List<XFile?> pictures) async {
    Archive archive = Archive();

    //
    //----------------------------- Save PDF -----------------------------
    //
    Uint8List pdfBytes = await pdf.save();
    archive.addFile(ArchiveFile("${timeString}_EDRIReport.pdf", pdfBytes.length, pdfBytes));

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
      Uint8List xImgBytes = await xImg.readAsBytes();
      archive.addFile(ArchiveFile("${timeString}_StructureView$fileLabel.png", xImgBytes.length, xImgBytes));
    }

    Uint8List archiveBytes = Uint8List.fromList(ZipEncoder().encode(archive)!);
    triggerDownload(bytes: archiveBytes, downloadName: "${timeString}_EDRIReport.zip");
  }
}
