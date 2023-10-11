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

// this global variable is used to prevent the
// CalculateSleepDuration screen which is the app default
// screen from reloading data
bool isAppStarting = true;

const String kApplicationName = "Circadian Calculator";
const String kApplicationVersion = '0.5.4';
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
const String kCircadianAppDataTestSaveDir =
    'c:\\temp\\test\\CircadianDataSaved';

const String kDefaultJsonFileName = 'circadian.json';
const String kSettingsFileName = 'settings.json';
const double kVerticalFieldDistance = 23.0;
const double kVerticalFieldDistanceAddSubScreen = 1.0;
const double kResetButtonBottomDistance = 5.0;

final DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
final DateFormat HHmmDateTimeFormat = DateFormat("HH:mm");

// temporary in constants.dart. Will be definable in set medic
// time dialog and stored in circadian.json file
const Duration fiveHoursDuration = Duration(hours: 5);
