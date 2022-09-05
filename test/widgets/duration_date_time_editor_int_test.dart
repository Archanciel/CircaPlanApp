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

  group(
    'DurationDateTimeEditor int duration widget testing',
    () {
      testWidgets(
        'Adding one digit duration',
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

          await tester.enterText(durationTextField, '2');
          await tester.tap(durationSignButton);
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);
        },
      );
      testWidgets(
        'Adding two digits duration',
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

          await tester.enterText(durationTextField, '24');
          await tester.tap(durationSignButton);
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('24:00'), findsOneWidget);
          expect(find.text('12-08-2022 10:00'), findsOneWidget);
        },
      );
      testWidgets(
        'Adding one digit with - sign duration',
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

          await tester.enterText(durationTextField, '-2');
          await tester.tap(durationSignButton);
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);
        },
      );
      testWidgets(
        'Adding one digit with + sign duration',
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

          await tester.enterText(durationTextField, '+2');
          await tester.tap(durationSignButton);
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);
        },
      );
      testWidgets(
        'Adding one digit with -- signs duration',
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

          await tester.enterText(durationTextField, '--2');
          await tester.tap(durationSignButton);
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);
        },
      );
      testWidgets(
        'Adding one digit with +- signduration',
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

          await tester.enterText(durationTextField, '+-2');
          await tester.tap(durationSignButton);
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('2:00'), findsOneWidget);
          expect(find.text('11-08-2022 12:00'), findsOneWidget);
        },
      );
      testWidgets(
        'Adding two digit with ++- signs duration',
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

          await tester.enterText(durationTextField, '++-48');
          await tester.tap(durationSignButton);
          await tester.tap(durationSignButton);

          await tester.pumpAndSettle();

          expect(find.text('48:00'), findsOneWidget);
          expect(find.text('13-08-2022 10:00'), findsOneWidget);
        },
      );
    },
  );
}
