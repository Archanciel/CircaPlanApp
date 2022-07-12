import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:test/test.dart';

import 'package:circa_plan/model/screen_data.dart';
import 'package:circa_plan/model/transfer_data.dart';

void main() {
  group(
    'TransferData',
    () {
      test(
        'TransferData with AddDurationToDateTimeData only',
        () async {
          AddDurationToDateTimeData addDurationToDateTimeData =
              AddDurationToDateTimeData();
          addDurationToDateTimeData.durationIconType = DurationIconType.add;
          addDurationToDateTimeData.addDurationStartDateTimeStr =
              '09_07_2022 23:58';
          addDurationToDateTimeData.durationStr = '01:00';
          addDurationToDateTimeData.endDateTimeStr = '10_07_2022 00:58';

          TransferData transferData = TransferData();
          transferData.addDurationToDateTimeData = addDurationToDateTimeData;

          String jsonFilePathName = 'transfer_data.json';
          transferData.saveTransferDataToFile(
              jsonFilePathName: jsonFilePathName);

          TransferData loadedTransferData = TransferData();
          await loadedTransferData.loadTransferDataFromFile(
              jsonFilePathName: jsonFilePathName);

          AddDurationToDateTimeData loadedAddDurationToDateTimeData =
              loadedTransferData.addDurationToDateTimeData;

          expect(loadedAddDurationToDateTimeData.screenDataType,
              ScreenDataType.addDurationToDateTimeData);
          expect(loadedAddDurationToDateTimeData.durationIconType,
              DurationIconType.add);
          expect(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr,
              '09_07_2022 23:58');
          expect(loadedAddDurationToDateTimeData.durationStr, '01:00');
          expect(loadedAddDurationToDateTimeData.endDateTimeStr,
              '10_07_2022 00:58');
        },
      );
    },
  );
}
