import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';

/// This DurationDateTimeEditor widget unit test tests
/// specifically handling integer duration setting in place of
/// defining HH:mm durations.
Future<void> main() async {
  String path = kCircadianAppDataTestDir;
  final Directory directory = Directory(path);
  bool directoryExists = await directory.exists();

  if (!directoryExists) {
    await directory.create();
  }

  Map<String, dynamic> transferDataMap = {};
  String pathSeparator = Platform.pathSeparator;
  String transferDataJsonFilePathName =
      '${directory.path}${pathSeparator}circadian.json';
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathName);
  transferDataViewModel.transferDataMap = transferDataMap;

  const IconData positiveDurationIcon = Icons.add;
  const IconData negativeDurationIcon = Icons.remove;

  /// This test group validate duration icon and color bug fix

          // testing the duration text field color
  group(
    'DurationDateTimeEditor adding multiple int durations',
    () {
      testWidgets(
        'Positive then negative duration',
        (tester) async {
          final Finder durationSignButtonFinder =
              find.byKey(const Key('durationSignButton'));
          final Finder durationTextFieldFinder =
              find.byKey(const Key('durationTextField'));
          final Finder editableDateTimeTextFieldFinder =
              find.byKey(const Key('editableDateTimeTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetName: 'one',
                  dateTimeTitle: 'End date time',
                  topSelMenuPosition: 210.0,
                  nowDateTimeEnglishFormatStr: '2022-08-11 11:00',
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                  nextAddSubtractResultableDuration: null,
                ),
              ),
            ),
          );

          // Adding positive one digit duration

          await tester.enterText(durationTextFieldFinder, '2');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();
          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          // expect(find.text('11-08-2022 13:00'), findsOneWidget);

          TextField editableDateTimeTextField =
              tester.widget(editableDateTimeTextFieldFinder);
          expect(editableDateTimeTextField.controller!.text, '11-08-2022 13:00');

          // testing the duration text field color
          TextField durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.controller!.text, '2:00');
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationPositiveColor);

          // testing the duration sign button icon and color
          dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, positiveDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationPositiveColor);

          // Adding negative one digit duration

          await tester.enterText(durationTextFieldFinder, '-2');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 09:00'), findsOneWidget);

          // testing the duration text field color
          durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationNegativeColor);

          // testing the duration sign button icon and color
          textButtonWithIconWidget = tester.widget(find.byWidgetPredicate(
              (Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, negativeDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationNegativeColor);

          // Typing once on negative duration sign button

          await tester.tap(durationSignButtonFinder);
          await tester.pumpAndSettle();

          // testing the duration text field color
          durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationPositiveColor);

          // testing the duration sign button icon and color
          textButtonWithIconWidget = tester.widget(find.byWidgetPredicate(
              (Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, positiveDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationPositiveColor);

          // Typing again on now positive duration sign button

          await tester.tap(durationSignButtonFinder);
          await tester.pumpAndSettle();

          // testing the duration text field color
          durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationNegativeColor);

          // testing the duration sign button icon and color
          textButtonWithIconWidget = tester.widget(find.byWidgetPredicate(
              (Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, negativeDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationNegativeColor);
        },
      );
    },
  );
}
