import 'dart:io';
import 'package:circa_plan/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/date_time_difference_duration_data.dart';
import 'package:circa_plan/model/time_calculator_data.dart';
import 'package:circa_plan/model/transfer_data.dart';

/// This class manages the correspondance between the transfer data
/// map currently storing the different screens data and the
/// [TransferData] instance which save or load data in or from
/// the circadian json file.
class TransferDataViewModel {
  final String _transferDataJsonFilePathName;
  final TransferData _transferData;

  // since the transferDataMap can not be set by the constructor but
  // by calling the corresponding setter, the instance variable must
  // be declared nullable.
  Map<String, dynamic>? _transferDataMap;

  TransferDataViewModel({
    required String transferDataJsonFilePathName,
  })  : _transferDataJsonFilePathName = transferDataJsonFilePathName,
        // the TransferData constructor instanciates 4 empty screen
        // data sub classes.
        _transferData = TransferData();

  Map<String, dynamic>? getTransferDataMap() => _transferDataMap;

  /// the transferDataMap being not settable by the constructor, this
  /// setter must be declared.
  set transferDataMap(Map<String, dynamic> transferDataMap) =>
      _transferDataMap = transferDataMap;

  AddDurationToDateTimeData get addDurationToDateTimeData =>
      _transferData.addDurationToDateTimeData;

  CalculateSleepDurationData get calculateSleepDurationData =>
      _transferData.calculateSleepDurationData;

  DateTimeDifferenceDurationData get dateTimeDifferenceDurationData =>
      _transferData.dateTimeDifferenceDurationData;

  TimeCalculatorData get timeCalculatorData => _transferData.timeCalculatorData;

  /// Copy transferDataMap values to TransferData instance in order to
  /// then update the json file.
  void updateAndSaveTransferData() {
    updateAddDurationToDateTimeData();
    updateCalculateSleepDurationData();
    updateDateTimeDifferenceDurationData();
    updateTimeCalculatorData();

    // print('\nTRANSFER DATA MAP BEFORE SAVING IT');
    // print(DirUtil.formatMapContent(map: _transferDataMap!));

    String jsonUndoFileNameOne =
        '${Utility.extractFileName(filePathName: _transferDataJsonFilePathName)}-1';

    _transferData.saveTransferDataToFile(
        jsonFilePathName: _transferDataJsonFilePathName,
        jsonUndoFileName: jsonUndoFileNameOne);
  }

  /// Saves the screens app transfer data to a json file and return
  /// true if the json filr was created, false if it was updated.
  ///
  /// If nothing is passed transferDataJsonFileName, the json file name
  /// is the current CalculateSleepDuration screen new date time
  /// reformatted.
  Future<bool> saveAsTransferData({String? transferDataJsonFileName}) async {
    final String transferDataJsonPath = getTransferDataJsonPath();
    bool transferDataJsonFileCreated = false;

    if (transferDataJsonFileName == null) {
      final CalculateSleepDurationData calculateSleepDurationData =
          _transferData.calculateSleepDurationData;
      final String sleepDurationNewDateTimeStr =
          calculateSleepDurationData.sleepDurationNewDateTimeStr;

      final String englishDateTimeStr =
          reformatDateTimeStrToCompatibleEnglishFormattedFileName(
              sleepDurationNewDateTimeStr);

      final String saveAsTransferDataJsonFilePathName =
          '$transferDataJsonPath${Platform.pathSeparator}$englishDateTimeStr.json';

      transferDataJsonFileCreated =
          !await File(saveAsTransferDataJsonFilePathName).exists();
      _transferData.saveTransferDataToFile(
          jsonFilePathName: saveAsTransferDataJsonFilePathName);
    }

    return transferDataJsonFileCreated;
  }

  List<String?> getFileNameInDirLst(String transferDataJsonPath) {
    final Directory directory = Directory(transferDataJsonPath);
    final List<FileSystemEntity> contents = directory.listSync();
    final List<String?> fileNameLst = contents
        .map((e) => e is File ? e : null)
        .map((e) => e?.path.split(Platform.pathSeparator).last)
        .toList();

    return fileNameLst;
  }

  static void deleteFilesInDir(String transferDataJsonPath) {
    final Directory directory = Directory(transferDataJsonPath);
    final List<FileSystemEntity> contents = directory.listSync();

    for (FileSystemEntity file in contents) {
      file.deleteSync();
    }
  }

