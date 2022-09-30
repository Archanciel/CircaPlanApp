import 'dart:io';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:circa_plan/widgets/duration_date_time_editor.dart';

/// This DurationDateTimeEditor widget unit test tests
/// specifically handling integer duration setting in place of
/// defining HH:mm durations.
Future<void> main() async {
  const String kCircadianAppDataDir = 'c:\\temp\\CircadianData';
  String path = kCircadianAppDataDir;
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

  group(
    'DurationDateTimeEditor adding one int duration',
    () {
      testWidgets(
        'Adding one digit duration',
        (tester) async {
          final Finder durationTextFieldFinder =
              find.byKey(const Key('durationTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetName: 'one',
                  dateTimeTitle: 'End date time',
                  topSelMenuPosition: 210.0,
                  nowDateTimeEnglishFormatStr: '2022-08-11 10:00',
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                  nextAddSubtractResultableDuration: null,
                ),
              ),
            ),
          );

          await tester.enterText(durationTextFieldFinder, '2');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationPositiveColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, positiveDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationPositiveColor);
        },
      );
      testWidgets(
        'Adding two digits duration',
        (tester) async {
          final Finder durationTextFieldFinder =
              find.byKey(const Key('durationTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetName: 'one',
                  dateTimeTitle: 'End date time',
                  topSelMenuPosition: 210.0,
                  nowDateTimeEnglishFormatStr: '2022-08-11 10:00',
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                  nextAddSubtractResultableDuration: null,
                ),
              ),
            ),
          );

          await tester.enterText(durationTextFieldFinder, '24');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('24:00'), findsOneWidget);
          expect(find.text('12-08-2022 10:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationPositiveColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, positiveDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationPositiveColor);
        },
      );
      testWidgets(
        'Adding one digit with - sign duration',
        (tester) async {
          final Finder durationTextFieldFinder =
              find.byKey(const Key('durationTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetName: 'one',
                  dateTimeTitle: 'End date time',
                  topSelMenuPosition: 210.0,
                  nowDateTimeEnglishFormatStr: '2022-08-11 10:00',
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                  nextAddSubtractResultableDuration: null,
                ),
              ),
            ),
          );

          await tester.enterText(durationTextFieldFinder, '-2');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 08:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationNegativeColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, negativeDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationNegativeColor);
        },
      );
      testWidgets(
        'Adding two digits with - signs duration',
        (tester) async {
          final Finder durationTextFieldFinder =
              find.byKey(const Key('durationTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetName: 'one',
                  dateTimeTitle: 'End date time',
                  topSelMenuPosition: 210.0,
                  nowDateTimeEnglishFormatStr: '2022-08-11 10:00',
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                  nextAddSubtractResultableDuration: null,
                ),
              ),
            ),
          );

          await tester.enterText(durationTextFieldFinder, '-24');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('10-08-2022 10:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
          expect(durationTextField.style!.color,
              DurationDateTimeEditor.durationNegativeColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, negativeDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              DurationDateTimeEditor.durationNegativeColor);
        },
      );
    },
  );
  group(
    'DurationDateTimeEditor adding multiple int durations',
    () {
      /// This test validate duration icon and color bug fix
      testWidgets(
        'Positive and negative durations',
        (tester) async {
          final Finder durationSignButtonFinder =
              find.byKey(const Key('durationSignButton'));
          final Finder durationTextFieldFinder =
              find.byKey(const Key('durationTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetName: 'one',
                  dateTimeTitle: 'End date time',
                  topSelMenuPosition: 210.0,
                  nowDateTimeEnglishFormatStr: '2022-08-11 10:00',
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

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);

          // testing the duration text field color
          TextField durationTextField =
              tester.widget(find.byKey(const Key('durationTextField')));
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
          expect(find.text('11-08-2022 08:00'), findsOneWidget);

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
