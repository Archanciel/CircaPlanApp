import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/widgets/flutter_editable_date_time.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

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

  // accessing to a unit test specific json file is necessary
  // since the 'Clicking on Del button' unit test updates
  // the json file with a "dateTimeDurationPercentStr": ""
  // instead of "70 %", which then prevents running
  // utility_test.dart separately.
  String transferDataJsonFilePathName =
      '${directory.path}${pathSeparator}circadian_edt.json';
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathName);
  transferDataViewModel.transferDataMap = transferDataMap;
  await transferDataViewModel.loadTransferData();

  group(
    'EditableDateTime widget testing',
    () {
      testWidgets(
        'testing default date time set to now',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDateTime(
                  dateTimeTitle: 'Start date time',
                  topSelMenuPosition: 120,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataViewModel.getTransferDataMap()!,
                  handleDateTimeModificationFunction: handleEndDateTimeChange,
                  handleSelectedDateTimeStrFunction: handleEndDateTimeSelected,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          String nowStr = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now());
          expect(find.text(nowStr), findsOneWidget);
        },
      );
      testWidgets(
        'Clicking on Now button',
        (tester) async {
          final edtNowButton =
              find.byKey(const Key('editableDateTimeNowButton'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDateTime(
                  dateTimeTitle: 'Start date time',
                  topSelMenuPosition: 120,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataViewModel.getTransferDataMap()!,
                  handleDateTimeModificationFunction: handleEndDateTimeChange,
                  handleSelectedDateTimeStrFunction: handleEndDateTimeSelected,
                ),
              ),
            ),
          );

          await tester.tap(edtNowButton);
          await tester.pumpAndSettle();

          String nowStr = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now());
          Text text =
              tester.widget(find.byKey(const Key('editableDateTimeText')));
          expect(text.data, nowStr);
        },
      );
      testWidgets(
        'Clicking on Sel button',
        (tester) async {
          final edtSelButton =
              find.byKey(const Key('editableDateTimeSelButton'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDateTime(
                  dateTimeTitle: 'Start date time',
                  topSelMenuPosition: 120,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataViewModel.getTransferDataMap()!,
                  handleDateTimeModificationFunction: handleEndDateTimeChange,
                  handleSelectedDateTimeStrFunction: handleEndDateTimeSelected,
                ),
              ),
            ),
          );

          await tester.tap(edtSelButton);
          await tester.pumpAndSettle();
          String selectedDateTimeStr = '12-07-2022 16:00';
          await tester.tap(find.text(selectedDateTimeStr));
          await tester.pumpAndSettle();

          Text text =
              tester.widget(find.byKey(const Key('editableDateTimeText')));
          expect(text.data, selectedDateTimeStr);
        },
      );
      testWidgets(
        'Clicking on Sel, then Now button',
        (tester) async {
          final edtNowButton =
              find.byKey(const Key('editableDateTimeNowButton'));
          final edtSelButton =
              find.byKey(const Key('editableDateTimeSelButton'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDateTime(
                  dateTimeTitle: 'Start date time',
                  topSelMenuPosition: 120,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataViewModel.getTransferDataMap()!,
                  handleDateTimeModificationFunction: handleEndDateTimeChange,
                  handleSelectedDateTimeStrFunction: handleEndDateTimeSelected,
                ),
              ),
            ),
          );

          await tester.tap(edtSelButton);
          await tester.pumpAndSettle();
          String selectedDateTimeStr = '12-07-2022 16:00';
          await tester.tap(find.text(selectedDateTimeStr));
          await tester.pumpAndSettle();

          Text text =
              tester.widget(find.byKey(const Key('editableDateTimeText')));
          expect(text.data, selectedDateTimeStr);

          await tester.tap(edtNowButton);
          await tester.pumpAndSettle();

          text = tester.widget(find.byKey(const Key('editableDateTimeText')));
          String nowStr = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now());
          expect(text.data, nowStr);
        },
      );
    },
  );
}

void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
  // print('handleEndDateTimeChange() $endDateTimeEnglishFormatStr');
}

void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
  // print('handleEndDateTimeSelected() $endDateTimeFrenchFormatStr');
}