  /// This method converts the french formatted date time string to
  /// an english formatted date time string with '.' in place of ':'.
  String reformatDateTimeStrToCompatibleEnglishFormattedFileName(
      String frenchFormattedDateTimeStr) {
    final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

    // on Android, file name can not contain ':' !
    final DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH.mm");
    DateTime dateTime;
    String englishDateTimeStr = '';

    try {
      dateTime = frenchDateTimeFormat.parse(frenchFormattedDateTimeStr);
      englishDateTimeStr = englishDateTimeFormat.format(dateTime);
    } on FormatException catch (_) {}

    return englishDateTimeStr;
  }

  /// This method converts the english formatted date time string to
  /// a french formatted date time string with ':' in place of '.'.
  String reformatEnglishDateTimeStrWithPointToFrenchFormattedDateTimeStr(
      String englishFormattedDateTimeStr) {
    final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

    // on Android, file name can not contain ':' !
    final DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH.mm");
    DateTime dateTime;
    String frenchDateTimeStr = '';

    try {
      dateTime = englishDateTimeFormat.parse(englishFormattedDateTimeStr);
      frenchDateTimeStr = frenchDateTimeFormat.format(dateTime);
    } on FormatException catch (_) {}

    return frenchDateTimeStr;
  }

  String getTransferDataJsonPath() {
    final List<String> pathComponents =
        _transferDataJsonFilePathName.split(Platform.pathSeparator);
    final String transferDataJsonPath = pathComponents
        .sublist(0, pathComponents.length - 1)
        .map((e) => e)
        .join(Platform.pathSeparator);

    return transferDataJsonPath;
  }

  String get transferDataJsonFilePathName => _transferDataJsonFilePathName;

  void printScreenData() {
    print(_transferData.addDurationToDateTimeData);
    print(_transferData.calculateSleepDurationData);
    print(_transferData.dateTimeDifferenceDurationData);
    print(_transferData.timeCalculatorData);
  }

  void updateAddDurationToDateTimeData() {
    // _transferDataMap is nullable !
    int? firstDurationSign = _transferDataMap!['firstDurationSign'];

    if (firstDurationSign == null) {
      // the case if no AddDurationToDateTime screen field was
      // modified and so no AddDurationToDateTime data were stored
      // in the transfer data map !
      return;
    }

    AddDurationToDateTimeData addDurationToDateTimeData =
        _transferData.addDurationToDateTimeData;

    addDurationToDateTimeData.addDurationStartDateTimeStr =
        _transferDataMap!['addDurStartDateTimeStr'] ?? '';

    addDurationToDateTimeData.firstDurationIconType = (firstDurationSign > 0)
        ? DurationIconType.add
        : DurationIconType.subtract;
    addDurationToDateTimeData.firstAddDurationStartDateTimeStr =
        _transferDataMap!['firstStartDateTimeStr'];
    addDurationToDateTimeData.firstAddDurationDurationStr =
        _transferDataMap!['firstDurationStr'];
    addDurationToDateTimeData.firstAddDurationEndDateTimeStr =
        _transferDataMap!['firstEndDateTimeStr'];

    int secondDurationSign = _transferDataMap!['secondDurationSign'];

    addDurationToDateTimeData.secondDurationIconType = (secondDurationSign > 0)
        ? DurationIconType.add
        : DurationIconType.subtract;
    addDurationToDateTimeData.secondAddDurationStartDateTimeStr =
        _transferDataMap!['secondStartDateTimeStr'];
    addDurationToDateTimeData.secondAddDurationDurationStr =
        _transferDataMap!['secondDurationStr'];
    addDurationToDateTimeData.secondAddDurationEndDateTimeStr =
        _transferDataMap!['secondEndDateTimeStr'];

    int thirdDurationSign = _transferDataMap!['thirdDurationSign'];

    addDurationToDateTimeData.thirdDurationIconType = (thirdDurationSign > 0)
        ? DurationIconType.add
        : DurationIconType.subtract;
    addDurationToDateTimeData.thirdAddDurationStartDateTimeStr =
        _transferDataMap!['thirdStartDateTimeStr'];
    addDurationToDateTimeData.thirdAddDurationDurationStr =
        _transferDataMap!['thirdDurationStr'];
    addDurationToDateTimeData.thirdAddDurationEndDateTimeStr =
        _transferDataMap!['thirdEndDateTimeStr'];
  }

