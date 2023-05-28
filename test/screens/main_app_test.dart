import 'package:circa_plan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

Future<void> main() async {
  Map<String, dynamic> transferDataMapCircadian = {
    "firstDurationIconData": Icons.add,
    "firstDurationIconColor": Colors.green.shade200,
    "firstDurationSign": 1,
    "firstDurationTextColor": Colors.green.shade200,
    "addDurStartDateTimeStr": "2022-07-12 16:00",
    "firstDurationStr": "00:50",
    "firstStartDateTimeStr": "2022-07-12 16:00",
    "firstEndDateTimeStr": "2022-07-12 16:50",
    "firstEndDateTimeCheckbox": false,
    "secondDurationIconData": Icons.remove,
    "secondDurationIconColor": Colors.red.shade200,
    "secondDurationSign": -1,
    "secondDurationTextColor": Colors.red.shade200,
    "secondDurationStr": "02:00",
    "secondStartDateTimeStr": "2022-07-12 16:50",
    "secondEndDateTimeStr": "2022-07-12 14:50",
    "secondEndDateTimeCheckbox": false,
    "thirdDurationIconData": Icons.remove,
    "thirdDurationIconColor": Colors.red.shade200,
    "thirdDurationSign": -1,
    "thirdDurationTextColor": Colors.red.shade200,
    "thirdDurationStr": "01:00",
    "thirdStartDateTimeStr": "2022-07-12 14:50",
    "thirdEndDateTimeStr": "2022-07-12 13:50",
    "thirdEndDateTimeCheckbox": false,
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
    "calcSlDurStatus": Status.wakeUp,
    "calcSlDurSleepTimeStrHistory": ['10-07-2022 00:58', '05:35', '04:00'],
    "calcSlDurWakeUpTimeStrHistory": ['10-07-2022 05:58', '00:35'],
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
  String testPath = kCircadianAppDataTestDir;
  final Directory directory = Directory(testPath);
  bool directoryExists = await directory.exists();

  if (!directoryExists) {
    await directory.create();
  }

  String jsonFileNameCircadian = 'circadian.json';
  String transferDataJsonFilePathNameCircadian =
      '$testPath${Platform.pathSeparator}$jsonFileNameCircadian';
  TransferDataViewModel transferDataViewModelCircadian = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathNameCircadian);
  transferDataViewModelCircadian.transferDataMap = transferDataMapCircadian;
  await transferDataViewModelCircadian.updateAndSaveTransferData();

  String jsonFileNameOne = '2022-07-14 13.09.json';
  String transferDataJsonFilePathNameOne =
      '$testPath${Platform.pathSeparator}$jsonFileNameOne';
  TransferDataViewModel transferDataViewModelOne = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathNameOne);
  transferDataViewModelOne.transferDataMap = transferDataMapCircadian;
  await transferDataViewModelOne.updateAndSaveTransferData();

  Map<String, dynamic> transferDataMapTwo = {
    "firstDurationIconData": Icons.add,
    "firstDurationIconColor": Colors.green.shade200,
    "firstDurationSign": 1,
    "firstDurationTextColor": Colors.green.shade200,
    "addDurStartDateTimeStr": "2022-07-12 16:00",
    "firstDurationStr": "00:50",
    "firstStartDateTimeStr": "2022-07-12 16:00",
    "firstEndDateTimeStr": "2022-07-12 16:50",
    "firstEndDateTimeCheckbox": false,
    "secondDurationIconData": Icons.remove,
    "secondDurationIconColor": Colors.red.shade200,
    "secondDurationSign": -1,
    "secondDurationTextColor": Colors.red.shade200,
    "secondDurationStr": "02:00",
    "secondStartDateTimeStr": "2022-07-12 16:50",
    "secondEndDateTimeStr": "2022-07-12 14:50",
    "secondEndDateTimeCheckbox": false,
    "thirdDurationIconData": Icons.remove,
    "thirdDurationIconColor": Colors.red.shade200,
    "thirdDurationSign": -1,
    "thirdDurationTextColor": Colors.red.shade200,
    "thirdDurationStr": "01:00",
    "thirdStartDateTimeStr": "2022-07-12 14:50",
    "thirdEndDateTimeStr": "2022-07-12 13:50",
    "thirdEndDateTimeCheckbox": false,
    "preferredDurationsItemsStr": '{"good":["12:00","3:30","10:30"]}',
    "calcSlDurNewDateTimeStr": '14-07-2022 16:39',
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
    "calcSlDurStatus": Status.wakeUp,
    "calcSlDurSleepTimeStrHistory": [
      '10-07-2022 00:58',
      '05:35',
      '04:00',
      '03:00'
    ],
    "calcSlDurWakeUpTimeStrHistory": ['10-07-2022 05:58', '00:35', '00:30'],
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

  String jsonFileNameTwo = '2022-07-14 16.39.json';
  String transferDataJsonFilePathNameTwo =
      '$testPath${Platform.pathSeparator}$jsonFileNameTwo';
  TransferDataViewModel transferDataViewModelTwo = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathNameTwo);
  transferDataViewModelTwo.transferDataMap = transferDataMapTwo;
  await transferDataViewModelTwo.updateAndSaveTransferData();

  group(
    'AppBar menu testing',
    () {
      testWidgets(
        'Undo load. Test not working',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MainApp(
                  key: const Key('mainAppKey'),
                  transferDataViewModel: transferDataViewModelOne,
                ),
              ),
            ),
          );

          final MainApp mainApp = tester
              .firstWidget(find.byKey(const Key('mainAppKey'))) as MainApp;

          // clicking on AppBar popup menu button
          // await tester.tap(find.byKey(const Key('appBarPopupMenuButton')));
          // await tester.pumpAndSettle();

          // // then clicking on the Load menu item
          // await tester.tap(find.byKey(const Key('appBarMenuLoad')).first);
          // await tester.pumpAndSettle();

          // // then loading jsonFileNameOne
          // await tester.tap(find.text(jsonFileNameOne).first);
          // await tester.pumpAndSettle();

          // // re-clicking on AppBar popup menu button.
          await tester.tap(find.byKey(const Key('appBarPopupMenuButton')));
          await tester.pumpAndSettle();

          // then clicking on the Load menu item
          await tester.tap(find.byKey(const Key('appBarMenuLoad')).first);
          await tester.pumpAndSettle();

          // then loading jsonFileNameTwo
          await tester.tap(find.text(jsonFileNameTwo).first);
          await tester.pumpAndSettle();
        },
      );
    },
  );
}
