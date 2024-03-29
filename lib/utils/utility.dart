import 'dart:convert';
import 'dart:io';

import 'package:circa_plan/constants.dart';

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

    // adding a try/catch block fixes failure of integration tests
    // which is run on Windows 10. This failure doesn't happen on
    // Android smartphone or Android emulator.
    try {
      return file.renameSync(newPath);
    } catch (e) {
      return null;
    }
  }

  static String extractFileName({required String filePathName}) {
    RegExp defaultJsonFileNameRegExp = RegExp(kDefaultJsonFileName);
    RegExpMatch? match = defaultJsonFileNameRegExp.firstMatch(filePathName);

    if (match != null) {
      return match.group(0)!.trim();
    } else {
      RegExp jsonFileNameRegExp = RegExp(r'([\d\- \.]+.json)');
      RegExpMatch? match = jsonFileNameRegExp.firstMatch(filePathName);

      if (match != null) {
        return match.group(0)!.trim();
      } else {
        return '';
      }
    }
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

  /// Method used to format the entered string duration
  /// to the duration TextField format, either HH:mm or
  /// dd:HH:mm. The method enables entering an int
  /// duration value instead of an HH:mm duration. For
  /// example, 2 or 24 instead of 02:00 or 24:00.
  ///
  /// If the removeMinusSign parm is false, entering -2
  /// converts the duration string to -2:00, which is
  /// useful in the Add dialog accepting adding a positive
  /// or negative duration.
  ///
  /// If dayHourMinuteFormat is true, the returned string
  /// duration for 2 is 00:02:00 or for 3:24 00:03:24.
  static String formatStringDuration({
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
            durationStr = '-00:0${durationInt * -1}:00';
          } else {
            durationStr = '-00:${durationInt * -1}:00';
          }
        } else {
          if (durationInt < 10) {
            durationStr = '00:0$durationStr:00';
          } else {
            durationStr = '00:$durationStr:00';
          }
        }
      } else {
        RegExp re = RegExp(r"^\d+:\d{1}$");
        RegExpMatch? match = re.firstMatch(durationStr);
        if (match != null) {
          durationStr = '${match.group(0)}0';
        } else {
          if (!removeMinusSign) {
            RegExp re = RegExp(r"^-\d+:\d{1}$");
            RegExpMatch? match = re.firstMatch(durationStr);
            if (match != null) {
              durationStr = '${match.group(0)}0';
            }
          }
        }
      }

      RegExp re = RegExp(r"^\d{1}:\d+$");
      RegExpMatch? match = re.firstMatch(durationStr);

      if (match != null) {
        durationStr = '00:0${match.group(0)}';
      } else {
        RegExp re = RegExp(r"^\d{2}:\d+$");
        RegExpMatch? match = re.firstMatch(durationStr);
        if (match != null) {
          durationStr = '00:${match.group(0)}';
        } else {
          RegExp re = RegExp(r"^\d{1}:\d{2}:\d+$");
          RegExpMatch? match = re.firstMatch(durationStr);
          if (match != null) {
            durationStr = '0${match.group(0)}';
          } else {
            RegExp re = RegExp(r"^\d{2}:\d{2}:\d+$");
            RegExpMatch? match = re.firstMatch(durationStr);
            if (match != null) {
              durationStr = '${match.group(0)}';
            }
          }
        }
      }
    } else {
      int? durationInt = int.tryParse(durationStr);

      if (durationInt != null) {
        // the case if a one or two digits duration was entered ...
        durationStr = '$durationStr:00';
      } else {
        RegExp re = RegExp(r"^\d+:\d{1}$");
        RegExpMatch? match = re.firstMatch(durationStr);
        if (match != null) {
          durationStr = '${match.group(0)}0';
        } else {
          if (!removeMinusSign) {
            RegExp re = RegExp(r"^-\d+:\d{1}$");
            RegExpMatch? match = re.firstMatch(durationStr);
            if (match != null) {
              durationStr = '${match.group(0)}0';
            }
          } else {
            // the case when copying a 00:hh:mm time text field content to a
            // duration text field.
            RegExp re = RegExp(r"^00:\d{2}:\d{2}$");
            RegExpMatch? match = re.firstMatch(durationStr);
            if (match != null) {
              durationStr = match.group(0)!.replaceFirst('00:', '');
            }
          }
        }
      }
    }

    return durationStr;
  }

  static String extractHHmmAtPosition({
    required String dataStr,
    required int pos,
  }) {
    if (pos > dataStr.length) {
      return '';
    }

    int newLineCharIdx = dataStr.lastIndexOf('\n');
    int leftIdx;

    if (pos > newLineCharIdx) {
      // the case if clicking on second line
      leftIdx = dataStr.substring(newLineCharIdx + 1, pos).lastIndexOf(' ') +
          newLineCharIdx;
    } else {
      leftIdx = dataStr.substring(0, pos).lastIndexOf(' ');
    }

    String extractedHHmmStr;

    if (leftIdx == -1) {
      // the case if selStartPosition is before the first space position
      leftIdx = 0;
    }

    int rightIdx = dataStr.indexOf(',', pos);

    if (rightIdx == -1) {
      // the case if the position is on the last HH:mm value
      rightIdx = dataStr.lastIndexOf(RegExp(r'-|\d')) + 1;
    }

    extractedHHmmStr = dataStr.substring(leftIdx, rightIdx);

    if (extractedHHmmStr.contains(RegExp(r'\D'))) {
      RegExpMatch? match = RegExp(r'(-|\d)+:\d+').firstMatch(extractedHHmmStr);

      if (match != null) {
        extractedHHmmStr = match.group(0) ?? '';
      }
    }

    return extractedHHmmStr;
  }

  static String getApplicationDataPath({bool isTest = false}) {
    if (Platform.isWindows) {
      if (isTest) {
        return kCircadianAppTestDirWindows;
      } else {
        return kCircadianAppDirWindows;
      }
    } else {
      if (isTest) {
        return kCircadianAppDataTestDir;
      } else {
        return kCircadianAppDir;
      }
    }
  }

  static void deleteFilesInDirAndSubDirs(String transferDataJsonPath) {
    final Directory directory = Directory(transferDataJsonPath);
    final List<FileSystemEntity> contents = directory.listSync(recursive: true);

    for (FileSystemEntity file in contents) {
      if (file is File) {
        file.deleteSync();
      }
    }
  }

  /// If [targetFileName] is not provided, the moved file will
  /// have the same name than the source file name.
  ///
  /// Returns true if the file has been copied, false
  /// otherwise in case the copied file already exist in
  /// the target dir.
  static bool copyFileToDirectorySync({
    required String sourceFilePathName,
    required String targetDirectoryPath,
    String? targetFileName,
  }) {
    File sourceFile = File(sourceFilePathName);
    String copiedFileName = targetFileName ?? sourceFile.uri.pathSegments.last;
    String targetPathFileName = '$targetDirectoryPath/$copiedFileName';

    if (File(targetPathFileName).existsSync()) {
      return false;
    }

    sourceFile.copySync(targetPathFileName);

    return true;
  }
}

