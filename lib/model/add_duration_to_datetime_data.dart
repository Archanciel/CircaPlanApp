import 'package:circa_plan/model/screen_data.dart';

// used to select Icons type since Icon instances can't be
// serialized/deserialized in json file
enum DurationIconType {
  add,
  subtract,
}

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
  /*
    map['durationIconData'] = _durationIcon;
    map['durationIconColor'] =  YOU WILL USE DurationIconType instead !!!;
    map['durationSign'] = _durationSign; YOU WILL USE DurationIconType instead !!!
    map['durationTextColor'] = _durationTextColor; YOU WILL USE DurationIconType instead !!!
    map['addDurStartDateTimeStr'] = _startDateTimeStr;
    map['durationStr'] = _durationStr;
    map['endDateTimeStr'] = _endDateTimeStr;
*/
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

  String get durationStr => attributes['durationStr'];
  set durationStr(String value) => attributes['durationStr'] = value;

  String get endDateTimeStr => attributes['endDateTimeStr'];
  set endDateTimeStr(String value) => attributes['endDateTimeStr'] = value;

  @override
  String toString() {
    DurationIconType? durationIconType = getDurationIconType();

    if (durationIconType == null) {
      return '';
    } else {
      return 'durationIconType: $durationIconType\naddDurationStartDateTimeStr: $addDurationStartDateTimeStr\ndurationStr: $durationStr\nendDateTimeStr: $endDateTimeStr';
    }
  }
}
