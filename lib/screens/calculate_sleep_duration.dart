import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';

enum status { wakeUp, sleep }
final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

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
            frenchDateTimeFormat.format(DateTime.now()),
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
  String _name = '';

  late TextEditingController _newDateTimeController;
  late TextEditingController _addTimeDialogController;

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = frenchDateTimeFormat.format(dateTimeNow);

    _newDateTimeController = TextEditingController(
        text: _transferDataMap['calcSlDurNewDateTimeStr'] ?? nowDateTimeStr);
    _addTimeDialogController = TextEditingController();
  }

  @override
  void dispose() {
    _newDateTimeController.dispose();
    _addTimeDialogController.dispose();

    super.dispose();
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
    /// is nanually modified.

    // dateTimeStr format is not validated here in order to avoid preventing
    // new date time manual modification. The new date time string format will
    // be validated right before it is used.
    setState(() {
      _newDateTimeStr = dateTimeStr;
    });

    _updateTransferDataMap();
  }

  void _incDecNewDateTimeMinute(
      {required BuildContext context, required int minuteNb}) {
    /// Private method called each time the '+' or '-' button
    /// is pressed.
    DateTime? newDateTime;

    newDateTime = DateTimeParser.parseDDMMYYYYDateTime(_newDateTimeStr);

    if (newDateTime == null) {
      openWarningDialog(context,
          'You are trying to increase/decrease an incorrectly formated dd-MM-yyyy HH:mm new date time ($_newDateTimeStr). Please correct it and retry !');
      return;
    }

    if (minuteNb > 0) {
      newDateTime = newDateTime.subtract(Duration(minutes: -minuteNb));
    } else {
      newDateTime = newDateTime.add(Duration(minutes: minuteNb));
    }

    _newDateTimeStr = frenchDateTimeFormat.format(newDateTime);

    setState(() {
      _newDateTimeController.text = _newDateTimeStr;
    });

    _updateTransferDataMap();
  }

  void _resetScreen() {
    /// Private method called when clicking on 'Reset' button.
    setState(
      () {
        _newDateTimeStr = frenchDateTimeFormat.format(DateTime.now());
        _newDateTimeController.text = _newDateTimeStr;
        _previousDateTimeStr = '';
        _currentSleepDurationStr = '';
        _currentWakeUpDurationStr = '';
        _status = status.wakeUp;
      },
    );

    _updateTransferDataMap();
  }

  void _handleAddButton(BuildContext context) {
    /// Private method called when clicking on 'Add' button located at right of
    /// new date time TextField.
    DateTime? newDateTime;

    newDateTime = DateTimeParser.parseDDMMYYYYDateTime(_newDateTimeStr);

    if (newDateTime == null) {
      openWarningDialog(context,
          'You entered an incorrectly formated dd-MM-yyyy HH:mm new date time ($_newDateTimeStr). Please correct it and retry !');
      return;
    }

    if (_status == status.wakeUp) {
      if (_previousDateTimeStr == '') {
        // first click on 'Add' button after reinitializing
        // or resetting the app
        setState(() {
          // Without using applying ! bang operator to the newDateTime variable,
          // the compiler displays this error: 'The argument type 'DateTime?'
          // can't be assigned to the parameter type DateTime
          _previousDateTimeStr = frenchDateTimeFormat.format(newDateTime!);
          _status = status.sleep;
        });
      } else {
        DateTime? previousDateTime;

        previousDateTime = frenchDateTimeFormat.parse(_previousDateTimeStr);

        if (newDateTime.isBefore(previousDateTime)) {
          openWarningDialog(context,
              'New date time can\'t be before previous date time ($_newDateTimeStr < $_previousDateTimeStr). Please increase it and retry !');
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

        setState(() {
          _currentWakeUpDurationStr = currentWakeUpDuration!.HHmm();
          _previousDateTimeStr = _newDateTimeStr;
          _status = status.sleep;
        });
      }
    } else {
      // status == status.sleep
      DateTime? previousDateTime;

      previousDateTime = frenchDateTimeFormat.parse(_previousDateTimeStr);

      if (newDateTime.isBefore(previousDateTime)) {
        openWarningDialog(context,
            'New date time can\'t be before previous date time ($_newDateTimeStr < $_previousDateTimeStr). Please retry !');
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

      setState(() {
        _currentSleepDurationStr = currentSleepDuration!.HHmm();
        _previousDateTimeStr = _newDateTimeStr;
        _status = status.wakeUp;
      });

      _updateTransferDataMap();
    }
  }

  void _addTimeToCurrentSleepDuration(

      /// Private method called when clicking on 'Add' button located at right of
      /// current sleep duration TextField.
      BuildContext context,
      String durationStr) {
    Duration? addDuration = DateTimeParser.parseHHmmDuration(durationStr);

    if (addDuration == null) {
      openWarningDialog(context,
          'You entered an incorrectly formated HH:mm time ($durationStr). Please retry !');
      return;
    } else {
      Duration? currentSleepDuration =
          DateTimeParser.parseHHmmDuration(_currentSleepDurationStr);

      if (currentSleepDuration == null) {
        currentSleepDuration = addDuration;
      } else {
        currentSleepDuration += addDuration;
      }

      setState(() {
        _currentSleepDurationStr = currentSleepDuration!.HHmm();
      });

      _updateTransferDataMap();
    }
  }

  String _statusStr(status enumStatus) {
    if (enumStatus == status.wakeUp) {
      return 'Wake Up';
    } else if (enumStatus == status.sleep) {
      return 'Sleep';
    } else {
      return '';
    }
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
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          setState(() {
                            String dateTimeStr =
                                frenchDateTimeFormat.format(DateTime.now());
                            _newDateTimeController.text = dateTimeStr;
                            _newDateTimeStr = dateTimeStr;
                          });
                        },
                        child: const Text(
                          'Now',
                          style: TextStyle(
                            fontSize: ScreenMixin.appTextFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          IconButton(
                            constraints: const BoxConstraints(
                              minHeight: 0,
                              minWidth: 0,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () => _incDecNewDateTimeMinute(
                                context: context, minuteNb: 1),
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
                            onPressed: () => _incDecNewDateTimeMinute(
                                context: context, minuteNb: -1),
                            icon: Icon(
                              Icons.remove,
                              color: appTextAndIconColor,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () => _handleAddButton(context),
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
                          enabled: false,
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
                          enabled: false,
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
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () async {
                          final timeStr = await openTextInputDialog();
                          if (timeStr == null || timeStr.isEmpty) return;

                          _addTimeToCurrentSleepDuration(context, timeStr);
                        },
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
                          enabled: false,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  _statusStr(_status),
                  style: TextStyle(
                    color: appLabelColor,
                    fontSize: ScreenMixin.appTextFontSize,
                  ),
                ),
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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

  Future<String?> openTextInputDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Time to add'),
          content: TextField(
            autofocus: true,
            style: TextStyle(
                fontSize: ScreenMixin.appTextFontSize,
                fontWeight: ScreenMixin.appTextFontWeight),
            decoration: const InputDecoration(hintText: 'HH:mm'),
            controller: _addTimeDialogController,
            onSubmitted: (_) => submit(),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              child: const Text('Add time'),
              onPressed: submit,
            ),
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop(_addTimeDialogController.text);

    _addTimeDialogController.clear();
  }
}