// void main() {
//   String histoStr =
//       'Sleep 11-10 12:17: 6:12, 3:00\nWake 11-10 18:29: 0:30, 0:20';

//   print(histoStr);

//   String firstHHmmPos20 = Utility.extractHHmmAtPosition(
//     dataStr: histoStr,
//     selStartPosition: 20,
//   );

//   print('firstHHmmPos20 $firstHHmmPos20');

//   String firstHHmmPos22 = Utility.extractHHmmAtPosition(
//     dataStr: histoStr,
//     selStartPosition: 22,
//   );

//   print('firstHHmmPos22 $firstHHmmPos22');

//   String lastHHmmPos56 = Utility.extractHHmmAtPosition(
//     dataStr: histoStr,
//     selStartPosition: 56,
//   );

//   print('lastHHmmPos56 $lastHHmmPos56');

//   String lastHHmmPos58 = Utility.extractHHmmAtPosition(
//     dataStr: histoStr,
//     selStartPosition: 58,
//   );

//   print('lastHHmmPos58 $lastHHmmPos58');

//   String notHHmmPos3 = Utility.extractHHmmAtPosition(
//     dataStr: histoStr,
//     selStartPosition: 3,
//   );

//   print('notHHmmPos3 $notHHmmPos3');

//   String notHHmmPos33 = Utility.extractHHmmAtPosition(
//     dataStr: histoStr,
//     selStartPosition: 33,
//   );

//   print('notHHmmPos33 $notHHmmPos33');

//   String lastHHmmPos59 = Utility.extractHHmmAtPosition(
//     dataStr: histoStr,
//     selStartPosition: 59,
//   );

//   print('lastHHmmPos59 $lastHHmmPos59');
// }
