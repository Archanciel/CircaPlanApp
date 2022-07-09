import 'dart:io';

import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:enough_serialization/enough_serialization.dart';

class TransferData extends SerializableObject {
  TransferData() {
    objectCreators['addDurationToDateTimeData'] =
        (map) => AddDurationToDateTimeData();
  }

  AddDurationToDateTimeData get addDurationToDateTimeData =>
      attributes['addDurationToDateTimeData'];
  set addDurationToDateTimeData(AddDurationToDateTimeData value) =>
      attributes['addDurationToDateTimeData'] = value;

  Future<TransferData> loadTransferDataFromFile(
      {required String filePathName}) async {
    final Serializer serializer = Serializer();
    final String inputJsonStr = await File(filePathName).readAsString();
    final TransferData deserializedOrder = this;
    serializer.deserialize(inputJsonStr, deserializedOrder);

    return deserializedOrder;
  }

  void saveTransferDataToFile({required String filePathName}) {
    final Serializer serializer = Serializer();
    final String orderJsonStr = serializer.serialize(this);

    print(
        'transferData json string before writing it to $filePathName:\n$orderJsonStr\n\n');

    File(filePathName).writeAsStringSync(orderJsonStr);
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
  transferData.saveTransferDataToFile(filePathName: jsonFilePathName);

  TransferData loadedTransferData = TransferData();
  await loadedTransferData.loadTransferDataFromFile(
      filePathName: jsonFilePathName);

  AddDurationToDateTimeData loadedAddDurationToDateTimeData =
      loadedTransferData.addDurationToDateTimeData;

  print(loadedAddDurationToDateTimeData.screenDataType);
  print(loadedAddDurationToDateTimeData.durationIconType);
  print(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr);
  print(loadedAddDurationToDateTimeData.durationStr);
  print(loadedAddDurationToDateTimeData.endDateTimeStr);
}
