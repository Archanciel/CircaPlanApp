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
  await transferDataViewModel.loadTransferData();

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
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );

          await tester.enterText(
              edpDurationPercentComputedValueTextField, '12:00');
          await tester.enterText(edpDurationPercentTextField, '50 %');
          await tester.tap(edpDelButton);

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextField);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '');
        },
      );
      testWidgets(
        'Computing % duration',
        (tester) async {
          final edpDelButton = find.byKey(const Key('edpDelButton'));
          final edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final edpDurationPercentTextField =
              find.byKey(const Key('edpDurationPercentTextField'));

          final EditableDurationPercent editableDurationPercentWidget =
              EditableDurationPercent(
            dateTimeTitle: 'Duration %',
            durationStr: '13:00',
            topSelMenuPosition: 343.0,
            transferDataViewModel: transferDataViewModel,
            transferDataMap: transferDataMap,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: editableDurationPercentWidget,
              ),
            ),
          );

          editableDurationPercentWidget.stateInstance.handleSelectedPercentStr('70 %');

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '9:06');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextField);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '70 %');
        },
      );
      testWidgets(
        'Change duration',
        (tester) async {
          final edpDelButton = find.byKey(const Key('edpDelButton'));
          final edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final edpDurationPercentTextField =
              find.byKey(const Key('edpDurationPercentTextField'));

          final EditableDurationPercent editableDurationPercentWidget =
              EditableDurationPercent(
            dateTimeTitle: 'Duration %',
            durationStr: '13:00',
            topSelMenuPosition: 343.0,
            transferDataViewModel: transferDataViewModel,
            transferDataMap: transferDataMap,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: editableDurationPercentWidget,
              ),
            ),
          );

          editableDurationPercentWidget.stateInstance.handleSelectedPercentStr('70 %');

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '9:06');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextField);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '70 %');

          editableDurationPercentWidget.setDurationStr('24:00');

          expect(durationPercentComputedValueTextFieldController.text, '16:48');
        },
      );
      testWidgets(
        'Clicking on Sel button',
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
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );

          await tester.enterText(
              edpDurationPercentComputedValueTextField, '12:00');
          await tester.enterText(edpDurationPercentTextField, '50 %');
          await tester.tap(edpDelButton);

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextField);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '');
        },
      );
    },
  );
}
