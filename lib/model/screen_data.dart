// https://pub.dev/packages/enough_serialization

import 'package:enough_serialization/enough_serialization.dart';

// used to select ScreenData sub type
enum ScreenDataType {
  addDurationToDateTimeData,
  calculateSleepDurationData,
  dateTimeDifferenceDurationData,
  timeCalculatorData,
}

/// used to define Colors value since Color instances can't be
/// serialized/deserialized in json file
enum ColorType {
  white,
  blue,
  blue900,
  yellow200,
  yellow300,
}

/// Screen data base class.
class ScreenData extends SerializableObject {
  ScreenData() {
    transformers['screenDataType'] = (value) =>
        value is ScreenDataType ? value.index : ScreenDataType.values[value];
    transformers['colorType'] =
        (value) => value is ColorType ? value.index : ColorType.values[value];
  }

  ScreenDataType get screenDataType => attributes['screenDataType'];
  set screenDataType(ScreenDataType value) => attributes['screenDataType'] = value;

  ColorType get colorType => attributes['colorType'];
  set colorType(ColorType value) => attributes['colorType'] = value;
}
