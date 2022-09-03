import 'dart:io';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/date_time_difference_duration_data.dart';
import 'package:circa_plan/model/time_calculator_data.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';
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
  const String kCircadianAppDataDir = 'c:\\temp\\CircadianData';
  group(
    'TransferDataViewModel',
    () {
      test(
        'TransferDataViewModel updateAddDurationToDateTimeData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "firstDurationIconData": Icons.add,
            "firstDurationIconColor": Colors.green.shade200,
            "firstDurationSign": 1,
            "firstDurationTextColor": Colors.green.shade200,
            "firstDurationStr": "00:00",
            "firstStartDateTimeStr": "12-07-2022 16:00",
            "firstEndDateTimeStr": "12-07-2022 16:00",
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "00:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 16:00",
            "thirdDurationIconData": Icons.remove,
            "thirdDurationIconColor": Colors.red.shade200,
            "thirdDurationSign": -1,
            "thirdDurationTextColor": Colors.red.shade200,
            "thirdDurationStr": "00:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 16:00",
          };

          String path = kCircadianAppDataDir;
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
          expect(addDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(addDurationToDateTimeData.firstDurationIconType,
              DurationIconType.add);
          expect(
              addDurationToDateTimeData.firstAddDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.firstAddDurationEndDateTimeStr,
              '12-07-2022 16:00');
          expect(addDurationToDateTimeData.secondDurationIconType,
              DurationIconType.subtract);
          expect(
              addDurationToDateTimeData.secondAddDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.secondAddDurationEndDateTimeStr,
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
            "calcSlDurCurrSleepDurationPercentStr": '99.74 %',
            "calcSlDurCurrWakeUpDurationPercentStr": '0.26 %',
            "calcSlDurCurrTotalDurationPercentStr": '100 %',
            "calcSlDurCurrSleepPrevDayTotalPercentStr": '79.74 %',
            "calcSlDurCurrWakeUpPrevDayTotalPercentStr": '1.26 %',
            "calcSlDurCurrTotalPrevDayTotalPercentStr": '81 %',
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

          String path = kCircadianAppDataDir;
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
          expect(calculateSleepDurationData.sleepDurationPercentStr, '99.74 %');
          expect(calculateSleepDurationData.wakeUpDurationPercentStr, '0.26 %');
          expect(calculateSleepDurationData.totalDurationPercentStr, '100 %');
          expect(calculateSleepDurationData.sleepPrevDayTotalPercentStr,
              '79.74 %');
          expect(calculateSleepDurationData.wakeUpPrevDayTotalPercentStr,
              '1.26 %');
          expect(
              calculateSleepDurationData.totalPrevDayTotalPercentStr, '81 %');
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
            "dtDurationPercentStr": "70 %"
          };

          String path = kCircadianAppDataDir;
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
          expect(
              dateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationPercentStr,
              "70 %");
        },
      );
      test(
        'TransferDataViewModel updateTimeCalculatorData',
        () async {
          Map<String, dynamic> transferDataMap = {
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
            "resultPercentStr": "40 %",
          };

          String path = kCircadianAppDataDir;
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
            "firstDurationIconData": Icons.add,
            "firstDurationIconColor": Colors.green.shade200,
            "firstDurationSign": 1,
            "firstDurationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "firstDurationStr": "00:00",
            "firstStartDateTimeStr": "12-07-2022 16:00",
            "firstEndDateTimeStr": "12-07-2022 16:00",
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "00:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 16:00",
            "thirdDurationIconData": Icons.remove,
            "thirdDurationIconColor": Colors.red.shade200,
            "thirdDurationSign": -1,
            "thirdDurationTextColor": Colors.red.shade200,
            "thirdDurationStr": "00:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 16:00",
            "calcSlDurNewDateTimeStr": '14-07-2022 13:09',
            "calcSlDurPreviousDateTimeStr": '14-07-2022 13:13',
            "calcSlDurBeforePreviousDateTimeStr": '14-07-2022 13:12',
            "calcSlDurCurrSleepDurationStr": '12:36',
            "calcSlDurCurrWakeUpDurationStr": '0:02',
            "calcSlDurCurrTotalDurationStr": '12:38',
            "calcSlDurCurrSleepDurationPercentStr": '99.74 %',
            "calcSlDurCurrWakeUpDurationPercentStr": '0.26 %',
            "calcSlDurCurrTotalDurationPercentStr": '100 %',
            "calcSlDurCurrSleepPrevDayTotalPercentStr": '79.74 %',
            "calcSlDurCurrWakeUpPrevDayTotalPercentStr": '1.26 %',
            "calcSlDurCurrTotalPrevDayTotalPercentStr": '81 %',
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
            "dtDurationPercentStr": "70 %",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
            "resultPercentStr": "40 %",
          };

          String path = kCircadianAppDataDir;
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
          transferDataViewModel.updateAndSaveTransferData();

          AddDurationToDateTimeData addDurationToDateTimeData =
              transferDataViewModel.addDurationToDateTimeData;

          expect(addDurationToDateTimeData.screenDataType,
              ScreenDataType.addDurationToDateTimeData);
          expect(addDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(addDurationToDateTimeData.firstDurationIconType,
              DurationIconType.add);
          expect(
              addDurationToDateTimeData.firstAddDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.firstAddDurationEndDateTimeStr,
              '12-07-2022 16:00');
          expect(addDurationToDateTimeData.secondDurationIconType,
              DurationIconType.subtract);
          expect(
              addDurationToDateTimeData.secondAddDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.secondAddDurationEndDateTimeStr,
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
          expect(calculateSleepDurationData.sleepDurationPercentStr, '99.74 %');
          expect(calculateSleepDurationData.wakeUpDurationPercentStr, '0.26 %');
          expect(calculateSleepDurationData.totalDurationPercentStr, '100 %');
          expect(calculateSleepDurationData.sleepPrevDayTotalPercentStr,
              '79.74 %');
          expect(calculateSleepDurationData.wakeUpPrevDayTotalPercentStr,
              '1.26 %');
          expect(
              calculateSleepDurationData.totalPrevDayTotalPercentStr, '81 %');
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
          expect(
              dateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationPercentStr,
              "70 %");

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
            "firstDurationIconData": Icons.add,
            "firstDurationIconColor": Colors.green.shade200,
            "firstDurationSign": 1,
            "firstDurationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "firstDurationStr": "00:50",
            "firstStartDateTimeStr": "12-07-2022 16:00",
            "firstEndDateTimeStr": "12-07-2022 16:50",
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "02:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 14:00",
            "thirdDurationIconData": Icons.remove,
            "thirdDurationIconColor": Colors.red.shade200,
            "thirdDurationSign": -1,
            "thirdDurationTextColor": Colors.red.shade200,
            "thirdDurationStr": "00:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 16:00",
            "calcSlDurNewDateTimeStr": '14-07-2022 13:09',
            "calcSlDurPreviousDateTimeStr": '14-07-2022 13:13',
            "calcSlDurBeforePreviousDateTimeStr": '14-07-2022 13:12',
            "calcSlDurCurrSleepDurationStr": '12:36',
            "calcSlDurCurrWakeUpDurationStr": '0:02',
            "calcSlDurCurrTotalDurationStr": '12:38',
            "calcSlDurCurrSleepDurationPercentStr": '99.74 %',
            "calcSlDurCurrWakeUpDurationPercentStr": '0.26 %',
            "calcSlDurCurrTotalDurationPercentStr": '100 %',
            "calcSlDurCurrSleepPrevDayTotalPercentStr": '79.74 %',
            "calcSlDurCurrWakeUpPrevDayTotalPercentStr": '1.26 %',
            "calcSlDurCurrTotalPrevDayTotalPercentStr": '81 %',
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
            "dtDurationPercentStr": "70 %",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
            "resultPercentStr": "40 %",
          };

          String path = kCircadianAppDataDir;
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
          transferDataViewModel
              .updateAndSaveTransferData(); // saves to json file

          TransferDataViewModel loadedTransferDataViewModel =
              TransferDataViewModel(
                  transferDataJsonFilePathName: transferDataJsonFilePathName);

          Map<String, dynamic> emptyTransferDataMap = {};

          loadedTransferDataViewModel.transferDataMap = emptyTransferDataMap;
          await loadedTransferDataViewModel.loadTransferData();

          AddDurationToDateTimeData loadedAddDurationToDateTimeData =
              loadedTransferDataViewModel.addDurationToDateTimeData;
          expect(loadedAddDurationToDateTimeData.toString(),
              "addDurationStartDateTimeStr: 2022-07-12 16:00:26.486627\nfirstDurationIconType: DurationIconType.add\nfirstDurationStr: 00:50\nfirstStartDateTimeStr: 12-07-2022 16:00\nfirstEndDateTimeStr: 12-07-2022 16:50\nsecondDurationIconType: DurationIconType.subtract\nsecondDurationStr: 02:00\nsecondStartDateTimeStr: 12-07-2022 16:00\nsecondEndDateTimeStr: 12-07-2022 14:00\nthirdDurationIconType: DurationIconType.subtract\nthirdDurationStr: 00:00\nthirdStartDateTimeStr: 12-07-2022 16:00\nthirdEndDateTimeStr: 12-07-2022 16:00");
          expect(loadedAddDurationToDateTimeData.screenDataType,
              ScreenDataType.addDurationToDateTimeData);
          expect(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(loadedAddDurationToDateTimeData.firstDurationIconType,
              DurationIconType.add);
          expect(loadedAddDurationToDateTimeData.firstAddDurationDurationStr,
              '00:50');
          expect(loadedAddDurationToDateTimeData.firstAddDurationEndDateTimeStr,
              '12-07-2022 16:50');
          expect(loadedAddDurationToDateTimeData.secondDurationIconType,
              DurationIconType.subtract);
          expect(loadedAddDurationToDateTimeData.secondAddDurationDurationStr,
              '02:00');
          expect(
              loadedAddDurationToDateTimeData.secondAddDurationEndDateTimeStr,
              '12-07-2022 14:00');

          // currently, those data are not stored in AddDurationToDateTimeData,
          // but only in the transfer data map !
          Map<String, dynamic> loadedTransferDataMap =
              loadedTransferDataViewModel.getTransferDataMap()!;

          expect(loadedTransferDataMap['firstDurationIconColor'],
              DurationDateTimeEditor.durationPositiveColor);
          expect(loadedTransferDataMap['firstDurationTextColor'],
              DurationDateTimeEditor.durationPositiveColor);
          expect(loadedTransferDataMap['firstDurationSign'], 1);

          expect(loadedTransferDataMap['secondDurationIconColor'],
              DurationDateTimeEditor.durationNegativeColor);
          expect(loadedTransferDataMap['secondDurationTextColor'],
              DurationDateTimeEditor.durationNegativeColor);
          expect(loadedTransferDataMap['secondDurationSign'], -1);

          CalculateSleepDurationData loadedCalculateSleepDurationData =
              loadedTransferDataViewModel.calculateSleepDurationData;

          expect(loadedCalculateSleepDurationData.screenDataType,
              ScreenDataType.calculateSleepDurationData);
          expect(loadedCalculateSleepDurationData.status, Status.sleep);
          expect(loadedCalculateSleepDurationData.sleepDurationNewDateTimeStr,
              '14-07-2022 13:09');
          expect(
              loadedCalculateSleepDurationData.sleepDurationPreviousDateTimeStr,
              '14-07-2022 13:13');
          expect(
              loadedCalculateSleepDurationData
                  .sleepDurationBeforePreviousDateTimeStr,
              '14-07-2022 13:12');
          expect(loadedCalculateSleepDurationData.sleepDurationStr, '12:36');
          expect(loadedCalculateSleepDurationData.wakeUpDurationStr, '0:02');
          expect(loadedCalculateSleepDurationData.totalDurationStr, '12:38');
          expect(loadedCalculateSleepDurationData.sleepDurationPercentStr,
              '99.74 %');
          expect(loadedCalculateSleepDurationData.wakeUpDurationPercentStr,
              '0.26 %');
          expect(loadedCalculateSleepDurationData.totalDurationPercentStr,
              '100 %');
          expect(loadedCalculateSleepDurationData.sleepPrevDayTotalPercentStr,
              '79.74 %');
          expect(loadedCalculateSleepDurationData.wakeUpPrevDayTotalPercentStr,
              '1.26 %');
          expect(loadedCalculateSleepDurationData.totalPrevDayTotalPercentStr,
              '81 %');
          expect(loadedCalculateSleepDurationData.sleepHistoryDateTimeStrLst,
              ['10_07_2022 00:58', '05:35', '04:00']);
          expect(loadedCalculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10_07_2022 05:58', '00:35', '01:00']);

          DateTimeDifferenceDurationData loadedDateTimeDifferenceDurationData =
              loadedTransferDataViewModel.dateTimeDifferenceDurationData;

          expect(loadedDateTimeDifferenceDurationData.screenDataType,
              ScreenDataType.dateTimeDifferenceDurationData);
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceStartDateTimeStr,
              "2022-07-13 16:09");
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceEndDateTimeStr,
              "2022-07-14 16:09:42.390753");
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationStr,
              "24:00");
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceFinalDurationStr,
              "25:00");
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationPercentStr,
              "70 %");

          TimeCalculatorData loadedTimeCalculatorData =
              loadedTransferDataViewModel.timeCalculatorData;

          expect(loadedTimeCalculatorData.screenDataType,
              ScreenDataType.timeCalculatorData);
          expect(
              loadedTimeCalculatorData.timeCalculatorFirstTimeStr, "00:10:00");
          expect(
              loadedTimeCalculatorData.timeCalculatorSecondTimeStr, "00:05:00");
          expect(
              loadedTimeCalculatorData.timeCalculatorResultTimeStr, "00:15:00");

          expect(loadedTransferDataViewModel.getTransferDataMap(),
              transferDataMap);
        },
      );
    },
  );
}
