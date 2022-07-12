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
    transformers['status'] = (value) => value is Status
        ? value.index
        : Status.values[value];
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
*/
  Status get status => attributes['status'];
  set status(Status value) =>
      attributes['status'] = value;

  String get addDurationStartDateTimeStr =>
      attributes['addDurationStartDateTimeStr'];
  set addDurationStartDateTimeStr(String value) =>
      attributes['addDurationStartDateTimeStr'] = value;

  String get durationStr => attributes['durationStr'];
  set durationStr(String value) => attributes['durationStr'] = value;

  String get endDateTimeStr => attributes['endDateTimeStr'];
  set endDateTimeStr(String value) => attributes['endDateTimeStr'] = value;
}
