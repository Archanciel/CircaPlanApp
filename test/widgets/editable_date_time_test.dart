import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

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
                  dateTimePickerController: dateTimePickerController,
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
          String widgetPrefixOne = 'first';

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
                  widgetPrefix: widgetPrefixOne,
                ),
              ),
            ),
          );

          final edtNowButton =
              find.byKey(const Key('editableDateTimeNowButton'));
          const String selectedDateTimeStr = '12-08-2022 16:00';
          dateTimePickerController.text = selectedDateTimeStr;

          await tester.tap(edtNowButton);
          await tester.pumpAndSettle();

          String nowStr = frenchDateTimeFormat.format(DateTime.now());
          TextField text = tester.widget(
              find.byKey(Key('${widgetPrefixOne}EditableDateTimeTextField')));
          expect(text.controller!.text, nowStr);
        },
      );
      testWidgets(
        'Clicking on Sel button',
        (tester) async {
          String widgetPrefixOne = 'first';

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
                  widgetPrefix: widgetPrefixOne,
                ),
              ),
            ),
          );

          final edtSelButton =
              find.byKey(const Key('editableDateTimeSelButton'));

          await tester.tap(edtSelButton);
          await tester.pumpAndSettle();

          const String selectedDateTimeStr = '12-07-2022 16:00';
          await tester.tap(find.text(selectedDateTimeStr));
          await tester.pumpAndSettle();

          TextField textField = tester.widget(
              find.byKey(Key('${widgetPrefixOne}EditableDateTimeTextField')));
          expect(textField.controller!.text, selectedDateTimeStr);
        },
      );
    },
  );
}

void handleEndDateTimeChange(
  String endDateTimeEnglishFormatStr,
  bool notUsed, // parm required since this function
  //               is passed as a callback parm)
) {
  // print('handleEndDateTimeChange() $endDateTimeEnglishFormatStr');
}

void handleEndDateTimeSelected(
  String endDateTimeFrenchFormatStr,
  bool notUsed, // parm required since this function
  //               is passed as a callback parm)
) {
  // print('handleEndDateTimeSelected() $endDateTimeFrenchFormatStr');
}
