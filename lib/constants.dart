import 'package:intl/intl.dart';

/// AddDurationToDateTime screen enum
enum DurationIconType {
  add,
  subtract,
}

/// CalculateSleepDuration screen enum
enum Status {
  wakeUp,
  sleep,
}

/// Enum used by GestureDetector.onDoubleTap enclosing TextField's
enum ClipboardLastAction {
  copy,
  paste,
}

const String kApplicationName = "Circadian Calculator";
const String kApplicationVersion = '2.9';
const String kCircadianAppDir = '/storage/emulated/0/Download/CircadianData';
const String kCircadianAppDirWindows =
    "C:\\Users\\Jean-Pierre\\Downloads\\Circadian";
const String kCircadianAppTestDirWindows =
    "D:\\Development\\Flutter\\circa_plan\\test\\data";
// Tests are run on Windows only. Files in this local test dir are stored in project test_data dir updated
// on GitHub

// files in this local test dir are stored in project test_data dir updated
// on GitHub
const String kCircadianAppDataTestDir = 'c:\\temp\\test\\CircadianData';
const String kCircadianAppDataTestSaveDir = 'c:\\temp\\test\\CircadianDataSaved';

const String kDefaultJsonFileName = 'circadian.json';
const double kVerticalFieldDistance = 23.0;
const double kVerticalFieldDistanceAddSubScreen = 1.0;
const double kResetButtonBottomDistance = 5.0;

DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
