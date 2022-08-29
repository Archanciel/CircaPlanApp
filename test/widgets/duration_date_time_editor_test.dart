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

  group(
    'DurationDateTimeEditor widget testing',
    () {
      testWidgets(
        'Adding valid duration',
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
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('02:30'), findsOneWidget);
          expect(find.text('11-08-2022 12:30'), findsOneWidget);
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
