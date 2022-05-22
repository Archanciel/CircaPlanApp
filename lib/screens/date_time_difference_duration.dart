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
        _addTimeStr = transferDataMap['dtDiffAddTimeStr'] ?? '',
        _finalDurationStr = transferDataMap['dtDiffFinalDurationStr'] ?? '',
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _transferDataMap;

  String _startDateTimeStr = '';
  String _endDateTimeStr = '';
  String _durationStr = '';
  String _addTimeStr = '';
  String _finalDurationStr = '';

  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;
  late TextEditingController _durationTextFieldController;
  late TextEditingController _addTimeDialogController;
  late TextEditingController _addTimeTextFieldController;
  late TextEditingController _finalDurationTextFieldController;

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
    _durationTextFieldController = TextEditingController(
        text: _transferDataMap['dtDiffDurationStr'] ?? '');
    _addTimeDialogController = TextEditingController();
    _addTimeTextFieldController =
        TextEditingController(text: _transferDataMap['dtDiffAddTimeStr'] ?? '');
    _finalDurationTextFieldController = TextEditingController(
        text: _transferDataMap['dtDiffFinalDurationStr'] ?? '');
  }

  @override
  void dispose() {
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    _durationTextFieldController.dispose();
    _addTimeDialogController.dispose();
    _addTimeTextFieldController.dispose();
    _finalDurationTextFieldController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['dtDiffStartDateTimeStr'] = _startDateTimeStr;
    map['dtDiffEndDateTimeStr'] = _endDateTimeStr;
    map['dtDiffDurationStr'] = _durationStr;
    map['dtDiffAddTimeStr'] = _addTimeStr;
    map['dtDiffFinalDurationStr'] = _finalDurationStr;

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

    Duration? finalDuration;
    Duration? addTimeDuration = DateTimeParser.parseHHmmDuration(_addTimeStr);

    if (addTimeDuration != null) {
      finalDuration = diffDuration + addTimeDuration;
    }

    setState(() {
      _durationStr = diffDuration.HHmm();
      _durationTextFieldController.text = _durationStr;
      _finalDurationStr = finalDuration?.HHmm() ?? '';
      _finalDurationTextFieldController.text = _finalDurationStr;
    });

    _updateTransferDataMap();
  }

  void _addPosOrNegTimeToCurrentDuration(

      /// Private method called when clicking on 'Add' button located at right
      /// of the 3 duration TextField's.
      BuildContext context,
      String dialogTimeStr) {
    Duration? dialogTimeDuration =
        DateTimeParser.parseHHmmDuration(dialogTimeStr);

    if (dialogTimeDuration == null) {
      openWarningDialog(context,
          'You entered an incorrectly formated (-)HH:mm time ($dialogTimeStr). Please retry !');
      return;
    } else {
      Duration? existingAddTimeDuration =
          DateTimeParser.parseHHmmDuration(_addTimeStr);

      if (existingAddTimeDuration == null) {
        existingAddTimeDuration = dialogTimeDuration;
      } else {
        existingAddTimeDuration += dialogTimeDuration;
      }

      Duration? startEndDateTimeDiffDuration =
          DateTimeParser.parseHHmmDuration(_durationStr);
      Duration? finalDuration;

      if (startEndDateTimeDiffDuration != null) {
        finalDuration = startEndDateTimeDiffDuration + existingAddTimeDuration;
      }

      setState(() {
        _addTimeStr = existingAddTimeDuration!.HHmm();
        _addTimeTextFieldController.text = _addTimeStr;
        _finalDurationStr = finalDuration?.HHmm() ?? '';
        _finalDurationTextFieldController.text = _finalDurationStr;
      });

      _updateTransferDataMap();
    }
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
                  Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: selectionColor,
                      ),
                    ),
                    child: DateTimePicker(
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
                  Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: selectionColor,
                      ),
                    ),
                    child: DateTimePicker(
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
                  Row(
                    children: [
                      SizedBox(
                        width: 55,
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
                            controller: _durationTextFieldController,
                            onChanged: (val) {
                              // called when manually updating the TextField
                              // content. Although we do not edit this field
                              // manually, onChanged must be defined aswell as
                              // the controller in order for pasting a value to
                              // the TextField to really modify the TextField
                              // value.
                              _durationTextFieldController.text = val;

                              // next two instructions required for the changes
                              // to be memorized in screen navigation transfer
                              // data
                              _durationStr = val;
                              _updateTransferDataMap();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55,
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
                            controller: _addTimeTextFieldController,
                            onChanged: (val) {
                              // called when manually updating the TextField
                              // content. Although we do not edit this field
                              // manually, onChanged must be defined aswell as
                              // the controller in order for pasting a value to
                              // the TextField to really modify the TextField
                              // value.
                              _addTimeTextFieldController.text = val;

                              // next two instructions required for the changes
                              // to be memorized in screen navigation transfer
                              // data
                              _addTimeStr = val;
                              _updateTransferDataMap();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55,
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
                            controller: _finalDurationTextFieldController,
                            onChanged: (val) {
                              // called when manually updating the TextField
                              // content. Although we do not edit this field
                              // manually, onChanged must be defined aswell as
                              // the controller in order for pasting a value to
                              // the TextField to really modify the TextField
                              // value.
                              _finalDurationTextFieldController.text = val;

                              // next two instructions required for the changes
                              // to be memorized in screen navigation transfer
                              // data
                              _finalDurationStr = val;
                              _updateTransferDataMap();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 90,
              child: Column(
                children: [
                  SizedBox(
                    height: 38,
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
                  SizedBox(
                    height: 32,
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
                  SizedBox(
                    height: 35,
                  ),
                  Tooltip(
                    message: 'Used to add positive or negative time.',
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: appElevatedButtonBackgroundColor,
                          shape: appElevatedButtonRoundedShape),
                      onPressed: () async {
                        final timeStr = await openTextInputDialog();
                        if (timeStr == null || timeStr.isEmpty) return;

                        _addPosOrNegTimeToCurrentDuration(context, timeStr);
                      },
                      child: const Text(
                        'Add',
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
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.fromLTRB(240, 404, 0, 0),
/*                child: ElevatedButton(
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
                ),*/
              ),
            ),
          ],
        ),
      ),
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
            decoration: const InputDecoration(hintText: '(-)HH:mm'),
            controller: _addTimeDialogController,
            onSubmitted: (_) => submit(),
            keyboardType: TextInputType.datetime,
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
