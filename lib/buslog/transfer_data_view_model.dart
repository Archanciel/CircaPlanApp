import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:circa_plan/model/transfer_data.dart';

/// This class manages the correspondance between the transfer data
/// map currently storing the different screens data and the
/// [TransferData] instance which save or load data in or from
/// the circadian json file.
class TransferDataViewModel {
  final String _transferDataJsonFilePathName;
  final TransferData _transferData;

  // since the transferDataMap can not be set by the constructor but
  // by calling the corresponding setter, the instance variable must
  // be declared nullable.
  Map<String, dynamic>? _transferDataMap;

  TransferDataViewModel({
    required String transferDataJsonFilePathName,
  })  : _transferDataJsonFilePathName = transferDataJsonFilePathName,
        // the TransferData constructor instanciates 4 empty screen
        // data sub classes.
        _transferData = TransferData();

  /// the transferDataMap being not setable by the constructor, this
  /// setter must be declared.
  set transferDataMap(Map<String, dynamic> transferDataMap) =>
      _transferDataMap = transferDataMap;

  AddDurationToDateTimeData get addDurationToDateTimeData =>
      _transferData.addDurationToDateTimeData;

  /// Copy transferDataMap values to TransferData instance in order to
  /// then update the json file.
  void updateTransferData() {
    updateAddDurationToDateTimeData();
//    updateCalculateSleepDurationData();
    printScreenData();
  }

  void printScreenData() {
    print(_transferData.addDurationToDateTimeData);
  }

  void updateAddDurationToDateTimeData() {
    AddDurationToDateTimeData addDurationToDateTimeData =
        _transferData.addDurationToDateTimeData;

    int? durationSign = _transferDataMap!['durationSign'];

    if (durationSign == null) {
      // the case if no AddDurationToDateTime screen field was
      // modified
      return;
    }

    addDurationToDateTimeData.durationIconType =
        (durationSign >
                0) // _transferDataMap is nullable !
            ? DurationIconType.add
            : DurationIconType.subtract;
    addDurationToDateTimeData.addDurationStartDateTimeStr =
        _transferDataMap!['addDurStartDateTimeStr'];
    addDurationToDateTimeData.durationStr = _transferDataMap!['durationStr'];
    addDurationToDateTimeData.endDateTimeStr =
        _transferDataMap!['endDateTimeStr'];
  }

  void updateCalculateSleepDurationData() {
    CalculateSleepDurationData calculateSleepDurationData =
        _transferData.calculateSleepDurationData;

    /*
    map['calcSlDurNewDateTimeStr'] = _newDateTimeStr;
    map['calcSlDurLastWakeUpTimeStr'] = _lastWakeUpTimeStr;
    map['calcSlDurPreviousDateTimeStr'] = _previousDateTimeStr;
    map['calcSlDurBeforePreviousDateTimeStr'] = _beforePreviousDateTimeStr;
    map['calcSlDurCurrSleepDurationStr'] = _currentSleepDurationStr;
    map['calcSlDurCurrWakeUpDurationStr'] = _currentWakeUpDurationStr;
    map['calcSlDurCurrTotalDurationStr'] = _currentTotalDurationStr;
    map['calcSlDurStatus'] = _status;
    map['calcSlDurSleepTimeStrHistory'] = _sleepTimeStrHistory;
    map['calcSlDurWakeUpTimeStrHistory'] = _wakeUpTimeStrHistory;
*/

    calculateSleepDurationData.status = _transferDataMap!['calcSlDurStatus'];
    calculateSleepDurationData.addDurationStartDateTimeStr =
        _transferDataMap!['addDurStartDateTimeStr'];
    calculateSleepDurationData.durationStr = _transferDataMap!['durationStr'];
    calculateSleepDurationData.endDateTimeStr =
        _transferDataMap!['endDateTimeStr'];
  }
}
