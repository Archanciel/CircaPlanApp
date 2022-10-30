import 'package:circa_plan/model/screen_data.dart';

import '../constants.dart';

/// Add duration screen data class.
///
/// Inherit from [ScreenData] base class. Its unique instance will be
/// added to the [TransferData] instance which is responsible of saving
/// and loading data to and from json file.
class AddDurationToDateTimeData extends ScreenData {
  AddDurationToDateTimeData() {
    transformers['firstDurationIconType'] = (value) => value is DurationIconType
        ? value.index
        : DurationIconType.values[value];
    transformers['secondDurationIconType'] = (value) =>
        value is DurationIconType
            ? value.index
            : DurationIconType.values[value];
    transformers['thirdDurationIconType'] = (value) =>
        value is DurationIconType
            ? value.index
            : DurationIconType.values[value];
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
  DurationIconType? getFirstDurationIconType() {
    return attributes['firstDurationIconType'];
  }

  DurationIconType get firstDurationIconType =>
      attributes['firstDurationIconType'];
  set firstDurationIconType(DurationIconType value) =>
      attributes['firstDurationIconType'] = value;

  String get firstAddDurationStartDateTimeStr =>
      attributes['firstAddDurationStartDateTimeStr'];
  set firstAddDurationStartDateTimeStr(String value) =>
      attributes['firstAddDurationStartDateTimeStr'] = value;

  String get firstAddDurationDurationStr =>
      attributes['firstAddDurationDurationStr'];
  set firstAddDurationDurationStr(String value) =>
      attributes['firstAddDurationDurationStr'] = value;

  String get firstAddDurationEndDateTimeStr =>
      attributes['firstAddDurationEndDateTimeStr'];
  set firstAddDurationEndDateTimeStr(String value) =>
      attributes['firstAddDurationEndDateTimeStr'] = value;

  DurationIconType get secondDurationIconType =>
      attributes['secondDurationIconType'];
  set secondDurationIconType(DurationIconType value) =>
      attributes['secondDurationIconType'] = value;

  String get secondAddDurationStartDateTimeStr =>
      attributes['secondAddDurationStartDateTimeStr'];
  set secondAddDurationStartDateTimeStr(String value) =>
      attributes['secondAddDurationStartDateTimeStr'] = value;

  String get secondAddDurationDurationStr =>
      attributes['secondAddDurationDurationStr'];
  set secondAddDurationDurationStr(String value) =>
      attributes['secondAddDurationDurationStr'] = value;

  String get secondAddDurationEndDateTimeStr =>
      attributes['secondAddDurationEndDateTimeStr'];
  set secondAddDurationEndDateTimeStr(String value) =>
      attributes['secondAddDurationEndDateTimeStr'] = value;

  DurationIconType get thirdDurationIconType =>
      attributes['thirdDurationIconType'];
  set thirdDurationIconType(DurationIconType value) =>
      attributes['thirdDurationIconType'] = value;

  String get thirdAddDurationStartDateTimeStr =>
      attributes['thirdAddDurationStartDateTimeStr'];
  set thirdAddDurationStartDateTimeStr(String value) =>
      attributes['thirdAddDurationStartDateTimeStr'] = value;

  String get thirdAddDurationDurationStr =>
      attributes['thirdAddDurationDurationStr'];
  set thirdAddDurationDurationStr(String value) =>
      attributes['thirdAddDurationDurationStr'] = value;

  String get thirdAddDurationEndDateTimeStr =>
      attributes['thirdAddDurationEndDateTimeStr'];
  set thirdAddDurationEndDateTimeStr(String value) =>
      attributes['thirdAddDurationEndDateTimeStr'] = value;

  String get preferredDurationsItemsStr =>
      attributes['preferredDurationsItemsStr'];
  set preferredDurationsItemsStr(String value) =>
      attributes['preferredDurationsItemsStr'] = value;

  @override
  String toString() {
    DurationIconType? firstDurationIconType = getFirstDurationIconType();

    if (firstDurationIconType == null) {
      return '';
    } else {
      return 'addDurationStartDateTimeStr: $addDurationStartDateTimeStr\nfirstDurationIconType: $firstDurationIconType\nfirstDurationStr: $firstAddDurationDurationStr\nfirstStartDateTimeStr: $firstAddDurationStartDateTimeStr\nfirstEndDateTimeStr: $firstAddDurationEndDateTimeStr\nsecondDurationIconType: $secondDurationIconType\nsecondDurationStr: $secondAddDurationDurationStr\nsecondStartDateTimeStr: $secondAddDurationStartDateTimeStr\nsecondEndDateTimeStr: $secondAddDurationEndDateTimeStr\nthirdDurationIconType: $thirdDurationIconType\nthirdDurationStr: $thirdAddDurationDurationStr\nthirdStartDateTimeStr: $thirdAddDurationStartDateTimeStr\nthirdEndDateTimeStr: $thirdAddDurationEndDateTimeStr\npreferredDurationsItemsStr: $preferredDurationsItemsStr';
    }
  }
}
