import 'dart:io';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_duration_percent.dart';
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

  group(
    'EditableDurationPercent widget testing',
    () {
      testWidgets(
        'Clicking on Del button',
        (tester) async {
          final edpDelButton = find.byKey(const Key('edpDelButton'));
          final edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final edpDurationPercentTextField =
              find.byKey(const Key('edpDurationPercentTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDurationPercent(
                  dateTimeTitle: 'Duration %',
                  durationStr: '24:00',
                  addTimeTextFieldController: TextEditingController(),
                  addTimeDialogController: TextEditingController(),
                  addPosOrNegTimeToCurrentDurationFunction:
                      () {},
                  deleteAddedTimeDurationFunction: () {},
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );

          await tester.enterText(
              edpDurationPercentComputedValueTextField, '12:00');
          await tester.enterText(
              edpDurationPercentTextField, '50 %');
          await tester.tap(edpDelButton);

          await tester.pumpAndSettle();

          expect(find.text(''), findsNWidgets(2));
        },
      );
      testWidgets(
        'Subtracting valid duration',
        (tester) async {
          final durationSignButton =
              find.byKey(const Key('durationSignButton'));
          final durationTextField = find.byKey(const Key('durationTextField'));

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

          await tester.enterText(durationTextField, '02:30');
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('02:30'), findsOneWidget);
          expect(find.text('11-08-2022 07:30'), findsOneWidget);
        },
      );
    },
  );
}