  void updateCalculateSleepDurationData() {
    // _transferDataMap is nullable !
    Status? status = _transferDataMap!['calcSlDurStatus'];

    if (status == null) {
      // the case if no CalculateSleepDuration screen field was
      // modified and so no CalculateSleepDuration data were stored
      // in the transfer data map !
      return;
    }

    CalculateSleepDurationData calculateSleepDurationData =
        _transferData.calculateSleepDurationData;

    calculateSleepDurationData.status = status;
    calculateSleepDurationData.sleepDurationNewDateTimeStr =
        _transferDataMap!['calcSlDurNewDateTimeStr'];
    calculateSleepDurationData.sleepDurationPreviousDateTimeStr =
        _transferDataMap!['calcSlDurPreviousDateTimeStr'];
    calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr =
        _transferDataMap!['calcSlDurBeforePreviousDateTimeStr'];
    calculateSleepDurationData.sleepDurationStr =
        _transferDataMap!['calcSlDurCurrSleepDurationStr'];
    calculateSleepDurationData.wakeUpDurationStr =
        _transferDataMap!['calcSlDurCurrWakeUpDurationStr'];
    calculateSleepDurationData.totalDurationStr =
        _transferDataMap!['calcSlDurCurrTotalDurationStr'];
    calculateSleepDurationData.sleepDurationPercentStr =
        _transferDataMap!['calcSlDurCurrSleepDurationPercentStr'];
    calculateSleepDurationData.wakeUpDurationPercentStr =
        _transferDataMap!['calcSlDurCurrWakeUpDurationPercentStr'];
    calculateSleepDurationData.totalDurationPercentStr =
        _transferDataMap!['calcSlDurCurrTotalDurationPercentStr'];
    calculateSleepDurationData.sleepPrevDayTotalPercentStr =
        _transferDataMap!['calcSlDurCurrSleepPrevDayTotalPercentStr'];
    calculateSleepDurationData.wakeUpPrevDayTotalPercentStr =
        _transferDataMap!['calcSlDurCurrWakeUpPrevDayTotalPercentStr'];
    calculateSleepDurationData.totalPrevDayTotalPercentStr =
        _transferDataMap!['calcSlDurCurrTotalPrevDayTotalPercentStr'];
    calculateSleepDurationData.sleepHistoryDateTimeStrLst =
        _transferDataMap!['calcSlDurSleepTimeStrHistory'];
    calculateSleepDurationData.wakeUpHistoryDateTimeStrLst =
        _transferDataMap!['calcSlDurWakeUpTimeStrHistory'];
  }

  void updateDateTimeDifferenceDurationData() {
    // _transferDataMap is nullable !
    String? dateTimeDifferenceStartDateTimeStr =
        _transferDataMap!['dtDiffStartDateTimeStr'];

    if (dateTimeDifferenceStartDateTimeStr == null) {
      // the case if no DateTimeDifferenceDuration screen field
      // was modified and so no DateTimeDifferenceDuration data
      // were stored in the transfer data map !
      return;
    }

    DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
        _transferData.dateTimeDifferenceDurationData;

    dateTimeDifferenceDurationData.dateTimeDifferenceStartDateTimeStr =
        dateTimeDifferenceStartDateTimeStr;
    dateTimeDifferenceDurationData.dateTimeDifferenceEndDateTimeStr =
        _transferDataMap!['dtDiffEndDateTimeStr'];
    dateTimeDifferenceDurationData.dateTimeDifferenceDurationStr =
        _transferDataMap!['dtDiffDurationStr'];
    dateTimeDifferenceDurationData.dateTimeDifferenceAddTimeStr =
        _transferDataMap!['dtDiffAddTimeStr'];
    dateTimeDifferenceDurationData.dateTimeDifferenceFinalDurationStr =
        _transferDataMap!['dtDiffFinalDurationStr'];
    dateTimeDifferenceDurationData.dateTimeDifferenceDurationPercentStr =
        _transferDataMap!['dtDurationPercentStr'];
  }

  void updateTimeCalculatorData() {
    // _transferDataMap is nullable !
    String? timeCalculatorFirstTimeStr = _transferDataMap!['firstTimeStr'];

    if (timeCalculatorFirstTimeStr == null) {
      // the case if no TimeCalculator screen field was
      // modified and so no TimeCalculator data were stored
      // in the transfer data map !
      return;
    }

    TimeCalculatorData timeCalculatorData = _transferData.timeCalculatorData;

    timeCalculatorData.timeCalculatorFirstTimeStr = timeCalculatorFirstTimeStr;
    timeCalculatorData.timeCalculatorSecondTimeStr =
        _transferDataMap!['secondTimeStr'];
    timeCalculatorData.timeCalculatorResultTimeStr =
        _transferDataMap!['resultTimeStr'];
    timeCalculatorData.timeCalculatorResultPercentStr =
        _transferDataMap!['resultPercentStr'];
  }

