import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_duration_percent.dart';

Future<void> main() async {
  String path = kCircadianAppDataTestDir;
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
    'EditableDurationPercent widget testing',
    () {
      testWidgets(
        'Clicking on Del button',
        (tester) async {
          final Finder edpDelButtonFinder =
              find.byKey(const Key('edpDelButton'));
          final Finder edpDurationPercentComputedValueTextFieldFinder =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDurationPercent(
                  dateTimeTitle: 'Duration %',
                  transferDataMapPercentKey: 'dtDurationPercentStr',
                  durationStr: '24:00',
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );

          await tester.enterText(
              edpDurationPercentComputedValueTextFieldFinder, '12:00');
          await tester.enterText(edpDurationPercentTextFieldFinder, '50 %');
          await tester.tap(edpDelButtonFinder);

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField = tester
              .firstWidget(edpDurationPercentComputedValueTextFieldFinder);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '');
        },
      );
      testWidgets(
        'Computing % duration',
        (tester) async {
          final Finder edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          final EditableDurationPercent editableDurationPercentWidget =
              EditableDurationPercent(
            dateTimeTitle: 'Duration %',
            transferDataMapPercentKey: 'dtDurationPercentStr',
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

          editableDurationPercentWidget.stateInstance
              .handleSelectedPercentStr('70 %');

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '9:06');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '70 %');
        },
      );
      testWidgets(
        'Change duration',
        (tester) async {
          final Finder edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          final EditableDurationPercent editableDurationPercentWidget =
              EditableDurationPercent(
            dateTimeTitle: 'Duration %',
            transferDataMapPercentKey: 'dtDurationPercentStr',
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

          editableDurationPercentWidget.stateInstance
              .handleSelectedPercentStr('70 %');

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '9:06');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
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
          final edpSelButton = find.byKey(const Key('edpSelButton'));
          final Finder edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDurationPercent(
                  dateTimeTitle: 'Duration %',
                  transferDataMapPercentKey: 'dtDurationPercentStr',
                  durationStr: '15:00',
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );

          await tester.tap(edpSelButton);
          await tester.pumpAndSettle();
          await tester.tap(find.text('60 %'));
          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '9:00');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '60 %');

          await tester.tap(edpSelButton);
          await tester.pumpAndSettle();
          await tester.tap(find.text('70 %'));
          await tester.pumpAndSettle();

          expect(durationPercentComputedValueTextFieldController.text, '10:30');
          expect(durationPercentTextFieldController.text, '70 %');
        },
      );
      testWidgets(
        'Entering double percent value',
        (tester) async {
          final Finder edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDurationPercent(
                  dateTimeTitle: 'Duration %',
                  transferDataMapPercentKey: 'dtDurationPercentStr',
                  durationStr: '15:00',
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );
          // await tester.enterText(
          //     tester.firstWidget(edpDurationPercentTextFieldFinder), '73.2');

          await tester.enterText(edpDurationPercentTextFieldFinder, '73.2');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '10:58');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '73.2 %');
        },
      );
      testWidgets(
        'Entering empty percent value',
        (tester) async {
          final Finder edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDurationPercent(
                  dateTimeTitle: 'Duration %',
                  transferDataMapPercentKey: 'dtDurationPercentStr',
                  durationStr: '15:00',
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );

          await tester.enterText(edpDurationPercentTextFieldFinder, '');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '0:00');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '0 %');
        },
      );
      testWidgets(
        'Entering invalid percent value no % symbol',
        (tester) async {
          final Finder edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDurationPercent(
                  dateTimeTitle: 'Duration %',
                  transferDataMapPercentKey: 'dtDurationPercentStr',
                  durationStr: '15:00',
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );
          // await tester.enterText(
          //     tester.firstWidget(edpDurationPercentTextFieldFinder), '73.2');

          await tester.enterText(edpDurationPercentTextFieldFinder, 'iiii');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '0:00');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '0 %');
        },
      );
      testWidgets(
        'Entering invalid percent value with % symbol',
        (tester) async {
          final Finder edpDurationPercentComputedValueTextField =
              find.byKey(const Key('edpDurationPercentComputedValueTextField'));
          final Finder edpDurationPercentTextFieldFinder =
              find.byKey(const Key('edpDurationPercentTextField'));

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EditableDurationPercent(
                  dateTimeTitle: 'Duration %',
                  transferDataMapPercentKey: 'dtDurationPercentStr',
                  durationStr: '15:00',
                  topSelMenuPosition: 343.0,
                  transferDataViewModel: transferDataViewModel,
                  transferDataMap: transferDataMap,
                ),
              ),
            ),
          );
          // await tester.enterText(
          //     tester.firstWidget(edpDurationPercentTextFieldFinder), '73.2');

          await tester.enterText(edpDurationPercentTextFieldFinder, 'iiii %');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);

          await tester.pumpAndSettle();

          TextField durationPercentComputedValueTextField =
              tester.firstWidget(edpDurationPercentComputedValueTextField);
          TextEditingController
              durationPercentComputedValueTextFieldController =
              durationPercentComputedValueTextField.controller!;
          expect(durationPercentComputedValueTextFieldController.text, '0:00');

          TextField durationPercentTextField =
              tester.firstWidget(edpDurationPercentTextFieldFinder);
          TextEditingController durationPercentTextFieldController =
              durationPercentTextField.controller!;
          expect(durationPercentTextFieldController.text, '0 %');
        },
      );
    },
  );
}
