import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';

enum Status { wakeUp, sleep }

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
    with ScreenMixin, WidgetsBindingObserver {
    // adding the WidgetsBindingObserver as mixin enables 
    // _CalculateSleepDurationState to be added as observer to WidgetsBinding
    // in overridden method initState
  _CalculateSleepDurationState(Map<String, dynamic> transferDataMap)
      : _transferDataMap = transferDataMap,
        _newDateTimeStr = transferDataMap['calcSlDurNewDateTimeStr'] ??
            frenchDateTimeFormat.format(DateTime.now()),
        _previousDateTimeStr =
            transferDataMap['calcSlDurPreviousDateTimeStr'] ?? '',
        _currentSleepDurationStr =
            transferDataMap['calcSlDurCurrSleepDurationStr'] ?? '',
        _currentWakeUpDurationStr =
            transferDataMap['calcSlDurCurrWakeUpDurationStr'] ?? '',
        _status = transferDataMap['calcSlDurStatus'] ?? Status.wakeUp,
        _sleepTimeStrHistory =
            transferDataMap['calcSlDurSleepTimeStrHistory'] ?? [],
        _wakeUpTimeStrHistory =
            transferDataMap['calcSlDurWakeUpTimeStrHistory'] ?? [],
        super();

  Map<String, dynamic> _transferDataMap;

  String _newDateTimeStr = '';
  String _previousDateTimeStr = '';
  String _currentSleepDurationStr = '';
  String _currentWakeUpDurationStr = '';
  Status _status = Status.wakeUp;
  List<String> _sleepTimeStrHistory = [];
  List<String> _wakeUpTimeStrHistory = [];

  late TextEditingController _newDateTimeController;
  late TextEditingController _previousDateTimeController;
  late TextEditingController _addTimeDialogController;
  late TextEditingController _currentSleepDurationController;
  late TextEditingController _currentWakeUpDurationController;
  late TextEditingController _sleepWakeUpHistoryController;

  String _buildSleepWakeUpHistoryStr() {
    List<String>? sleepTimeHistoryLst =
        _transferDataMap['calcSlDurSleepTimeStrHistory'];
    List<String>? wakeUpTimeHistoryLst =
        _transferDataMap['calcSlDurWakeUpTimeStrHistory'];

    String sleepTimeHistoryStr = '';

    if (sleepTimeHistoryLst != null) {
      if (sleepTimeHistoryLst.length >= 2) {
        String firstSleepTimeHistoryLstItem = sleepTimeHistoryLst.first;

        if (_isDateTimeStr(firstSleepTimeHistoryLstItem)) {
          sleepTimeHistoryStr = 'Sleep ' +
              _removeYear(firstSleepTimeHistoryLstItem) +
              ': ' +
              sleepTimeHistoryLst.sublist(1).join(', ');
        }
      }
    }

    String wakeUpTimeHistoryStr = '';

    if (wakeUpTimeHistoryLst != null) {
      if (wakeUpTimeHistoryLst.length == 1) {
        // the case if the add siesta button with negative value was pressed
        // before adding any wake up time
      } else if (wakeUpTimeHistoryLst.length >= 2) {
        wakeUpTimeHistoryStr = 'Wake ' +
            _removeYear(wakeUpTimeHistoryLst.first) +
            ': ' +
            wakeUpTimeHistoryLst.sublist(1).join(', ');
      }
    }

    return sleepTimeHistoryStr + '\n' + wakeUpTimeHistoryStr;
  }

  String _removeYear(dateTimeStr) {
    List<String> dateTimeStrLst = dateTimeStr.split(' ');
    List<String> dateStrLst = dateTimeStrLst.first.split('-');

    String dateTimeNoYearStr =
        '${dateStrLst.sublist(0, 2).join('-')} ${dateTimeStrLst.last}';

    return dateTimeNoYearStr;
  }

  @override
  void initState() {
    super.initState();

    // adding the instance as observer to WidgetsBinding.instance causes the
    // overridden method didChangeAppLifecycleState() to be called each time
    // the current screen ststus changes
    WidgetsBinding.instance.addObserver(this);

    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = frenchDateTimeFormat.format(dateTimeNow);

    _newDateTimeController = TextEditingController(
        text: _transferDataMap['calcSlDurNewDateTimeStr'] ?? nowDateTimeStr);
    _previousDateTimeController = TextEditingController(
        text: _transferDataMap['calcSlDurPreviousDateTimeStr'] ?? '');
    _currentSleepDurationController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrSleepDurationStr'] ?? '');
    _currentWakeUpDurationController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrWakeUpDurationStr'] ?? '');
    _addTimeDialogController = TextEditingController();
    _sleepWakeUpHistoryController =
        TextEditingController(text: _buildSleepWakeUpHistoryStr());

    _handleMedics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // the case when the current screen is selected or, if the screen is
      // active, when the app is reselected
      _handleMedics();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _newDateTimeController.dispose();
    _previousDateTimeController.dispose();
    _currentSleepDurationController.dispose();
    _currentWakeUpDurationController.dispose();
    _addTimeDialogController.dispose();
    _sleepWakeUpHistoryController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['calcSlDurNewDateTimeStr'] = _newDateTimeStr;
    map['calcSlDurPreviousDateTimeStr'] = _previousDateTimeStr;
    map['calcSlDurCurrSleepDurationStr'] = _currentSleepDurationStr;
    map['calcSlDurCurrWakeUpDurationStr'] = _currentWakeUpDurationStr;
    map['calcSlDurStatus'] = _status;
    map['calcSlDurSleepTimeStrHistory'] = _sleepTimeStrHistory;
    map['calcSlDurWakeUpTimeStrHistory'] = _wakeUpTimeStrHistory;

    _buildSleepWakeUpHistoryStr();
    //  print('sleepTimeStrHistory: $_sleepTimeStrHistory');
    //  print('wakeUpTimeStrHistory: $_wakeUpTimeStrHistory');

    return map;
  }

  void _handleMedics() {
    /// Called each time the CalculateSleepDuration screen is selected or the
    /// app showing the CalculateSleepDuration screen resumes. Handles the
    /// medics to take display, i.e. changing the screen body color in the
    /// situation the medics have not yet been taken although the hour of taking
    /// them is passed or near.
    print('_handleMedics() called');
  }

  void _setStateNewDateTimeDependentFields(String dateTimeStr) {
    /// Private method called each time the New date time TextField
    /// is nanually modified.

    /// dateTimeStr format is not validated here in order to avoid preventing
    /// new date time manual modification. The new date time string format will
    /// be validated right before it is used.
    DateTime dateTime;

    // reformatting the entered dateTimeStr in order for the previous date time
    // string to be set at a fully conform format. For eample, if the user
    // entered 23-05-2022 2:57, dateTimeStr is reformated to 23-05-2022 02:57.
    // In case of FormatException, nothing is done (see method description).
    try {
      dateTime = frenchDateTimeFormat.parse(dateTimeStr);
      dateTimeStr = frenchDateTimeFormat.format(dateTime);
    } on FormatException catch (_) {}

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
        _previousDateTimeController.text = _previousDateTimeStr;
        _currentSleepDurationStr = '';
        _currentSleepDurationController.text = _currentSleepDurationStr;
        _currentWakeUpDurationStr = '';
        _currentWakeUpDurationController.text = _currentWakeUpDurationStr;
        _status = Status.wakeUp;
        _sleepTimeStrHistory = [];
        _wakeUpTimeStrHistory = [];
        _sleepWakeUpHistoryController.text = '';
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

    if (_status == Status.wakeUp) {
      if (_previousDateTimeStr == '') {
        // first click on 'Add' button after reinitializing
        // or restarting the app
        String newDateTimeStr = frenchDateTimeFormat.format(newDateTime);
        _addFirstDateTimeStrToHistorylst(_sleepTimeStrHistory, newDateTimeStr);

        setState(
          () {
            // Without using applying ! bang operator to the newDateTime variable,
            // the compiler displays this error: 'The argument type 'DateTime?'
            // can't be assigned to the parameter type DateTime
            _previousDateTimeStr = newDateTimeStr;
            _previousDateTimeController.text = _previousDateTimeStr;
            _status = Status.sleep;
          },
        );
      } else {
        DateTime? previousDateTime;

        previousDateTime = frenchDateTimeFormat.parse(_previousDateTimeStr);

        if (newDateTime.isBefore(previousDateTime)) {
          openWarningDialog(context,
              'New date time can\'t be before previous date time ($_newDateTimeStr < $_previousDateTimeStr). Please increase it and retry !');
          return;
        }

        if (_wakeUpTimeStrHistory.isEmpty ||
            !_isDateTimeStr(_wakeUpTimeStrHistory.first)) {
          // here, registering the first wake up time duration and ensuring
          // that the wake up time history list first item is the date time
          // when I waked up, i.e the _previousDateTimeStr
          _addFirstDateTimeStrToHistorylst(
              _wakeUpTimeStrHistory, _previousDateTimeStr);
        }

        Duration wakeUpDuration = newDateTime.difference(previousDateTime);

        Duration? currentWakeUpDuration =
            DateTimeParser.parseHHmmDuration(_currentWakeUpDurationStr);

        if (currentWakeUpDuration == null) {
          currentWakeUpDuration = wakeUpDuration;
/*          if (_wakeUpTimeStrHistory.isEmpty) {
            _wakeUpTimeStrHistory.add(_previousDateTimeStr);
          } */
        } else {
          currentWakeUpDuration += wakeUpDuration;
        }

        setState(() {
          _currentWakeUpDurationStr = currentWakeUpDuration!.HHmm();
          _currentWakeUpDurationController.text = _currentWakeUpDurationStr;
          _previousDateTimeStr = _newDateTimeStr;
          _previousDateTimeController.text = _previousDateTimeStr;
          _status = Status.sleep;
          _wakeUpTimeStrHistory.add(wakeUpDuration.HHmm());
          _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();
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
        _currentSleepDurationController.text = _currentSleepDurationStr;
        _previousDateTimeStr = _newDateTimeStr;
        _previousDateTimeController.text = _previousDateTimeStr;
        _sleepTimeStrHistory.add(sleepDuration.HHmm());
        _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();
        _status = Status.wakeUp;
      });
    }
    _updateTransferDataMap();
  }

  bool _isDateTimeStr(String str) {
    return str.contains('-');
  }

  void _addFirstDateTimeStrToHistorylst(

      /// This method handle two situations:
      ///   1/ if the first sleep duration is to be added to an empty sleep time
      ///      history list
      ///   2/ if a siesto duration was added before adding any sleep time
      ///      duration. In this case, the date time string must be inserted
      ///      at the first position in the history list.
      List<String> historyLst,
      String dateTimeStr) {
    if (historyLst.isEmpty) {
      historyLst.add(dateTimeStr);
    } else {
      // the case if add siesto duration was done before adding any sleep
      // duration
      historyLst.insert(0, dateTimeStr);
    }
  }

  void _addTimeToCurrentSleepAndWakeUpDuration(
      BuildContext context, String durationStr) {
    /// Private method called when clicking on 'Add' button located at right
    /// of current sleep duration TextField.

    Duration? addDuration = DateTimeParser.parseHHmmDuration(durationStr);

    if (addDuration == null) {
      openWarningDialog(context,
          'You entered an incorrectly formated HH:mm time ($durationStr). Please retry !');
      return;
    } else {
      Duration? currentSleepDuration =
          DateTimeParser.parseHHmmDuration(_currentSleepDurationStr);
      Duration? currentWakeUpDuration =
          DateTimeParser.parseHHmmDuration(_currentWakeUpDurationStr);

      if (durationStr.contains('-')) {
        if (currentWakeUpDuration == null) {
          currentWakeUpDuration = -addDuration;
        } else {
          currentWakeUpDuration -= addDuration;
        }

        currentSleepDuration = _addDurationToCurrentSleepDuration(
            currentSleepDuration, addDuration);
      } else {
        currentSleepDuration = _addDurationToCurrentSleepDuration(
            currentSleepDuration, addDuration);
      }

      setState(() {
        if (durationStr.contains('-')) {
          _currentWakeUpDurationStr = currentWakeUpDuration!.HHmm();
          _currentWakeUpDurationController.text = _currentWakeUpDurationStr;
          _wakeUpTimeStrHistory.add(durationStr.replaceFirst('-', ''));
        }

        _currentSleepDurationStr = currentSleepDuration!.HHmm();
        _currentSleepDurationController.text = _currentSleepDurationStr;
        _sleepTimeStrHistory.add(durationStr);
        _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();
      });

      _updateTransferDataMap();
    }
  }

  Duration _addDurationToCurrentSleepDuration(
      Duration? currentSleepDuration, Duration duration) {
    if (currentSleepDuration == null) {
      currentSleepDuration = duration;
    } else {
      currentSleepDuration += duration;
    }

    return currentSleepDuration;
  }

  String _statusStr(Status enumStatus) {
    if (enumStatus == Status.wakeUp) {
      return 'Wake Up';
    } else if (enumStatus == Status.sleep) {
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
                  horizontal: 15,
                  vertical: ScreenMixin.app_computed_vertical_top_margin),
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
                      fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
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
                                fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                                fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                            keyboardType: TextInputType.datetime,
                            controller: _newDateTimeController, // links the
                            //                                                TextField content to pressing
                            //                                                the button 'Now'. '+' or '-'
                            onChanged: (val) {
                              // called when manually updating the TextField
                              // content or when pasting
                              _setStateNewDateTimeDependentFields(val);
                            },
                          ),
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
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
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
                            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
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
                      fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: selectionColor,
                              // commenting cursorColor discourage manually
                              // editing the TextField !
                              // cursorColor: appTextAndIconColor,
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(
                                color: appTextAndIconColor,
                                fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                                fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            keyboardType: TextInputType.datetime,
                            controller: _previousDateTimeController,
                            onChanged: (val) {
                              // called when manually updating the TextField
                              // content. Although we do not edit this field
                              // manually, onChanged must be defined aswell as
                              // the controller in order for pasting a value to
                              // the TextField to really modify the TextField
                              // value.
                              _previousDateTimeController.text = val;

                              // next two instructions required for the changes
                              // to be memorized in screen navigation transfer
                              // data
                              _previousDateTimeStr = val;
                              _updateTransferDataMap();
                            },
                          ),
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
                      fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: selectionColor,
                              // commenting cursorColor discourage manually
                              // editing the TextField !
                              // cursorColor: appTextAndIconColor,
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(
                                color: appTextAndIconColor,
                                fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                                fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            keyboardType: TextInputType.datetime,
                            controller: _currentSleepDurationController,
                            onChanged: (val) {
                              // called when manually updating the TextField
                              // content. Although we do not edit this field
                              // manually, onChanged must be defined aswell as
                              // the controller in order for pasting a value to
                              // the TextField to really modify the TextField
                              // value.
                              _currentSleepDurationController.text = val;

                              // next two instructions required for the changes
                              // to be memorized in screen navigation transfer
                              // data
                              _currentSleepDurationStr = val;
                              _updateTransferDataMap();
                            },
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Add siesta or sleep reduction time.',
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: appElevatedButtonBackgroundColor,
                              shape: appElevatedButtonRoundedShape),
                          onPressed: () async {
                            final timeStr = await openTextInputDialog();
                            if (timeStr == null || timeStr.isEmpty) return;

                            _addTimeToCurrentSleepAndWakeUpDuration(
                                context, timeStr);
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                            ),
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
                      fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: selectionColor,
                              // commenting cursorColor discourage manually
                              // editing the TextField !
                              // cursorColor: appTextAndIconColor,
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(
                                color: appTextAndIconColor,
                                fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                                fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            keyboardType: TextInputType.datetime,
                            controller: _currentWakeUpDurationController,
                            onChanged: (val) {
                              // called when manually updating the TextField
                              // content. Although we do not edit this field
                              // manually, onChanged must be defined aswell as
                              // the controller in order for pasting a value to
                              // the TextField to really modify the TextField
                              // value.
                              _currentWakeUpDurationController.text = val;

                              // next two instructions required for the changes
                              // to be memorized in screen navigation transfer
                              // data
                              _currentWakeUpDurationStr = val;
                              _updateTransferDataMap();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Sleep and wake up history',
                    style: TextStyle(
                      color: appLabelColor,
                      fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: selectionColor,
                        // commenting cursorColor discourage manually
                        // editing the TextField !
                        // cursorColor: appTextAndIconColor,
                      ),
                    ),
                    child: TextField(
                      maxLines: null,
                      minLines: 3,
                      style: TextStyle(
                          color: appTextAndIconColor,
                          fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                          fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                      decoration: const InputDecoration.collapsed(hintText: ''),
                      keyboardType: TextInputType.datetime,
                      controller: _sleepWakeUpHistoryController,
                    ),
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
                    fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
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
            margin: const EdgeInsets.fromLTRB(265, 0, 0, 88),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () => _resetScreen(),
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
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
                fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
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
