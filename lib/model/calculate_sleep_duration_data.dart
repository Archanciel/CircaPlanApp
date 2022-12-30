import 'package:circa_plan/model/screen_data.dart';

import '../constants.dart';

/// Calculate sleep duration screen data class.
///
/// Inherit from [ScreenData] base class. Its unique instance will be
/// added to the [TransferData] instance which is responsible of saving
/// and loading data to and from json file.
class CalculateSleepDurationData extends ScreenData {
  CalculateSleepDurationData() {
    transformers['status'] =
        (value) => value is Status ? value.index : Status.values[value];
    objectCreators['sleepHistoryDateTimeStrLst'] = (map) => <String>[];
    objectCreators['wakeUpHistoryDateTimeStrLst'] = (map) => <String>[];
    screenDataType = ScreenDataType.calculateSleepDurationData;
  }

  /// Alternative to dart getter since testing if null is returned by
  /// the method is useful.
  ///
  /// A getter can not return null. Null is returned if no
  /// CalculateSleepDuration screen field was modified.
  Status? getStatus() {
    return attributes['status'];
  }

  Status get status => attributes['status'];
  set status(Status value) => attributes['status'] = value;

  String get sleepDurationNewDateTimeStr =>
      attributes['sleepDurationNewDateTimeStr'];
  set sleepDurationNewDateTimeStr(String value) =>
      attributes['sleepDurationNewDateTimeStr'] = value;

  String get sleepDurationPreviousDateTimeStr =>
      attributes['sleepDurationPreviousDateTimeStr'];
  set sleepDurationPreviousDateTimeStr(String value) =>
      attributes['sleepDurationPreviousDateTimeStr'] = value;

  String get sleepDurationBeforePreviousDateTimeStr =>
      attributes['sleepDurationBeforePreviousDateTimeStr'];
  set sleepDurationBeforePreviousDateTimeStr(String value) =>
      attributes['sleepDurationBeforePreviousDateTimeStr'] = value;

  String get sleepDurationStr => attributes['sleepDurationStr'];
  set sleepDurationStr(String value) => attributes['sleepDurationStr'] = value;

  String get wakeUpDurationStr => attributes['wakeUpDurationStr'];
  set wakeUpDurationStr(String value) =>
      attributes['wakeUpDurationStr'] = value;

  String get totalDurationStr => attributes['totalDurationStr'];
  set totalDurationStr(String value) => attributes['totalDurationStr'] = value;

  String get sleepDurationPercentStr => attributes['sleepDurationPercentStr'];
  set sleepDurationPercentStr(String value) =>
      attributes['sleepDurationPercentStr'] = value;

  String get wakeUpDurationPercentStr => attributes['wakeUpDurationPercentStr'];
  set wakeUpDurationPercentStr(String value) =>
      attributes['wakeUpDurationPercentStr'] = value;

  String get totalDurationPercentStr => attributes['totalDurationPercentStr'];
  set totalDurationPercentStr(String value) =>
      attributes['totalDurationPercentStr'] = value;

  String get sleepPrevDayTotalPercentStr => attributes['sleepPrevDayTotalPercentStr'];
  set sleepPrevDayTotalPercentStr(String value) =>
      attributes['sleepPrevDayTotalPercentStr'] = value;

  String get wakeUpPrevDayTotalPercentStr => attributes['wakeUpPrevDayTotalPercentStr'];
  set wakeUpPrevDayTotalPercentStr(String value) =>
      attributes['wakeUpPrevDayTotalPercentStr'] = value;

  String get totalPrevDayTotalPercentStr => attributes['totalPrevDayTotalPercentStr'];
  set totalPrevDayTotalPercentStr(String value) =>
      attributes['totalPrevDayTotalPercentStr'] = value;

  List<String> get sleepHistoryDateTimeStrLst =>
      attributes['sleepHistoryDateTimeStrLst'];
  set sleepHistoryDateTimeStrLst(List<String> value) =>
      attributes['sleepHistoryDateTimeStrLst'] = value;

  List<String> get wakeUpHistoryDateTimeStrLst =>
      attributes['wakeUpHistoryDateTimeStrLst'];
  set wakeUpHistoryDateTimeStrLst(List<String> value) =>
      attributes['wakeUpHistoryDateTimeStrLst'] = value;

  String get alarmMedicDateTimeStr => attributes['alarmMedicDateTimeStr'];
  set alarmMedicDateTimeStr(String value) =>
      attributes['alarmMedicDateTimeStr'] = value;

  String get sleepDurationCommentStr => attributes['sleepDurationCommentStr'];
  set sleepDurationCommentStr(String value) =>
      attributes['sleepDurationCommentStr'] = value;

  @override
  String toString() {
    Status? status = getStatus();

    if (status == null) {
      return '';
    } else {
      return 'status: $status\nsleepDurationNewDateTimeStr: $sleepDurationNewDateTimeStr\nsleepDurationPreviousDateTimeStr: $sleepDurationPreviousDateTimeStr\nsleepDurationBeforePreviousDateTimeStr: $sleepDurationBeforePreviousDateTimeStr\nsleepDurationStr: $sleepDurationStr\nwakeUpDurationStr: $wakeUpDurationStr\ntotalDurationStr: $totalDurationStr\nsleepDurationPercentStr: $sleepDurationPercentStr\nwakeUpDurationPercentStr: $wakeUpDurationPercentStr\ntotalDurationPercentStr: $totalDurationPercentStr\nsleepHistoryDateTimeStr: $sleepHistoryDateTimeStrLst\nwakeUpHistoryDateTimeStr: $wakeUpHistoryDateTimeStrLst\nalarmMedicDateTimeStr: $alarmMedicDateTimeStr';
    }
  }
}
