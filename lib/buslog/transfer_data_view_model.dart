import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/transfer_data.dart';

/// This class manages the correspondance between the transfer data
/// map currently storing the different screens data and the
/// [TransferData] instance which save or load data in or from
/// the circadian json file.
class TransferDataViewModel {
  String _transferDataJsonFilePathName;
  TransferData _transferData;
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
    print('TransferDataViewModel.dataUpdated()');
    print(_transferDataMap);
    updateAddDurationToDateTimeData();
  }

  void updateAddDurationToDateTimeData() {
    AddDurationToDateTimeData addDurationToDateTimeData =
        _transferData.addDurationToDateTimeData;
    addDurationToDateTimeData.durationIconType = DurationIconType.add;
    addDurationToDateTimeData.addDurationStartDateTimeStr = '09_07_2022 23:58';
    addDurationToDateTimeData.durationStr = '01:00';
    addDurationToDateTimeData.endDateTimeStr = '10_07_2022 00:58';

    TransferData transferData = TransferData();
    transferData.addDurationToDateTimeData = addDurationToDateTimeData;
  }
}
