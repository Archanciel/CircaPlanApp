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
    "addDurStartDateTimeStr": "2022-07-12 10:00",
    "firstDurationStr": "09:30",
    "firstStartDateTimeStr": "2022-07-12 10:00",
    "firstEndDateTimeStr": "2022-07-12 19:30",
    "firstEndDateTimeCheckbox": false,
    "secondDurationIconData": Icons.add,
    "secondDurationIconColor": Colors.green.shade200,
    "secondDurationSign": 1,
    "secondDurationTextColor": Colors.green.shade200,
    "secondDurationStr": "03:30",
    "secondStartDateTimeStr": "2022-07-12 19:30",
    "secondEndDateTimeStr": "2022-07-12 23:00",
    "secondEndDateTimeCheckbox": false,
    "thirdDurationIconData": Icons.add,
    "thirdDurationIconColor": Colors.green.shade200,
    "thirdDurationSign": 1,
    "thirdDurationTextColor": Colors.green.shade200,
    "thirdDurationStr": "11:00",
    "thirdStartDateTimeStr": "2022-07-12 23:00",
    "thirdEndDateTimeStr": "2022-07-13 10:00",
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
        'plus 2 hours',
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
                    'firstEndDateTimeStr'], // "2022-07-12 19:30"
              ));

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['firstDurationStr'], // 9:30
          );

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'secondEndDateTimeStr'], // "2022-07-12 23:00"
              ));

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['secondDurationStr'], // 3:30
          );

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'thirdEndDateTimeStr'], // "2022-07-13 10:00"
              ));

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['thirdDurationStr'], // 11:00
          );

          // setting first End date time 5:30 hours sooner

          // 2:00 hours latetr than 12-07-2022 19:30
          const String englishFormatFirstNewEndDateTimeStr = "2022-07-12 21:30";

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing !
          firstDurationDateTimeEditorWidget.dateTimePickerControllerTst.text =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: englishFormatFirstNewEndDateTimeStr)!;

          // causing second and third DurationDateTimeEditor widgets to be
          // updated
          firstDurationDateTimeEditorWidget
              .handleEndDateTimeChangeTst(englishFormatFirstNewEndDateTimeStr);

          expect(editableStartDateTime.dateTimePickerController.text,
              '12-07-2022 10:00'); // not changed

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatFirstNewEndDateTimeStr,
              ));

          expect(transferDataMap['firstEndDateTimeStr'],
              englishFormatFirstNewEndDateTimeStr);

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            '11:30', // duration 9:30 + 2:00 = 11:30 hours
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

          // 2:00 hours after 2022-07-12 23:00 or new second start date
          // time 2022-07-12 21:30 + 3:30
          const String englishFormatSecondNewEndDateTimeStr = '2022-07-13 01:00';

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatSecondNewEndDateTimeStr,
              ));

          expect(transferDataMap['secondEndDateTimeStr'],
              englishFormatSecondNewEndDateTimeStr);

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            '03:30', // duration not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color not changed
          );

          // 2 hours after than 2022-07-13 10:00 or new third start date
          // time 2022-07-13 01:00 + 11:00
          const String englishFormatThirdNewEndDateTimeStr = '2022-07-13 12:00';

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr:
                    englishFormatThirdNewEndDateTimeStr,
              ));

          expect(transferDataMap['thirdEndDateTimeStr'],
              englishFormatThirdNewEndDateTimeStr);

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            '11:00', // duration not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color not changed
          );
        },
      );
      testWidgets(
        'less 5:30 hours',
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
                    'firstEndDateTimeStr'], // "2022-07-12 19:30"
              ));

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['firstDurationStr'], // 9:30
          );

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'secondEndDateTimeStr'], // "2022-07-12 23:00"
              ));

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['secondDurationStr'], // 3:30
          );

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'thirdEndDateTimeStr'], // "2022-07-13 10:00"
              ));

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['thirdDurationStr'], // 11:00
          );

          // setting first End date time 5:30 hours sooner

          // 5:30 hours sooner than 12-07-2022 19:30
          const String englishFormatFirstNewEndDateTimeStr = "2022-07-12 14:00";

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing !
          firstDurationDateTimeEditorWidget.dateTimePickerControllerTst.text =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: englishFormatFirstNewEndDateTimeStr)!;

          // causing second and third DurationDateTimeEditor widgets to be
          // updated
          firstDurationDateTimeEditorWidget
              .handleEndDateTimeChangeTst(englishFormatFirstNewEndDateTimeStr);

          expect(editableStartDateTime.dateTimePickerController.text,
              '12-07-2022 10:00'); // not changed

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatFirstNewEndDateTimeStr,
              ));

          expect(transferDataMap['firstEndDateTimeStr'],
              englishFormatFirstNewEndDateTimeStr);

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            '4:00', // duration 9:30 - 5:30 = 4 hours
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

          // 5:30 hours sooner than 2022-07-12 23:00 or new second start date
          // time 2022-07-12 14:00 + 3:30
          const String englishFormatSecondNewEndDateTimeStr = '2022-07-12 17:30';

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatSecondNewEndDateTimeStr,
              ));

          expect(transferDataMap['secondEndDateTimeStr'],
              englishFormatSecondNewEndDateTimeStr);

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            '03:30', // duration not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color not changed
          );

          // 5:30 hours sooner than 2022-07-13 10:00 or new third start date
          // time 2022-07-12 17:30 + 11:00
          const String englishFormatThirdNewEndDateTimeStr = '2022-07-13 04:30';

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr:
                    englishFormatThirdNewEndDateTimeStr,
              ));

          expect(transferDataMap['thirdEndDateTimeStr'],
              englishFormatThirdNewEndDateTimeStr);

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            '11:00', // duration not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color not changed
          );
        },
      );
      testWidgets(
        'less 10:00 hours',
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
                    'firstEndDateTimeStr'], // "2022-07-12 19:30"
              ));

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['firstDurationStr'], // 9:30
          );

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'secondEndDateTimeStr'], // "2022-07-12 23:00"
              ));

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['secondDurationStr'], // 3:30
          );

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'thirdEndDateTimeStr'], // "2022-07-13 10:00"
              ));

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['thirdDurationStr'], // 11:00
          );

          // setting first End date time 10:00 hours sooner

          // 10:00 hours sooner than 12-07-2022 19:30
          const String englishFormatFirstNewEndDateTimeStr = "2022-07-12 09:30";

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing !
          firstDurationDateTimeEditorWidget.dateTimePickerControllerTst.text =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: englishFormatFirstNewEndDateTimeStr)!;

          // causing second and third DurationDateTimeEditor widgets to be
          // updated
          firstDurationDateTimeEditorWidget
              .handleEndDateTimeChangeTst(englishFormatFirstNewEndDateTimeStr);

          expect(editableStartDateTime.dateTimePickerController.text,
              '12-07-2022 10:00'); // not changed

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatFirstNewEndDateTimeStr,
              ));

          expect(transferDataMap['firstEndDateTimeStr'],
              englishFormatFirstNewEndDateTimeStr);

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            '0:30', // duration 9:30 - 10:00 = 0:30 hours
          );

          expect(
            firstDurationDateTimeEditorWidget.durationSignTst,
            -1, // duration sign not changed
          );

          expect(
            firstDurationDateTimeEditorWidget.durationIconTst,
            Icons.remove, // duration icon not changed
          );

          expect(
            firstDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration icon color not changed
          );

          expect(
            firstDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationNegativeColor, // duration text color not changed
          );

          // 10:00 hours sooner than 2022-07-12 23:00 or new second start date
          // time 2022-07-12 09:30 + 3:30
          const String englishFormatSecondNewEndDateTimeStr = '2022-07-12 13:00';

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: englishFormatSecondNewEndDateTimeStr,
              ));

          expect(transferDataMap['secondEndDateTimeStr'],
              englishFormatSecondNewEndDateTimeStr);

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            '03:30', // duration not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color not changed
          );

          expect(
            secondDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color not changed
          );

          // 10:00 hours sooner than 2022-07-13 10:00 or new third start date
          // time 2022-07-12 13:00 + 11:00
          const String englishFormatThirdNewEndDateTimeStr = '2022-07-13 00:00';

          // dateTimePickerControllerTst is a controller getter used only for
          // widget testing ! It gives access to DurationDateTimeEditor widget
          // end date time controller
          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr:
                    englishFormatThirdNewEndDateTimeStr,
              ));

          expect(transferDataMap['thirdEndDateTimeStr'],
              englishFormatThirdNewEndDateTimeStr);

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            '11:00', // duration not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color not changed
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color not changed
          );
        },
      );
    },
  );
}
