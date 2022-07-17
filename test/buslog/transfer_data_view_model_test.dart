import 'dart:io';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/date_time_difference_duration_data.dart';
import 'package:circa_plan/model/time_calculator_data.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/screen_data.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

class TestClassWithScreenMixin with ScreenMixin {}

void main() {
  final TestClassWithScreenMixin testClassWithSreenMixin =
      TestClassWithScreenMixin();
  group(
    'TransferDataViewModel',
    () {
      test(
        'TransferDataViewModel updateAddDurationToDateTimeData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "durationIconData": Icons.add,
            "durationIconColor": Colors.green.shade200,
            "durationSign": 1,
            "durationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "durationStr": "00:00",
            "endDateTimeStr": "12-07-2022 16:00",
          };

          String path = 'c:\\temp\\CircadianData';
          final Directory directory = Directory(path);
          bool directoryExists = await directory.exists();

          if (!directoryExists) {
            await directory.create();
          }

          String pathSeparator = Platform.pathSeparator;
          String transferDataJsonFilePathName =
              '${directory.path}${pathSeparator}test${pathSeparator}buslog${pathSeparator}circadian.json';
          TransferDataViewModel transferDataViewModel = TransferDataViewModel(
              transferDataJsonFilePathName: transferDataJsonFilePathName);
          transferDataViewModel.transferDataMap = transferDataMap;
          transferDataViewModel.updateAddDurationToDateTimeData();

          AddDurationToDateTimeData addDurationToDateTimeData =
              transferDataViewModel.addDurationToDateTimeData;

          expect(addDurationToDateTimeData.screenDataType,
              ScreenDataType.addDurationToDateTimeData);
          expect(
              addDurationToDateTimeData.durationIconType, DurationIconType.add);
          expect(addDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(addDurationToDateTimeData.addDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.addDurationEndDateTimeStr,
              '12-07-2022 16:00');
        },
      );
      test(
        'TransferDataViewModel updateCalculateSleepDurationData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "calcSlDurNewDateTimeStr": '14-07-2022 13:09',
            "calcSlDurPreviousDateTimeStr": '14-07-2022 13:13',
            "calcSlDurBeforePreviousDateTimeStr": '14-07-2022 13:12',
            "calcSlDurCurrSleepDurationStr": '12:36',
            "calcSlDurCurrWakeUpDurationStr": '0:02',
            "calcSlDurCurrTotalDurationStr": '12:38',
            "calcSlDurStatus": Status.sleep,
            "calcSlDurSleepTimeStrHistory": [
              '10_07_2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10_07_2022 05:58',
              '00:35',
              '01:00'
            ],
          };

          String path = 'c:\\temp\\CircadianData';
          final Directory directory = Directory(path);
          bool directoryExists = await directory.exists();

          if (!directoryExists) {
            await directory.create();
          }

          String pathSeparator = Platform.pathSeparator;
          String transferDataJsonFilePathName =
              '${directory.path}${pathSeparator}test${pathSeparator}buslog${pathSeparator}circadian.json';
          TransferDataViewModel transferDataViewModel = TransferDataViewModel(
              transferDataJsonFilePathName: transferDataJsonFilePathName);
          transferDataViewModel.transferDataMap = transferDataMap;
          transferDataViewModel.updateCalculateSleepDurationData();

          CalculateSleepDurationData calculateSleepDurationData =
              transferDataViewModel.calculateSleepDurationData;

          expect(calculateSleepDurationData.screenDataType,
              ScreenDataType.calculateSleepDurationData);
          expect(calculateSleepDurationData.status, Status.sleep);
          expect(calculateSleepDurationData.sleepDurationNewDateTimeStr,
              '14-07-2022 13:09');
          expect(calculateSleepDurationData.sleepDurationPreviousDateTimeStr,
              '14-07-2022 13:13');
          expect(
              calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr,
              '14-07-2022 13:12');
          expect(calculateSleepDurationData.sleepDurationStr, '12:36');
          expect(calculateSleepDurationData.wakeUpDurationStr, '0:02');
          expect(calculateSleepDurationData.totalDurationStr, '12:38');
          expect(calculateSleepDurationData.sleepHistoryDateTimeStrLst,
              ['10_07_2022 00:58', '05:35', '04:00']);
          expect(calculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10_07_2022 05:58', '00:35', '01:00']);
        },
      );
      test(
        'TransferDataViewModel updateDateTimeDifferenceDurationData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "dtDiffStartDateTimeStr": "2022-07-13 16:09",
            "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
            "dtDiffDurationStr": "24:00",
            "dtDiffAddTimeStr": "1:00",
            "dtDiffFinalDurationStr": "25:00",
          };

          String path = 'c:\\temp\\CircadianData';
          final Directory directory = Directory(path);
          bool directoryExists = await directory.exists();

          if (!directoryExists) {
            await directory.create();
          }

          String pathSeparator = Platform.pathSeparator;
          String transferDataJsonFilePathName =
              '${directory.path}${pathSeparator}test${pathSeparator}buslog${pathSeparator}circadian.json';
          TransferDataViewModel transferDataViewModel = TransferDataViewModel(
              transferDataJsonFilePathName: transferDataJsonFilePathName);
          transferDataViewModel.transferDataMap = transferDataMap;
          transferDataViewModel.updateDateTimeDifferenceDurationData();

          DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
              transferDataViewModel.dateTimeDifferenceDurationData;

          expect(dateTimeDifferenceDurationData.screenDataType,
              ScreenDataType.dateTimeDifferenceDurationData);
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceStartDateTimeStr,
              "2022-07-13 16:09");
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceEndDateTimeStr,
              "2022-07-14 16:09:42.390753");
          expect(dateTimeDifferenceDurationData.dateTimeDifferenceDurationStr,
              "24:00");
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceFinalDurationStr,
              "25:00");
        },
      );
      test(
        'TransferDataViewModel updateTimeCalculatorData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
          };

          String path = 'c:\\temp\\CircadianData';
          final Directory directory = Directory(path);
          bool directoryExists = await directory.exists();

          if (!directoryExists) {
            await directory.create();
          }

          String pathSeparator = Platform.pathSeparator;
          String transferDataJsonFilePathName =
              '${directory.path}${pathSeparator}test${pathSeparator}buslog${pathSeparator}circadian.json';
          TransferDataViewModel transferDataViewModel = TransferDataViewModel(
              transferDataJsonFilePathName: transferDataJsonFilePathName);
          transferDataViewModel.transferDataMap = transferDataMap;
          transferDataViewModel.updateTimeCalculatorData();

          TimeCalculatorData timeCalculatorData =
              transferDataViewModel.timeCalculatorData;

          expect(timeCalculatorData.screenDataType,
              ScreenDataType.timeCalculatorData);
          expect(timeCalculatorData.timeCalculatorFirstTimeStr, "00:10:00");
          expect(timeCalculatorData.timeCalculatorSecondTimeStr, "00:05:00");
          expect(timeCalculatorData.timeCalculatorResultTimeStr, "00:15:00");
        },
      );
      test(
        'TransferDataViewModel updateTransferData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "durationIconData": Icons.add,
            "durationIconColor": Colors.green.shade200,
            "durationSign": 1,
            "durationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "durationStr": "00:00",
            "endDateTimeStr": "12-07-2022 16:00",
            "calcSlDurNewDateTimeStr": '14-07-2022 13:09',
            "calcSlDurPreviousDateTimeStr": '14-07-2022 13:13',
            "calcSlDurBeforePreviousDateTimeStr": '14-07-2022 13:12',
            "calcSlDurCurrSleepDurationStr": '12:36',
            "calcSlDurCurrWakeUpDurationStr": '0:02',
            "calcSlDurCurrTotalDurationStr": '12:38',
            "calcSlDurStatus": Status.sleep,
            "calcSlDurSleepTimeStrHistory": [
              '10_07_2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10_07_2022 05:58',
              '00:35',
              '01:00'
            ],
            "dtDiffStartDateTimeStr": "2022-07-13 16:09",
            "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
            "dtDiffDurationStr": "24:00",
            "dtDiffAddTimeStr": "1:00",
            "dtDiffFinalDurationStr": "25:00",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
          };

          String path = 'c:\\temp\\CircadianData';
          final Directory directory = Directory(path);
          bool directoryExists = await directory.exists();

          if (!directoryExists) {
            await directory.create();
          }

          String pathSeparator = Platform.pathSeparator;
          String transferDataJsonFilePathName =
              '${directory.path}${pathSeparator}circadian.json';
          TransferDataViewModel transferDataViewModel = TransferDataViewModel(
              transferDataJsonFilePathName: transferDataJsonFilePathName);
          transferDataViewModel.transferDataMap = transferDataMap;
          transferDataViewModel.updateTransferData();

          AddDurationToDateTimeData addDurationToDateTimeData =
              transferDataViewModel.addDurationToDateTimeData;

          expect(addDurationToDateTimeData.screenDataType,
              ScreenDataType.addDurationToDateTimeData);
          expect(
              addDurationToDateTimeData.durationIconType, DurationIconType.add);
          expect(addDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(addDurationToDateTimeData.addDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.addDurationEndDateTimeStr,
              '12-07-2022 16:00');

          CalculateSleepDurationData calculateSleepDurationData =
              transferDataViewModel.calculateSleepDurationData;

          expect(calculateSleepDurationData.screenDataType,
              ScreenDataType.calculateSleepDurationData);
          expect(calculateSleepDurationData.status, Status.sleep);
          expect(calculateSleepDurationData.sleepDurationNewDateTimeStr,
              '14-07-2022 13:09');
          expect(calculateSleepDurationData.sleepDurationPreviousDateTimeStr,
              '14-07-2022 13:13');
          expect(
              calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr,
              '14-07-2022 13:12');
          expect(calculateSleepDurationData.sleepDurationStr, '12:36');
          expect(calculateSleepDurationData.wakeUpDurationStr, '0:02');
          expect(calculateSleepDurationData.totalDurationStr, '12:38');
          expect(calculateSleepDurationData.sleepHistoryDateTimeStrLst,
              ['10_07_2022 00:58', '05:35', '04:00']);
          expect(calculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10_07_2022 05:58', '00:35', '01:00']);

          DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
              transferDataViewModel.dateTimeDifferenceDurationData;

          expect(dateTimeDifferenceDurationData.screenDataType,
              ScreenDataType.dateTimeDifferenceDurationData);
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceStartDateTimeStr,
              "2022-07-13 16:09");
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceEndDateTimeStr,
              "2022-07-14 16:09:42.390753");
          expect(dateTimeDifferenceDurationData.dateTimeDifferenceDurationStr,
              "24:00");
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceFinalDurationStr,
              "25:00");

          TimeCalculatorData timeCalculatorData =
              transferDataViewModel.timeCalculatorData;

          expect(timeCalculatorData.screenDataType,
              ScreenDataType.timeCalculatorData);
          expect(timeCalculatorData.timeCalculatorFirstTimeStr, "00:10:00");
          expect(timeCalculatorData.timeCalculatorSecondTimeStr, "00:05:00");
          expect(timeCalculatorData.timeCalculatorResultTimeStr, "00:15:00");
        },
      );
      test(
        'TransferDataViewModel loadTransferData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "durationIconData": Icons.add,
            "durationIconColor": Colors.green.shade200,
            "durationSign": 1,
            "durationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "durationStr": "00:00",
            "endDateTimeStr": "12-07-2022 16:00",
            "calcSlDurNewDateTimeStr": '14-07-2022 13:09',
            "calcSlDurPreviousDateTimeStr": '14-07-2022 13:13',
            "calcSlDurBeforePreviousDateTimeStr": '14-07-2022 13:12',
            "calcSlDurCurrSleepDurationStr": '12:36',
            "calcSlDurCurrWakeUpDurationStr": '0:02',
            "calcSlDurCurrTotalDurationStr": '12:38',
            "calcSlDurStatus": Status.sleep,
            "calcSlDurSleepTimeStrHistory": [
              '10_07_2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10_07_2022 05:58',
              '00:35',
              '01:00'
            ],
            "dtDiffStartDateTimeStr": "2022-07-13 16:09",
            "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
            "dtDiffDurationStr": "24:00",
            "dtDiffAddTimeStr": "1:00",
            "dtDiffFinalDurationStr": "25:00",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
          };

          String path = 'c:\\temp\\CircadianData';
          final Directory directory = Directory(path);
          bool directoryExists = await directory.exists();

          if (!directoryExists) {
            await directory.create();
          }

          String pathSeparator = Platform.pathSeparator;
          String transferDataJsonFilePathName =
              '${directory.path}${pathSeparator}circadian.json';
          TransferDataViewModel transferDataViewModel = TransferDataViewModel(
              transferDataJsonFilePathName: transferDataJsonFilePathName);
          transferDataViewModel.transferDataMap = transferDataMap;
          transferDataViewModel.updateTransferData(); // saves to json file

          TransferDataViewModel loadedTransferDataViewModel =
              TransferDataViewModel(
                  transferDataJsonFilePathName: transferDataJsonFilePathName);

          Map<String, dynamic> emptyTransferDataMap = {};

          loadedTransferDataViewModel.transferDataMap = emptyTransferDataMap;
          await loadedTransferDataViewModel.loadTransferData();

          AddDurationToDateTimeData addDurationToDateTimeData =
              loadedTransferDataViewModel.addDurationToDateTimeData;

          expect(addDurationToDateTimeData.screenDataType,
              ScreenDataType.addDurationToDateTimeData);
          expect(
              addDurationToDateTimeData.durationIconType, DurationIconType.add);
          expect(addDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(addDurationToDateTimeData.addDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.addDurationEndDateTimeStr,
              '12-07-2022 16:00');

          CalculateSleepDurationData calculateSleepDurationData =
              loadedTransferDataViewModel.calculateSleepDurationData;

          expect(calculateSleepDurationData.screenDataType,
              ScreenDataType.calculateSleepDurationData);
          expect(calculateSleepDurationData.status, Status.sleep);
          expect(calculateSleepDurationData.sleepDurationNewDateTimeStr,
              '14-07-2022 13:09');
          expect(calculateSleepDurationData.sleepDurationPreviousDateTimeStr,
              '14-07-2022 13:13');
          expect(
              calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr,
              '14-07-2022 13:12');
          expect(calculateSleepDurationData.sleepDurationStr, '12:36');
          expect(calculateSleepDurationData.wakeUpDurationStr, '0:02');
          expect(calculateSleepDurationData.totalDurationStr, '12:38');
          expect(calculateSleepDurationData.sleepHistoryDateTimeStrLst,
              ['10_07_2022 00:58', '05:35', '04:00']);
          expect(calculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10_07_2022 05:58', '00:35', '01:00']);

          DateTimeDifferenceDurationData dateTimeDifferenceDurationData =
              loadedTransferDataViewModel.dateTimeDifferenceDurationData;

          expect(dateTimeDifferenceDurationData.screenDataType,
              ScreenDataType.dateTimeDifferenceDurationData);
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceStartDateTimeStr,
              "2022-07-13 16:09");
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceEndDateTimeStr,
              "2022-07-14 16:09:42.390753");
          expect(dateTimeDifferenceDurationData.dateTimeDifferenceDurationStr,
              "24:00");
          expect(
              dateTimeDifferenceDurationData.dateTimeDifferenceFinalDurationStr,
              "25:00");

          TimeCalculatorData timeCalculatorData =
              loadedTransferDataViewModel.timeCalculatorData;

          expect(timeCalculatorData.screenDataType,
              ScreenDataType.timeCalculatorData);
          expect(timeCalculatorData.timeCalculatorFirstTimeStr, "00:10:00");
          expect(timeCalculatorData.timeCalculatorSecondTimeStr, "00:05:00");
          expect(timeCalculatorData.timeCalculatorResultTimeStr, "00:15:00");

          expect(loadedTransferDataViewModel.getTransferDataMap(),
              transferDataMap);
        },
      );
    },
  );
}
