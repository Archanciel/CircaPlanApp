import 'package:circa_plan/model/screen_data.dart';

// used to select Icons type since Icon instances can't be
// serialized/deserialized in json file
enum DurationIconType {
  add,
  subtract,
}

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

  String get addDurationStartDateTimeStr => attributes['addDurationStartDateTimeStr'];
  set addDurationStartDateTimeStr(String value) => attributes['addDurationStartDateTimeStr'] = value;

  String get durationStr => attributes['durationStr'];
  set durationStr(String value) => attributes['durationStr'] = value;

  String get endDateTimeStr => attributes['endDateTimeStr'];
  set endDateTimeStr(String value) => attributes['endDateTimeStr'] = value;
}
