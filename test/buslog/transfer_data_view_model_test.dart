import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

          Directory directory = await getApplicationDocumentsDirectory();
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
          expect(addDurationToDateTimeData.durationIconType,
              DurationIconType.add);
          expect(addDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(addDurationToDateTimeData.durationStr, '00:00');
          expect(addDurationToDateTimeData.endDateTimeStr,
              '12-07-2022 16:00');
        },
      );
      test(
        'TransferDataViewModel updateCalculateSleepDurationData',
        () async {
/*
"calcSlDurNewDateTimeStr" -> "14-07-2022 02:56"
"calcSlDurLastWakeUpTimeStr" -> ""
"calcSlDurPreviousDateTimeStr" -> "14-07-2022 02:56"
"calcSlDurBeforePreviousDateTimeStr" -> "14-07-2022 00:56"
"calcSlDurCurrSleepDurationStr" -> "2:30"
"calcSlDurCurrWakeUpDurationStr" -> "4:00"
"calcSlDurCurrTotalDurationStr" -> "6:30"
"calcSlDurStatus" -> Status
"calcSlDurSleepTimeStrHistory"
List (4 items)
"13-07-2022 20:26"
"1:00"
"0:30"
"1:00"
"calcSlDurWakeUpTimeStrHistory" -> List (4 items)
"calcSlDurWakeUpTimeStrHistory"
List (4 items)
"13-07-2022 21:26"
"1:00"
"1:00"
"2:00"
*/
          Map<String, dynamic> transferDataMap = {
            "durationIconData": Icons.add,
            "durationIconColor": Colors.green.shade200,
            "durationSign": 1,
            "durationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
            "durationStr": "00:00",
            "endDateTimeStr": "12-07-2022 16:00",
          };

          Directory directory = await getApplicationDocumentsDirectory();
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
          expect(addDurationToDateTimeData.durationIconType,
              DurationIconType.add);
          expect(addDurationToDateTimeData.addDurationStartDateTimeStr,
              '2022-07-12 16:00:26.486627');
          expect(addDurationToDateTimeData.durationStr, '00:00');
          expect(addDurationToDateTimeData.endDateTimeStr,
              '12-07-2022 16:00');
        },
      );
    },
  );
}
