import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
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

  set transferDataMap(Map<String, dynamic> transferDataMap) =>
      _transferDataMap = transferDataMap;

  void dataUpdated() {
    updateAddDurationToDateTimeData();
    printScreenData();
  }

  void printScreenData() {
    print(_transferData.addDurationToDateTimeData);
  }

  void updateAddDurationToDateTimeData() {
    AddDurationToDateTimeData addDurationToDateTimeData =
        _transferData.addDurationToDateTimeData;

    addDurationToDateTimeData.durationIconType =
        (_transferDataMap!['durationSign'] > 0) // _transferDataMap is nullable !
            ? DurationIconType.add
            : DurationIconType.subtract;
    addDurationToDateTimeData.addDurationStartDateTimeStr =
        _transferDataMap!['addDurStartDateTimeStr'];
    addDurationToDateTimeData.durationStr = _transferDataMap!['durationStr'];
    addDurationToDateTimeData.endDateTimeStr =
        _transferDataMap!['endDateTimeStr'];
  }
}
