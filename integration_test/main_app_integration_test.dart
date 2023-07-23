import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'dart:io';

import 'package:circa_plan/main.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/utils/utility.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/utils/date_time_parser.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'AppBar menu testing',
    () {
      testWidgets(
        'Undo load. Test working and results checked.',
        (tester) async {
          Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);
          Utility.copyFileToDirectorySync(
              sourceFilePathName:
                  '$kCircadianAppDataTestSaveDir${Platform.pathSeparator}circadian.json',
              targetDirectoryPath: kCircadianAppDataTestDir);

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
            "preferredDurationsItemsStr":
                '{"good":["12:00","3:30","10:30","false","true"]}',
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
            "calcSlDurSleepTimeStrHistory": [
              '10-07-2022 00:58',
              '05:35',
              '04:00'
            ],
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
          TransferDataViewModel transferDataViewModelCircadian =
              TransferDataViewModel(
                  transferDataJsonFilePathName:
                      transferDataJsonFilePathNameCircadian);
          transferDataViewModelCircadian.transferDataMap =
              transferDataMapCircadian;
          await transferDataViewModelCircadian.updateAndSaveTransferData();

          String jsonFileNameOne = '2022-07-14 13.09.json';
          String transferDataJsonFilePathNameOne =
              '$testPath${Platform.pathSeparator}$jsonFileNameOne';
          TransferDataViewModel transferDataViewModelOne =
              TransferDataViewModel(
                  transferDataJsonFilePathName:
                      transferDataJsonFilePathNameOne);
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
            "preferredDurationsItemsStr":
                '{"good":["12:00","3:30","10:30","false","true"]}',
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
            "calcSlDurWakeUpTimeStrHistory": [
              '10-07-2022 05:58',
              '00:35',
              '00:30'
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

          String jsonFileNameTwo = '2022-07-14 16.39.json';
          String transferDataJsonFilePathNameTwo =
              '$testPath${Platform.pathSeparator}$jsonFileNameTwo';
          TransferDataViewModel transferDataViewModelTwo =
              TransferDataViewModel(
                  transferDataJsonFilePathName:
                      transferDataJsonFilePathNameTwo);
          transferDataViewModelTwo.transferDataMap = transferDataMapTwo;
          await transferDataViewModelTwo.updateAndSaveTransferData();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MainApp(
                  key: const Key('mainAppKey'),
                  transferDataViewModel: transferDataViewModelCircadian,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          TextField newDateTimeTextField =
              tester.widget(find.byKey(const Key('newDateTimeTextField')));
          final String nowFrenchFormatDateTimeStr =
              ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
          expect(newDateTimeTextField.controller!.text,
              nowFrenchFormatDateTimeStr);

          // clicking on AppBar popup menu button
          await tester.tap(find.byKey(const Key('appBarPopupMenuButton')));
          await tester.pumpAndSettle();

          // then clicking on the Load menu item
          await tester.tap(find.byKey(const Key('appBarMenuLoad')));
          await tester.pumpAndSettle();

          // then loading jsonFileNameOne
          await tester.tap(find.text(jsonFileNameOne));
          await tester.pumpAndSettle();

          // checking that '14-07-2022 13:09' is displayed once
          expect(find.text('14-07-2022 13:09'), findsOneWidget);

          // checking that startDateTime text field is '14-07-2022 13:09'
          newDateTimeTextField =
              tester.widget(find.byKey(const Key('newDateTimeTextField')));
          expect(newDateTimeTextField.controller!.text, '14-07-2022 13:09');

          //

          await tester.tap(find.text('Now'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Add').first);
          await tester.pumpAndSettle();

          // re-clicking on AppBar popup menu button.
          await tester.tap(find.byKey(const Key('appBarPopupMenuButton')));
          await tester.pumpAndSettle();

          // then clicking on the Load menu item
          await tester.tap(find.byKey(const Key('appBarMenuLoad')));
          await tester.pumpAndSettle();

          // then loading jsonFileNameTwo
          await tester.tap(find.text(jsonFileNameTwo));
          await tester.pumpAndSettle();

          // checking that '14-07-2022 16:39' is displayed once
          expect(find.text('14-07-2022 16:39'), findsOneWidget);

          // checking that newDateTime text field is '14-07-2022 16:39'
          newDateTimeTextField =
              tester.widget(find.byKey(const Key('newDateTimeTextField')));
          expect(newDateTimeTextField.controller!.text, '14-07-2022 16:39');

          // re-clicking on AppBar popup menu button.
          await tester.tap(find.byKey(const Key('appBarPopupMenuButton')));
          await tester.pumpAndSettle();

          // then undo the load
          await tester.tap(find.byKey(const Key('appBarMenuUndo')));
          await tester.pumpAndSettle();

          // checking that '14-07-2022 16:39' is no longer displayed
          expect(find.text('14-07-2022 16:39'), findsNothing);

          // checking that now date time is displayed twice
          expect(find.text(nowFrenchFormatDateTimeStr), findsNWidgets(2));

          // checking that newDateTime text field is '14-07-2022 13:09'
          newDateTimeTextField =
              tester.widget(find.byKey(const Key('newDateTimeTextField')));
          expect(newDateTimeTextField.controller!.text,
              nowFrenchFormatDateTimeStr);
        },
      );
    },
  );

  group(
    'Switch to other pages testing',
    () {
      testWidgets(
        'Switch to Wake Up Duration page.',
        (tester) async {
          Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);
          Utility.copyFileToDirectorySync(
              sourceFilePathName:
                  '$kCircadianAppDataTestSaveDir${Platform.pathSeparator}circadian.json',
              targetDirectoryPath: kCircadianAppDataTestDir);

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
            "preferredDurationsItemsStr":
                '{"good":["12:00","3:30","10:30","false","true"]}',
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
            "calcSlDurSleepTimeStrHistory": [
              '10-07-2022 00:58',
              '05:35',
              '04:00'
            ],
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
          TransferDataViewModel transferDataViewModelCircadian =
              TransferDataViewModel(
                  transferDataJsonFilePathName:
                      transferDataJsonFilePathNameCircadian);
          transferDataViewModelCircadian.transferDataMap =
              transferDataMapCircadian;
          await transferDataViewModelCircadian.updateAndSaveTransferData();

          String jsonFileNameOne = '2022-07-14 13.09.json';
          String transferDataJsonFilePathNameOne =
              '$testPath${Platform.pathSeparator}$jsonFileNameOne';
          TransferDataViewModel transferDataViewModelOne =
              TransferDataViewModel(
                  transferDataJsonFilePathName:
                      transferDataJsonFilePathNameOne);
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
            "preferredDurationsItemsStr":
                '{"good":["12:00","3:30","10:30","false","true"]}',
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
            "calcSlDurWakeUpTimeStrHistory": [
              '10-07-2022 05:58',
              '00:35',
              '00:30'
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

          String jsonFileNameTwo = '2022-07-14 16.39.json';
          String transferDataJsonFilePathNameTwo =
              '$testPath${Platform.pathSeparator}$jsonFileNameTwo';
          TransferDataViewModel transferDataViewModelTwo =
              TransferDataViewModel(
                  transferDataJsonFilePathName:
                      transferDataJsonFilePathNameTwo);
          transferDataViewModelTwo.transferDataMap = transferDataMapTwo;
          await transferDataViewModelTwo.updateAndSaveTransferData();

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

          await tester.pumpAndSettle();

          // Clicking on the second icon in the navigation bar
          await tester
              .tap(find.byKey(const Key('navBarWakeUpDurationPageTwo')));
          await tester.pumpAndSettle();

          // Confirming that the Wake Up Duration page is displayed
          EditableDateTime startDateTimeEditableDateTimeWidget = tester
              .widget(find.byKey(const Key('wakeUpDurationStartDateTimeKey')));
          expect(
              startDateTimeEditableDateTimeWidget.dateTimePickerController.text,
              '13-07-2022 16:09');
        },
      );
    },
  );
  group(
    "Add rounding preferred durations to 3rd screen DateTime's",
    () {
      testWidgets(
        'Reset, select rounding preferred duration, undo it and redo it',
        (tester) async {
          Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);

          String nowEnglishDateTimeFormatStr =
              ScreenMixin.englishDateTimeFormat.format(DateTime.now());
          String nowFrenchDateTimeFormatStr =
              ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
          String testPath = kCircadianAppDataTestDir;

          Map<String, dynamic> transferDataMapCircadian = {
            "firstDurationIconData": Icons.add,
            "firstDurationIconColor": Colors.green.shade200,
            "firstDurationSign": 1,
            "firstDurationTextColor": Colors.green.shade200,
            "addDurStartDateTimeStr": nowEnglishDateTimeFormatStr,
            "firstDurationStr": "00:00",
            "firstStartDateTimeStr": nowEnglishDateTimeFormatStr,
            "firstEndDateTimeStr": nowEnglishDateTimeFormatStr,
            "firstEndDateTimeCheckbox": false,
            "secondDurationIconData": Icons.add,
            "secondDurationIconColor": Colors.red.shade200,
            "secondDurationSign": 1,
            "secondDurationTextColor": Colors.green.shade200,
            "secondDurationStr": "00:00",
            "secondStartDateTimeStr": nowEnglishDateTimeFormatStr,
            "secondEndDateTimeStr": nowEnglishDateTimeFormatStr,
            "secondEndDateTimeCheckbox": false,
            "thirdDurationIconData": Icons.add,
            "thirdDurationIconColor": Colors.green.shade200,
            "thirdDurationSign": 1,
            "thirdDurationTextColor": Colors.green.shade200,
            "thirdDurationStr": "00:00",
            "thirdStartDateTimeStr": nowEnglishDateTimeFormatStr,
            "thirdEndDateTimeStr": nowEnglishDateTimeFormatStr,
            "thirdEndDateTimeCheckbox": false,
            "preferredDurationsItemsStr":
                '{"good rounding":["12:00","3:30","10:30","false","true"], "good not round":["12:00","3:30","10:30","false","false"], "bad":["18:00","5:30","15:30","false","true"]}',
            "calcSlDurNewDateTimeStr": nowFrenchDateTimeFormatStr,
            "calcSlDurPreviousDateTimeStr": nowFrenchDateTimeFormatStr,
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
              '04:00'
            ],
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

          String jsonFileNameCircadian = 'circadian.json';
          String transferDataJsonFilePathNameCircadian =
              '$testPath${Platform.pathSeparator}$jsonFileNameCircadian';
          TransferDataViewModel transferDataViewModelCircadian =
              TransferDataViewModel(
                  transferDataJsonFilePathName:
                      transferDataJsonFilePathNameCircadian);
          transferDataViewModelCircadian.transferDataMap =
              transferDataMapCircadian;
          await transferDataViewModelCircadian.updateAndSaveTransferData();

          // updating a second time updates the circadian undo file
          await transferDataViewModelCircadian.updateAndSaveTransferData();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: MainApp(
                  key: const Key('mainAppKey'),
                  transferDataViewModel: transferDataViewModelCircadian,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Clicking on the third icon in the navigation bar
          await tester.tap(
              find.byKey(const Key('navBarAddDurationToDateTimePageThree')));
          await tester.pumpAndSettle();

          // clicking on Reset button
          await tester.tap(find.byKey(const Key('resetButton')));
          await tester.pumpAndSettle();

          EditableDateTime startDateTimeEditableDateTimeWidget = tester
              .widget(find.byKey(const Key('addDurToDateTimeStartDateTime')));

          // Confirming the Add Duration To Date Time page Start Date Time
          // is set to the current date and time.
          String startDateTimeFrenchFormatStr =
              startDateTimeEditableDateTimeWidget.dateTimePickerController.text;
          expect(startDateTimeFrenchFormatStr, nowFrenchDateTimeFormatStr);

          // Find the preferred duration selection IconButton by the icon.
          final iconButtonFinder = find.byIcon(Icons.favorite);

          // Tap the yellow heart IconButton.
          await tester.tap(iconButtonFinder);

          // Wait for the tap to be processed and for any animations to complete.
          await tester.pumpAndSettle();

          // Tap the menu item.
          await tester.tap(find.text('good rounding 12:00, 3:30, 10:30'));

          // Wait for the tap to be processed and for any animations to complete.
          await tester.pumpAndSettle();

          checkFirstSecondAndThirdEndDateTimeAndDuration(
            startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
            firstDurationStr: '12:00',
            isRoundingSetForPreferredDuration: true,
          );

          // Tapping a first time on the Undo menu

          // Find the AppBar's PopupMenuButton
          final Finder appBarMenuFinder =
              find.byKey(const Key('appBarPopupMenuButton'));

          await tester.tap(appBarMenuFinder);

          // Wait for the tap to be processed and for any animations to complete.
          await tester.pumpAndSettle();

          // Tap the Undo menu item to undo selected preferred durations
          // application.
          await tester.tap(find.text('Undo'));

          // Wait for the tap to be processed and for any animations to complete.
          await tester.pumpAndSettle();

          expect(find.text(nowFrenchDateTimeFormatStr), findsNWidgets(4));
          expect(find.text('00:00'), findsNWidgets(3));

          // Tapping a second time on the Undo menu which undoes the
          // first undo

          await tester.tap(appBarMenuFinder);

          // Wait for the tap to be processed and for any animations to complete.
          await tester.pumpAndSettle();

          // Retap the Undo menu item to undo selected preferred durations
          // application.
          await tester.tap(find.text('Undo'));

          // Wait for the tap to be processed and for any animations to complete.
          await tester.pumpAndSettle();

          checkFirstSecondAndThirdEndDateTimeAndDuration(
            startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
            firstDurationStr: '12:00',
            isRoundingSetForPreferredDuration: true,
          );
        },
      );
      testWidgets(
          'Reset, select rounding preferred duration, lock first end date time, change duration, unlock first end date time, rechange duration',
          (tester) async {
        Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);

        String nowEnglishDateTimeFormatStr =
            ScreenMixin.englishDateTimeFormat.format(DateTime.now());
        String nowFrenchDateTimeFormatStr =
            ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
        String testPath = kCircadianAppDataTestDir;

        Map<String, dynamic> transferDataMapCircadian = {
          "firstDurationIconData": Icons.add,
          "firstDurationIconColor": Colors.green.shade200,
          "firstDurationSign": 1,
          "firstDurationTextColor": Colors.green.shade200,
          "addDurStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstDurationStr": "00:00",
          "firstStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeCheckbox": false,
          "secondDurationIconData": Icons.add,
          "secondDurationIconColor": Colors.red.shade200,
          "secondDurationSign": 1,
          "secondDurationTextColor": Colors.green.shade200,
          "secondDurationStr": "00:00",
          "secondStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeCheckbox": false,
          "thirdDurationIconData": Icons.add,
          "thirdDurationIconColor": Colors.green.shade200,
          "thirdDurationSign": 1,
          "thirdDurationTextColor": Colors.green.shade200,
          "thirdDurationStr": "00:00",
          "thirdStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeCheckbox": false,
          "preferredDurationsItemsStr":
              '{"good rounding":["12:00","3:30","10:30","false","true"], "good not round":["12:00","3:30","10:30","false","false"], "bad":["18:00","5:30","15:30","false","true"]}',
          "calcSlDurNewDateTimeStr": nowFrenchDateTimeFormatStr,
          "calcSlDurPreviousDateTimeStr": nowFrenchDateTimeFormatStr,
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
            '04:00'
          ],
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

        String jsonFileNameCircadian = 'circadian.json';
        String transferDataJsonFilePathNameCircadian =
            '$testPath${Platform.pathSeparator}$jsonFileNameCircadian';
        TransferDataViewModel transferDataViewModelCircadian =
            TransferDataViewModel(
                transferDataJsonFilePathName:
                    transferDataJsonFilePathNameCircadian);
        transferDataViewModelCircadian.transferDataMap =
            transferDataMapCircadian;
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        // updating a second time updates the circadian undo file
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MainApp(
                key: const Key('mainAppKey'),
                transferDataViewModel: transferDataViewModelCircadian,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Clicking on the third icon in the navigation bar
        await tester
            .tap(find.byKey(const Key('navBarAddDurationToDateTimePageThree')));
        await tester.pumpAndSettle();

        // clicking on Reset button
        await tester.tap(find.byKey(const Key('resetButton')));
        await tester.pumpAndSettle();

        EditableDateTime startDateTimeEditableDateTimeWidget = tester
            .widget(find.byKey(const Key('addDurToDateTimeStartDateTime')));

        // Confirming the Add Duration To Date Time page Start Date Time
        // is set to the current date and time.
        String startDateTimeFrenchFormatStr =
            startDateTimeEditableDateTimeWidget.dateTimePickerController.text;
        DateTime actualStartDateTime = ScreenMixin.frenchDateTimeFormat
            .parse(startDateTimeFrenchFormatStr);
        DateTime expectedStartDateTime =
            ScreenMixin.frenchDateTimeFormat.parse(nowFrenchDateTimeFormatStr);
        DateTime expectedStartDateTimeOneMinuteBefore =
            expectedStartDateTime.subtract(const Duration(minutes: 1));
        DateTime expectedStartDateTimeOneMinuteAfter =
            expectedStartDateTime.add(const Duration(minutes: 1));

        // Check if the actual time is within that range
        expect(
            actualStartDateTime.isAfter(expectedStartDateTimeOneMinuteBefore),
            isTrue);
        expect(
            actualStartDateTime.isBefore(expectedStartDateTimeOneMinuteAfter),
            isTrue);

        // Find the preferred duration selection IconButton by the icon.
        final iconButtonFinder = find.byIcon(Icons.favorite);

        // Tap the yellow heart IconButton.
        await tester.tap(iconButtonFinder);

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        // Tap the menu item.
        await tester.tap(find.text('good rounding 12:00, 3:30, 10:30'));

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        final Map<String, dynamic> mapResults =
            checkFirstSecondAndThirdEndDateTimeAndDuration(
          startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
          firstDurationStr: '12:00',
          isRoundingSetForPreferredDuration: true,
        );
        final DateTime firstEndDateTime = mapResults['firstEndDateTime'];

        // Now verifying that when you change the first duration in the
        // situation in which the first end date time checkbox is checked,
        // the start date time is changed.

        // Tapping on the first end date time checkbox to lock it

        Finder checkboxFinder = find.byType(Checkbox).first;

        await tester.tap(checkboxFinder);
        await tester.pumpAndSettle();

        expect((tester.firstWidget(checkboxFinder) as Checkbox).value, true);

        // Setting the first duration to 10 hours

        const String changedFirstDurationStr = '10:00';

        // Findingvthe first duration text field
        Finder firstDurationWidgetFinder = find.byType(EditableText).at(1);
        // Finder firstDurationWidgetFinder = find.text(firstDurationStr);

        await tester.enterText(
            firstDurationWidgetFinder, changedFirstDurationStr);

        // Tapping on on DONE keyboard button or Enter key in order
        // to apply changing the first duration which, since the first
        // end date time checkbox is checked, will change the start date time
        // time.
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(find.text(changedFirstDurationStr), findsOneWidget);

        DateTime newStartDateTime = firstEndDateTime.subtract(
            DateTimeParser.parseHHMMDuration(changedFirstDurationStr)!);
        final String newStartDateTimeFrenchFormatStr =
            ScreenMixin.frenchDateTimeFormat.format(newStartDateTime);

        expect(find.text(newStartDateTimeFrenchFormatStr), findsOneWidget);
      });
      testWidgets(
          'Reset, select rounding preferred duration, change duration without locking first end date time',
          (tester) async {
        Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);

        String nowEnglishDateTimeFormatStr =
            ScreenMixin.englishDateTimeFormat.format(DateTime.now());
        String nowFrenchDateTimeFormatStr =
            ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
        String testPath = kCircadianAppDataTestDir;

        Map<String, dynamic> transferDataMapCircadian = {
          "firstDurationIconData": Icons.add,
          "firstDurationIconColor": Colors.green.shade200,
          "firstDurationSign": 1,
          "firstDurationTextColor": Colors.green.shade200,
          "addDurStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstDurationStr": "00:00",
          "firstStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeCheckbox": false,
          "secondDurationIconData": Icons.add,
          "secondDurationIconColor": Colors.red.shade200,
          "secondDurationSign": 1,
          "secondDurationTextColor": Colors.green.shade200,
          "secondDurationStr": "00:00",
          "secondStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeCheckbox": false,
          "thirdDurationIconData": Icons.add,
          "thirdDurationIconColor": Colors.green.shade200,
          "thirdDurationSign": 1,
          "thirdDurationTextColor": Colors.green.shade200,
          "thirdDurationStr": "00:00",
          "thirdStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeCheckbox": false,
          "preferredDurationsItemsStr":
              '{"good rounding":["12:00","3:30","10:30","false","true"], "good not round":["12:00","3:30","10:30","false","false"], "bad":["18:00","5:30","15:30","false","true"]}',
          "calcSlDurNewDateTimeStr": nowFrenchDateTimeFormatStr,
          "calcSlDurPreviousDateTimeStr": nowFrenchDateTimeFormatStr,
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
            '04:00'
          ],
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

        String jsonFileNameCircadian = 'circadian.json';
        String transferDataJsonFilePathNameCircadian =
            '$testPath${Platform.pathSeparator}$jsonFileNameCircadian';
        TransferDataViewModel transferDataViewModelCircadian =
            TransferDataViewModel(
                transferDataJsonFilePathName:
                    transferDataJsonFilePathNameCircadian);
        transferDataViewModelCircadian.transferDataMap =
            transferDataMapCircadian;
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        // updating a second time updates the circadian undo file
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MainApp(
                key: const Key('mainAppKey'),
                transferDataViewModel: transferDataViewModelCircadian,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Clicking on the third icon in the navigation bar
        await tester
            .tap(find.byKey(const Key('navBarAddDurationToDateTimePageThree')));
        await tester.pumpAndSettle();

        // clicking on Reset button
        await tester.tap(find.byKey(const Key('resetButton')));
        await tester.pumpAndSettle();

        EditableDateTime startDateTimeEditableDateTimeWidget = tester
            .widget(find.byKey(const Key('addDurToDateTimeStartDateTime')));

        // Confirming the Add Duration To Date Time page Start Date Time
        // is set to the current date and time.
        String startDateTimeFrenchFormatStr =
            startDateTimeEditableDateTimeWidget.dateTimePickerController.text;
        expect(startDateTimeFrenchFormatStr, nowFrenchDateTimeFormatStr);

        // Find the preferred duration selection IconButton by the icon.
        final iconButtonFinder = find.byIcon(Icons.favorite);

        // Tap the yellow heart IconButton.
        await tester.tap(iconButtonFinder);

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        // Tap the menu item.
        await tester.tap(find.text('good rounding 12:00, 3:30, 10:30'));

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        checkFirstSecondAndThirdEndDateTimeAndDuration(
          startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
          firstDurationStr: '12:00',
          isRoundingSetForPreferredDuration: true,
        );

        // Now verifying that when you change the first duration in the
        // situation in which the first end date time checkbox is not
        // checked, the start date time is not changed. Instead, the
        // end date time widgets are updated.

        // Setting the first duration to 10 hours

        const String changedFirstDurationStr = '10:00';

        // Finding the first duration text field
        Finder firstDurationWidgetFinder = find.byType(EditableText).at(1);

        await tester.enterText(
            firstDurationWidgetFinder, changedFirstDurationStr);

        // Tapping on on DONE keyboard button or Enter key in order
        // to apply changing the first duration which, since the first
        // end date time checkbox is checked, will change the start date time
        // time.
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(find.text(changedFirstDurationStr), findsOneWidget);

        // Verifying the Start Date Time was not changed since the first
        // end date time checkbox which locks it is not checked.
        expect(find.text(startDateTimeFrenchFormatStr), findsOneWidget);

        checkFirstSecondAndThirdEndDateTimeAndDuration(
          startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
          firstDurationStr: changedFirstDurationStr,
          isRoundingSetForPreferredDuration: false,
        );
      });
    },
  );
  group(
    "Add not rounding preferred durations to 3rd screen DateTime's",
    () {
      testWidgets(
          'Reset, select not rounding preferred duration, lock first end date time, change duration, unlock first end date time, rechange duration',
          (tester) async {
        Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);

        String nowEnglishDateTimeFormatStr =
            ScreenMixin.englishDateTimeFormat.format(DateTime.now());
        String nowFrenchDateTimeFormatStr =
            ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
        String testPath = kCircadianAppDataTestDir;

        Map<String, dynamic> transferDataMapCircadian = {
          "firstDurationIconData": Icons.add,
          "firstDurationIconColor": Colors.green.shade200,
          "firstDurationSign": 1,
          "firstDurationTextColor": Colors.green.shade200,
          "addDurStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstDurationStr": "00:00",
          "firstStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeCheckbox": false,
          "secondDurationIconData": Icons.add,
          "secondDurationIconColor": Colors.red.shade200,
          "secondDurationSign": 1,
          "secondDurationTextColor": Colors.green.shade200,
          "secondDurationStr": "00:00",
          "secondStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeCheckbox": false,
          "thirdDurationIconData": Icons.add,
          "thirdDurationIconColor": Colors.green.shade200,
          "thirdDurationSign": 1,
          "thirdDurationTextColor": Colors.green.shade200,
          "thirdDurationStr": "00:00",
          "thirdStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeCheckbox": false,
          "preferredDurationsItemsStr":
              '{"good rounding":["12:00","3:30","10:30","false","true"], "good not round":["12:00","3:30","10:30","false","false"], "bad":["18:00","5:30","15:30","false","true"]}',
          "calcSlDurNewDateTimeStr": nowFrenchDateTimeFormatStr,
          "calcSlDurPreviousDateTimeStr": nowFrenchDateTimeFormatStr,
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
            '04:00'
          ],
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

        String jsonFileNameCircadian = 'circadian.json';
        String transferDataJsonFilePathNameCircadian =
            '$testPath${Platform.pathSeparator}$jsonFileNameCircadian';
        TransferDataViewModel transferDataViewModelCircadian =
            TransferDataViewModel(
                transferDataJsonFilePathName:
                    transferDataJsonFilePathNameCircadian);
        transferDataViewModelCircadian.transferDataMap =
            transferDataMapCircadian;
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        // updating a second time updates the circadian undo file
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MainApp(
                key: const Key('mainAppKey'),
                transferDataViewModel: transferDataViewModelCircadian,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Clicking on the third icon in the navigation bar
        await tester
            .tap(find.byKey(const Key('navBarAddDurationToDateTimePageThree')));
        await tester.pumpAndSettle();

        // clicking on Reset button
        await tester.tap(find.byKey(const Key('resetButton')));
        await tester.pumpAndSettle();

        EditableDateTime startDateTimeEditableDateTimeWidget = tester
            .widget(find.byKey(const Key('addDurToDateTimeStartDateTime')));

        // Confirming the Add Duration To Date Time page Start Date Time
        // is set to the current date and time.
        String startDateTimeFrenchFormatStr =
            startDateTimeEditableDateTimeWidget.dateTimePickerController.text;
        DateTime actualStartDateTime = ScreenMixin.frenchDateTimeFormat
            .parse(startDateTimeFrenchFormatStr);
        DateTime expectedStartDateTime =
            ScreenMixin.frenchDateTimeFormat.parse(nowFrenchDateTimeFormatStr);
        DateTime expectedStartDateTimeOneMinuteBefore =
            expectedStartDateTime.subtract(const Duration(minutes: 1));
        DateTime expectedStartDateTimeOneMinuteAfter =
            expectedStartDateTime.add(const Duration(minutes: 1));

        // Check if the actual time is within that range
        expect(
            actualStartDateTime.isAfter(expectedStartDateTimeOneMinuteBefore),
            isTrue);
        expect(
            actualStartDateTime.isBefore(expectedStartDateTimeOneMinuteAfter),
            isTrue);

        // Find the preferred duration selection IconButton by the icon.
        final iconButtonFinder = find.byIcon(Icons.favorite);

        // Tap the yellow heart IconButton.
        await tester.tap(iconButtonFinder);

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        // Tap the menu item.
        await tester.tap(find.text('good rounding 12:00, 3:30, 10:30'));

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        final Map<String, dynamic> mapResults =
            checkFirstSecondAndThirdEndDateTimeAndDuration(
          startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
          firstDurationStr: '12:00',
          isRoundingSetForPreferredDuration: true,
        );
        final DateTime firstEndDateTime = mapResults['firstEndDateTime'];

        // Now verifying that when you change the first duration in the
        // situation in which the first end date time checkbox is checked,
        // the start date time is changed.

        // Tapping on the first end date time checkbox to lock it

        Finder checkboxFinder = find.byType(Checkbox).first;

        await tester.tap(checkboxFinder);
        await tester.pumpAndSettle();

        expect((tester.firstWidget(checkboxFinder) as Checkbox).value, true);

        // Setting the first duration to 10 hours

        const String changedFirstDurationStr = '10:00';

        // Findingvthe first duration text field
        Finder firstDurationWidgetFinder = find.byType(EditableText).at(1);
        // Finder firstDurationWidgetFinder = find.text(firstDurationStr);

        await tester.enterText(
            firstDurationWidgetFinder, changedFirstDurationStr);

        // Tapping on on DONE keyboard button or Enter key in order
        // to apply changing the first duration which, since the first
        // end date time checkbox is checked, will change the start date time
        // time.
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(find.text(changedFirstDurationStr), findsOneWidget);

        DateTime newStartDateTime = firstEndDateTime.subtract(
            DateTimeParser.parseHHMMDuration(changedFirstDurationStr)!);
        final String newStartDateTimeFrenchFormatStr =
            ScreenMixin.frenchDateTimeFormat.format(newStartDateTime);

        expect(find.text(newStartDateTimeFrenchFormatStr), findsOneWidget);
      });
      testWidgets(
          'Reset, select not rounding preferred duration, change duration without locking first end date time',
          (tester) async {
        Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);

        String nowEnglishDateTimeFormatStr =
            ScreenMixin.englishDateTimeFormat.format(DateTime.now());
        String nowFrenchDateTimeFormatStr =
            ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
        String testPath = kCircadianAppDataTestDir;

        Map<String, dynamic> transferDataMapCircadian = {
          "firstDurationIconData": Icons.add,
          "firstDurationIconColor": Colors.green.shade200,
          "firstDurationSign": 1,
          "firstDurationTextColor": Colors.green.shade200,
          "addDurStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstDurationStr": "00:00",
          "firstStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "firstEndDateTimeCheckbox": false,
          "secondDurationIconData": Icons.add,
          "secondDurationIconColor": Colors.red.shade200,
          "secondDurationSign": 1,
          "secondDurationTextColor": Colors.green.shade200,
          "secondDurationStr": "00:00",
          "secondStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "secondEndDateTimeCheckbox": false,
          "thirdDurationIconData": Icons.add,
          "thirdDurationIconColor": Colors.green.shade200,
          "thirdDurationSign": 1,
          "thirdDurationTextColor": Colors.green.shade200,
          "thirdDurationStr": "00:00",
          "thirdStartDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeStr": nowEnglishDateTimeFormatStr,
          "thirdEndDateTimeCheckbox": false,
          "preferredDurationsItemsStr":
              '{"good rounding":["12:00","3:30","10:30","false","true"], "good not round":["12:00","3:30","10:30","false","false"], "bad":["18:00","5:30","15:30","false","true"]}',
          "calcSlDurNewDateTimeStr": nowFrenchDateTimeFormatStr,
          "calcSlDurPreviousDateTimeStr": nowFrenchDateTimeFormatStr,
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
            '04:00'
          ],
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

        String jsonFileNameCircadian = 'circadian.json';
        String transferDataJsonFilePathNameCircadian =
            '$testPath${Platform.pathSeparator}$jsonFileNameCircadian';
        TransferDataViewModel transferDataViewModelCircadian =
            TransferDataViewModel(
                transferDataJsonFilePathName:
                    transferDataJsonFilePathNameCircadian);
        transferDataViewModelCircadian.transferDataMap =
            transferDataMapCircadian;
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        // updating a second time updates the circadian undo file
        await transferDataViewModelCircadian.updateAndSaveTransferData();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MainApp(
                key: const Key('mainAppKey'),
                transferDataViewModel: transferDataViewModelCircadian,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Clicking on the third icon in the navigation bar
        await tester
            .tap(find.byKey(const Key('navBarAddDurationToDateTimePageThree')));
        await tester.pumpAndSettle();

        // clicking on Reset button
        await tester.tap(find.byKey(const Key('resetButton')));
        await tester.pumpAndSettle();

        EditableDateTime startDateTimeEditableDateTimeWidget = tester
            .widget(find.byKey(const Key('addDurToDateTimeStartDateTime')));

        // Confirming the Add Duration To Date Time page Start Date Time
        // is set to the current date and time.
        String startDateTimeFrenchFormatStr =
            startDateTimeEditableDateTimeWidget.dateTimePickerController.text;
        expect(startDateTimeFrenchFormatStr, nowFrenchDateTimeFormatStr);

        // Find the preferred duration selection IconButton by the icon.
        final iconButtonFinder = find.byIcon(Icons.favorite);

        // Tap the yellow heart IconButton.
        await tester.tap(iconButtonFinder);

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        // Tap the menu item.
        await tester.tap(find.text('good rounding 12:00, 3:30, 10:30'));

        // Wait for the tap to be processed and for any animations to complete.
        await tester.pumpAndSettle();

        checkFirstSecondAndThirdEndDateTimeAndDuration(
          startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
          firstDurationStr: '12:00',
          isRoundingSetForPreferredDuration: true,
        );

        // Now verifying that when you change the first duration in the
        // situation in which the first end date time checkbox is not
        // checked, the start date time is not changed. Instead, the
        // end date time widgets are updated.

        // Setting the first duration to 10 hours

        const String changedFirstDurationStr = '10:00';

        // Finding the first duration text field
        Finder firstDurationWidgetFinder = find.byType(EditableText).at(1);

        await tester.enterText(
            firstDurationWidgetFinder, changedFirstDurationStr);

        // Tapping on on DONE keyboard button or Enter key in order
        // to apply changing the first duration which, since the first
        // end date time checkbox is checked, will change the start date time
        // time.
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(find.text(changedFirstDurationStr), findsOneWidget);

        // Verifying the Start Date Time was not changed since the first
        // end date time checkbox which locks it is not checked.
        expect(find.text(startDateTimeFrenchFormatStr), findsOneWidget);

        checkFirstSecondAndThirdEndDateTimeAndDuration(
          startDateTimeFrenchFormatStr: startDateTimeFrenchFormatStr,
          firstDurationStr: changedFirstDurationStr,
          isRoundingSetForPreferredDuration: false,
        );
      });
    },
  );
}

/// Verify the end date time and duration of the first, second and third
/// DurationDateTimeEditor widgets
///
/// Returns a Map containing the first duration string (10:00 for example)
/// and the first DateTime end date time.
///
/// {isRoundingSetForPreferredDuration} this indicates that the selected
/// preferred duration were defined with rounding set to true or false,
/// which mens that the end date time will be rounded to the nearest hour
/// or not after adding the duration.
Map<String, dynamic> checkFirstSecondAndThirdEndDateTimeAndDuration({
  required String startDateTimeFrenchFormatStr,
  required String firstDurationStr,
  required bool isRoundingSetForPreferredDuration,
}) {
  // Checking first end date time

  DateTime startDateTime =
      ScreenMixin.frenchDateTimeFormat.parse(startDateTimeFrenchFormatStr);
  DateTime firstEndDateTime =
      startDateTime.add(DateTimeParser.parseHHMMDuration(firstDurationStr)!);

  if (isRoundingSetForPreferredDuration) {
    DateTime firstEndDateTimeRounded =
        DateTimeParser.roundDateTimeToHour(firstEndDateTime);
    firstEndDateTime = firstEndDateTimeRounded;
    Duration firstDuration = firstEndDateTimeRounded.difference(startDateTime);
    firstDurationStr = firstDuration.HHmm();
  }

  String firstEndDateTimeStr =
      ScreenMixin.frenchDateTimeFormat.format(firstEndDateTime);

  expect(find.text(firstEndDateTimeStr), findsOneWidget);
  expect(find.text(firstDurationStr), findsOneWidget);

  // Checking second end date time

  DateTime secondEndDateTime = firstEndDateTime
      .add(const Duration(hours: 3, minutes: 30, seconds: 0, milliseconds: 0));
  String secondEndDateTimeStr =
      ScreenMixin.frenchDateTimeFormat.format(secondEndDateTime);

  expect(find.text(secondEndDateTimeStr), findsOneWidget);

  // Checking third end date time

  DateTime thirdEndDateTime = secondEndDateTime
      .add(const Duration(hours: 10, minutes: 30, seconds: 0, milliseconds: 0));
  String thirdEndDateTimeStr =
      ScreenMixin.frenchDateTimeFormat.format(thirdEndDateTime);

  expect(find.text(thirdEndDateTimeStr), findsOneWidget);

  return {
    'firstDurationStr': firstDurationStr,
    'firstEndDateTime': firstEndDateTime,
  };
}
