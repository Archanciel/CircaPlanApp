import 'dart:io';
import 'package:circa_plan/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

Future<void> main() async {
  final Finder nextMonthIcon = find.byWidgetPredicate((Widget w) =>
      w is IconButton && (w.tooltip?.startsWith('Next month') ?? false));
  final Finder previousMonthIcon = find.byWidgetPredicate((Widget w) =>
      w is IconButton && (w.tooltip?.startsWith('Previous month') ?? false));

  Utility.deleteFilesInDirAndSubDirs(kCircadianAppDataTestDir);
  Utility.copyFileToDirectorySync(
      sourceFilePathName:
          '$kCircadianAppDataTestSaveDir${Platform.pathSeparator}circadian_edt.json',
      targetDirectoryPath: kCircadianAppDataTestDir);

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
    },
  );
}

void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
  // print('handleEndDateTimeChange() $endDateTimeEnglishFormatStr');
}

void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
  // print('handleEndDateTimeSelected() $endDateTimeFrenchFormatStr');
}
