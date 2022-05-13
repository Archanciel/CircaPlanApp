import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

enum status { wakeUp, sleep }

class CalculateSleepDuration extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;

  const CalculateSleepDuration({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
  })  : _screenNavigTransData = screenNavigTransData,
        super(key: key);

  @override
  _CalculateSleepDurationState createState() {
    return _CalculateSleepDurationState(_screenNavigTransData.transferDataMap);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _CalculateSleepDurationState extends State<CalculateSleepDuration>
    with ScreenMixin {
  _CalculateSleepDurationState(Map<String, dynamic> transferDataMap)
      : _transferDataMap = transferDataMap,
        _newDateTimeStr = transferDataMap['calcSlDurNewDateTimeStr'] ??
            DateTime.now().toString(),
        _previousDateTimeStr =
            transferDataMap['calcSlDurPreviousDateTimeStr'] ?? '',
        _currentSleepDurationStr =
            transferDataMap['calcSlDurCurrSleepDurationStr'] ?? '',
        _currentWakeUpDurationStr =
            transferDataMap['calcSlDurCurrentWakeUpDurationStr'] ?? '',
        _status = transferDataMap['calcSlDurStatus'] ?? status.wakeUp,
        super();

  Map<String, dynamic> _transferDataMap;

  String _newDateTimeStr = '';
  String _previousDateTimeStr = '';
  String _currentSleepDurationStr = '';
  String _currentWakeUpDurationStr = '';
  status _status = status.wakeUp;

  late TextEditingController _newDateTimeController;

  final DateFormat _frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = _frenchDateTimeFormat.format(dateTimeNow);

    _newDateTimeController = TextEditingController(
        text: _transferDataMap['calcSlDurNewDateTimeStr'] ?? nowDateTimeStr);
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['calcSlDurNewDateTimeStr'] = _newDateTimeStr;
    map['calcSlDurPreviousDateTimeStr'] = _previousDateTimeStr;
    map['calcSlDurCurrSleepDurationStr'] = _currentSleepDurationStr;
    map['calcSlDurCurrentWakeUpDurationStr'] = _currentWakeUpDurationStr;
    map['calcSlDurStatus'] = _status;

    return map;
  }

  void _setStateNewDateTimeDependentFields(String dateTimeStr) {
    /// Private method called each time the New date time TextField
    /// is nanually modified. This is temporary !
    DateTime newDateTime;

    try {
      newDateTime = _frenchDateTimeFormat.parse(dateTimeStr);
    } on FormatException {
      return;
    }

    setState(() {
      _newDateTimeStr = dateTimeStr;
    });

    _updateTransferDataMap();
  }

  void _modifyNewDateTimeMinute({required int minuteNb}) {
    /// Private method called each time the '+' or '-' button
    /// is pressed.
    DateTime newDateTime =
        _frenchDateTimeFormat.parse(_newDateTimeController.text);

    if (minuteNb > 0) {
      newDateTime = newDateTime.subtract(Duration(minutes: -minuteNb));
    } else {
      newDateTime = newDateTime.add(Duration(minutes: minuteNb));
    }

    _newDateTimeStr = _frenchDateTimeFormat.format(newDateTime);

    setState(() {
      _newDateTimeController.text = _newDateTimeStr;
    });

    _updateTransferDataMap();
  }

  void _resetScreen() {
    /// Private method called when clicking on 'Reset' button.
    setState(
      () {
        _newDateTimeStr = _frenchDateTimeFormat.format(DateTime.now());
        _newDateTimeController.text = _newDateTimeStr;
        _previousDateTimeStr = '';
        _currentSleepDurationStr = '';
        _currentWakeUpDurationStr = '';
        _status = status.wakeUp;
      },
    );

    _updateTransferDataMap();
  }

  void _handleAddButton() {
    /// Private method called when clicking on 'Add' button.
    setState(
      () {
        if (_status == status.wakeUp) {
          if (_currentSleepDurationStr == '') {
            // first click on 'Add' button after reinitializing
            // or resetting the app
            _previousDateTimeStr = _newDateTimeStr;
          } else {
            DateTime? newDateTime;

            try {
              newDateTime = _frenchDateTimeFormat.parse(_newDateTimeStr);
            } on FormatException {
              return;
            }

            DateTime? previousDateTime;

            try {
              previousDateTime =
                  _frenchDateTimeFormat.parse(_previousDateTimeStr);
            } on FormatException {
              return;
            }

            Duration wakeUpDuration = newDateTime.difference(previousDateTime);

            Duration? currentWakeUpDuration =
                DateTimeParser.parseHHmmDuration(_currentWakeUpDurationStr);

            if (currentWakeUpDuration == null) {
              currentWakeUpDuration = wakeUpDuration;
            } else {
              currentWakeUpDuration += wakeUpDuration;
            }

            _currentWakeUpDurationStr = currentWakeUpDuration.HHmm();
            _previousDateTimeStr = _newDateTimeStr;
          }

          _status = status.sleep;
        } else {
          // status == status.sleep
          DateTime? newDateTime;

          try {
            newDateTime = _frenchDateTimeFormat.parse(_newDateTimeStr);
          } on FormatException {
            return;
          }

          DateTime? previousDateTime;

          try {
            previousDateTime =
                _frenchDateTimeFormat.parse(_previousDateTimeStr);
          } on FormatException {
            return;
          }

          Duration sleepDuration = newDateTime.difference(previousDateTime);

          Duration? currentSleepDuration =
              DateTimeParser.parseHHmmDuration(_currentSleepDurationStr);

          if (currentSleepDuration == null) {
            currentSleepDuration = sleepDuration;
          } else {
            currentSleepDuration += sleepDuration;
          }

          _currentSleepDurationStr = currentSleepDuration.HHmm();
          _previousDateTimeStr = _newDateTimeStr;
          _status = status.wakeUp;
        }
      },
    );

    _updateTransferDataMap();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 15, vertical: ScreenMixin.appVerticalTopMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height:
                        15, // same distance from Appbar than the other screens
                  ),
                  Text(
                    'New date time',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: TextStyle(
                              color: appTextAndIconColor,
                              fontSize: ScreenMixin.appTextFontSize,
                              fontWeight: ScreenMixin.appTextFontWeight),
                          keyboardType: TextInputType.datetime,
                          controller: _newDateTimeController, // links the
//                                                TextField content to pressing
//                                                the button 'Now'. '+' or '-'
                          onChanged: (val) {
                            // called when manually updating the TextField
                            // content
                            _setStateNewDateTimeDependentFields(val);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          setState(() {
                            _newDateTimeController.text =
                                _frenchDateTimeFormat.format(DateTime.now());
                          });
                        },
                        child: const Text(
                          'Now',
                          style: TextStyle(
                            fontSize: ScreenMixin.appTextFontSize,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            constraints: const BoxConstraints(
                              minHeight: 0,
                              minWidth: 0,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () =>
                                _modifyNewDateTimeMinute(minuteNb: 1),
                            icon: Icon(
                              Icons.add,
                              color: appTextAndIconColor,
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(
                              minHeight: 0,
                              minWidth: 0,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () =>
                                _modifyNewDateTimeMinute(minuteNb: -1),
                            icon: Icon(
                              Icons.remove,
                              color: appTextAndIconColor,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () => _handleAddButton(),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: ScreenMixin.appTextFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Previous date time',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: TextField(
                          readOnly: true,
                          style: TextStyle(
                              color: appTextAndIconColor,
                              fontSize: ScreenMixin.appTextFontSize,
                              fontWeight: ScreenMixin.appTextFontWeight),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 17, 0, 0),
                            labelText: _previousDateTimeStr,
                            labelStyle: TextStyle(
                              fontSize: ScreenMixin.appTextFontSize,
                              color: appTextAndIconColor,
                              fontWeight: ScreenMixin.appTextFontWeight,
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Current sleep duration',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: TextField(
                          readOnly: true,
                          style: TextStyle(
                              color: appTextAndIconColor,
                              fontSize: ScreenMixin.appTextFontSize,
                              fontWeight: ScreenMixin.appTextFontWeight),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 17, 0, 0),
                            labelText: _currentSleepDurationStr,
                            labelStyle: TextStyle(
                              fontSize: ScreenMixin.appTextFontSize,
                              color: appTextAndIconColor,
                              fontWeight: ScreenMixin.appTextFontWeight,
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          //controller: _newDateTimeController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Current wake up duration',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: TextField(
                          readOnly: true,
                          style: TextStyle(
                              color: appTextAndIconColor,
                              fontSize: ScreenMixin.appTextFontSize,
                              fontWeight: ScreenMixin.appTextFontWeight),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 17, 0, 0),
                            labelText: _currentWakeUpDurationStr,
                            labelStyle: TextStyle(
                              fontSize: ScreenMixin.appTextFontSize,
                              color: appTextAndIconColor,
                              fontWeight: ScreenMixin.appTextFontWeight,
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          //controller: _newDateTimeController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(''),
              Container(
                child: Text(
                  _status.toString(),
                  style: TextStyle(
                    color: appLabelColor,
                    fontSize: ScreenMixin.appTextFontSize,
                  ),
                ),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 86),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 75),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () => _resetScreen(),
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: ScreenMixin.appTextFontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
