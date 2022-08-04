import 'package:circa_plan/model/screen_data.dart';

import '../constants.dart';

/// Add duration screen data class.
///
/// Inherit from [ScreenData] base class. Its unique instance will be
/// added to the [TransferData] instance which is responsible of saving
/// and loading data to and from json file.
class AddDurationToDateTimeData extends ScreenData {
  AddDurationToDateTimeData() {
    transformers['firstDurationIconType'] = (value) =>
        value is FirstDurationIconType
            ? value.index
            : FirstDurationIconType.values[value];
    transformers['secondDurationIconType'] = (value) =>
        value is SecondDurationIconType
            ? value.index
            : SecondDurationIconType.values[value];
    transformers['thirdDurationIconType'] = (value) =>
        value is ThirdDurationIconType
            ? value.index
            : ThirdDurationIconType.values[value];
    screenDataType = ScreenDataType.addDurationToDateTimeData;
  }

  String get addDurationStartDateTimeStr =>
      attributes['addDurationStartDateTimeStr'];
  set addDurationStartDateTimeStr(String value) =>
      attributes['addDurationStartDateTimeStr'] = value;

  /// Alternative to dart getter since testing if null is returned by
  /// the method is useful.
  ///
  /// A getter can not return null. Null is returned if no
  /// AddDurationToDateTime screen field was modified.
  FirstDurationIconType? getFirstDurationIconType() {
    return attributes['firstDurationIconType'];
  }

  FirstDurationIconType get firstDurationIconType =>
      attributes['firstDurationIconType'];
  set firstDurationIconType(FirstDurationIconType value) =>
      attributes['firstDurationIconType'] = value;

  String get firstAddDurationDurationStr =>
      attributes['firstAddDurationDurationStr'];
  set firstAddDurationDurationStr(String value) =>
      attributes['firstAddDurationDurationStr'] = value;

  String get firstAddDurationEndDateTimeStr =>
      attributes['firstAddDurationEndDateTimeStr'];
  set firstAddDurationEndDateTimeStr(String value) =>
      attributes['firstAddDurationEndDateTimeStr'] = value;

  SecondDurationIconType get secondDurationIconType => attributes['secondDurationIconType'];
  set secondDurationIconType(SecondDurationIconType value) =>
      attributes['secondDurationIconType'] = value;

  String get secondAddDurationDurationStr => attributes['secondAddDurationDurationStr'];
  set secondAddDurationDurationStr(String value) => attributes['secondAddDurationDurationStr'] = value;

  String get secondAddDurationEndDateTimeStr =>
      attributes['secondAddDurationEndDateTimeStr'];
  set secondAddDurationEndDateTimeStr(String value) =>
      attributes['secondAddDurationEndDateTimeStr'] = value;

  ThirdDurationIconType get thirdDurationIconType => attributes['thirdDurationIconType'];
  set thirdDurationIconType(ThirdDurationIconType value) =>
      attributes['thirdDurationIconType'] = value;

  String get thirdAddDurationDurationStr => attributes['thirdAddDurationDurationStr'];
  set thirdAddDurationDurationStr(String value) => attributes['thirdAddDurationDurationStr'] = value;

  String get thirdAddDurationEndDateTimeStr =>
      attributes['thirdAddDurationEndDateTimeStr'];
  set thirdAddDurationEndDateTimeStr(String value) =>
      attributes['thirdAddDurationEndDateTimeStr'] = value;

  @override
  String toString() {
    FirstDurationIconType? firstDurationIconType = getFirstDurationIconType();

    if (firstDurationIconType == null) {
      return '';
    } else {
      return 'firstDurationIconType: $firstDurationIconType\naddDurationStartDateTimeStr: $addDurationStartDateTimeStr\nfirstDurationStr: $firstAddDurationDurationStr\nfirstEndDateTimeStr: $firstAddDurationEndDateTimeStr\nsecondDurationIconType: $secondDurationIconType\nsecondDurationStr: $secondAddDurationDurationStr\nsecondEndDateTimeStr: $secondAddDurationEndDateTimeStr\nthirdDurationIconType: $thirdDurationIconType\nthirdDurationStr: $thirdAddDurationDurationStr\nthirdEndDateTimeStr: $thirdAddDurationEndDateTimeStr';
    }
  }
}