  /// Loads the application screen data json file and sets
  /// the loaded values in the _transferDataMap.
  ///
  /// The _transferDataMap references the screen data map
  /// used to store all the screen field values. Each time
  /// a screen field is modified, the app json file is
  /// updated.
  Future<void> loadTransferData({String? jsonFileName}) async {
    String jsonFilePathName;

    if (jsonFileName == null) {
      jsonFilePathName = _transferDataJsonFilePathName;
    } else {
      jsonFilePathName =
          '${getTransferDataJsonPath()}${Platform.pathSeparator}$jsonFileName';
    }

    await _transferData.loadTransferDataFromFile(
        jsonFilePathName: jsonFilePathName);

    AddDurationToDateTimeData addDurationToDateTimeData =
        _transferData.addDurationToDateTimeData;

    DurationIconType? durationIconType =
        addDurationToDateTimeData.getFirstDurationIconType();

    if (durationIconType != null) {
      _transferDataMap!["addDurStartDateTimeStr"] =
          addDurationToDateTimeData.addDurationStartDateTimeStr;

      if (addDurationToDateTimeData.firstDurationIconType ==
          DurationIconType.add) {
        _transferDataMap!["firstDurationIconData"] = Icons.add;
        _transferDataMap!["firstDurationIconColor"] = Colors.green.shade200;
        _transferDataMap!["firstDurationSign"] = 1;
        _transferDataMap!["firstDurationTextColor"] = Colors.green.shade200;
      } else {
        _transferDataMap!["firstDurationIconData"] = Icons.remove;
        _transferDataMap!["firstDurationIconColor"] = Colors.red.shade200;
        _transferDataMap!["firstDurationSign"] = -1;
        _transferDataMap!["firstDurationTextColor"] = Colors.red.shade200;
      }

      _transferDataMap!["firstStartDateTimeStr"] =
          addDurationToDateTimeData.firstAddDurationStartDateTimeStr;
      _transferDataMap!["firstDurationStr"] =
          addDurationToDateTimeData.firstAddDurationDurationStr;
      _transferDataMap!["firstEndDateTimeStr"] =
          addDurationToDateTimeData.firstAddDurationEndDateTimeStr;

      if (addDurationToDateTimeData.secondDurationIconType ==
          DurationIconType.add) {
        _transferDataMap!["secondDurationIconData"] = Icons.add;
        _transferDataMap!["secondDurationIconColor"] = Colors.green.shade200;
        _transferDataMap!["secondDurationSign"] = 1;
        _transferDataMap!["secondDurationTextColor"] = Colors.green.shade200;
      } else {
        _transferDataMap!["secondDurationIconData"] = Icons.remove;
        _transferDataMap!["secondDurationIconColor"] = Colors.red.shade200;
        _transferDataMap!["secondDurationSign"] = -1;
        _transferDataMap!["secondDurationTextColor"] = Colors.red.shade200;
      }

      _transferDataMap!["secondStartDateTimeStr"] =
          addDurationToDateTimeData.secondAddDurationStartDateTimeStr;
      _transferDataMap!["secondDurationStr"] =
          addDurationToDateTimeData.secondAddDurationDurationStr;
      _transferDataMap!["secondEndDateTimeStr"] =
          addDurationToDateTimeData.secondAddDurationEndDateTimeStr;

      if (addDurationToDateTimeData.thirdDurationIconType ==
          DurationIconType.add) {
        _transferDataMap!["thirdDurationIconData"] = Icons.add;
        _transferDataMap!["thirdDurationIconColor"] = Colors.green.shade200;
        _transferDataMap!["thirdDurationSign"] = 1;
        _transferDataMap!["thirdDurationTextColor"] = Colors.green.shade200;
      } else {
        _transferDataMap!["thirdDurationIconData"] = Icons.remove;
        _transferDataMap!["thirdDurationIconColor"] = Colors.red.shade200;
        _transferDataMap!["thirdDurationSign"] = -1;
        _transferDataMap!["thirdDurationTextColor"] = Colors.red.shade200;
      }

      _transferDataMap!["thirdStartDateTimeStr"] =
          addDurationToDateTimeData.thirdAddDurationStartDateTimeStr;
      _transferDataMap!["thirdDurationStr"] =
          addDurationToDateTimeData.thirdAddDurationDurationStr;
      _transferDataMap!["thirdEndDateTimeStr"] =
          addDurationToDateTimeData.thirdAddDurationEndDateTimeStr;
    }

    CalculateSleepDurationData calculateSleepDurationData =
        _transferData.calculateSleepDurationData;

    _transferDataMap!["calcSlDurNewDateTimeStr"] =
        calculateSleepDurationData.sleepDurationNewDateTimeStr;
    _transferDataMap!["calcSlDurPreviousDateTimeStr"] =
        calculateSleepDurationData.sleepDurationPreviousDateTimeStr;
    _transferDataMap!["calcSlDurBeforePreviousDateTimeStr"] =
        calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr;
    _transferDataMap!["calcSlDurCurrSleepDurationStr"] =
        calculateSleepDurationData.sleepDurationStr;
    _transferDataMap!["calcSlDurCurrWakeUpDurationStr"] =
        calculateSleepDurationData.wakeUpDurationStr;
    _transferDataMap!["calcSlDurCurrTotalDurationStr"] =
        calculateSleepDurationData.totalDurationStr;
    _transferDataMap!["calcSlDurCurrSleepDurationPercentStr"] =
        calculateSleepDurationData.sleepDurationPercentStr;
    _transferDataMap!["calcSlDurCurrWakeUpDurationPercentStr"] =
        calculateSleepDurationData.wakeUpDurationPercentStr;
    _transferDataMap!["calcSlDurCurrTotalDurationPercentStr"] =
        calculateSleepDurationData.totalDurationPercentStr;
    _transferDataMap!["calcSlDurCurrSleepPrevDayTotalPercentStr"] =
        calculateSleepDurationData.sleepPrevDayTotalPercentStr;
    _transferDataMap!["calcSlDurCurrWakeUpPrevDayTotalPercentStr"] =
        calculateSleepDurationData.wakeUpPrevDayTotalPercentStr;
    _transferDataMap!["calcSlDurCurrTotalPrevDayTotalPercentStr"] =
        calculateSleepDurationData.totalPrevDayTotalPercentStr;
    _transferDataMap!["calcSlDurStatus"] = calculateSleepDurationData.status;
    _transferDataMap!["calcSlDurSleepTimeStrHistory"] =
        calculateSleepDurationData.sleepHistoryDateTimeStrLst;
    _transferDataMap!["calcSlDurWakeUpTimeStrHistory"] =
        calculateSleepDurationData.wakeUpHistoryDateTimeStrLst;

    DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
        _transferData.dateTimeDifferenceDurationData;

    String? dateTimeDifferenceStartDateTimeStr =
        dateTimeDifferenceDurationData.getDateTimeDifferenceStartDateTimeStr();

    if (dateTimeDifferenceStartDateTimeStr != null) {
      _transferDataMap!["dtDiffStartDateTimeStr"] =
          dateTimeDifferenceDurationData.dateTimeDifferenceStartDateTimeStr;
      _transferDataMap!["dtDiffEndDateTimeStr"] =
          dateTimeDifferenceDurationData.dateTimeDifferenceEndDateTimeStr;
      _transferDataMap!["dtDiffDurationStr"] =
          dateTimeDifferenceDurationData.dateTimeDifferenceDurationStr;
      _transferDataMap!["dtDiffAddTimeStr"] =
          dateTimeDifferenceDurationData.dateTimeDifferenceAddTimeStr;
      _transferDataMap!["dtDiffFinalDurationStr"] =
          dateTimeDifferenceDurationData.dateTimeDifferenceFinalDurationStr;
      _transferDataMap!["dtDurationPercentStr"] =
          dateTimeDifferenceDurationData.dateTimeDifferenceDurationPercentStr;
    }

    TimeCalculatorData timeCalculatorData = _transferData.timeCalculatorData;

    String? timeCalculatorFirstTimeStr =
        timeCalculatorData.getTimeCalculatorFirstTimeStr();

    if (timeCalculatorFirstTimeStr != null) {
      _transferDataMap!["firstTimeStr"] =
          timeCalculatorData.timeCalculatorFirstTimeStr;
      _transferDataMap!["secondTimeStr"] =
          timeCalculatorData.timeCalculatorSecondTimeStr;
      _transferDataMap!["resultTimeStr"] =
          timeCalculatorData.timeCalculatorResultTimeStr;
      _transferDataMap!["resultPercentStr"] =
          timeCalculatorData.timeCalculatorResultPercentStr;
    }

    // print('\nTRANSFER DATA MAP AFTER LOADING IT');
    // print(DirUtil.formatMapContent(map: _transferDataMap!));
  }
}
