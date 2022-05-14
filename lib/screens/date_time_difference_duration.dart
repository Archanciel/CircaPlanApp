import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/utils/date_time_parser.dart';

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

  @override
  void dispose() {
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['dtDiffStartDateTimeStr'] = _startDateTimeStr;
    map['dtDiffEndDateTimeStr'] = _endDateTimeStr;
    map['dtDiffDurationStr'] = _durationStr;

    return map;
  }

  void _setStateDiffDuration() {
    /// Private method called each time one of the elements
    /// implied in calculating the Duration value is changed.
    _startDateTimeStr = _startDateTimeController.text;
    DateTime startDateTime = _englishDateTimeFormat.parse(_startDateTimeStr);
    _endDateTimeStr = _endDateTimeController.text;
    DateTime endDateTime = _englishDateTimeFormat.parse(_endDateTimeStr);
    Duration diffDuration;

    if (endDateTime.isAfter(startDateTime)) {
      diffDuration = endDateTime.difference(startDateTime);
    } else {
      diffDuration = startDateTime.difference(endDateTime);
    }

    setState(
      () {
        _durationStr = diffDuration.HHmm();
      },
    );

    _updateTransferDataMap();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 15, vertical: ScreenMixin.appVerticalTopMargin),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
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
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                  ),
                  const SizedBox(
                    height: 25,
                  ),
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
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Duration',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                      fontWeight: ScreenMixin.appTextFontWeight,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      //           contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      labelText: _durationStr,
                      labelStyle: TextStyle(
                        fontSize: ScreenMixin.appTextFontSize,
                        color: appTextAndIconColor,
                        fontWeight: ScreenMixin.appTextFontWeight,
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                  ),
                  const SizedBox(
                    height: 25,
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
                      child: const Text(
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
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
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
                  SizedBox(
                    height: 37,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: appElevatedButtonBackgroundColor,
                        shape: appElevatedButtonRoundedShape),
                    onPressed: () {
                      _endDateTimeController.text = DateTime.now().toString();
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
            ),
          ],
        ),
      ),
    );
  }
}
