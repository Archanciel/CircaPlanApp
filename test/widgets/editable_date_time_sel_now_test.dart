import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

Future<void> main() async {
  final Finder nextMonthIcon = find.byWidgetPredicate((Widget w) =>
      w is IconButton && (w.tooltip?.startsWith('Next month') ?? false));
  final Finder previousMonthIcon = find.byWidgetPredicate((Widget w) =>
      w is IconButton && (w.tooltip?.startsWith('Previous month') ?? false));

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
      '${directory.path}${pathSeparator}circadian_edt.json';
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathName);
  transferDataViewModel.transferDataMap = transferDataMap;
  await transferDataViewModel.loadTransferData();

  TextEditingController dateTimePickerController = TextEditingController();

  group(
    'EditableDateTime widget testing',
    () {
      testWidgets(
        'Clicking on Sel, then Now button', // fails if located in
        //              flutter_editable_date_time_test.dart file !
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
                  dateTimePickerController: dateTimePickerController,
                ),
              ),
            ),
          );

          await tester.tap(edtSelButton);
          await tester.pumpAndSettle();

          String selectedDateTimeStr = '12-07-2022 16:00';
          await tester.tap(find.text(selectedDateTimeStr));
          await tester.pumpAndSettle();

          TextField textField =
              tester.widget(find.byKey(const Key('editableDateTimeTextField')));
          expect(textField.controller!.text, selectedDateTimeStr);

          await tester.tap(edtNowButton);
          await tester.pumpAndSettle();

          String nowStr = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now());
          expect(textField.controller!.text, nowStr);
        },
      );
      testWidgets(
        'Setting date day only',
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
                  dateTimePickerController: dateTimePickerController,
                ),
              ),
            ),
          );

          await tester.tap(edtSelButton);
          await tester.pumpAndSettle();

          String selectedDateTimeStr = '12-07-2022 16:00';
          await tester.tap(find.text(selectedDateTimeStr));
          await tester.pumpAndSettle();

          TextField textField =
              tester.widget(find.byKey(const Key('editableDateTimeTextField')));
          expect(textField.controller!.text, selectedDateTimeStr);

          await tester.tap(find.byKey(const Key('editableDateTimeTextField')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('14')); // set day
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('OK'));
          expect(textField.controller!.text, '14-07-2022 16:00');
        },
      );
      testWidgets(
        'Selecting previous date month and setting day only',
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
                  dateTimePickerController: dateTimePickerController,
                ),
              ),
            ),
          );

          dateTimePickerController.text = '20-09-2022 12:45';

          TextField textField =
              tester.widget(find.byKey(const Key('editableDateTimeTextField')));

          expect(textField.controller!.text, '20-09-2022 12:45');

          await tester.tap(find.byKey(const Key('editableDateTimeTextField')));
          await tester.pumpAndSettle();
          await tester.tap(previousMonthIcon);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          await tester.tap(find.text('6')); // set day
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('OK'));

          expect(textField.controller!.text, '06-08-2022 12:45');
        },
      );
      testWidgets(
        'Selecting next date month and setting day only',
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
                  dateTimePickerController: dateTimePickerController,
                ),
              ),
            ),
          );

          dateTimePickerController.text = '20-09-2022 12:45';

          TextField textField =
              tester.widget(find.byKey(const Key('editableDateTimeTextField')));

          expect(textField.controller!.text, '20-09-2022 12:45');

          await tester.tap(find.byKey(const Key('editableDateTimeTextField')));
          await tester.pumpAndSettle();
          await tester.tap(nextMonthIcon);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          await tester.tap(find.text('6')); // set day
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('OK'));

          expect(textField.controller!.text, '06-10-2022 12:45');
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
