import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/widgets/manually_selectable_text_field.dart';
import 'package:circa_plan/screens/time_calculator.dart';

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

  String transferDataJsonFilePathName =
      '${directory.path}${Platform.pathSeparator}circadian.json';
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathName);
  transferDataViewModel.transferDataMap = transferDataMap;
  await transferDataViewModel.updateAndSaveTransferData();
  final ScreenNavigTransData screenNavigTransData =
      ScreenNavigTransData(transferDataMap: transferDataMap);

  group(
    'Division test, checkbox set to false',
    () {
      testWidgets(
        'Greatest divided by smallest',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TimeCalculator(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final Finder firstTimeTextFieldFinder =
              find.byKey(const Key('firstTimeTextField'));
          final Finder secondTimeTextFieldFinder =
              find.byKey(const Key('secondTimeTextField'));
          final Finder resultTextFieldFinder =
              find.byKey(const Key('resultTextField'));
          final Finder divButtonFinder = find.byKey(const Key('divButton'));

          await tester.enterText(firstTimeTextFieldFinder, '30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField firstTimeTextField =
              tester.firstWidget(firstTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController firstTimeTextFieldController =
              firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, '00:30:00');

          await tester.enterText(secondTimeTextFieldFinder, '15');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField secondTimeTextField =
              tester.firstWidget(secondTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController secondTimeTextFieldController =
              secondTimeTextField.controller!;
          expect(secondTimeTextFieldController.text, '00:15:00');

          await tester.tap(divButtonFinder);
          await tester.pumpAndSettle();

          TextField resultTextField = tester.firstWidget(resultTextFieldFinder);
          TextEditingController resultTextFieldController =
              resultTextField.controller!;
          expect(resultTextFieldController.text, '50.00 %');
        },
      );
      testWidgets(
        'Smallest divided by greatest',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TimeCalculator(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final Finder firstTimeTextFieldFinder =
              find.byKey(const Key('firstTimeTextField'));
          final Finder secondTimeTextFieldFinder =
              find.byKey(const Key('secondTimeTextField'));
          final Finder resultTextFieldFinder =
              find.byKey(const Key('resultTextField'));
          final Finder divButtonFinder = find.byKey(const Key('divButton'));

          await tester.enterText(firstTimeTextFieldFinder, '15');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField firstTimeTextField =
              tester.firstWidget(firstTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController firstTimeTextFieldController =
              firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, '00:15:00');

          await tester.enterText(secondTimeTextFieldFinder, '30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField secondTimeTextField =
              tester.firstWidget(secondTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController secondTimeTextFieldController =
              secondTimeTextField.controller!;
          expect(secondTimeTextFieldController.text, '00:30:00');

          await tester.tap(divButtonFinder);
          await tester.pumpAndSettle();

          TextField resultTextField = tester.firstWidget(resultTextFieldFinder);
          TextEditingController resultTextFieldController =
              resultTextField.controller!;
          expect(resultTextFieldController.text, '50.00 %');
        },
      );
    },
  );
  group(
    'Division test, checkbox set to true',
    () {
      testWidgets(
        'Greatest divided by smallest',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TimeCalculator(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final Finder firstTimeTextFieldFinder =
              find.byKey(const Key('firstTimeTextField'));
          final Finder secondTimeTextFieldFinder =
              find.byKey(const Key('secondTimeTextField'));
          final Finder resultTextFieldFinder =
              find.byKey(const Key('resultTextField'));
          final Finder divButtonFinder = find.byKey(const Key('divButton'));
          final Finder divCheckboxFinder =
              find.byKey(const Key('divideFirstBySecond'));

          await tester.enterText(firstTimeTextFieldFinder, '30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField firstTimeTextField =
              tester.firstWidget(firstTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController firstTimeTextFieldController =
              firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, '00:30:00');

          await tester.enterText(secondTimeTextFieldFinder, '15');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField secondTimeTextField =
              tester.firstWidget(secondTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController secondTimeTextFieldController =
              secondTimeTextField.controller!;
          expect(secondTimeTextFieldController.text, '00:15:00');

          Checkbox divideFirstBySecondCheckBox =
              tester.firstWidget(divCheckboxFinder) as Checkbox;
          expect(divideFirstBySecondCheckBox.value, false);

          // typing on divideFirstBySecondCheckBox
          await tester.tap(divCheckboxFinder);
          await tester.pumpAndSettle();
          divideFirstBySecondCheckBox = // checkbox must be obtained again !
              tester.firstWidget(divCheckboxFinder) as Checkbox;
          expect(divideFirstBySecondCheckBox.value, true);

          await tester.tap(divButtonFinder);
          await tester.pumpAndSettle();

          TextField resultTextField = tester.firstWidget(resultTextFieldFinder);
          TextEditingController resultTextFieldController =
              resultTextField.controller!;
          expect(resultTextFieldController.text, '200.00 %');
        },
      );
      testWidgets(
        'Smallest divided by greatest',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TimeCalculator(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final Finder firstTimeTextFieldFinder =
              find.byKey(const Key('firstTimeTextField'));
          final Finder secondTimeTextFieldFinder =
              find.byKey(const Key('secondTimeTextField'));
          final Finder resultTextFieldFinder =
              find.byKey(const Key('resultTextField'));
          final Finder divButtonFinder = find.byKey(const Key('divButton'));
          final Finder divCheckboxFinder =
              find.byKey(const Key('divideFirstBySecond'));

          await tester.enterText(firstTimeTextFieldFinder, '15');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField firstTimeTextField =
              tester.firstWidget(firstTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController firstTimeTextFieldController =
              firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, '00:15:00');

          await tester.enterText(secondTimeTextFieldFinder, '30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField secondTimeTextField =
              tester.firstWidget(secondTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController secondTimeTextFieldController =
              secondTimeTextField.controller!;
          expect(secondTimeTextFieldController.text, '00:30:00');

          Checkbox divideFirstBySecondCheckBox =
              tester.firstWidget(divCheckboxFinder) as Checkbox;

          // checkbox was set to true in 'Greatest divided by smallest'
          // previous test !
          expect(divideFirstBySecondCheckBox.value, true);

          await tester.tap(divButtonFinder);
          await tester.pumpAndSettle();

          TextField resultTextField = tester.firstWidget(resultTextFieldFinder);
          TextEditingController resultTextFieldController =
              resultTextField.controller!;
          expect(resultTextFieldController.text, '200.00 %');
        },
      );
    },
  );
  group(
    'First dd:hh:mm time setting',
    () {
      testWidgets(
        'Now button test',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TimeCalculator(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final Finder firstTimeTextFieldFinder =
              find.byKey(const Key('firstTimeTextField'));
          final Finder nowButtonFinder =
              find.byKey(const Key('timeCalculatorNowButton'));

          await tester.enterText(firstTimeTextFieldFinder, '30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          ManuallySelectableTextField firstTimeTextField =
              tester.firstWidget(firstTimeTextFieldFinder)
                  as ManuallySelectableTextField;
          TextEditingController firstTimeTextFieldController =
              firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, '00:30:00');
          await tester.tap(nowButtonFinder);
          await tester.pumpAndSettle();

          String now_dd_hh_mm_str =
              '00:${ScreenMixin.HHmmDateTimeFormat.format(DateTime.now())}';

          firstTimeTextField = tester.firstWidget(firstTimeTextFieldFinder)
              as ManuallySelectableTextField;
          firstTimeTextFieldController = firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, now_dd_hh_mm_str);
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
