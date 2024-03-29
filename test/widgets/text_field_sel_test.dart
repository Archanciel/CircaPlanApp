import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  group(
    'TextField testing',
    () {
      TextEditingController controller = TextEditingController();

      testWidgets(
        'Copy text field value to clipboard',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    GestureDetector(
                      child: TextField(
                        key: const Key('textField'),
                        enableInteractiveSelection: true,
                        controller: controller,
                        onSubmitted: (value) async {
                          await Clipboard.setData(ClipboardData(text: value));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          Finder textFieldFinder = find.byKey(const Key('textField'));
          String textFieldValue = DateTime.now().toString();

          await tester.tap(textFieldFinder);
          await tester.enterText(textFieldFinder, textFieldValue);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        },
      );
    },
  );
}
