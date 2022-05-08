import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:intl/intl.dart';

class DateTimeDifferenceDuration extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;

  const DateTimeDifferenceDuration({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
  })  : _screenNavigTransData = screenNavigTransData,
        super(key: key);

  @override
  _DateTimeDifferenceDurationState createState() {
    return _DateTimeDifferenceDurationState(
        _screenNavigTransData.transferDataMap);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _DateTimeDifferenceDurationState extends State<DateTimeDifferenceDuration>
    with ScreenMixin {
  _DateTimeDifferenceDurationState(Map<String, dynamic> transferDataMap)
      : _transferDataMap = transferDataMap,
        _startDateTimeStr = transferDataMap['dtDiffStartDateTimeStr'] ??
            DateTime.now().toString(),
        _endDateTimeStr = transferDataMap['dtDiffEndDateTimeStr'] ??
            DateTime.now().toString(),
        _durationStr = transferDataMap['dtDiffDurationStr'] ?? '',
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _transferDataMap;

  String _startDateTimeStr = '';
  String _endDateTimeStr = '';
  String _durationStr = '';

  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;

  final DateFormat _englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");

  //String _initialValue = '';
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();

    _startDateTimeController = TextEditingController(
        text: _transferDataMap['dtDiffStartDateTimeStr'] ?? nowDateTimeStr);
    _endDateTimeController = TextEditingController(
        text: _transferDataMap['dtDiffEndDateTimeStr'] ?? nowDateTimeStr);
  }

  Map<String, dynamic> _createTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['dtDiffStartDateTimeStr'] = _startDateTimeStr;
    map['dtDiffEndDateTimeStr'] = _endDateTimeStr;
    map['dtDiffDurationStr'] = _durationStr;

    return map;
  }

  void _setStateDiffDuration() {
    setState(
      () {
        _startDateTimeStr = _startDateTimeController.text;
        DateTime startDateTime =
            _englishDateTimeFormat.parse(_startDateTimeStr);
        _endDateTimeStr = _endDateTimeController.text;
        DateTime endDateTime = _englishDateTimeFormat.parse(_endDateTimeStr);
        Duration diffDuration;

        if (endDateTime.isAfter(startDateTime)) {
          diffDuration = endDateTime.difference(startDateTime);
        } else {
          diffDuration = startDateTime.difference(endDateTime);
        }
        _durationStr = diffDuration.HHmm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: Container(
        width: MediaQuery.of(context).size.width *
            ScreenMixin.appDrawerWidthProportion,
        child: Drawer(
          backgroundColor: Colors.blue[300],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: ScreenMixin.appDrawerHeaderHeight,
                child: DrawerHeader(
                  child: Text(
                    ScreenMixin.appDrawerHeaderText,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: ScreenMixin.appTextFontSize,
                      fontWeight: ScreenMixin.appDrawerFontWeight,
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.blue),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.keyboard_double_arrow_up,
                ),
                title: const Text(
                  ScreenMixin.addDurationToDateTimeTitle,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: ScreenMixin.appDrawerTextFontSize,
                    fontWeight: ScreenMixin.appDrawerFontWeight,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddDurationToDateTime(
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
                title: const Text(
                  ScreenMixin.calculateSleepDurationTitle,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: ScreenMixin.appDrawerTextFontSize,
                    fontWeight: ScreenMixin.appDrawerFontWeight,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => CalculateSleepDuration(
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
        backgroundColor: Colors.blue.shade900,
        foregroundColor: appLabelColor,
        title: const Text(ScreenMixin.dateTimeDiffDurationTitle),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Start date time',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                      fontWeight: ScreenMixin.appTextFontWeight,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: appElevatedButtonBackgroundColor,
                        shape: appElevatedButtonRoundedShape),
                    onPressed: () {
                      _startDateTimeController.text = DateTime.now().toString();
                      _setStateDiffDuration();
                    },
                    child: const Text(
                      'Now',
                      style: TextStyle(
                        fontSize: ScreenMixin.appTextFontSize,
                      ),
                    ),
                  ),
                ],
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'dd-MM-yyyy HH:mm',
                use24HourFormat: true,
                controller: _startDateTimeController,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(
                  Icons.event,
                  color: appTextAndIconColor,
                  size: 30,
                ),
                decoration: const InputDecoration.collapsed(hintText: ''),
                style: TextStyle(
                  color: appTextAndIconColor,
                  fontSize: ScreenMixin.appTextFontSize,
                  fontWeight: ScreenMixin.appTextFontWeight,
                ),
                onChanged: (val) => _setStateDiffDuration(),
                validator: (val) {
                  setState(() => _valueToValidate1 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  Row(
                    children: [
                      Text(
                        'End date time',
                        style: TextStyle(
                          color: appLabelColor,
                          fontSize: ScreenMixin.appTextFontSize,
                          fontWeight: ScreenMixin.appTextFontWeight,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          _endDateTimeController.text =
                              DateTime.now().toString();
                          _setStateDiffDuration();
                        },
                        child: const Text(
                          'Now',
                          style: TextStyle(
                            fontSize: ScreenMixin.appTextFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    dateMask: 'dd-MM-yyyy HH:mm',
                    use24HourFormat: true,
                    controller: _endDateTimeController,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(
                      Icons.event,
                      color: appTextAndIconColor,
                      size: 30,
                    ),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: TextStyle(
                      color: appTextAndIconColor,
                      fontSize: ScreenMixin.appTextFontSize,
                      fontWeight: ScreenMixin.appTextFontWeight,
                    ),
                    onChanged: (val) => _setStateDiffDuration(),
                    validator: (val) {
                      setState(() => _valueToValidate2 = val ?? '');
                      return null;
                    },
                    onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Duration',
                style: TextStyle(
                  color: appLabelColor,
                  fontSize: ScreenMixin.appTextFontSize,
                  fontWeight: ScreenMixin.appTextFontWeight,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(47, 0, 0, 0),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    labelText: _durationStr,
                    labelStyle: TextStyle(
                      fontSize: ScreenMixin.appTextFontSize,
                      color: appTextAndIconColor,
                      fontWeight: ScreenMixin.appTextFontWeight,
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
                  style: ButtonStyle(
                      backgroundColor: appElevatedButtonBackgroundColor,
                      shape: appElevatedButtonRoundedShape),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      _formKey.currentState!.save();
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
