import 'package:circa_plan/model/screen_data.dart';

enum Status {
  wakeUp,
  sleep,
}

/// Calculate sleep duration screen data class.
///
/// Inherit from [ScreenData] base class. Its unique instance will be
/// added to the [TransferData] instance which is responsible of saving
/// and loading data to and from json file.
class CalculateSleepDurationData extends ScreenData {
  CalculateSleepDurationData() {
    transformers['status'] =
        (value) => value is Status ? value.index : Status.values[value];
    screenDataType = ScreenDataType.calculateSleepDurationData;
  }
  /*
    map['calcSlDurNewDateTimeStr'] = _newDateTimeStr;
    map['calcSlDurLastWakeUpTimeStr'] = _lastWakeUpTimeStr;
    map['calcSlDurPreviousDateTimeStr'] = _previousDateTimeStr;
    map['calcSlDurBeforePreviousDateTimeStr'] = _beforePreviousDateTimeStr;
    map['calcSlDurCurrSleepDurationStr'] = _currentSleepDurationStr;
    map['calcSlDurCurrWakeUpDurationStr'] = _currentWakeUpDurationStr;
    map['calcSlDurCurrTotalDurationStr'] = _currentTotalDurationStr;
    map['calcSlDurStatus'] = _status;
    map['calcSlDurSleepTimeStrHistory'] = _sleepTimeStrHistory;
    map['calcSlDurWakeUpTimeStrHistory'] = _wakeUpTimeStrHistory;

    "calcSlDurSleepTimeStrHistory"
    List (4 items)
    "13-07-2022 20:26"
    "1:00"
    "0:30"
    "1:00"
    "calcSlDurWakeUpTimeStrHistory" -> List (4 items)
    "calcSlDurWakeUpTimeStrHistory"
    List (4 items)
    "13-07-2022 21:26"
    "1:00"
    "1:00"
    "2:00"
*/

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
/*
"calcSlDurSleepTimeStrHistory"
List (4 items)
"13-07-2022 20:26"
"1:00"
"0:30"
"1:00"
"calcSlDurWakeUpTimeStrHistory" -> List (4 items)
"calcSlDurWakeUpTimeStrHistory"
List (4 items)
"13-07-2022 21:26"
"1:00"
"1:00"
"2:00"
*/
  String get sleepHistoryDateTimeStr => attributes['sleepHistoryDateTimeStr'];
  set sleepHistoryDateTimeStr(String value) =>
      attributes['sleepHistoryDateTimeStr'] = value;

  String get wakeUpHistoryDateTimeStr => attributes['wakeUpHistoryDateTimeStr'];
  set wakeUpHistoryDateTimeStr(String value) =>
      attributes['wakeUpHistoryDateTimeStr'] = value;

  @override
  String toString() {
    Status? status = getStatus();

    if (status == null) {
      return '';
    } else {
      return 'status: $status\nsleepDurationNewDateTimeStr: $sleepDurationNewDateTimeStr\nsleepDurationPreviousDateTimeStr: $sleepDurationPreviousDateTimeStr\nsleepDurationBeforePreviousDateTimeStr: $sleepDurationBeforePreviousDateTimeStr\nsleepDurationStr: $sleepDurationStr\nwakeUpDurationStr: $wakeUpDurationStr\ntotalDurationStr: $totalDurationStr\nsleepHistoryDateTimeStr: $sleepHistoryDateTimeStr\nwakeUpHistoryDateTimeStr: $wakeUpHistoryDateTimeStr';
    }
  }
}
