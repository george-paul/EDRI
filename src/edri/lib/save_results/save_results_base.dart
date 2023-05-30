import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class AbstractSaveResults {
  Future<void> save(pw.Document pdf, String timeString, List<XFile?> pictures);
}

class SaveResults extends AbstractSaveResults {
  @override
  Future<void> save(pw.Document pdf, String timeString, List<XFile?> pictures) {
    throw Exception("Stub implementation");
  }
}
