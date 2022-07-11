import 'package:circa_plan/model/screen_data.dart';

/// Add duration screen data class.
/// 
/// Inherit from [ScreenData] base class. Its unique instance will be
/// added to the [TransferData] instance which is responsible of saving
/// and loading data to and from json file.
class TimeCalculatorData extends ScreenData {
  TimeCalculatorData() {
    screenDataType = ScreenDataType.timeCalculatorData;
  }
  /*
    map['firstTimeStr'] = _firstTimeStr;
    map['secondTimeStr'] = _secondTimeStr;
    map['resultTimeStr'] = _resultTimeStr;
*/
  String get addDurationStartDateTimeStr => attributes['addDurationStartDateTimeStr'];
  set addDurationStartDateTimeStr(String value) => attributes['addDurationStartDateTimeStr'] = value;

  String get durationStr => attributes['durationStr'];
  set durationStr(String value) => attributes['durationStr'] = value;

  String get endDateTimeStr => attributes['endDateTimeStr'];
  set endDateTimeStr(String value) => attributes['endDateTimeStr'] = value;
}
