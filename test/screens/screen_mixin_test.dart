import 'dart:io';
import 'package:test/test.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

const String kCircadianAppDataDir = 'c:\\temp\\CircadianData';

class TestClassWithScreenMixin with ScreenMixin {}

Future<TransferDataViewModel> instanciateTransferDataViewModel({
  bool mustAppDirBeDeleted = false,
}) async {
  String path = kCircadianAppDataDir;
  final Directory directory = Directory(path);
  bool directoryExists = await directory.exists();

  if (mustAppDirBeDeleted) {
    if (directoryExists) {
      TransferDataViewModel.deleteFilesInDir(path);
    }
  }

  if (!directoryExists) {
    await directory.create();
  }

  String transferDataJsonFilePathName =
      '$path${Platform.pathSeparator}circadian.json';
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathName);

  bool jsonFileExists = await File(transferDataJsonFilePathName).exists();

  if (jsonFileExists) {
    transferDataViewModel.loadTransferData();
  }

  return transferDataViewModel;
}

Future<void> main() async {
  final TestClassWithScreenMixin testClassWithSreenMixin =
      TestClassWithScreenMixin();

  final TransferDataViewModel transferDataViewModel =
      await instanciateTransferDataViewModel();

  group(
    'Test ScreenMixin',
    () {
      final Map<String, dynamic> transferDataMapRegular = {};

      transferDataMapRegular['calcSlDurNewDateTimeStr'] = '01-06-2022 23:42';
      transferDataMapRegular['calcSlDurLastWakeUpTimeStr'] = '02-06-2022 02:42';
      transferDataMapRegular['calcSlDurPreviousDateTimeStr'] =
          '03-06-2022 03:42';
      transferDataMapRegular['calcSlDurBeforePreviousDateTimeStr'] =
          '02-06-2022 02:42';
      transferDataMapRegular['calcSlDurCurrSleepDurationStr'] = '04:00';
      transferDataMapRegular['calcSlDurCurrWakeUpDurationStr'] = '00:48';
      transferDataMapRegular['calcSlDurCurrTotalDurationStr'] = '04:48';
      transferDataMapRegular['calcSlDurSleepTimeStrHistory'] = [
        '01-06-2022 23:12',
        '06:00',
      ];
      transferDataMapRegular['calcSlDurWakeUpTimeStrHistory'] = [
        '02-06-2022 02:22',
        '04:00',
      ];
      transferDataMapRegular['addDurStartDateTimeStr'] = '03-06-2022 03:42';

      transferDataMapRegular['firstTimeStr'] = '00:03:45';
      transferDataMapRegular['secondTimeStr'] = '00:00:45';
      transferDataMapRegular['dtDiffEndDateTimeStr'] = '03-06-2022 06:42';
      transferDataMapRegular['dtDiffDurationStr'] = '02:53';

      test(
        'buildSortedAppDateTimeStrList several and double date time str most late first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapRegular,
            mostRecentFirst: false,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '01-06-2022 23:12',
            '01-06-2022 23:42',
            '02-06-2022 02:22',
            '02-06-2022 02:42',
            '03-06-2022 03:42',
            '03-06-2022 06:42',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      test(
        'buildSortedAppDateTimeStrList several and double date time str most recent first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapRegular,
            mostRecentFirst: true,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '03-06-2022 06:42',
            '03-06-2022 03:42',
            '02-06-2022 02:42',
            '02-06-2022 02:22',
            '01-06-2022 23:42',
            '01-06-2022 23:12',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      final Map<String, dynamic> transferDataMapTimeOnly = {};

      transferDataMapTimeOnly['calcSlDurCurrSleepDurationStr'] = '04:00';
      transferDataMapTimeOnly['calcSlDurCurrWakeUpDurationStr'] = '00:48';
      transferDataMapTimeOnly['calcSlDurCurrTotalDurationStr'] = '04:48';
      transferDataMapTimeOnly['firstTimeStr'] = '00:03:45';
      transferDataMapTimeOnly['secondTimeStr'] = '00:00:45';
      transferDataMapTimeOnly['calcSlDurSleepTimeStrHistory'] = [
        '04:00',
      ];
      transferDataMapTimeOnly['calcSlDurWakeUpTimeStrHistory'] = [
        '04:00',
      ];

      test(
        'buildSortedAppDateTimeStrList no date time str most late first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapTimeOnly,
            mostRecentFirst: false,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      test(
        'buildSortedAppDateTimeStrList no date time str most recent first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapTimeOnly,
            mostRecentFirst: true,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      final Map<String, dynamic> transferDataMapEmpty = {};

      test(
        'buildSortedAppDateTimeStrList map empty most late first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapEmpty,
            mostRecentFirst: false,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      test(
        'buildSortedAppDateTimeStrList map empty most recent first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapEmpty,
            mostRecentFirst: true,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      final Map<String, dynamic> transferDataMapOneDateTime = {};

      transferDataMapOneDateTime['calcSlDurNewDateTimeStr'] =
          '01-06-2022 23:42';

      test(
        'buildSortedAppDateTimeStrList one date time str most late first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapOneDateTime,
            mostRecentFirst: false,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '01-06-2022 23:42',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      test(
        'buildSortedAppDateTimeStrList one date time str most recent first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapOneDateTime,
            mostRecentFirst: true,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '01-06-2022 23:42',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      final Map<String, dynamic> transferDataMapInvalidFormat = {};

      // entry with invalid date format
      transferDataMapInvalidFormat['calcSlDurNewDateTimeStr'] =
          '01/06/2022 23:42';

      // entry with invalid date format
      transferDataMapInvalidFormat['calcSlDurLastWakeUpTimeStr'] =
          '02-06 02:42';

      // entry with invalid date format
      transferDataMapInvalidFormat['calcSlDurPreviousDateTimeStr'] =
          '06-2022 03:42';

      // entry with invalid date format
      transferDataMapInvalidFormat['calcSlDurBeforePreviousDateTimeStr'] =
          '02-06 02:42';
      transferDataMapInvalidFormat['calcSlDurCurrSleepDurationStr'] = '04:00';
      transferDataMapInvalidFormat['calcSlDurCurrWakeUpDurationStr'] = '00:48';
      transferDataMapInvalidFormat['calcSlDurCurrTotalDurationStr'] = '04:48';
      transferDataMapInvalidFormat['calcSlDurSleepTimeStrHistory'] = [
        '01-06-2022 23:42',
        '04:00',
      ];
      transferDataMapInvalidFormat['calcSlDurWakeUpTimeStrHistory'] = [
        '02-06-2022 21-42', // invalid format in histo list. Will be ignored !
        '04:00',
      ];
      transferDataMapInvalidFormat['addDurStartDateTimeStr'] =
          '03-06-2022 03:42';

      transferDataMapInvalidFormat['firstTimeStr'] = '00:03:45';
      transferDataMapInvalidFormat['secondTimeStr'] = '00:00:45';
      transferDataMapInvalidFormat['dtDiffEndDateTimeStr'] = '03-06-2022 06:42';

      // entry with invalid time format
      transferDataMapInvalidFormat['dtDiffDurationStr'] = '02:53';

      // entry with invalid time format
      transferDataMapInvalidFormat['dtDiffStartDateTimeStr'] =
          '04-06-2022 06-22';

      test(
        'buildSortedAppDateTimeStrList several and double date time str most late first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapInvalidFormat,
            mostRecentFirst: false,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '01-06-2022 23:42',
            '03-06-2022 03:42',
            '03-06-2022 06:42',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      test(
        'buildSortedAppDateTimeStrList several and double date time str most recent first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapInvalidFormat,
            mostRecentFirst: true,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '03-06-2022 06:42',
            '03-06-2022 03:42',
            '01-06-2022 23:42',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      final Map<String, dynamic> transferDataMapEnglishAndFrenchDateTime = {};

      transferDataMapEnglishAndFrenchDateTime['calcSlDurNewDateTimeStr'] =
          '01-06-2022 23:42';
      transferDataMapEnglishAndFrenchDateTime['dtDiffEndDateTimeStr'] =
          '2022-06-11 22:30';
      transferDataMapEnglishAndFrenchDateTime['calcSlDurPreviousDateTimeStr'] =
          '02-06-2022 23:42';
      transferDataMapEnglishAndFrenchDateTime['dtDiffStartDateTimeStr'] =
          '2022-06-10 00:30';

      test(
        'buildSortedAppDateTimeStrList english (DateTimePicker field) and french format date time str most late first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapEnglishAndFrenchDateTime,
            mostRecentFirst: false,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '01-06-2022 23:42',
            '02-06-2022 23:42',
            '10-06-2022 00:30',
            '11-06-2022 22:30',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      test(
        'buildSortedAppDateTimeStrList english (DateTimePicker field) and french format date time str most recent first',
        () {
          List<String> actualDateTimeStrLst =
              testClassWithSreenMixin.buildSortedAppDateTimeStrList(
            transferDataMap: transferDataMapEnglishAndFrenchDateTime,
            mostRecentFirst: true,
            transferDataViewModel: transferDataViewModel,
          );
          List<String> expectedDateTimeStrLst = [
            '11-06-2022 22:30',
            '10-06-2022 00:30',
            '02-06-2022 23:42',
            '01-06-2022 23:42',
          ];

          expect(actualDateTimeStrLst, expectedDateTimeStrLst);
        },
      );

      const List<String> dateTimeFrenchYYYYStrLst = [
        '14-12-2022 13:35',
        '4-2-2022 3:05',
        '04-02-2022 03:05',
        '4-2-2022 3:00',
        '4-2-2022 3:0',
        'a4-2-2022 3:05',
        '14-2-2022 3:u5',
        '14-2-2022 3:5',
        '14/2/2022 3:50',
        '14-2-2022 3-50',
        '4-2-22 3:05',
        'a4-2-22 3:05',
        '14-2-22 3:u5',
        '14-2-22 3:5',
      ];

      test(
        'isDateTimeStrValid french format date time str',
        () {
          List<bool> actualValidationResultLst = [];

          for (String str in dateTimeFrenchYYYYStrLst) {
            actualValidationResultLst
                .add(testClassWithSreenMixin.isDateTimeStrValid(str));
          }
          List<bool> expectedValidationResultLst = [
            true, // '14-12-2022 13:35',
            true, // '4-2-2022 3:05',
            true, // '04-02-2022 03:05',
            true, // '4-2-2022 3:00',
            false, // '4-2-2022 3:0',
            false, // 'a4-2-2022 3:05',
            false, // '14-2-2022 3:u5',
            false, // '14-2-2022 3:5',
            false, // '14/2/2022 3:50',
            false, // '14-2-2022 3-50',
            false, // '4-2-22 3:05',
            false, // 'a4-2-22 3:05',
            false, // '14-2-22 3:u5',
            false, // '14-2-22 3:5',
          ];

          expect(actualValidationResultLst, expectedValidationResultLst);
        },
      );

      const List<String> dateTimeEnglishYYYYStrLst = [
        '2022-4-12 13:35',
        '2022-4-2 3:05',
        '2022-04-02 03:05',
        '2022-4-2 3:00',
        '2022-4-2 3:0',
        '2022-a4-2 3:05',
        '2022-04-02 3:u5',
        '2022-04-20 3:5',
        '2022/04/02 3:50',
        '2022-04-02 3-50',
        '22-04-02 3:05',
        '22-a4-2 3:05',
        '22-4-2 3:u5',
        '22-4-2 3:5',
      ];

      test(
        'isDateTimeStrValid english format date time str',
        () {
          List<bool> actualValidationResultLst = [];

          for (String str in dateTimeEnglishYYYYStrLst) {
            actualValidationResultLst
                .add(testClassWithSreenMixin.isDateTimeStrValid(str));
          }
          List<bool> expectedValidationResultLst = [
            true, // '2022-4-12 13:35',
            true, // '2022-4-2 3:05',
            true, // '2022-04-02 03:05',
            true, // '2022-4-2 3:00',
            false, // '2022-4-2 3:0',
            false, // '2022-a4-2 3:05',
            false, // '2022-04-02 3:u5',
            false, // '2022-04-20 3:5',
            false, // '2022/04/02 3:50',
            false, // '2022-04-02 3-50',
            false, // '22-04-02 3:05',
            false, // '22-a4-2 3:05',
            false, // '22-4-2 3:u5',
            false, // '22-4-2 3:5',
          ];

          expect(actualValidationResultLst, expectedValidationResultLst);
        },
      );
    },
  );
}
