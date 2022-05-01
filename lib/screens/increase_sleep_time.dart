import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/date_time_difference_duration.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:intl/intl.dart';

class IncreaseSleepTime extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;
  
  const IncreaseSleepTime({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
  })  : _screenNavigTransData = screenNavigTransData,
        super(key: key);

  @override
  _IncreaseSleepTimeState createState() {
    return _IncreaseSleepTimeState(_screenNavigTransData.transferDataMap);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _IncreaseSleepTimeState extends State<IncreaseSleepTime> with ScreenMixin {
  _IncreaseSleepTimeState(Map<String, dynamic> transferDataMap)
      : _transferDataMap = transferDataMap,
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _transferDataMap;

  late TextEditingController _controller1;

  late DateFormat _dateTimeFormat;
  late DateFormat _dateOnlyFormat;

  //String _initialValue = '';
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String? _wakeUpDT;
  String? _awakeHHmm;
  String? _goToBedDT;
  String? _outputText;

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    String _initialValue = dateTimeNow.toString();
    final String localName = 'fr_CH';
    Intl.defaultLocale = localName;
    _dateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
    _dateOnlyFormat = DateFormat("dd-MM-yyyy");

    String lsHour = dateTimeNow.hour.toString().padLeft(2, '0');
    String lsMinute = dateTimeNow.minute.toString().padLeft(2, '0');
    _controller1 = TextEditingController(text: '$lsHour:$lsMinute');
  }

  String? _validateDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid dd-mm hh:mm wake up date time';
    } else {
      List<String?> dateTimeStrLst = DateTimeParser.parseDDMMDateTime(value);
      if (dateTimeStrLst.contains(null)) {
        return 'Please enter a valid dd-mm hh:mm wake up date time';
      }
    }

    return null;
  }

  Map<String, dynamic> _createTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    return map;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid hh:mm wake up duration';
    } else {
      String? timeStr = DateTimeParser.parseTime(value);
      if (timeStr == null) {
        return 'Please enter a valid hh:mm wake up duration';
      }
    }

    return null;
  }

  String _reformatDateTimeStr(String dateTimeStr) => (dateTimeStr != '')
      ? _dateTimeFormat.format(DateTime.parse(dateTimeStr))
      : '';
  String _reformatDateStr(String dateTimeStr) => (dateTimeStr != '')
      ? _dateOnlyFormat.format(DateTime.parse(dateTimeStr))
      : '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Drawer(
          backgroundColor: Colors.blue[300],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Text('Header'),
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                leading: const Icon(
                  Icons.keyboard_double_arrow_up,
                ),
                title: const Text('Add duration to date time'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                           AddDurationToDateTime(
                        screenNavigTransData:
                             ScreenNavigTransData(transferDataMap: _createTransferDataMap()),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.keyboard_double_arrow_up,
                ),
                title: const Text('Date time difference duration'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                           DateTimeDifferenceDuration(
                        screenNavigTransData:
                             ScreenNavigTransData(transferDataMap: _createTransferDataMap()),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        foregroundColor: labelColor,
        title: const Text('Circadian App'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  Text(
                    'Stay awake',
                    style: TextStyle(
                      color: labelColor,
                      fontSize: textFontSize,
                    ),
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.time,
                    timePickerEntryModeInput: true,
                    controller: _controller1,
                    icon: Icon(
                      Icons.access_time,
                      color: textAndIconColor,
                      size: 30,
                    ),
                    //dateLabelText: 'Date Time',
                    style: TextStyle(
                      color: textAndIconColor,
                      fontSize: textFontSize,
                    ),
                    onChanged: (val) => setState(() => _valueChanged1 = val),
                    validator: (val) {
                      setState(() => _valueToValidate1 = val ?? '');
                      return null;
                    },
                    onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      _formKey.currentState!.save();
                      setState(() {
                        _outputText =
                            'Input values: $_wakeUpDT, $_awakeHHmm, $_goToBedDT';
                      });
                      print(
                          'Input values: $_wakeUpDT, $_awakeHHmm, $_goToBedDT');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _outputText ?? '',
                style: TextStyle(
                  color: textAndIconColor,
                  fontSize: textFontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
