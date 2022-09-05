import 'dart:io';

import 'package:circa_plan/utils/utility.dart';
import 'package:enough_serialization/enough_serialization.dart';

import '../constants.dart';
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
    AddDurationToDateTimeData addDurationToDateTimeData =
        AddDurationToDateTimeData();
    CalculateSleepDurationData calculateSleepDurationData =
        CalculateSleepDurationData();
    DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
        DateTimeDifferenceDurationData();
    TimeCalculatorData timeCalculatorData = TimeCalculatorData();

    objectCreators['addDurationToDateTimeData'] =
        (map) => addDurationToDateTimeData;
    objectCreators['calculateSleepDurationData'] =
        (map) => calculateSleepDurationData;
    objectCreators['dateTimeDifferenceDurationData'] =
        (map) => dateTimeDifferenceDurationData;
    objectCreators['timeCalculatorData'] = (map) => timeCalculatorData;

    // required as well so that the getter/setter below do work !
    attributes['addDurationToDateTimeData'] = addDurationToDateTimeData;
    attributes['calculateSleepDurationData'] = calculateSleepDurationData;
    attributes['dateTimeDifferenceDurationData'] =
        dateTimeDifferenceDurationData;
    attributes['timeCalculatorData'] = timeCalculatorData;
  }

  AddDurationToDateTimeData get addDurationToDateTimeData =>
      attributes['addDurationToDateTimeData'];
  set addDurationToDateTimeData(AddDurationToDateTimeData value) =>
      attributes['addDurationToDateTimeData'] = value;

  CalculateSleepDurationData get calculateSleepDurationData =>
      attributes['calculateSleepDurationData'];
  set calculateSleepDurationData(CalculateSleepDurationData value) =>
      attributes['calculateSleepDurationData'] = value;

  DateTimeDifferenceDurationData get dateTimeDifferenceDurationData =>
      attributes['dateTimeDifferenceDurationData'];
  set dateTimeDifferenceDurationData(DateTimeDifferenceDurationData value) =>
      attributes['dateTimeDifferenceDurationData'] = value;

  TimeCalculatorData get timeCalculatorData => attributes['timeCalculatorData'];
  set timeCalculatorData(TimeCalculatorData value) =>
      attributes['timeCalculatorData'] = value;

  Future<TransferData> loadTransferDataFromFile({
    required String jsonFilePathName,
  }) async {
    final Serializer serializer = Serializer();
    final String inputJsonStr = await File(jsonFilePathName).readAsString();

    // print('\nJSON CONTENT AFTER LOADING JSON FILE $jsonFilePathName');
    // print(Utility.formatJsonString(jsonString: inputJsonStr));

    // print('\ncircadian.json CONTENT AFTER LOADING $jsonFilePathName');
    // String circadianJsonFilePathName = '/storage/emulated/0/Download/CircadianData/circadian.json';
    // String circadianJsonContent = await Utility.formatJsonFileContent(jsonFilePathName: circadianJsonFilePathName);
    // print('$circadianJsonFilePathName\n$circadianJsonContent');

    final TransferData deserializedTransferData = this;
    serializer.deserialize(inputJsonStr, deserializedTransferData);

    // print(
    //     'loadTransferDataFromFile($jsonFilePathName)\nsleepDurationStr: ${calculateSleepDurationData.sleepDurationStr}\nsleepHistoryDateTimeStrLst: ${calculateSleepDurationData.sleepHistoryDateTimeStrLst}');

    Utility.renameFile(
      filePathNameStr: jsonFilePathName,
      newFileNameStr: '$kDefaultJsonFileName-1',
    );

    return deserializedTransferData;
  }

  Future<void> saveTransferDataToFile({
    required String jsonFilePathName,
    String? jsonUndoFileName,
  }) async {
    final bool jsonFileExist = await File(jsonFilePathName).exists();

    if (jsonFileExist && jsonUndoFileName != null) {
      String circadianJsonFilePathName =
          '/storage/emulated/0/Download/CircadianData/$jsonUndoFileName';
      // String screenDataSubMapKey = 'dateTimeDifferenceDurationData';
      String screenDataSubMapKey = 'calculateSleepDurationData';

      String formattedScreenDataSubMap =
          await Utility.formatScreenDataSubMapFromJsonFileContent(
              jsonFilePathName: circadianJsonFilePathName,
              screenDataSubMapKey: screenDataSubMapKey);
      print(
          '\n$jsonUndoFileName CONTENT BEFORE RENAMING circadian.json$circadianJsonFilePathName\n$formattedScreenDataSubMap');

      Utility.renameFile(
        filePathNameStr: jsonFilePathName,
        newFileNameStr: jsonUndoFileName,
      );

      formattedScreenDataSubMap =
          await Utility.formatScreenDataSubMapFromJsonFileContent(
              jsonFilePathName: circadianJsonFilePathName,
              screenDataSubMapKey: screenDataSubMapKey);
      print(
          '\n$jsonUndoFileName CONTENT AFTER RENAMING circadian.json$circadianJsonFilePathName\n$formattedScreenDataSubMap');
    }

    final Serializer serializer = Serializer();
    final String outputJsonStr = serializer.serialize(this);

    // print('\nJSON CONTENT BEFORE SAVING IT TO $jsonFilePathName');
    // print(Utility.formatJsonString(jsonString: outputJsonStr));

    // print(
    //     'saveTransferDataToFile($jsonFilePathName)\nsleepDurationStr: ${calculateSleepDurationData.sleepDurationStr}\nsleepHistoryDateTimeStrLst: ${calculateSleepDurationData.sleepHistoryDateTimeStrLst}');

    File(jsonFilePathName).writeAsStringSync(outputJsonStr);

    // print('\ncircadian.json CONTENT AFTER SAVING $jsonFilePathName');
    // String circadianJsonFilePathName = '/storage/emulated/0/Download/CircadianData/circadian.json';
    // Utility.formatJsonFileContent(jsonFilePathName: circadianJsonFilePathName).then((value) => print('$circadianJsonFilePathName\n$value'));
  }
}

Future<void> main() async {
  AddDurationToDateTimeData addDurationToDateTimeData =
      AddDurationToDateTimeData();
  addDurationToDateTimeData.firstDurationIconType = DurationIconType.add;
  addDurationToDateTimeData.addDurationStartDateTimeStr = '09_07_2022 23:58';
  addDurationToDateTimeData.firstAddDurationDurationStr = '01:00';
  addDurationToDateTimeData.firstAddDurationEndDateTimeStr = '10_07_2022 00:58';

  TransferData transferData = TransferData();
  transferData.addDurationToDateTimeData = addDurationToDateTimeData;

  String jsonFilePathName = 'transfer_data.json';
  transferData.saveTransferDataToFile(
      jsonFilePathName: jsonFilePathName,
      jsonUndoFileName: 'transfer_data.json-1');

  TransferData loadedTransferData = TransferData();
  await loadedTransferData.loadTransferDataFromFile(
      jsonFilePathName: jsonFilePathName);

  AddDurationToDateTimeData loadedAddDurationToDateTimeData =
      loadedTransferData.addDurationToDateTimeData;

  print(loadedAddDurationToDateTimeData.screenDataType);
  print(loadedAddDurationToDateTimeData.firstDurationIconType);
  print(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr);
  print(loadedAddDurationToDateTimeData.firstAddDurationDurationStr);
  print(loadedAddDurationToDateTimeData.firstAddDurationEndDateTimeStr);
}
