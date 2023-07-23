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

  // files in this local test dir are stored in
  // project test_data dir updated
  // on GitHub
  String path = kCircadianAppDataTestDir;
  final Directory directory = Directory(path);
  bool directoryExists = await directory.exists();

  if (!directoryExists) {
    await directory.create();
  }

  String transferDataJsonFilePathName =
      '${directory.path}${Platform.pathSeparator}circadian.json';
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathName);
  transferDataViewModel.transferDataMap = transferDataMap;
  await transferDataViewModel.updateAndSaveTransferData();
  final ScreenNavigTransData screenNavigTransData =
      ScreenNavigTransData(transferDataMap: transferDataMap);

  group(
    'Updating Start date time - first fix checkbox set to true',
    () {
      testWidgets(
        'plus 3 hours',
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
          final Finder firstDateTimeCheckboxFinder =
              find.byKey(const Key('firstFixedDateTimeCheckbox'));

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

          // Now setting firstDateTimeCheckBox to true

          Checkbox firstDateTimeCheckBox =
              tester.firstWidget(firstDateTimeCheckboxFinder) as Checkbox;
          expect(firstDateTimeCheckBox.value, false);

          // typing on firstDateTimeCheckBox
          await tester.tap(firstDateTimeCheckboxFinder);
          await tester.pumpAndSettle();
          firstDateTimeCheckBox = // checkbox must be obtained again !
              tester.firstWidget(firstDateTimeCheckboxFinder) as Checkbox;
          expect(firstDateTimeCheckBox.value, true);

          // Now updating Start date time 3 hours later

          // editableStartDateTime.dateTimePickerController.text =
          //     "12-07-2022 13:00";
          // firstDurationDateTimeEditorWidget.setStartDateTimeStr(
          //     englishFormatStartDateTimeStr: "2022-07-12 13:00");

          // Finder firstDurationWidgetFinder = find.byType(EditableText).at(0);
          Finder startDateTimeWidgetFinder = find.text("12-07-2022 10:00");

          await tester.enterText(
              startDateTimeWidgetFinder, "12-07-2022 13:00");

          // Tapping on on DONE keyboard button or Enter key in order
          // to apply changing the first duration which, since the first
          // end date time checkbox is checked, will change the start date time
          // time.
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            '6:30', // duration 9:30 - 3:00 = 6:30 hours
          );

          expect(
              firstDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: transferDataMap[
                    'firstEndDateTimeStr'], // "2022-07-12 19:30"
              ));

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

          // Now adding one hour to first End date time whose checkbox
          // is true

          // 1 hours later than 12-07-2022 19:30
          const String englishFormatFirstEndDateTimeStr = "2022-07-12 20:30";

          firstDurationDateTimeEditorWidget.dateTimePickerControllerTst.text =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: englishFormatFirstEndDateTimeStr)!;
          firstDurationDateTimeEditorWidget
              .handleEndDateTimeChangeTst(englishFormatFirstEndDateTimeStr);

          expect(editableStartDateTime.dateTimePickerController.text,
              '12-07-2022 13:00'); // not changed

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: "2022-07-13 00:00",
              ));

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['secondDurationStr'], // 3:30
          );

          expect(
            secondDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign now positive
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon now add
          );

          expect(
            secondDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color now positive
          );

          expect(
            secondDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color now positive
          );

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: "2022-07-13 11:00"));

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['thirdDurationStr'], // 11:00
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationSignTst,
            1, // duration sign now positive
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconTst,
            Icons.add, // duration icon now add
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationIconColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration icon color now positive
          );

          expect(
            thirdDurationDateTimeEditorWidget.durationTextColorTst,
            DurationDateTimeEditor
                .durationPositiveColor, // duration text color now positive
          );
        },
      );
    },
  );
}
