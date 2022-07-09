import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:enough_serialization/enough_serialization.dart';

class TransferData extends SerializableObject {
  TransferData() {
    objectCreators['addDurationToDateTimeData'] = (map) => AddDurationToDateTimeData();    
  }

  AddDurationToDateTimeData get addDurationToDateTimeData => attributes['addDurationToDateTimeData'];
  set screenDataType(AddDurationToDateTimeData value) => attributes['addDurationToDateTimeData'] = value;
}
