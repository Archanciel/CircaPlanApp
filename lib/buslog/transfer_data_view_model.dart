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
        _transferData = TransferData();

  set transferDataMap(Map<String, dynamic> transferDataMap) =>
      _transferDataMap = transferDataMap;

  void dataUpdated() {
    print('TransferDataViewModel.dataUpdated()');
  }
}
