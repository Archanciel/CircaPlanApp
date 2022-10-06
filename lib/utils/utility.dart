import 'dart:convert';
import 'dart:io';

class Utility {
  /// Returns true if the passed file path name exists, false
  /// otherwise.
  static bool fileExist(String filePathNameStr) {
    File file = File(filePathNameStr);

    return file.existsSync();
  }

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

  static String extractFileName({required String filePathName}) {
    return filePathName.split(Platform.pathSeparator).last;
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

  static Future<String> formatScreenDataSubMapFromJsonFileContent({
    required String jsonFilePathName,
    required String screenDataSubMapKey,
  }) async {
    if (!fileExist(jsonFilePathName)) {
      return '${extractFileName(filePathName: jsonFilePathName)} not exist !';
    }

    final String jsonString = await File(jsonFilePathName).readAsString();

    return formatScreenDataSubMapFromJsonString(
      jsonString: jsonString,
      screenDataSubMapKey: screenDataSubMapKey,
    );
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

  static String formatScreenDataSubMapFromJsonString({
    required String jsonString,
    required String screenDataSubMapKey,
  }) {
    final Map<String, dynamic> parsedJsonMap = json.decode(jsonString);

    return formatMapContentNoNull(map: parsedJsonMap[screenDataSubMapKey]);
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
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');

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

  static String formatMapContentNoNull({required Map<String, dynamic> map}) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');

    String formattedMapStr = encoder.convert(map);

    return formattedMapStr;
  }

  /// Method used to enable entering an int duration value
  /// instead of a HH:mm duration. For example, 2 or 24
  /// instead of 02:00 or 24:00.
  ///
  /// If the removeMinusSign parm is false, entering -2
  /// converts the duration string to -2:00, which is
  /// useful in the Add dialog accepting adding a positive
  /// or negative duration.
  static String convertIntDuration({
    required String durationStr,
    bool removeMinusSign = true,
    bool dayHourMinuteFormat = false,
  }) {
    if (removeMinusSign) {
      durationStr = durationStr.replaceAll(RegExp(r'[+\-]+'), '');
    } else {
      durationStr = durationStr.replaceAll(RegExp(r'[+]+'), '');
    }

    if (dayHourMinuteFormat) {
      // the case if used on TimeCalculator screen
      int? durationInt = int.tryParse(durationStr);

      if (durationInt != null) {
        if (durationInt < 0) {
          if (durationInt > -10) {
            durationStr = '-0${durationInt * -1}';
          }
        } else {
          if (durationInt < 10) {
            durationStr = '00:0$durationStr:00';
          } else {
            durationStr = '00:$durationStr:00';
          }
        }
      } else {
        RegExp re = RegExp(r"^\d{1}:\d{2}");

        RegExpMatch? match = re.firstMatch(durationStr);

        if (match != null) {
          durationStr = '00:0${match.group(0)}';
        } else {
          RegExp re = RegExp(r"^\d{2}:\d{2}");
          RegExpMatch? match = re.firstMatch(durationStr);
          if (match != null) {
            durationStr = '00:${match.group(0)}';
          }
        }
      }
    } else {
      int? durationInt = int.tryParse(durationStr);

      if (durationInt != null) {
        // the case if a one or two digits duration was entered ...
        durationStr = '$durationStr:00';
      }
    }

    return durationStr;
  }
}
