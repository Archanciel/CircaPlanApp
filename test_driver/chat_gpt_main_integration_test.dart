// test_driver/app_test.dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// Running the test in terminal:
/// flutter drive --target=test_driver/chat_gpt_main_integration.dart
/// 
/// WARNING: the tested app must not be already running before running
/// the test !
void main() {
  group('App Navigation Test', () {
    final navBarAddDurationToDateTimePageThree =
        find.byValueKey('navBarAddDurationToDateTimePageThree');

    FlutterDriver? driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });

    test('Switch to Add Duration To Date Time page three', () async {
      // Wait for the element to be available for interaction
      await driver!.waitFor(navBarAddDurationToDateTimePageThree);

      // Tap on the element responsible for navigation
      await driver!.tap(navBarAddDurationToDateTimePageThree);

      // Optionally, you can assert whether you are on the new page.
      // For example, you might look for a widget that is unique to that page.
      final someElementInNewPageFinder = find.byValueKey('addDurToDateTimeStartDateTime');
      await driver!.waitFor(someElementInNewPageFinder);
    });

    test('Switch to second page', () async {
      // Finder for the second item in the navigation bar
      final secondPageNavBarItemFinder = find.byValueKey('navBarWakeUpDurationPageTwo');

      // Wait for the navigation bar item to be available for interaction
      await driver!.waitFor(secondPageNavBarItemFinder);

      // Tap on the navigation bar item
      await driver!.tap(secondPageNavBarItemFinder);

      // Optionally, you can assert whether you are on the new page.
      // For example, you might look for a widget that is unique to that page.
      final someElementInNewPageFinder = find.byValueKey('wakeUpDurationStartDateTimeKey');
      await driver!.waitFor(someElementInNewPageFinder);
    });
  });
}
