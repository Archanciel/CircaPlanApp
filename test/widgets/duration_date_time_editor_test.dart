import 'dart:io';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/duration_date_time_editor.dart';

/// This DurationDateTimeEditor widget unit test tests
/// specifically handling integer duration setting in place of
/// defining HH:mm durations.
Future<void> main() async {
  // files in this local test dir are stored in
  // project test_data dir updated
  // on GitHub
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

  group(
    'DurationDateTimeEditor adding one int duration',
    () {
      testWidgets(
        'Adding one digit duration',
        (tester) async {
          const String widgetPrefixOne = 'one';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetPrefix: widgetPrefixOne,
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

          final Finder durationTextFieldFinder = find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField'));

          await tester.enterText(durationTextFieldFinder, '2');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField = tester.widget(find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField')));
          expect(durationTextField.style!.color,
              ScreenMixin.durationPositiveColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, positiveDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              ScreenMixin.durationPositiveColor);
        },
      );
      testWidgets(
        'Adding two digits duration',
        (tester) async {
          const String widgetPrefixOne = 'one';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetPrefix: widgetPrefixOne,
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

          final Finder durationTextFieldFinder = find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField'));

          await tester.enterText(durationTextFieldFinder, '24');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('24:00'), findsOneWidget);
          expect(find.text('12-08-2022 10:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField = tester.widget(find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField')));
          expect(durationTextField.style!.color,
              ScreenMixin.durationPositiveColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, positiveDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              ScreenMixin.durationPositiveColor);
        },
      );
      testWidgets(
        'Adding one digit with - sign duration',
        (tester) async {
          const String widgetPrefixOne = 'one';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetPrefix: widgetPrefixOne,
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

          final Finder durationTextFieldFinder = find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField'));

          await tester.enterText(durationTextFieldFinder, '-2');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 08:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField = tester.widget(find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField')));
          expect(durationTextField.style!.color,
              ScreenMixin.durationNegativeColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, negativeDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              ScreenMixin.durationNegativeColor);
        },
      );
      testWidgets(
        'Adding two digits with - signs duration',
        (tester) async {
          const String widgetPrefixOne = 'one';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetPrefix: widgetPrefixOne,
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

          final Finder durationTextFieldFinder = find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField'));

          await tester.enterText(durationTextFieldFinder, '-24');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('10-08-2022 10:00'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField = tester.widget(find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField')));
          expect(durationTextField.style!.color,
              ScreenMixin.durationNegativeColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, negativeDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              ScreenMixin.durationNegativeColor);
        },
      );
      testWidgets(
        'Subtracting valid duration',
        (tester) async {
          const String widgetPrefixOne = 'one';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DurationDateTimeEditor(
                  widgetPrefix: widgetPrefixOne,
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

          final Finder durationTextFieldFinder = find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField'));

          await tester.enterText(durationTextFieldFinder, '-2:30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('2:30'), findsOneWidget);
          expect(find.text('11-08-2022 07:30'), findsOneWidget);

          // testing the duration text field color
          final TextField durationTextField = tester.widget(find.byKey(
              const Key('${widgetPrefixOne}ManuallySelectableTextField')));
          expect(durationTextField.style!.color,
              ScreenMixin.durationNegativeColor);

          // testing the duration sign button icon and color
          final dynamic textButtonWithIconWidget = tester.widget(
              find.byWidgetPredicate((Widget widget) =>
                  '${widget.runtimeType}' == '_TextButtonWithIconChild'));
          expect(textButtonWithIconWidget.icon.icon, negativeDurationIcon);
          expect(textButtonWithIconWidget.icon.color,
              ScreenMixin.durationNegativeColor);
        },
      );
    },
  );
}
