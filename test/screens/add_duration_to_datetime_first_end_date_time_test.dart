import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';

Future<void> main() async {
  Map<String, dynamic> transferDataMap = {
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
    "calcSlDurStatus": Status.sleep,
    "calcSlDurSleepTimeStrHistory": ['10-07-2022 00:58', '05:35', '04:00'],
    "calcSlDurWakeUpTimeStrHistory": ['10-07-2022 05:58', '00:35', '01:00'],
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
  await transferDataViewModel.updateAndSaveTransferData();
  final ScreenNavigTransData screenNavigTransData =
      ScreenNavigTransData(transferDataMap: transferDataMap);

  group(
    'Updating first End date time',
    () {
      testWidgets(
        'plus 4 hours',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AddDurationToDateTime(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final EditableDateTime editableStartDateTime = tester.firstWidget(
                  find.byKey(const Key('addDurToDateTimeStartDateTime')))
              as EditableDateTime;

          expect(
              editableStartDateTime.dateTimePickerController.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr:
                      transferDataMap['addDurStartDateTimeStr']));

          final DurationDateTimeEditor firstDurationDateTimeEditorWidget =
              tester.firstWidget(find
                      .byKey(const Key('firstAddSubtractResultableDuration')))
                  as DurationDateTimeEditor;
          final DurationDateTimeEditor secondDurationDateTimeEditorWidget =
              tester.firstWidget(find
                      .byKey(const Key('secondAddSubtractResultableDuration')))
                  as DurationDateTimeEditor;
          final DurationDateTimeEditor thirdDurationDateTimeEditorWidget =
              tester.firstWidget(find
                      .byKey(const Key('thirdAddSubtractResultableDuration')))
                  as DurationDateTimeEditor;

          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'firstEndDateTimeStr'], // "2022-07-12 16:50"
              ));

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['firstDurationStr'],
          );

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'secondEndDateTimeStr'], // "2022-07-12 14:50"
              ));

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['secondDurationStr'],
          );

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'thirdEndDateTimeStr'], // "2022-07-12 13:50"
              ));

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['thirdDurationStr'],
          );

          // changing first End date time

          // 4 hours later than 12-07-2022 16:50
          const String englishFormatFirstNewDateTimeStr = "2022-07-12 20:50";

          firstDurationDateTimeEditorWidget.dateTimePickerControllerTst.text =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: englishFormatFirstNewDateTimeStr)!;
          firstDurationDateTimeEditorWidget
              .handleEndDateTimeChangeTst(englishFormatFirstNewDateTimeStr);

          expect(editableStartDateTime.dateTimePickerController.text,
              '12-07-2022 16:00'); // not changed

          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatFirstNewDateTimeStr,
              ));

          expect(transferDataMap['firstEndDateTimeStr'],
              englishFormatFirstNewDateTimeStr);

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            '4:50', // duration 4 hours bigger
          );

          expect(
            firstDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign not changed
          );

          expect(
            firstDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon not changed
          );

          expect(
            firstDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color not changed
          );

          expect(
            firstDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color not changed
          );

          // 4 hours later
          const String englishFormatSecondNewDateTimeStr = '2022-07-12 18:50';

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatSecondNewDateTimeStr,
              ));

          expect(transferDataMap['secondEndDateTimeStr'],
              englishFormatSecondNewDateTimeStr);

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            '02:00', // duration not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationSignTst,
            -1, // duration sign not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconTst,
            Icons.remove, // duration icon not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration icon color not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration text color not changed
          );

          // 4 hours later
          const String englishFormatThirdNewDateTimeStr = '2022-07-12 17:50';

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr:
                    englishFormatThirdNewDateTimeStr, // 4 hours later
              ));

          expect(transferDataMap['thirdEndDateTimeStr'],
              englishFormatThirdNewDateTimeStr);

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            '01:00', // duration not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationSignTst,
            -1, // duration sign not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconTst,
            Icons.remove, // duration icon not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration icon color not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration text color not changed
          );
        },
      );
      testWidgets(
        'minus 4 hours',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AddDurationToDateTime(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final EditableDateTime editableStartDateTime = tester.firstWidget(
                  find.byKey(const Key('addDurToDateTimeStartDateTime')))
              as EditableDateTime;

          expect(
              editableStartDateTime.dateTimePickerController.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr:
                      transferDataMap['addDurStartDateTimeStr']));

          final DurationDateTimeEditor firstDurationDateTimeEditorWidget =
              tester.firstWidget(find
                      .byKey(const Key('firstAddSubtractResultableDuration')))
                  as DurationDateTimeEditor;
          final DurationDateTimeEditor secondDurationDateTimeEditorWidget =
              tester.firstWidget(find
                      .byKey(const Key('secondAddSubtractResultableDuration')))
                  as DurationDateTimeEditor;
          final DurationDateTimeEditor thirdDurationDateTimeEditorWidget =
              tester.firstWidget(find
                      .byKey(const Key('thirdAddSubtractResultableDuration')))
                  as DurationDateTimeEditor;

          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'firstEndDateTimeStr'], // "2022-07-12 16:50"
              ));

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['firstDurationStr'],
          );

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'secondEndDateTimeStr'], // "2022-07-12 14:50"
              ));

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['secondDurationStr'],
          );

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'thirdEndDateTimeStr'], // "2022-07-12 13:50"
              ));

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['thirdDurationStr'],
          );

          // changing first End date time

          // 4 hours sooner than 12-07-2022 16:50
          const String englishFormatFirstNewDateTimeStr = "2022-07-12 12:50";

          firstDurationDateTimeEditorWidget.dateTimePickerControllerTst.text =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: englishFormatFirstNewDateTimeStr)!;
          firstDurationDateTimeEditorWidget
              .handleEndDateTimeChangeTst(englishFormatFirstNewDateTimeStr);

          expect(editableStartDateTime.dateTimePickerController.text,
              '12-07-2022 16:00'); // not changed

          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatFirstNewDateTimeStr,
              ));

          expect(transferDataMap['firstEndDateTimeStr'],
              englishFormatFirstNewDateTimeStr);

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            '3:10', // duration 4 hours smaller
          );

          expect(
            firstDurationDateTimeEditorWidget.durationSignTst,
            -1, // duration sign now negative
          );

          expect(
            firstDurationDateTimeEditorWidget.durationIconTst,
            Icons.remove, // duration icon now minus
          );

          expect(
            firstDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration icon color now negative
          );

          expect(
            firstDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration text color now negative
          );

          // 4 hours sooner
          const String englishFormatSecondNewDateTimeStr = '2022-07-12 10:50';

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatSecondNewDateTimeStr,
              ));

          expect(transferDataMap['secondEndDateTimeStr'],
              englishFormatSecondNewDateTimeStr);

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            '02:00', // duration not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationSignTst,
            -1, // duration sign not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconTst,
            Icons.remove, // duration icon not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration icon color not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration text color not changed
          );

          // 4 hours sooner
          const String englishFormatThirdNewDateTimeStr = '2022-07-12 09:50';

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr:
                    englishFormatThirdNewDateTimeStr, // 4 hours later
              ));

          expect(transferDataMap['thirdEndDateTimeStr'],
              englishFormatThirdNewDateTimeStr);

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            '01:00', // duration not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationSignTst,
            -1, // duration sign not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconTst,
            Icons.remove, // duration icon not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration icon color not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration text color not changed
          );
        },
      );
    },
  );
}
