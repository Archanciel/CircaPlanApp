import 'package:circa_plan/constants.dart';
import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/date_time_difference_duration_data.dart';
import 'package:circa_plan/model/time_calculator_data.dart';
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
          addDurationToDateTimeData.firstDurationIconType =
              FirstDurationIconType.add;
          addDurationToDateTimeData.addDurationStartDateTimeStr =
              '09_07_2022 23:58';
          addDurationToDateTimeData.firstAddDurationDurationStr = '01:00';
          addDurationToDateTimeData.firstAddDurationEndDateTimeStr =
              '10_07_2022 00:58';

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
          expect(loadedAddDurationToDateTimeData.firstDurationIconType,
              FirstDurationIconType.add);
          expect(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr,
              '09_07_2022 23:58');
          expect(loadedAddDurationToDateTimeData.firstAddDurationDurationStr,
              '01:00');
          expect(loadedAddDurationToDateTimeData.firstAddDurationEndDateTimeStr,
              '10_07_2022 00:58');
        },
      );
      test(
        'TransferData with CalculateSleepDurationData only',
        () async {
          CalculateSleepDurationData calculateSleepDurationData =
              CalculateSleepDurationData();
          calculateSleepDurationData.status = Status.sleep;
          calculateSleepDurationData.sleepDurationNewDateTimeStr =
              '09_07_2022 23:58';
          calculateSleepDurationData.sleepDurationPreviousDateTimeStr =
              '09_07_2022 22:58';
          calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr =
              '09_07_2022 21:58';
          calculateSleepDurationData.sleepDurationStr = '01:00';
          calculateSleepDurationData.wakeUpDurationStr = '00:30';
          calculateSleepDurationData.totalDurationStr = '01:30';
          calculateSleepDurationData.sleepHistoryDateTimeStrLst = [
            '10_07_2022 00:58',
            '05:35',
            '04:00'
          ];
          calculateSleepDurationData.wakeUpHistoryDateTimeStrLst = [
            '10_07_2022 05:58',
            '00:35',
            '01:00'
          ];

          TransferData transferData = TransferData();
          transferData.calculateSleepDurationData = calculateSleepDurationData;

          String jsonFilePathName = 'transfer_data.json';
          transferData.saveTransferDataToFile(
              jsonFilePathName: jsonFilePathName);

          TransferData loadedTransferData = TransferData();
          await loadedTransferData.loadTransferDataFromFile(
              jsonFilePathName: jsonFilePathName);

          CalculateSleepDurationData loadedCalculateSleepDurationData =
              loadedTransferData.calculateSleepDurationData;

          expect(loadedCalculateSleepDurationData.screenDataType,
              ScreenDataType.calculateSleepDurationData);
          expect(loadedCalculateSleepDurationData.status, Status.sleep);
          expect(loadedCalculateSleepDurationData.sleepDurationNewDateTimeStr,
              '09_07_2022 23:58');
          expect(
              loadedCalculateSleepDurationData.sleepDurationPreviousDateTimeStr,
              '09_07_2022 22:58');
          expect(
              loadedCalculateSleepDurationData
                  .sleepDurationBeforePreviousDateTimeStr,
              '09_07_2022 21:58');
          expect(loadedCalculateSleepDurationData.sleepDurationStr, '01:00');
          expect(loadedCalculateSleepDurationData.wakeUpDurationStr, '00:30');
          expect(loadedCalculateSleepDurationData.totalDurationStr, '01:30');
          expect(loadedCalculateSleepDurationData.sleepHistoryDateTimeStrLst,
              ['10_07_2022 00:58', '05:35', '04:00']);
          expect(loadedCalculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10_07_2022 05:58', '00:35', '01:00']);
        },
      );
      test(
        'TransferData with DateTimeDifferenceDurationData only',
        () async {
          DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
              DateTimeDifferenceDurationData();
          dateTimeDifferenceDurationData.dateTimeDifferenceStartDateTimeStr =
              '09_07_2022 23:58';
          dateTimeDifferenceDurationData.dateTimeDifferenceEndDateTimeStr =
              '09_07_2022 22:58';
          dateTimeDifferenceDurationData.dateTimeDifferenceDurationStr =
              '-01:00';
          dateTimeDifferenceDurationData.dateTimeDifferenceAddTimeStr = '02:00';
          dateTimeDifferenceDurationData.dateTimeDifferenceFinalDurationStr =
              '01:00';

          TransferData transferData = TransferData();
          transferData.dateTimeDifferenceDurationData =
              dateTimeDifferenceDurationData;

          String jsonFilePathName = 'transfer_data.json';
          transferData.saveTransferDataToFile(
              jsonFilePathName: jsonFilePathName);

          TransferData loadedTransferData = TransferData();
          await loadedTransferData.loadTransferDataFromFile(
              jsonFilePathName: jsonFilePathName);

          DateTimeDifferenceDurationData loadedDateTimeDifferenceDurationData =
              loadedTransferData.dateTimeDifferenceDurationData;

          expect(loadedDateTimeDifferenceDurationData.screenDataType,
              ScreenDataType.dateTimeDifferenceDurationData);
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceStartDateTimeStr,
              '09_07_2022 23:58');
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceEndDateTimeStr,
              '09_07_2022 22:58');
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationStr,
              '-01:00');
          expect(
              loadedDateTimeDifferenceDurationData.dateTimeDifferenceAddTimeStr,
              '02:00');
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceFinalDurationStr,
              '01:00');
        },
      );
      test(
        'TransferData with TimeCalculatorData only',
        () async {
          TimeCalculatorData timeCalculatorData = TimeCalculatorData();
          timeCalculatorData.timeCalculatorFirstTimeStr = '00:10:00';
          timeCalculatorData.timeCalculatorSecondTimeStr = '00:05:00';
          timeCalculatorData.timeCalculatorResultTimeStr = '00:15:00';

          TransferData transferData = TransferData();
          transferData.timeCalculatorData = timeCalculatorData;

          String jsonFilePathName = 'transfer_data.json';
          transferData.saveTransferDataToFile(
              jsonFilePathName: jsonFilePathName);

          TransferData loadedTransferData = TransferData();
          await loadedTransferData.loadTransferDataFromFile(
              jsonFilePathName: jsonFilePathName);

          TimeCalculatorData loadedTimeCalculatorData =
              loadedTransferData.timeCalculatorData;

          expect(loadedTimeCalculatorData.screenDataType,
              ScreenDataType.timeCalculatorData);
          expect(
              loadedTimeCalculatorData.timeCalculatorFirstTimeStr, '00:10:00');
          expect(
              loadedTimeCalculatorData.timeCalculatorSecondTimeStr, '00:05:00');
          expect(
              loadedTimeCalculatorData.timeCalculatorResultTimeStr, '00:15:00');
        },
      );
      test(
        'TransferData with all data types',
        () async {
          AddDurationToDateTimeData addDurationToDateTimeData =
              AddDurationToDateTimeData();
          addDurationToDateTimeData.firstDurationIconType =
              FirstDurationIconType.add;
          addDurationToDateTimeData.addDurationStartDateTimeStr =
              '09_07_2022 23:58';
          addDurationToDateTimeData.firstAddDurationDurationStr = '01:00';
          addDurationToDateTimeData.firstAddDurationEndDateTimeStr =
              '10_07_2022 00:58';

          TransferData transferData = TransferData();
          transferData.addDurationToDateTimeData = addDurationToDateTimeData;

          CalculateSleepDurationData calculateSleepDurationData =
              CalculateSleepDurationData();
          calculateSleepDurationData.status = Status.sleep;
          calculateSleepDurationData.sleepDurationNewDateTimeStr =
              '09_07_2022 23:58';
          calculateSleepDurationData.sleepDurationPreviousDateTimeStr =
              '09_07_2022 22:58';
          calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr =
              '09_07_2022 21:58';
          calculateSleepDurationData.sleepDurationStr = '01:00';
          calculateSleepDurationData.wakeUpDurationStr = '00:30';
          calculateSleepDurationData.totalDurationStr = '01:30';
          calculateSleepDurationData.sleepHistoryDateTimeStrLst = [
            '10_07_2022 00:58',
            '05:35',
            '04:00'
          ];
          calculateSleepDurationData.wakeUpHistoryDateTimeStrLst = [
            '10_07_2022 05:58',
            '00:35',
            '01:00'
          ];

          transferData.calculateSleepDurationData = calculateSleepDurationData;

          DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
              DateTimeDifferenceDurationData();
          dateTimeDifferenceDurationData.dateTimeDifferenceStartDateTimeStr =
              '09_07_2022 23:58';
          dateTimeDifferenceDurationData.dateTimeDifferenceEndDateTimeStr =
              '09_07_2022 22:58';
          dateTimeDifferenceDurationData.dateTimeDifferenceDurationStr =
              '-01:00';
          dateTimeDifferenceDurationData.dateTimeDifferenceAddTimeStr = '02:00';
          dateTimeDifferenceDurationData.dateTimeDifferenceFinalDurationStr =
              '01:00';

          transferData.dateTimeDifferenceDurationData =
              dateTimeDifferenceDurationData;

          TimeCalculatorData timeCalculatorData = TimeCalculatorData();
          timeCalculatorData.timeCalculatorFirstTimeStr = '00:10:00';
          timeCalculatorData.timeCalculatorSecondTimeStr = '00:05:00';
          timeCalculatorData.timeCalculatorResultTimeStr = '00:15:00';

          transferData.timeCalculatorData = timeCalculatorData;

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
          expect(loadedAddDurationToDateTimeData.firstDurationIconType,
              FirstDurationIconType.add);
          expect(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr,
              '09_07_2022 23:58');
          expect(loadedAddDurationToDateTimeData.firstAddDurationDurationStr,
              '01:00');
          expect(loadedAddDurationToDateTimeData.firstAddDurationEndDateTimeStr,
              '10_07_2022 00:58');

          CalculateSleepDurationData loadedCalculateSleepDurationData =
              loadedTransferData.calculateSleepDurationData;

          expect(loadedCalculateSleepDurationData.screenDataType,
              ScreenDataType.calculateSleepDurationData);
          expect(loadedCalculateSleepDurationData.status, Status.sleep);
          expect(loadedCalculateSleepDurationData.sleepDurationNewDateTimeStr,
              '09_07_2022 23:58');
          expect(
              loadedCalculateSleepDurationData.sleepDurationPreviousDateTimeStr,
              '09_07_2022 22:58');
          expect(
              loadedCalculateSleepDurationData
                  .sleepDurationBeforePreviousDateTimeStr,
              '09_07_2022 21:58');
          expect(loadedCalculateSleepDurationData.sleepDurationStr, '01:00');
          expect(loadedCalculateSleepDurationData.wakeUpDurationStr, '00:30');
          expect(loadedCalculateSleepDurationData.totalDurationStr, '01:30');
          expect(loadedCalculateSleepDurationData.sleepHistoryDateTimeStrLst,
              ['10_07_2022 00:58', '05:35', '04:00']);
          expect(loadedCalculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10_07_2022 05:58', '00:35', '01:00']);

          DateTimeDifferenceDurationData loadedDateTimeDifferenceDurationData =
              loadedTransferData.dateTimeDifferenceDurationData;

          expect(loadedDateTimeDifferenceDurationData.screenDataType,
              ScreenDataType.dateTimeDifferenceDurationData);
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceStartDateTimeStr,
              '09_07_2022 23:58');
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceEndDateTimeStr,
              '09_07_2022 22:58');
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationStr,
              '-01:00');
          expect(
              loadedDateTimeDifferenceDurationData.dateTimeDifferenceAddTimeStr,
              '02:00');
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceFinalDurationStr,
              '01:00');

          TimeCalculatorData loadedTimeCalculatorData =
              loadedTransferData.timeCalculatorData;

          expect(loadedTimeCalculatorData.screenDataType,
              ScreenDataType.timeCalculatorData);
          expect(
              loadedTimeCalculatorData.timeCalculatorFirstTimeStr, '00:10:00');
          expect(
              loadedTimeCalculatorData.timeCalculatorSecondTimeStr, '00:05:00');
          expect(
              loadedTimeCalculatorData.timeCalculatorResultTimeStr, '00:15:00');
        },
      );
    },
  );
}
