import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/date_time_difference_duration_data.dart';
import 'package:circa_plan/model/time_calculator_data.dart';
import 'package:circa_plan/model/transfer_data.dart';

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
  void updateTransferData() {
    updateAddDurationToDateTimeData();
    updateCalculateSleepDurationData();
    updateDateTimeDifferenceDurationData();
    updateTimeCalculatorData();
    printScreenData();
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
}
