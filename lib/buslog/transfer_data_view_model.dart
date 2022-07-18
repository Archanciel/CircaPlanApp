import 'dart:io';

import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/date_time_difference_duration_data.dart';
import 'package:circa_plan/model/time_calculator_data.dart';
import 'package:circa_plan/model/transfer_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

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

    _transferData.saveTransferDataToFile(
        jsonFilePathName: _transferDataJsonFilePathName);
  }

  void saveAsTransferData({String? transferDataJsonFileName}) {
    final String transferDataJsonPath = getTransferDataJsonPath();

    if (transferDataJsonFileName == null) {
      final CalculateSleepDurationData calculateSleepDurationData =
          _transferData.calculateSleepDurationData;
      final String sleepDurationNewDateTimeStr =
          calculateSleepDurationData.sleepDurationNewDateTimeStr;

      final String englishDateTimeStr =
          reformatDateTimeStrToCompatibleFileName(sleepDurationNewDateTimeStr);

      final String saveAsTransferDataJsonFilePathName =
          '$transferDataJsonPath${Platform.pathSeparator}$englishDateTimeStr.json';

      _transferData.saveTransferDataToFile(
          jsonFilePathName: saveAsTransferDataJsonFilePathName);

      final List<String?> fileNameLst = getFileNameInDirLst(transferDataJsonPath);

      print(fileNameLst);
    }
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

  String reformatDateTimeStrToCompatibleFileName(
      String sleepDurationNewDateTimeStr) {
    final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
    final DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH.mm");
    DateTime dateTime;
    String englishDateTimeStr = '';

    try {
      dateTime = frenchDateTimeFormat.parse(sleepDurationNewDateTimeStr);
      englishDateTimeStr = englishDateTimeFormat.format(dateTime);
    } on FormatException catch (_) {}

    return englishDateTimeStr;
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

  void printScreenData() {
    print(_transferData.addDurationToDateTimeData);
    print(_transferData.calculateSleepDurationData);
    print(_transferData.dateTimeDifferenceDurationData);
    print(_transferData.timeCalculatorData);
  }

  void updateAddDurationToDateTimeData() {
    // _transferDataMap is nullable !
    int? durationSign = _transferDataMap!['durationSign'];

    if (durationSign == null) {
      // the case if no AddDurationToDateTime screen field was
      // modified and so no AddDurationToDateTime data were stored
      // in the transfer data map !
      return;
    }

    AddDurationToDateTimeData addDurationToDateTimeData =
        _transferData.addDurationToDateTimeData;

    addDurationToDateTimeData.durationIconType =
        (durationSign > 0) ? DurationIconType.add : DurationIconType.subtract;
    addDurationToDateTimeData.addDurationStartDateTimeStr =
        _transferDataMap!['addDurStartDateTimeStr'];
    addDurationToDateTimeData.addDurationDurationStr =
        _transferDataMap!['durationStr'];
    addDurationToDateTimeData.addDurationEndDateTimeStr =
        _transferDataMap!['endDateTimeStr'];
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
      // the case if no DateTimeDifferenceDuration screen field was
      // modified and so no DateTimeDifferenceDuration data were stored
      // in the transfer data map !
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
  }

  /// Loads the application screen data json file and sets
  /// the loaded values in the _transferDataMap.
  ///
  /// The _transferDataMap references the screen data map
  /// used to store all the screen field values. Each time
  /// a screen field is modified, the app json file is
  /// updated.
  Future<void> loadTransferData() async {
    await _transferData.loadTransferDataFromFile(
        jsonFilePathName: _transferDataJsonFilePathName);

    AddDurationToDateTimeData addDurationToDateTimeData =
        _transferData.addDurationToDateTimeData;

    DurationIconType? durationIconType =
        addDurationToDateTimeData.getDurationIconType();

    if (durationIconType != null) {
      if (addDurationToDateTimeData.durationIconType == DurationIconType.add) {
        _transferDataMap!["durationIconData"] = Icons.add;
        _transferDataMap!["durationIconColor"] = Colors.green.shade200;
        _transferDataMap!["durationSign"] = 1;
        _transferDataMap!["durationTextColor"] = Colors.green.shade200;
      } else {
        _transferDataMap!["durationIconData"] = Icons.remove;
        _transferDataMap!["durationIconColor"] = Colors.red.shade200;
        _transferDataMap!["durationSign"] = -1;
        _transferDataMap!["durationTextColor"] = Colors.red.shade200;
      }
      _transferDataMap!["addDurStartDateTimeStr"] =
          addDurationToDateTimeData.addDurationStartDateTimeStr;
      _transferDataMap!["durationStr"] =
          addDurationToDateTimeData.addDurationDurationStr;
      _transferDataMap!["endDateTimeStr"] =
          addDurationToDateTimeData.addDurationEndDateTimeStr;
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
    }
  }
}
