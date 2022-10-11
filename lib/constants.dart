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
const String kApplicationVersion = '1.7.5';
const String kDownloadAppDir = '/storage/emulated/0/Download/CircadianData';
const String kCircadianAppDataDir_test = 'c:\\temp\\test\\CircadianData';
const String kDefaultJsonFileName = 'circadian.json';
const double kVerticalFieldDistance = 23.0;
const double kVerticalFieldDistanceAddSubScreen = 1.0;
const double kResetButtonBottomDistance = 5.0;
