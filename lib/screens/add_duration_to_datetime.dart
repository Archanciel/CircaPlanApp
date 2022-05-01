import 'package:circa_plan/screens/date_time_difference_duration.dart';
import 'package:circa_plan/screens/increase_sleep_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:intl/intl.dart';

class AddDurationToDateTime extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;

  const AddDurationToDateTime({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
  })  : _screenNavigTransData = screenNavigTransData,
        super(key: key);

  @override
  _AddDurationToDateTimeState createState() {
    return _AddDurationToDateTimeState(_screenNavigTransData.transferDataMap);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _AddDurationToDateTimeState extends State<AddDurationToDateTime>
    with ScreenMixin {
  _AddDurationToDateTimeState(Map<String, dynamic> transferDataMap)
      : _transferDataMap = transferDataMap,
        _durationIcon = transferDataMap['durationIconData'] ?? Icons.add,
        _durationIconColor =
            transferDataMap['durationIconColor'] ?? durationPositiveColor,
        _durationSign = transferDataMap['durationSign'] ?? 1,
        _durationTextColor =
            transferDataMap['durationTextColor'] ?? durationPositiveColor,
        super();

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _transferDataMap;
  IconData _durationIcon;
  Color _durationIconColor;
  Color _durationTextColor;
  int _durationSign;
  String _endDateTime = '';

  late TextEditingController _controller1;
  late TextEditingController _controller2;

  late DateFormat _englishDateTimeFormat;
  late DateFormat _frenchDateTimeFormat;
  late DateFormat _dateOnlyFormat;

  //String _initialValue = '';
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';

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
    _englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
    _frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
    _dateOnlyFormat = DateFormat("dd-MM-yyyy");

    _controller1 = TextEditingController(text: _initialValue);

//    String lsHour = dateTimeNow.hour.toString().padLeft(2, '0');
//    String lsMinute = dateTimeNow.minute.toString().padLeft(2, '0');
    _controller2 = TextEditingController(
        text: _transferDataMap['addDurationHHmm'] ?? '00:00');
  }

  Map<String, dynamic> _createTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['durationIconData'] = _durationIcon;
    map['durationIconColor'] = _durationIconColor;
    map['durationSign'] = _durationSign;
    map['durationTextColor'] = _durationTextColor;
    map['addDurationHHmm'] = _controller2.text;

    return map;
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
      ? _englishDateTimeFormat.format(DateTime.parse(dateTimeStr))
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
                title: const Text('Date time difference duration'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DateTimeDifferenceDuration(
                        screenNavigTransData: ScreenNavigTransData(
                            transferDataMap: _createTransferDataMap()),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.keyboard_double_arrow_up,
                ),
                title: const Text('Increase sleep time'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => IncreaseSleepTime(
                        screenNavigTransData: ScreenNavigTransData(
                            transferDataMap: _createTransferDataMap()),
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
              Wrap(
                children: [
                  Text(
                    'Start date time',
                    style: TextStyle(
                      color: labelColor,
                      fontSize: textFontSize,
                      fontWeight: textFontWeight,
                    ),
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    dateMask: 'dd-MM-yyyy HH:mm',
                    use24HourFormat: true,
                    controller: _controller1,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(
                      Icons.event,
                      color: textAndIconColor,
                      size: 30,
                    ),
                    //dateLabelText: 'Date Time',
                    style: TextStyle(
                      color: textAndIconColor,
                      fontSize: textFontSize,
                      fontWeight: textFontWeight,
                    ),
                    onChanged: (val) => _setStateEndDateTime(),
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
              Wrap(
                children: [
                  Text(
                    'Duration',
                    style: TextStyle(
                      color: labelColor,
                      fontSize: textFontSize,
                      fontWeight: textFontWeight,
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        left: -18,
                        child: TextButton.icon(
                          icon: Icon(
                            _durationIcon,
                            size: 30,
                            color: _durationIconColor,
                          ),
                          label: const Text(''),
                          onPressed: () {
                            if (_durationIcon == Icons.add) {
                              _durationIcon = Icons.remove;
                              _durationIconColor = durationNegativeColor;
                              _durationSign = -1;
                              _durationTextColor = durationNegativeColor;
                            } else {
                              _durationIcon = Icons.add;
                              _durationIconColor = durationPositiveColor;
                              _durationSign = 1;
                              _durationTextColor = durationPositiveColor;
                            }
                            _setStateEndDateTime();
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: DateTimePicker(
                          type: DateTimePickerType.time,
                          timePickerEntryModeInput: true,
                          controller: _controller2,
                          icon: Icon(
                            Icons.access_time,
                            color: textAndIconColor,
                            size: 30,
                          ),
                          style: TextStyle(
                            color: _durationTextColor,
                            fontSize: textFontSize,
                            fontWeight: textFontWeight,
                          ),
                          onChanged: (val) => _setStateEndDateTime(),
                          validator: (val) {
                            setState(() => _valueToValidate2 = val ?? '');
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => _valueSaved2 = val ?? ''),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'End date time',
                style: TextStyle(
                  color: labelColor,
                  fontSize: textFontSize,
                  fontWeight: textFontWeight,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(47, 0, 0, 0),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    labelText: _endDateTime,
                    labelStyle: TextStyle(
                      fontSize: textFontSize,
                      color: textAndIconColor,
                      fontWeight: textFontWeight,
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                ),
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

  void _setStateEndDateTime() {
    setState(() {
      String durationStr = _controller2.text;
      Duration? duration = DateTimeParser.parseHHmmDuration(durationStr);
      String text = _controller1.text;
      DateTime? startDateTime = _englishDateTimeFormat.parse(text);
      DateTime endDateTime;
      if (duration != null && startDateTime != null) {
        if (_durationSign > 0) {
          endDateTime = startDateTime.add(duration);
        } else {
          endDateTime = startDateTime.subtract(duration);
        }
        _endDateTime = _frenchDateTimeFormat.format(endDateTime);
      }
    });
  }
}
