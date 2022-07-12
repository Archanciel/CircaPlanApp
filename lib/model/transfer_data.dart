import 'dart:io';

import 'package:enough_serialization/enough_serialization.dart';

import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/date_time_difference_duration_data.dart';
import 'package:circa_plan/model/time_calculator_data.dart';

/// Class including screen data instances and responsible of saving
/// and loading data to and from json file.
///
/// Included screen data classes: [AddDurationToDateTimeData],
/// [CalculateSleepDurationData], [DateTimeDifferenceDurationData],
/// [TimeCalculatorData] which inherit from [ScreenData] base class.
///
class TransferData extends SerializableObject {
  TransferData() {
    // instanciating empty screen data sub classes
    objectCreators['addDurationToDateTimeData'] =
        (map) => AddDurationToDateTimeData();
    objectCreators['calculateSleepDurationData'] =
        (map) => CalculateSleepDurationData();
    objectCreators['dateTimeDifferenceDurationData'] =
        (map) => DateTimeDifferenceDurationData();
    objectCreators['timeCalculatorData'] = (map) => TimeCalculatorData();
  }

  AddDurationToDateTimeData get addDurationToDateTimeData =>
      attributes['addDurationToDateTimeData'];
  set addDurationToDateTimeData(AddDurationToDateTimeData value) =>
      attributes['addDurationToDateTimeData'] = value;

  CalculateSleepDurationData get calculateSleepDurationData =>
      attributes['calculateSleepDurationData'];
  set calculateSleepDurationData(CalculateSleepDurationData value) =>
      attributes['calculateSleepDurationData'] = value;

  AddDurationToDateTimeData get dateTimeDifferenceDurationData =>
      attributes['dateTimeDifferenceDurationData'];
  set dateTimeDifferenceDurationData(AddDurationToDateTimeData value) =>
      attributes['dateTimeDifferenceDurationData'] = value;

  TimeCalculatorData get timeCalculatorData => attributes['timeCalculatorData'];
  set timeCalculatorData(TimeCalculatorData value) =>
      attributes['timeCalculatorData'] = value;

  Future<TransferData> loadTransferDataFromFile(
      {required String jsonFilePathName}) async {
    final Serializer serializer = Serializer();
    final String inputJsonStr = await File(jsonFilePathName).readAsString();
    final TransferData deserializedTransferData = this;
    serializer.deserialize(inputJsonStr, deserializedTransferData);

    return deserializedTransferData;
  }

  void saveTransferDataToFile({required String jsonFilePathName}) {
    final Serializer serializer = Serializer();
    final String outputJsonStr = serializer.serialize(this);

    File(jsonFilePathName).writeAsStringSync(outputJsonStr);
  }
}

Future<void> main() async {
  AddDurationToDateTimeData addDurationToDateTimeData =
      AddDurationToDateTimeData();
  addDurationToDateTimeData.durationIconType = DurationIconType.add;
  addDurationToDateTimeData.addDurationStartDateTimeStr = '09_07_2022 23:58';
  addDurationToDateTimeData.durationStr = '01:00';
  addDurationToDateTimeData.endDateTimeStr = '10_07_2022 00:58';

  TransferData transferData = TransferData();
  transferData.addDurationToDateTimeData = addDurationToDateTimeData;

  String jsonFilePathName = 'transfer_data.json';
  transferData.saveTransferDataToFile(jsonFilePathName: jsonFilePathName);

  TransferData loadedTransferData = TransferData();
  await loadedTransferData.loadTransferDataFromFile(
      jsonFilePathName: jsonFilePathName);

  AddDurationToDateTimeData loadedAddDurationToDateTimeData =
      loadedTransferData.addDurationToDateTimeData;

  print(loadedAddDurationToDateTimeData.screenDataType);
  print(loadedAddDurationToDateTimeData.durationIconType);
  print(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr);
  print(loadedAddDurationToDateTimeData.durationStr);
  print(loadedAddDurationToDateTimeData.endDateTimeStr);
}
