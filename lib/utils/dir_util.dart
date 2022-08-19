import 'dart:convert';
import 'dart:io';

class DirUtil {
  /// If the filePathNameStr file exists, it is renamed and the
  /// renamed File is returned. Otherwise, null is returned.
  static File? renameFile({
    required String filePathNameStr,
    required String newFileNameStr,
  }) {
    File file = File(filePathNameStr);

    bool fileExist = file.existsSync();

    if (!fileExist) {
      return null;
    }

    var lastSeparator = filePathNameStr.lastIndexOf(Platform.pathSeparator);
    var newPath =
        filePathNameStr.substring(0, lastSeparator + 1) + newFileNameStr;

    return file.renameSync(newPath);
  }

  /// Returns a formatted String which can be printed to
  /// dislay a readable view of the passed json file path
  /// name.
  /// 
  /// Usage example:
  /// 
  /// String printableJsonFileContent = 
  ///   await DirUtil.formatJsonFileContent(
  ///     jsonFilePathName: 'c:\\temp\\CircadianData\\circadian.json');
  /// print(printableJsonFileContent);
  static Future<String> formatJsonFileContent ({
    required String jsonFilePathName,
  }) async {
    final String jsonString = await File(jsonFilePathName).readAsString();
    final Map<String, dynamic> parsedJson = json.decode(jsonString);

    JsonEncoder encoder = JsonEncoder.withIndent('  ');

    return encoder.convert(parsedJson);
  }
}

Future<void> main() async {
  String printableJsonFileContent = await DirUtil.formatJsonFileContent(
      jsonFilePathName: 'c:\\temp\\CircadianData\\circadian.json');

  print(printableJsonFileContent);
}
