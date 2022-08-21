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

  /// Returns a formatted String which can be printed to dislay a 
  /// readable view of the passed json file path name.
  ///
  /// Usage example:
  ///
  /// String printableJsonFileContent =
  ///   await DirUtil.formatJsonFileContent(
  ///     jsonFilePathName: 'c:\\temp\\CircadianData\\circadian.json');
  /// 
  /// print(printableJsonFileContent);
  static Future<String> formatJsonFileContent({
    required String jsonFilePathName,
  }) async {
    final String jsonString = await File(jsonFilePathName).readAsString();

    return formatJsonString(jsonString: jsonString);
  }

  /// Returns a formatted String which can be printed to dislay a 
  /// readable view of the passed json string.
  ///
  /// Usage example:
  ///
  /// String printableJsonString =
  ///   DirUtil.formatJsonString(jsonString: loadedJsonStr);
  /// 
  /// print(printableJsonFileContent);
  static String formatJsonString({required String jsonString}) {
    final Map<String, dynamic> parsedJsonMap = json.decode(jsonString);

    return formatMapContent(map: parsedJsonMap);
  }

  /// Returns a formatted String which can be printed to dislay a 
  /// readable view of the passed Map<String, dynamic> map.
  ///
  /// Usage example:
  ///
  /// String printableMapString =
  ///   DirUtil.formatMapContent(map: loadedMap);
  /// 
  /// print(printableJsonFileContent);
  static String formatMapContent({required Map<String, dynamic> map}) {
    const JsonEncoder encoder = const JsonEncoder.withIndent('  ');

    // next code avoids JsonUnsupportedObjectError Exception 
    // Converting object to an encodable object failed: Instance of '_CalculateSleepDurationState'
    // or (Converting object to an encodable object failed: Instance of 'IconData')
    // or (Converting object to an encodable object failed: Instance of 'Color')
    var currentScreenStateInstance = map['currentScreenStateInstance'];
    var status = map['calcSlDurStatus'];
    var firstDurationIconData = map['firstDurationIconData'];
    var firstDurationIconColor = map['firstDurationIconColor'];
    var secondDurationIconData = map['secondDurationIconData'];
    var secondDurationIconColor = map['secondDurationIconColor'];
    var thirdDurationIconData = map['thirdDurationIconData'];
    var thirdDurationIconColor = map['thirdDurationIconColor'];
    var firstDurationTextColor = map['firstDurationTextColor'];
    var secondDurationTextColor = map['secondDurationTextColor'];
    var thirdDurationTextColor = map['thirdDurationTextColor'];

    map['currentScreenStateInstance'] = null;
    map['calcSlDurStatus'] = null;
    map['firstDurationIconData'] = null;
    map['firstDurationIconColor'] = null;
    map['secondDurationIconData'] = null;
    map['secondDurationIconColor'] = null;
    map['thirdDurationIconData'] = null;
    map['thirdDurationIconColor'] = null;
    map['firstDurationTextColor'] = null;
    map['secondDurationTextColor'] = null;
    map['thirdDurationTextColor'] = null;

    String formattedMapStr = encoder.convert(map);

    map['currentScreenStateInstance'] = currentScreenStateInstance;
    map['calcSlDurStatus'] = status;
    map['firstDurationIconData'] = firstDurationIconData;
    map['firstDurationIconColor'] = firstDurationIconColor;
    map['secondDurationIconData'] = secondDurationIconData;
    map['secondDurationIconColor'] = secondDurationIconColor;
    map['thirdDurationIconData'] = thirdDurationIconData;
    map['thirdDurationIconColor'] = thirdDurationIconColor;
    map['firstDurationTextColor'] = firstDurationTextColor;
    map['secondDurationTextColor'] = secondDurationTextColor;
    map['thirdDurationTextColor'] = thirdDurationTextColor;

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
