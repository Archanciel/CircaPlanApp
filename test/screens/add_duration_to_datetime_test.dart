import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/screens/add_duration_to_datetime.dart';

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
    "secondDurationIconData": Icons.remove,
    "secondDurationIconColor": Colors.red.shade200,
    "secondDurationSign": -1,
    "secondDurationTextColor": Colors.red.shade200,
    "secondDurationStr": "02:00",
    "secondStartDateTimeStr": "2022-07-12 16:50",
    "secondEndDateTimeStr": "2022-07-12 14:50",
    "thirdDurationIconData": Icons.remove,
    "thirdDurationIconColor": Colors.red.shade200,
    "thirdDurationSign": -1,
    "thirdDurationTextColor": Colors.red.shade200,
    "thirdDurationStr": "01:00",
    "thirdStartDateTimeStr": "2022-07-12 14:50",
    "thirdEndDateTimeStr": "2022-07-12 13:50",
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
  final ScreenNavigTransData screenNavigTransData =
      ScreenNavigTransData(transferDataMap: transferDataMap);

  const IconData positiveDurationIcon = Icons.add;
  const IconData negativeDurationIcon = Icons.remove;

  group(
    'Division test',
    () {
      testWidgets(
        'Greatest divided by smallest',
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
                englishFormatDateTimeStr:
                    transferDataMap['firstEndDateTimeStr'],
              ));

          expect(
            firstDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['firstDurationStr'],
          );

          expect(
              secondDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr:
                    transferDataMap['secondEndDateTimeStr'],
              ));

          expect(
            secondDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['secondDurationStr'],
          );

          expect(
              thirdDurationDateTimeEditorWidget
                  .dateTimePickerControllerTst.text,
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr:
                    transferDataMap['thirdEndDateTimeStr'],
              ));

          expect(
            thirdDurationDateTimeEditorWidget.durationStrTst,
            transferDataMap['thirdDurationStr'],
          );
        },
      );
    },
  );
}

Offset textOffsetToPosition(WidgetTester tester, int offset) {
  final RenderEditable renderEditable = findRenderEditable(tester);
  final List<TextSelectionPoint> endpoints = globalize(
    renderEditable.getEndpointsForSelection(
      TextSelection.collapsed(offset: offset),
    ),
    renderEditable,
  );
  expect(endpoints.length, 1);
  return endpoints[0].point + const Offset(0.0, -2.0);
}

RenderEditable findRenderEditable(WidgetTester tester) {
  final RenderObject root = tester.renderObject(find.byType(EditableText));
  expect(root, isNotNull);
  RenderEditable? renderEditable;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder);
  }

  root.visitChildren(recursiveFinder);
  expect(renderEditable, isNotNull);
  return renderEditable!;
}

List<TextSelectionPoint> globalize(
    Iterable<TextSelectionPoint> points, RenderBox box) {
  return points.map<TextSelectionPoint>((TextSelectionPoint point) {
    return TextSelectionPoint(
      box.localToGlobal(point.point),
      point.direction,
    );
  }).toList();
}
