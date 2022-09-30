import 'dart:io';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:circa_plan/widgets/duration_date_time_editor.dart';

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
    'DurationDateTimeEditor widget testing',
    () {
      testWidgets(
        'Adding valid duration',
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

          await tester.enterText(durationTextFieldFinder, '02:30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('02:30'), findsOneWidget);
          expect(find.text('11-08-2022 12:30'), findsOneWidget);

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
        'Subtracting valid duration',
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

          await tester.enterText(durationTextFieldFinder, '-2:30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          expect(find.text('2:30'), findsOneWidget);
          expect(find.text('11-08-2022 07:30'), findsOneWidget);

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
}
