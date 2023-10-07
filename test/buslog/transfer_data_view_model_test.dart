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
            "firstEndDateTimeCheckbox": true,
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "00:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeCheckbox": false,
            "thirdDurationIconData": Icons.add,
            "thirdDurationIconColor": Colors.green.shade200,
            "thirdDurationSign": 1,
            "thirdDurationTextColor": Colors.green.shade200,
            "thirdDurationStr": "02:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 18:00",
            "thirdEndDateTimeCheckbox": true,
            "preferredDurationsItemsStr": '{"good":["12:00","3:30","10:30"]}',
          };

          // files in this local test dir are stored in
          // project test_data dir updated
          // on GitHub
          String path = kCircadianAppDataTestDir;
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
          expect(addDurationToDateTimeData.firstEndDateTimeCheckbox, true);
          expect(addDurationToDateTimeData.secondDurationIconType,
              DurationIconType.subtract);
          expect(
              addDurationToDateTimeData.secondAddDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.secondAddDurationEndDateTimeStr,
              '12-07-2022 16:00');
          expect(addDurationToDateTimeData.secondEndDateTimeCheckbox, false);
          expect(addDurationToDateTimeData.thirdDurationIconType,
              DurationIconType.add);
          expect(
              addDurationToDateTimeData.thirdAddDurationDurationStr, '02:00');
          expect(addDurationToDateTimeData.thirdAddDurationEndDateTimeStr,
              '12-07-2022 18:00');
          expect(addDurationToDateTimeData.thirdEndDateTimeCheckbox, true);
          expect(addDurationToDateTimeData.preferredDurationsItemsStr,
              '{"good":["12:00","3:30","10:30"]}');
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
              '10-07-2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10-07-2022 05:58',
              '00:35',
              '01:00'
            ],
            "alarmMedicDateTimeStr": '15-12-2022 06:00',
          };

          // files in this local test dir are stored in
          // project test_data dir updated
          // on GitHub
          String path = kCircadianAppDataTestDir;
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
              ['10-07-2022 00:58', '05:35', '04:00']);
          expect(calculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10-07-2022 05:58', '00:35', '01:00']);
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
            "dtDurationPercentStr": "70 %",
            "dtDurationTotalPercentStr": "90 %",
          };

          // files in this local test dir are stored in
          // project test_data dir updated
          // on GitHub
          String path = kCircadianAppDataTestDir;
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
          expect(
              dateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationTotalPercentStr,
              "90 %");
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
            "resultSecondPercentStr": "90 %",
            "divideFirstBySecondCheckBox": false,
          };

          // files in this local test dir are stored in
          // project test_data dir updated
          // on GitHub
          String path = kCircadianAppDataTestDir;
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
          expect(timeCalculatorData.timeCalculatorResultPercentStr, "40 %");
          expect(
              timeCalculatorData.timeCalculatorResultSecondPercentStr, "90 %");
          expect(timeCalculatorData.timeCalculatorDivideFirstBySecondCheckBox,
              false);
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
            "firstEndDateTimeCheckbox": true,
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "00:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeCheckbox": false,
            "thirdDurationIconData": Icons.add,
            "thirdDurationIconColor": Colors.green.shade200,
            "thirdDurationSign": 1,
            "thirdDurationTextColor": Colors.green.shade200,
            "thirdDurationStr": "02:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 18:00",
            "thirdEndDateTimeCheckbox": true,
            "preferredDurationsItemsStr": '{"good":["12:00","3:30","10:30"]}',
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
              '10-07-2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10-07-2022 05:58',
              '00:35',
              '01:00'
            ],
            "alarmMedicDateTimeStr": '15-12-2022 06:00',
            "dtDiffStartDateTimeStr": "2022-07-13 16:09",
            "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
            "dtDiffDurationStr": "24:00",
            "dtDiffAddTimeStr": "1:00",
            "dtDiffFinalDurationStr": "25:00",
            "dtDurationPercentStr": "70 %",
            "dtDurationTotalPercentStr": "90 %",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
            "resultPercentStr": "40 %",
            "resultSecondPercentStr": "90 %",
            "divideFirstBySecondCheckBox": false,
          };

          // files in this local test dir are stored in
          // project test_data dir updated
          // on GitHub
          String path = kCircadianAppDataTestDir;
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
          expect(addDurationToDateTimeData.firstEndDateTimeCheckbox, true);
          expect(addDurationToDateTimeData.secondDurationIconType,
              DurationIconType.subtract);
          expect(
              addDurationToDateTimeData.secondAddDurationDurationStr, '00:00');
          expect(addDurationToDateTimeData.secondAddDurationEndDateTimeStr,
              '12-07-2022 16:00');
          expect(addDurationToDateTimeData.secondEndDateTimeCheckbox, false);
          expect(addDurationToDateTimeData.thirdDurationIconType,
              DurationIconType.add);
          expect(
              addDurationToDateTimeData.thirdAddDurationDurationStr, '02:00');
          expect(addDurationToDateTimeData.thirdAddDurationEndDateTimeStr,
              '12-07-2022 18:00');
          expect(addDurationToDateTimeData.thirdEndDateTimeCheckbox, true);
          expect(addDurationToDateTimeData.preferredDurationsItemsStr,
              '{"good":["12:00","3:30","10:30"]}');

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
              ['10-07-2022 00:58', '05:35', '04:00']);
          expect(calculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10-07-2022 05:58', '00:35', '01:00']);

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
          expect(
              dateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationTotalPercentStr,
              "90 %");

          TimeCalculatorData timeCalculatorData =
              transferDataViewModel.timeCalculatorData;

          expect(timeCalculatorData.screenDataType,
              ScreenDataType.timeCalculatorData);
          expect(timeCalculatorData.timeCalculatorFirstTimeStr, "00:10:00");
          expect(timeCalculatorData.timeCalculatorSecondTimeStr, "00:05:00");
          expect(timeCalculatorData.timeCalculatorResultTimeStr, "00:15:00");
          expect(timeCalculatorData.timeCalculatorResultPercentStr, "40 %");
          expect(
              timeCalculatorData.timeCalculatorResultSecondPercentStr, "90 %");
          expect(timeCalculatorData.timeCalculatorDivideFirstBySecondCheckBox,
              false);
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
            "firstEndDateTimeCheckbox": true,
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "02:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 14:00",
            "secondEndDateTimeCheckbox": false,
            "thirdDurationIconData": Icons.remove,
            "thirdDurationIconColor": Colors.red.shade200,
            "thirdDurationSign": -1,
            "thirdDurationTextColor": Colors.red.shade200,
            "thirdDurationStr": "00:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeCheckbox": true,
            "preferredDurationsItemsStr": '{"good":["12:00","3:30","10:30"]}',
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
              '10-07-2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10-07-2022 05:58',
              '00:35',
              '01:00'
            ],
            "alarmMedicDateTimeStr": '15-12-2022 06:00',
            "sleepDurationCommentStr":
                "Mangé 2 pommes + 1 kaki ce matin.\nMangé 2 kakis ce soir.",
            "dtDiffStartDateTimeStr": "2022-07-13 16:09",
            "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
            "dtDiffDurationStr": "24:00",
            "dtDiffAddTimeStr": "1:00",
            "dtDiffFinalDurationStr": "25:00",
            "dtDurationPercentStr": "70 %",
            "dtDurationTotalPercentStr": "90 %",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
            "resultPercentStr": "40 %",
            "resultSecondPercentStr": "90 %",
            "divideFirstBySecondCheckBox": false,
          };

          // files in this local test dir are stored in
          // project test_data dir updated
          // on GitHub
          String path = kCircadianAppDataTestDir;
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

          // if not using await on next expression,
          // loadedTransferDataViewModel.loadTransferData() will fail with
          // dart Could not load source 'dart:io/file_impl.dart': <source not
          // available error !
          await transferDataViewModel
              .updateAndSaveTransferData(); // saves to json file

          TransferDataViewModel loadedTransferDataViewModel =
              TransferDataViewModel(
                  transferDataJsonFilePathName: transferDataJsonFilePathName);

          Map<String, dynamic> emptyTransferDataMap = {};

          loadedTransferDataViewModel.transferDataMap = emptyTransferDataMap;
          await loadedTransferDataViewModel.loadTransferData();

          AddDurationToDateTimeData loadedAddDurationToDateTimeData =
              loadedTransferDataViewModel.addDurationToDateTimeData;
          expect(
              loadedAddDurationToDateTimeData.toString(),
              'addDurationStartDateTimeStr: 2022-07-12 16:00:26.486627\n'
              'firstDurationIconType: DurationIconType.add\n'
              'firstDurationStr: 00:50\n'
              'firstStartDateTimeStr: 12-07-2022 16:00\n'
              'firstEndDateTimeStr: 12-07-2022 16:50\n'
              'firstEndDateTimeCheckbox: true\n'
              'secondDurationIconType: DurationIconType.subtract\n'
              'secondDurationStr: 02:00\n'
              'secondStartDateTimeStr: 12-07-2022 16:00\n'
              'secondEndDateTimeStr: 12-07-2022 14:00\n'
              'secondEndDateTimeCheckbox: false\n'
              'thirdDurationIconType: DurationIconType.subtract\n'
              'thirdDurationStr: 00:00\n'
              'thirdStartDateTimeStr: 12-07-2022 16:00\n'
              'thirdEndDateTimeStr: 12-07-2022 16:00\n'
              'thirdEndDateTimeCheckbox: true\n'
              'preferredDurationsItemsStr: {"good":["12:00","3:30","10:30"]}');
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
          expect(
              loadedAddDurationToDateTimeData.firstEndDateTimeCheckbox, true);
          expect(loadedAddDurationToDateTimeData.secondDurationIconType,
              DurationIconType.subtract);
          expect(loadedAddDurationToDateTimeData.secondAddDurationDurationStr,
              '02:00');
          expect(
              loadedAddDurationToDateTimeData.secondAddDurationEndDateTimeStr,
              '12-07-2022 14:00');
          expect(
              loadedAddDurationToDateTimeData.secondEndDateTimeCheckbox, false);

          // currently, those data are not stored in AddDurationToDateTimeData,
          // but only in the transfer data map !
          Map<String, dynamic> loadedTransferDataMap =
              loadedTransferDataViewModel.getTransferDataMap()!;

          expect(loadedTransferDataMap['firstDurationIconColor'],
              ScreenMixin.durationPositiveColor);
          expect(loadedTransferDataMap['firstDurationTextColor'],
              ScreenMixin.durationPositiveColor);
          expect(loadedTransferDataMap['firstDurationSign'], 1);

          expect(loadedTransferDataMap['secondDurationIconColor'],
              ScreenMixin.durationNegativeColor);
          expect(loadedTransferDataMap['secondDurationTextColor'],
              ScreenMixin.durationNegativeColor);
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
              ['10-07-2022 00:58', '05:35', '04:00']);
          expect(loadedCalculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10-07-2022 05:58', '00:35', '01:00']);

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
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationTotalPercentStr,
              "90 %");

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
          expect(
              loadedTimeCalculatorData.timeCalculatorResultPercentStr, "40 %");
          expect(loadedTimeCalculatorData.timeCalculatorResultSecondPercentStr,
              "90 %");
          expect(
              loadedTimeCalculatorData
                  .timeCalculatorDivideFirstBySecondCheckBox,
              false);

          expect(loadedTransferDataViewModel.getTransferDataMap(),
              transferDataMap);
        },
      );
      test(
        'TransferDataViewModel loadTransferData no preferredDurationsItemsStr',
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
            "firstEndDateTimeCheckbox": true,
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "02:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 14:00",
            "secondEndDateTimeCheckbox": false,
            "thirdDurationIconData": Icons.remove,
            "thirdDurationIconColor": Colors.red.shade200,
            "thirdDurationSign": -1,
            "thirdDurationTextColor": Colors.red.shade200,
            "thirdDurationStr": "00:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeCheckbox": true,
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
              '10-07-2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10-07-2022 05:58',
              '00:35',
              '01:00'
            ],
            "alarmMedicDateTimeStr": '15-12-2022 06:00',
            "sleepDurationCommentStr":
                "Mangé 2 pommes + 1 kaki ce matin.\nMangé 2 kakis ce soir.",
            "dtDiffStartDateTimeStr": "2022-07-13 16:09",
            "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
            "dtDiffDurationStr": "24:00",
            "dtDiffAddTimeStr": "1:00",
            "dtDiffFinalDurationStr": "25:00",
            "dtDurationPercentStr": "70 %",
            "dtDurationTotalPercentStr": "90 %",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
            "resultPercentStr": "40 %",
            "resultSecondPercentStr": "90 %",
            "divideFirstBySecondCheckBox": false,
          };

          // files in this local test dir are stored in
          // project test_data dir updated
          // on GitHub
          String path = kCircadianAppDataTestDir;
          final Directory directory = Directory(path);
          bool directoryExists = await directory.exists();

          if (!directoryExists) {
            await directory.create();
          }

          String pathSeparator = Platform.pathSeparator;
          String transferDataJsonFilePathName =
              '${directory.path}${pathSeparator}circadianNoPreferredDurItem.json';
          TransferDataViewModel transferDataViewModel = TransferDataViewModel(
              transferDataJsonFilePathName: transferDataJsonFilePathName);
          transferDataViewModel.transferDataMap = transferDataMap;

          // if not using await on next expression,
          // loadedTransferDataViewModel.loadTransferData() will fail with
          // dart Could not load source 'dart:io/file_impl.dart': <source not
          // available error !
          await transferDataViewModel
              .updateAndSaveTransferData(); // saves to json file

          TransferDataViewModel loadedTransferDataViewModel =
              TransferDataViewModel(
                  transferDataJsonFilePathName: transferDataJsonFilePathName);

          Map<String, dynamic> emptyTransferDataMap = {};

          loadedTransferDataViewModel.transferDataMap = emptyTransferDataMap;
          await loadedTransferDataViewModel.loadTransferData();

          AddDurationToDateTimeData loadedAddDurationToDateTimeData =
              loadedTransferDataViewModel.addDurationToDateTimeData;
          expect(
              loadedAddDurationToDateTimeData.toString(),
              'addDurationStartDateTimeStr: 2022-07-12 16:00:26.486627\n'
              'firstDurationIconType: DurationIconType.add\n'
              'firstDurationStr: 00:50\n'
              'firstStartDateTimeStr: 12-07-2022 16:00\n'
              'firstEndDateTimeStr: 12-07-2022 16:50\n'
              'firstEndDateTimeCheckbox: true\n'
              'secondDurationIconType: DurationIconType.subtract\n'
              'secondDurationStr: 02:00\n'
              'secondStartDateTimeStr: 12-07-2022 16:00\n'
              'secondEndDateTimeStr: 12-07-2022 14:00\n'
              'secondEndDateTimeCheckbox: false\n'
              'thirdDurationIconType: DurationIconType.subtract\n'
              'thirdDurationStr: 00:00\n'
              'thirdStartDateTimeStr: 12-07-2022 16:00\n'
              'thirdEndDateTimeStr: 12-07-2022 16:00\n'
              'thirdEndDateTimeCheckbox: true\n'
              'preferredDurationsItemsStr: ');
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
          expect(
              loadedAddDurationToDateTimeData.firstEndDateTimeCheckbox, true);
          expect(loadedAddDurationToDateTimeData.secondDurationIconType,
              DurationIconType.subtract);
          expect(loadedAddDurationToDateTimeData.secondAddDurationDurationStr,
              '02:00');
          expect(
              loadedAddDurationToDateTimeData.secondAddDurationEndDateTimeStr,
              '12-07-2022 14:00');
          expect(
              loadedAddDurationToDateTimeData.secondEndDateTimeCheckbox, false);

          // currently, those data are not stored in AddDurationToDateTimeData,
          // but only in the transfer data map !
          Map<String, dynamic> loadedTransferDataMap =
              loadedTransferDataViewModel.getTransferDataMap()!;

          expect(loadedTransferDataMap['firstDurationIconColor'],
              ScreenMixin.durationPositiveColor);
          expect(loadedTransferDataMap['firstDurationTextColor'],
              ScreenMixin.durationPositiveColor);
          expect(loadedTransferDataMap['firstDurationSign'], 1);

          expect(loadedTransferDataMap['secondDurationIconColor'],
              ScreenMixin.durationNegativeColor);
          expect(loadedTransferDataMap['secondDurationTextColor'],
              ScreenMixin.durationNegativeColor);
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
              ['10-07-2022 00:58', '05:35', '04:00']);
          expect(loadedCalculateSleepDurationData.wakeUpHistoryDateTimeStrLst,
              ['10-07-2022 05:58', '00:35', '01:00']);

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
          expect(
              loadedDateTimeDifferenceDurationData
                  .dateTimeDifferenceDurationTotalPercentStr,
              "90 %");

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
          expect(
              loadedTimeCalculatorData.timeCalculatorResultPercentStr, "40 %");
          expect(loadedTimeCalculatorData.timeCalculatorResultSecondPercentStr,
              "90 %");
          expect(
              loadedTimeCalculatorData
                  .timeCalculatorDivideFirstBySecondCheckBox,
              false);

          Map<String, dynamic> expectedLoadedTransferDataMap = {
            "firstDurationIconData": Icons.add,
            "firstDurationIconColor": Colors.green.shade200,
            "firstDurationSign": 1,
            "firstDurationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "firstDurationStr": "00:50",
            "firstStartDateTimeStr": "12-07-2022 16:00",
            "firstEndDateTimeStr": "12-07-2022 16:50",
            "firstEndDateTimeCheckbox": true,
            "secondDurationIconData": Icons.remove,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": -1,
            "secondDurationTextColor": Colors.red.shade200,
            "secondDurationStr": "02:00",
            "secondStartDateTimeStr": "12-07-2022 16:00",
            "secondEndDateTimeStr": "12-07-2022 14:00",
            "secondEndDateTimeCheckbox": false,
            "thirdDurationIconData": Icons.remove,
            "thirdDurationIconColor": Colors.red.shade200,
            "thirdDurationSign": -1,
            "thirdDurationTextColor": Colors.red.shade200,
            "thirdDurationStr": "00:00",
            "thirdStartDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeStr": "12-07-2022 16:00",
            "thirdEndDateTimeCheckbox": true,
            "preferredDurationsItemsStr": '',
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
              '10-07-2022 00:58',
              '05:35',
              '04:00'
            ],
            "calcSlDurWakeUpTimeStrHistory": [
              '10-07-2022 05:58',
              '00:35',
              '01:00'
            ],
            "alarmMedicDateTimeStr": '15-12-2022 06:00',
            "sleepDurationCommentStr":
                "Mangé 2 pommes + 1 kaki ce matin.\nMangé 2 kakis ce soir.",
            "dtDiffStartDateTimeStr": "2022-07-13 16:09",
            "dtDiffEndDateTimeStr": "2022-07-14 16:09:42.390753",
            "dtDiffDurationStr": "24:00",
            "dtDiffAddTimeStr": "1:00",
            "dtDiffFinalDurationStr": "25:00",
            "dtDurationPercentStr": "70 %",
            "dtDurationTotalPercentStr": "90 %",
            "firstTimeStr": "00:10:00",
            "secondTimeStr": "00:05:00",
            "resultTimeStr": "00:15:00",
            "resultPercentStr": "40 %",
            "resultSecondPercentStr": "90 %",
            "divideFirstBySecondCheckBox": false,
          };

          expect(loadedTransferDataViewModel.getTransferDataMap(),
              expectedLoadedTransferDataMap);
        },
      );
      test(
        'TransferDataViewModel deleteFile',
        () async {
          String fileName = '2022-12-31 12.55.json';
          String filePathName =
              kCircadianAppDataTestDir + Platform.pathSeparator + fileName;
          File file = File(filePathName);

          if (!await file.exists()) {
            // Create file
            file = await File(filePathName).writeAsString('Hello World');
          }

          bool fileExist = await file.exists();
          expect(fileExist, true);

          TransferDataViewModel.deleteFile(filePathName);

          file = File(filePathName);
          fileExist = await file.exists();
          expect(fileExist, false);
        },
      );
    },
  );
}
