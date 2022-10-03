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

  /// Alternative to dart getter since testing if null is returned by
  /// the method is useful.
  ///
  /// A getter can not return null. Null is returned if no
  /// TimeCalculator screen field was modified.
  String? getTimeCalculatorFirstTimeStr() {
    return attributes['timeCalculatorFirstTimeStr'];
  }

  String get timeCalculatorFirstTimeStr => attributes['timeCalculatorFirstTimeStr'];
  set timeCalculatorFirstTimeStr(String value) => attributes['timeCalculatorFirstTimeStr'] = value;

  String get timeCalculatorSecondTimeStr => attributes['timeCalculatorSecondTimeStr'];
  set timeCalculatorSecondTimeStr(String value) => attributes['timeCalculatorSecondTimeStr'] = value;

  String get timeCalculatorResultTimeStr => attributes['timeCalculatorResultTimeStr'];
  set timeCalculatorResultTimeStr(String value) => attributes['timeCalculatorResultTimeStr'] = value;

  /// Checking if the timeCalculatorResultPercentStr == null 
  /// solves the problem of starting the app on a physical device
  /// where the json files do not yet have the 
  /// 'timeCalculatorResultPercentStr' entry !
  String get timeCalculatorResultPercentStr {
    String? timeCalculatorResultPercentStr = attributes['timeCalculatorResultPercentStr'];

    timeCalculatorResultPercentStr ??= '100 %';

    return timeCalculatorResultPercentStr;
  }

  set timeCalculatorResultPercentStr(String value) => attributes['timeCalculatorResultPercentStr'] = value;

  /// Checking if the timeCalculatorResultSecondPercentStr == null 
  /// solves the problem of starting the app on a physical device
  /// where the json files do not yet have the 
  /// 'timeCalculatorResultPercentStr' entry !
  String get timeCalculatorResultSecondPercentStr {
    String? timeCalculatorResultSecondPercentStr = attributes['timeCalculatorResultSecondPercentStr'];

    timeCalculatorResultSecondPercentStr ??= '100 %';

    return timeCalculatorResultSecondPercentStr;
  }

  set timeCalculatorResultSecondPercentStr(String value) => attributes['timeCalculatorResultSecondPercentStr'] = value;

  @override
  String toString() {
    String? timeCalculatorFirstTimeStr = getTimeCalculatorFirstTimeStr();

    if (timeCalculatorFirstTimeStr == null) {
      return '';
    } else {
      return 'timeCalculatorFirstTimeStr: $timeCalculatorFirstTimeStr\ntimeCalculatorSecondTimeStr: $timeCalculatorSecondTimeStr\ntimeCalculatorResultTimeStr: $timeCalculatorResultTimeStr\ntimeCalculatorResultPercentStr: $timeCalculatorResultPercentStr';
    }
  }
}
