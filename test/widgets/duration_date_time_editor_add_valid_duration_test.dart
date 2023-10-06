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

  group('DurationDateTimeEditor adding valid duration', () {
    testWidgets(
      'Adding valid duration',
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

        final Finder durationTextFieldFinder = find
            .byKey(const Key('${widgetPrefixOne}ManuallySelectableTextField'));
        final Finder editableDateTimeTextFieldFinder = find
            .byKey(const Key('${widgetPrefixOne}EditableDateTimeTextField'));

        await tester.enterText(durationTextFieldFinder, '02:30');

        // typing on Done button
        await tester.testTextInput.receiveAction(TextInputAction.done);

        await tester.pumpAndSettle();

        expect(find.text('02:30'), findsOneWidget);
        final TextField editableDateTimeTextField =
            tester.widget(editableDateTimeTextFieldFinder);
        expect(editableDateTimeTextField.controller!.text, '11-08-2022 12:30');

        // testing the duration text field color
        final TextField durationTextField = tester.widget(find
            .byKey(const Key('${widgetPrefixOne}ManuallySelectableTextField')));
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
  });
}
