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
  static Future<String> formatJsonFileContent({
    required String jsonFilePathName,
  }) async {
    final String jsonString = await File(jsonFilePathName).readAsString();

    return formatJsonString(jsonString: jsonString);
  }

  static String formatJsonString({required String jsonString}) {
    final Map<String, dynamic> parsedJsonMap = json.decode(jsonString);

    return formatMapContent(map: parsedJsonMap);
  }

  static String formatMapContent({required Map<String, dynamic> map}) {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');

    //print(map);

    // avoiding Exception Converting object to an encodable object failed: Instance of '_CalculateSleepDurationState'
    var currentScreenStateInstance = map['currentScreenStateInstance'];
    var status = map['calcSlDurStatus'];

    map['currentScreenStateInstance'] = null;
    map['calcSlDurStatus'] = null;
    String formattedMapStr = encoder.convert(map);
    map['currentScreenStateInstance'] = currentScreenStateInstance;
    map['calcSlDurStatus'] = status;

    return formattedMapStr;
  }
}

Future<void> main() async {
  final String jsonFilePathName = 'c:\\temp\\CircadianData\\circadian.json';
  final String jsonString = await File(jsonFilePathName).readAsString();

  print(jsonString);

  String printableJsonString = DirUtil.formatJsonString(jsonString: jsonString);

  print(printableJsonString);
}
