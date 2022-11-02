import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/screens/time_calculator.dart';

/// This DurationDateTimeEditor widget unit test tests
/// specifically handling integer duration setting in place of
/// defining HH:mm durations.
Future<void> main() async {
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
  final ScreenNavigTransData screenNavigTransData =
      ScreenNavigTransData(transferDataMap: transferDataMap);

  const IconData positiveDurationIcon = Icons.add;
  const IconData negativeDurationIcon = Icons.remove;

  group(
    'Division test',
    () {
      testWidgets(
        'Greatest divided by smallest',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TimeCalculator(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final Finder firstTimeTextFieldFinder =
              find.byKey(const Key('firstTimeTextField'));
          final Finder secondTimeTextFieldFinder =
              find.byKey(const Key('secondTimeTextField'));
          final Finder resultTextFieldFinder =
              find.byKey(const Key('resultTextField'));
          final Finder divButtonFinder = find.byKey(const Key('divButton'));

          await tester.enterText(firstTimeTextFieldFinder, '30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          TextField firstTimeTextField =
              tester.firstWidget(firstTimeTextFieldFinder);
          TextEditingController firstTimeTextFieldController =
              firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, '00:30:00');

          await tester.enterText(secondTimeTextFieldFinder, '15');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          TextField secondTimeTextField =
              tester.firstWidget(secondTimeTextFieldFinder);
          TextEditingController secondTimeTextFieldController =
              secondTimeTextField.controller!;
          expect(secondTimeTextFieldController.text, '00:15:00');

          await tester.tap(divButtonFinder);
          await tester.pumpAndSettle();

          TextField resultTextField = tester.firstWidget(resultTextFieldFinder);
          TextEditingController resultTextFieldController =
              resultTextField.controller!;
          expect(resultTextFieldController.text, '50.00 %');
        },
      );
      testWidgets(
        'Smallest divided by greatest',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TimeCalculator(
                  transferDataViewModel: transferDataViewModel,
                  screenNavigTransData: screenNavigTransData,
                ),
              ),
            ),
          );

          final Finder firstTimeTextFieldFinder =
              find.byKey(const Key('firstTimeTextField'));
          final Finder secondTimeTextFieldFinder =
              find.byKey(const Key('secondTimeTextField'));
          final Finder resultTextFieldFinder =
              find.byKey(const Key('resultTextField'));
          final Finder divButtonFinder = find.byKey(const Key('divButton'));

          await tester.enterText(firstTimeTextFieldFinder, '15');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          TextField firstTimeTextField =
              tester.firstWidget(firstTimeTextFieldFinder);
          TextEditingController firstTimeTextFieldController =
              firstTimeTextField.controller!;
          expect(firstTimeTextFieldController.text, '00:15:00');

          await tester.enterText(secondTimeTextFieldFinder, '30');

          // typing on Done button
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          TextField secondTimeTextField =
              tester.firstWidget(secondTimeTextFieldFinder);
          TextEditingController secondTimeTextFieldController =
              secondTimeTextField.controller!;
          expect(secondTimeTextFieldController.text, '00:30:00');

          await tester.tap(divButtonFinder);
          await tester.pumpAndSettle();

          TextField resultTextField = tester.firstWidget(resultTextFieldFinder);
          TextEditingController resultTextFieldController =
              resultTextField.controller!;
          expect(resultTextFieldController.text, '50.00 %');
        },
      );
    },
  );
//   group(
//     'Add test',
//     () {
//       testWidgets(
//         "Simulating keyboard typing on Time TextField's",
//         (tester) async {
//           await tester.pumpWidget(
//             MaterialApp(
//               home: Scaffold(
//                 body: TimeCalculator(
//                   transferDataViewModel: transferDataViewModel,
//                   screenNavigTransData: screenNavigTransData,
//                 ),
//               ),
//             ),
//           );

//           final Finder firstTimeTextFieldFinder =
//               find.byKey(const Key('firstTimeTextField'));
//           final Finder secondTimeTextFieldFinder =
//               find.byKey(const Key('secondTimeTextField'));
//           final Finder resultTextFieldFinder =
//               find.byKey(const Key('resultTextField'));
//           final Finder addButtonFinder = find.byKey(const Key('addButton'));

//           TextField firstTimeTextField =
//               tester.firstWidget(firstTimeTextFieldFinder);
//           TextEditingController firstTimeTextFieldController =
//               firstTimeTextField.controller!;

//           // await tester.tap(firstTimeTextFieldFinder);
//           await tester.tapAt(textOffsetToPosition(
//               tester, firstTimeTextFieldController.text.length));
//           await tester.pump();

//           await simulateKeyDownEvent(LogicalKeyboardKey.backspace);
//           // await simulateKeyDownEvent(LogicalKeyboardKey.digit3);
//           await tester.pumpAndSettle();

//           expect(firstTimeTextFieldController.text, '00:03:00'); // not working

//           //   await tester.enterText(secondTimeTextFieldFinder, '15');

//           //   // typing on Done button
//           //   await tester.testTextInput.receiveAction(TextInputAction.done);
//           //   await tester.pumpAndSettle();

//           //   TextField secondTimeTextField =
//           //       tester.firstWidget(secondTimeTextFieldFinder);
//           //   TextEditingController secondTimeTextFieldController =
//           //       secondTimeTextField.controller!;
//           //   expect(secondTimeTextFieldController.text, '00:15:00');

//           //   await tester.tap(addButtonFinder);
//           //   await tester.pumpAndSettle();

//           //   TextField resultTextField = tester.firstWidget(resultTextFieldFinder);
//           //   TextEditingController resultTextFieldController =
//           //       resultTextField.controller!;
//           //   expect(resultTextFieldController.text, '50.00 %');
//         },
//       );
//     },
//   );
}

Offset textOffsetToPosition(WidgetTester tester, int offset) {
  final RenderEditable renderEditable = findRenderEditable(tester);
  final List<TextSelectionPoint> endpoints = globalize(
    renderEditable.getEndpointsForSelection(
      TextSelection.collapsed(offset: offset),
    ),
    renderEditable,
  );
  expect(endpoints.length, 1);
  return endpoints[0].point + const Offset(0.0, -2.0);
}

RenderEditable findRenderEditable(WidgetTester tester) {
  final RenderObject root = tester.renderObject(find.byType(EditableText));
  expect(root, isNotNull);
  RenderEditable? renderEditable = null;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder);
  }

  root.visitChildren(recursiveFinder);
  expect(renderEditable, isNotNull);
  return renderEditable!;
}

List<TextSelectionPoint> globalize(
    Iterable<TextSelectionPoint> points, RenderBox box) {
  return points.map<TextSelectionPoint>((TextSelectionPoint point) {
    return TextSelectionPoint(
      box.localToGlobal(point.point),
      point.direction,
    );
  }).toList();
}
