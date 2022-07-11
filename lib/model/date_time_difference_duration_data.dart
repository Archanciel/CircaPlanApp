import 'package:circa_plan/model/screen_data.dart';

/// Add duration screen data class.
/// 
/// Inherit from [ScreenData] base class. Its unique instance will be
/// added to the [TransferData] instance which is responsible of saving
/// and loading data to and from json file.
class DateTimeDifferenceDurationData extends ScreenData {
  DateTimeDifferenceDurationData() {
    screenDataType = ScreenDataType.dateTimeDifferenceDurationData;
  }
  /*
    map['dtDiffStartDateTimeStr'] = _startDateTimeStr;
    map['dtDiffEndDateTimeStr'] = _endDateTimeStr;
    map['dtDiffDurationStr'] = _durationStr;
    map['dtDiffAddTimeStr'] = _addTimeStr;
    map['dtDiffFinalDurationStr'] = _finalDurationStr;
*/
  String get addDurationStartDateTimeStr => attributes['addDurationStartDateTimeStr'];
  set addDurationStartDateTimeStr(String value) => attributes['addDurationStartDateTimeStr'] = value;

  String get durationStr => attributes['durationStr'];
  set durationStr(String value) => attributes['durationStr'] = value;

  String get endDateTimeStr => attributes['endDateTimeStr'];
  set endDateTimeStr(String value) => attributes['endDateTimeStr'] = value;
}
