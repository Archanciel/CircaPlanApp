import 'package:circa_plan/model/screen_data.dart';

import '../constants.dart';

/// Add duration screen data class.
///
/// Inherit from [ScreenData] base class. Its unique instance will be
/// added to the [TransferData] instance which is responsible of saving
/// and loading data to and from json file.
class AddDurationToDateTimeData extends ScreenData {
  AddDurationToDateTimeData() {
    transformers['durationIconType'] = (value) => value is DurationIconType
        ? value.index
        : DurationIconType.values[value];
    screenDataType = ScreenDataType.addDurationToDateTimeData;
  }
  
  /// Alternative to dart getter since testing if null is returned by
  /// the method is useful.
  ///
  /// A getter can not return null. Null is returned if no
  /// AddDurationToDateTime screen field was modified.
  DurationIconType? getDurationIconType() {
    return attributes['durationIconType'];
  }

  DurationIconType get durationIconType => attributes['durationIconType'];
  set durationIconType(DurationIconType value) =>
      attributes['durationIconType'] = value;

  String get addDurationStartDateTimeStr =>
      attributes['addDurationStartDateTimeStr'];
  set addDurationStartDateTimeStr(String value) =>
      attributes['addDurationStartDateTimeStr'] = value;

  String get addDurationDurationStr => attributes['addDurationDurationStr'];
  set addDurationDurationStr(String value) => attributes['addDurationDurationStr'] = value;

  String get addDurationEndDateTimeStr =>
      attributes['addDurationEndDateTimeStr'];
  set addDurationEndDateTimeStr(String value) =>
      attributes['addDurationEndDateTimeStr'] = value;

  @override
  String toString() {
    DurationIconType? durationIconType = getDurationIconType();

    if (durationIconType == null) {
      return '';
    } else {
      return 'durationIconType: $durationIconType\naddDurationStartDateTimeStr: $addDurationStartDateTimeStr\ndurationStr: $addDurationDurationStr\nendDateTimeStr: $addDurationEndDateTimeStr';
    }
  }
}
