import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';

enum status { wakeUp, sleep }

final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

class TimeCalculator extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;

  const TimeCalculator({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
  })  : _screenNavigTransData = screenNavigTransData,
        super(key: key);

  @override
  _TimeCalculatorState createState() {
    return _TimeCalculatorState(_screenNavigTransData.transferDataMap);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _TimeCalculatorState extends State<TimeCalculator> with ScreenMixin {
  _TimeCalculatorState(Map<String, dynamic> transferDataMap)
      : _transferDataMap = transferDataMap,
        _firstTimeStr = transferDataMap['firstTimeStr'] ?? '00:00:00',
        _secondTimeStr = transferDataMap['secondTimeStr'] ?? '00:00:00',
        _resultTimeStr = transferDataMap['resultTimeStr'] ?? '',
        super();

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _transferDataMap;

  String _firstTimeStr = '';
  String _secondTimeStr = '';
  String _resultTimeStr = '';

  late TextEditingController _firstTimeTextFieldController;
  late TextEditingController _secondTimeTextFieldController;

  final DateFormat _frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();

    _firstTimeTextFieldController = TextEditingController(
        text: _transferDataMap['firstTimeStr'] ?? '00:00:00');
    _secondTimeTextFieldController = TextEditingController(
        text: _transferDataMap['secondTimeStr'] ?? '00:00:00');

    _resultTimeStr = _transferDataMap['resultTimeStr'] ?? '';
  }

  @override
  void dispose() {
    _firstTimeTextFieldController.dispose();
    _secondTimeTextFieldController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['firstTimeStr'] = _firstTimeStr;
    map['secondTimeStr'] = _secondTimeStr;
    map['resultTimeStr'] = _resultTimeStr;

    return map;
  }

  void _addSubtractTimeDuration(
      {required BuildContext context, required bool isPlus}) {
    /// Private method called when pressing the 'Plus' or 'Minus' buttons.
    _firstTimeStr = _firstTimeTextFieldController.text;
    _secondTimeStr = _secondTimeTextFieldController.text;
    Duration? firstTimeDuration =
        DateTimeParser.parseDDHHMMDuration(_firstTimeStr);
    Duration? secondTimeDuration =
        DateTimeParser.parseDDHHMMDuration(_secondTimeStr);

    Duration resultDuration;

    if (firstTimeDuration == null) {
      openWarningDialog(context,
          'You are trying to add/subtract time to an incorrectly formated dd:hh:mm time ($_firstTimeStr). Please correct it and retry !');
      return;
    }

    if (secondTimeDuration == null) {
      openWarningDialog(context,
          'You are trying to add/subtract an incorrectly formated dd:hh:mm time ($_secondTimeStr). Please correct it and retry !');
      return;
    }

    if (isPlus) {
      resultDuration = firstTimeDuration + secondTimeDuration;
    } else {
      resultDuration = firstTimeDuration - secondTimeDuration;
    }

    String resultTimeStr;

    if (resultDuration.inDays > 0) {
      resultTimeStr = '${resultDuration.ddHHmm()} = ${resultDuration.HHmm()}';
    } else {
      resultTimeStr = '${resultDuration.ddHHmm()}';
    }

    setState(() {
      _resultTimeStr = resultTimeStr;
    });

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
                  Text(
                    'Time (dd:hh:mm)',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                      fontWeight: ScreenMixin.appTextFontWeight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: appTextAndIconColor,
                        ),
                      ),
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: TextStyle(
                            color: appTextAndIconColor,
                            fontSize: ScreenMixin.appTextFontSize,
                            fontWeight: ScreenMixin.appTextFontWeight),
                        keyboardType: TextInputType.datetime,
                        controller: _firstTimeTextFieldController,
                        onChanged: (val) {
                          // called when manually updating the TextField
                          // content. onChanged must be defined in order for
                          // pasting a value to the TextField to really
                          // modify the TextField value and store it
                          // in the screen navigation transfer
                          // data map.
                          _firstTimeStr = val;
                          _updateTransferDataMap();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Time (dd:hh:mm)',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.appTextFontSize,
                      fontWeight: ScreenMixin.appTextFontWeight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: appTextAndIconColor,
                        ),
                      ),
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: TextStyle(
                            color: appTextAndIconColor,
                            fontSize: ScreenMixin.appTextFontSize,
                            fontWeight: ScreenMixin.appTextFontWeight),
                        keyboardType: TextInputType.datetime,
                        controller: _secondTimeTextFieldController,
                        onChanged: (val) {
                          // called when manually updating the TextField
                          // content. onChanged must be defined in order for
                          // pasting a value to the TextField to really
                          // modify the TextField value and store it
                          // in the screen navigation transfer
                          // data map.
                          _secondTimeStr = val;
                          _updateTransferDataMap();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Result',
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
                      labelText: _resultTimeStr,
                      labelStyle: TextStyle(
                        fontSize: ScreenMixin.appTextFontSize,
                        color: appTextAndIconColor,
                        fontWeight: ScreenMixin.appTextFontWeight,
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  const SizedBox(
                    width: 200,
                  ),
                  const SizedBox(
                    width: 37,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    height: 115,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          //  _startDateTimeController.text = DateTime.now().toString();
                          _addSubtractTimeDuration(
                              context: context, isPlus: true);
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: ScreenMixin.appTextFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          //  _startDateTimeController.text = DateTime.now().toString();
                          _addSubtractTimeDuration(
                              context: context, isPlus: false);
                        },
                        child: const Text(
                          'Subtr',
                          style: TextStyle(
                            fontSize: ScreenMixin.appTextFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.fromLTRB(240, 404, 0, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: appElevatedButtonBackgroundColor,
                      shape: appElevatedButtonRoundedShape),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
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
            ),
          ],
        ),
      ),
    );
  }
}
