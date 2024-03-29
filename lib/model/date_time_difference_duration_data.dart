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

  /// Alternative to dart getter since testing if null is returned by
  /// the method is useful.
  ///
  /// A getter can not return null. Null is returned if no
  /// DateTimeDifferenceDuration screen field was modified.
  String? getDateTimeDifferenceStartDateTimeStr() {
    return attributes['dateTimeDifferenceStartDateTimeStr'];
  }

  String get dateTimeDifferenceStartDateTimeStr =>
      attributes['dateTimeDifferenceStartDateTimeStr'];
  set dateTimeDifferenceStartDateTimeStr(String value) =>
      attributes['dateTimeDifferenceStartDateTimeStr'] = value;

  String get dateTimeDifferenceEndDateTimeStr =>
      attributes['dateTimeDifferenceEndDateTimeStr'];
  set dateTimeDifferenceEndDateTimeStr(String value) =>
      attributes['dateTimeDifferenceEndDateTimeStr'] = value;

  String get dateTimeDifferenceDurationStr =>
      attributes['dateTimeDifferenceDurationStr'];
  set dateTimeDifferenceDurationStr(String value) =>
      attributes['dateTimeDifferenceDurationStr'] = value;

  String get dateTimeDifferenceAddTimeStr =>
      attributes['dateTimeDifferenceAddTimeStr'];
  set dateTimeDifferenceAddTimeStr(String value) =>
      attributes['dateTimeDifferenceAddTimeStr'] = value;

  String get dateTimeDifferenceFinalDurationStr =>
      attributes['dateTimeDifferenceFinalDurationStr'];
  set dateTimeDifferenceFinalDurationStr(String value) =>
      attributes['dateTimeDifferenceFinalDurationStr'] = value;

  /// Checking if the durationPercentStr == null solves the
  /// problem of starting the app on a physical device where
  /// the json files do not yet have the
  /// 'dateTimeDurationPercentStr' entry !
  String get dateTimeDifferenceDurationPercentStr {
    String? durationPercentStr = attributes['dateTimeDifferenceDurationPercentStr'];

    durationPercentStr ??= '100 %';

    return durationPercentStr;
  }

  set dateTimeDifferenceDurationPercentStr(String value) =>
      attributes['dateTimeDifferenceDurationPercentStr'] = value;

  /// Checking if the durationTotalPercentStr == null solves the
  /// problem of starting the app on a physical device where
  /// the json files do not yet have the
  /// 'dateTimeDurationTotalPercentStr' entry !
  String get dateTimeDifferenceDurationTotalPercentStr {
    String? durationPercentStr = attributes['dateTimeDifferenceDurationTotalPercentStr'];

    durationPercentStr ??= '100 %';

    return durationPercentStr;
  }

  set dateTimeDifferenceDurationTotalPercentStr(String value) =>
      attributes['dateTimeDifferenceDurationTotalPercentStr'] = value;

  @override
  String toString() {
    String? dateTimeDifferenceStartDateTimeStr =
        getDateTimeDifferenceStartDateTimeStr();

    if (dateTimeDifferenceStartDateTimeStr == null) {
      return '';
    } else {
      return 'dateTimeDifferenceStartDateTimeStr: $dateTimeDifferenceStartDateTimeStr\ndateTimeDifferenceEndDateTimeStr: $dateTimeDifferenceEndDateTimeStr\ndateTimeDifferenceDurationStr: $dateTimeDifferenceDurationStr\ndateTimeDifferenceAddTimeStr: $dateTimeDifferenceAddTimeStr\ndateTimeDifferenceFinalDurationStr: $dateTimeDifferenceFinalDurationStr\ndateTimeDurationPercentStr: $dateTimeDifferenceDurationPercentStr';
    }
  }
}
