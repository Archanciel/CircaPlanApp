import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/widgets/result_duration.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';

import '../constants.dart';

// Although defined in ScreenMixin, must be defined here since it is used in the
// constructor where accessing to mixin data is not possible !
final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

class CalculateSleepDuration extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;
  final TransferDataViewModel _transferDataViewModel;

  const CalculateSleepDuration({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
    required TransferDataViewModel transferDataViewModel,
  })  : _screenNavigTransData = screenNavigTransData,
        _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  _CalculateSleepDurationState createState() {
    return _CalculateSleepDurationState(
        transferDataMap: _screenNavigTransData.transferDataMap,
        transferDataViewModel: _transferDataViewModel);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _CalculateSleepDurationState extends State<CalculateSleepDuration>
    with ScreenMixin {
  _CalculateSleepDurationState(
      {required Map<String, dynamic> transferDataMap,
      required TransferDataViewModel transferDataViewModel})
      : _transferDataMap = transferDataMap,
        _transferDataViewModel = transferDataViewModel,
        _newDateTimeStr = transferDataMap['calcSlDurNewDateTimeStr'] ??
            frenchDateTimeFormat.format(DateTime.now()),
        _previousDateTimeStr =
            transferDataMap['calcSlDurPreviousDateTimeStr'] ?? '',
        _currentSleepDurationStr =
            transferDataMap['calcSlDurCurrSleepDurationStr'] ?? '',
        _currentWakeUpDurationStr =
            transferDataMap['calcSlDurCurrWakeUpDurationStr'] ?? '',
        _currentTotalDurationStr =
            transferDataMap['calcSlDurCurrTotalDurationStr'] ?? '',
        _currentSleepDurationPercentStr =
            transferDataMap['calcSlDurCurrSleepDurationPercentStr'] ?? '',
        _currentWakeUpDurationPercentStr =
            transferDataMap['calcSlDurCurrWakeUpDurationPercentStr'] ?? '',
        _currentTotalDurationPercentStr =
            transferDataMap['calcSlDurCurrTotalDurationPercentStr'] ?? '',
        _status = transferDataMap['calcSlDurStatus'] ?? Status.wakeUp,
        _sleepTimeStrHistory =
            transferDataMap['calcSlDurSleepTimeStrHistory'] ?? [],
        _wakeUpTimeStrHistory =
            transferDataMap['calcSlDurWakeUpTimeStrHistory'] ?? [],
        _currentSleepPrevDayTotalPercentStr =
            transferDataMap['calcSlDurCurrSleepPrevDayTotalPercentStr'] ?? '',
        _currentWakeUpPrevDayTotalPercentStr =
            transferDataMap['calcSlDurCurrWakeUpPrevDayTotalPercentStr'] ?? '',
        _currentTotalPrevDayTotalPercentStr =
            transferDataMap['calcSlDurCurrTotalPrevDayTotalPercentStr'] ?? '',
        super();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _newDateTimeStr = '';
  String _previousDateTimeStr = '';
  String _beforePreviousDateTimeStr = '';
  String _currentSleepDurationStr = '';
  String _currentWakeUpDurationStr = '';
  String _currentTotalDurationStr = '';
  String _currentSleepDurationPercentStr = '';
  String _currentWakeUpDurationPercentStr = '';
  String _currentTotalDurationPercentStr = '';
  Status _status = Status.wakeUp;
  List<String> _sleepTimeStrHistory = [];
  List<String> _wakeUpTimeStrHistory = [];

  String _currentSleepPrevDayTotalPercentStr;
  String _currentWakeUpPrevDayTotalPercentStr;
  String _currentTotalPrevDayTotalPercentStr;
  String _prevDayTotalWakeUpStr = '';

  late TextEditingController _newDateTimeController;
  late TextEditingController _previousDateTimeController;
  late TextEditingController _beforePreviousDateTimeController;
  late TextEditingController _addTimeDialogController;
  late TextEditingController _currentSleepDurationController;
  late TextEditingController _currentWakeUpDurationController;
  late TextEditingController _currentTotalDurationController;
  late TextEditingController _currentSleepDurationPercentController;
  late TextEditingController _currentWakeUpDurationPercentController;
  late TextEditingController _currentTotalDurationPercentController;
  late TextEditingController _sleepWakeUpHistoryController;

  late TextEditingController _currentSleepPrevDayTotalPercentController;
  late TextEditingController _currentWakeUpPrevDayTotalPercentController;
  late TextEditingController _currentTotalPrevDayTotalPercentController;
  late TextEditingController _prevDayTotalController;
  late TextEditingController _prevDayEmptyTotalController;

  String _buildSleepWakeUpHistoryStr() {
    List<String>? sleepTimeHistoryLst =
        _transferDataMap['calcSlDurSleepTimeStrHistory'];
    List<String>? wakeUpTimeHistoryLst =
        _transferDataMap['calcSlDurWakeUpTimeStrHistory'];

    String sleepTimeHistoryStr = '';

    if (sleepTimeHistoryLst != null) {
      if (sleepTimeHistoryLst.length >= 2) {
        String firstSleepTimeHistoryLstItem = sleepTimeHistoryLst.first;

        if (isDateTimeStrValid(firstSleepTimeHistoryLstItem)) {
          sleepTimeHistoryStr =
              'Sleep ${_removeYear(firstSleepTimeHistoryLstItem)}: ${sleepTimeHistoryLst.sublist(1).join(', ')}';
        }
      }
    }

    String wakeUpTimeHistoryStr = '';

    if (wakeUpTimeHistoryLst != null) {
      if (wakeUpTimeHistoryLst.length == 1) {
        // the case if the add siesta button with negative value was pressed
        // before adding any wake up time
      } else if (wakeUpTimeHistoryLst.length >= 2) {
        wakeUpTimeHistoryStr =
            'Wake ${_removeYear(wakeUpTimeHistoryLst.first)}: ${wakeUpTimeHistoryLst.sublist(1).join(', ')}';
      }
    }

    _computeSleepWakeUpPercentDuration();

    return '$sleepTimeHistoryStr\n$wakeUpTimeHistoryStr';
  }

  void _computeSleepWakeUpPercentDuration() {
    if (_currentSleepDurationStr.isNotEmpty &&
        _currentWakeUpDurationStr.isNotEmpty) {
      final int currentSleepDurationMinutes =
          DateTimeParser.parseHHmmDuration(_currentSleepDurationStr)!.inMinutes;
      final int currentWakeUpDurationMinutes =
          DateTimeParser.parseHHmmDuration(_currentWakeUpDurationStr)!
              .inMinutes;
      final int currentTotalDurationMinutes =
          currentSleepDurationMinutes + currentWakeUpDurationMinutes;
      final double currentSleepDurationPercent =
          currentSleepDurationMinutes * 100 / currentTotalDurationMinutes;
      final double currentWakeUpDurationPercent =
          currentWakeUpDurationMinutes * 100 / currentTotalDurationMinutes;
      _currentSleepDurationPercentStr =
          '${currentSleepDurationPercent.toStringAsFixed(1)} %';
      _currentWakeUpDurationPercentStr =
          '${currentWakeUpDurationPercent.toStringAsFixed(1)} %';
      _currentTotalDurationPercentStr = '100 %';
      _currentSleepDurationPercentController.text =
          _currentSleepDurationPercentStr;
      _currentWakeUpDurationPercentController.text =
          _currentWakeUpDurationPercentStr;
      _currentTotalDurationPercentController.text =
          _currentTotalDurationPercentStr;

      _currentSleepPrevDayTotalPercentController.text =
          _currentSleepPrevDayTotalPercentStr;
      _currentWakeUpPrevDayTotalPercentController.text =
          _currentWakeUpPrevDayTotalPercentStr;
      _currentTotalPrevDayTotalPercentController.text =
          _currentTotalPrevDayTotalPercentStr;
    }
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
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = frenchDateTimeFormat.format(dateTimeNow);

    _newDateTimeController = TextEditingController(
        text: _transferDataMap['calcSlDurNewDateTimeStr'] ?? nowDateTimeStr);
    _previousDateTimeController = TextEditingController(
        text: _transferDataMap['calcSlDurPreviousDateTimeStr'] ?? '');
    _beforePreviousDateTimeController = TextEditingController(
        text: _transferDataMap['calcSlDurBeforePreviousDateTimeStr'] ?? '');
    _currentSleepDurationController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrSleepDurationStr'] ?? '');
    _currentWakeUpDurationController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrWakeUpDurationStr'] ?? '');
    _currentTotalDurationController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrTotalDurationStr'] ?? '');
    _currentSleepDurationPercentController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrSleepDurationPercentStr'] ?? '');
    _currentWakeUpDurationPercentController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrWakeUpDurationPercentStr'] ?? '');
    _currentTotalDurationPercentController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrTotalDurationPercentStr'] ?? '');
    _addTimeDialogController = TextEditingController();
    _currentSleepPrevDayTotalPercentController = TextEditingController(
        text:
            _transferDataMap['calcSlDurCurrSleepPrevDayTotalPercentStr'] ?? '');
    _currentWakeUpPrevDayTotalPercentController = TextEditingController(
        text: _transferDataMap['calcSlDurCurrWakeUpPrevDayTotalPercentStr'] ??
            '');
    _currentTotalPrevDayTotalPercentController = TextEditingController(
        text:
            _transferDataMap['calcSlDurCurrTotalPrevDayTotalPercentStr'] ?? '');
    _prevDayTotalController = TextEditingController(
        text:
            _transferDataMap['calcSlDurPrevDayTotalWakeUpStr'] ?? '25:25');
    _prevDayEmptyTotalController = TextEditingController(
        text: '');
    _prevDayTotalWakeUpStr = '25:25';
    _sleepWakeUpHistoryController =
        TextEditingController(text: _buildSleepWakeUpHistoryStr());
  }

  @override
  void dispose() {
    _newDateTimeController.dispose();
    _previousDateTimeController.dispose();
    _beforePreviousDateTimeController.dispose();
    _currentSleepDurationController.dispose();
    _currentWakeUpDurationController.dispose();
    _currentTotalDurationController.dispose();
    _currentSleepDurationPercentController.dispose();
    _currentWakeUpDurationPercentController.dispose();
    _currentTotalDurationPercentController.dispose();
    _addTimeDialogController.dispose();
    _sleepWakeUpHistoryController.dispose();
    _currentSleepPrevDayTotalPercentController.dispose();
    _currentWakeUpPrevDayTotalPercentController.dispose();
    _currentTotalPrevDayTotalPercentController.dispose();
    _prevDayTotalController.dispose();
    _prevDayEmptyTotalController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['calcSlDurNewDateTimeStr'] = _newDateTimeStr;
    map['calcSlDurPreviousDateTimeStr'] = _previousDateTimeStr;
    map['calcSlDurBeforePreviousDateTimeStr'] = _beforePreviousDateTimeStr;
    map['calcSlDurCurrSleepDurationStr'] = _currentSleepDurationStr;
    map['calcSlDurCurrWakeUpDurationStr'] = _currentWakeUpDurationStr;
    map['calcSlDurCurrTotalDurationStr'] = _currentTotalDurationStr;
    map['calcSlDurCurrSleepDurationPercentStr'] =
        _currentSleepDurationPercentStr;
    map['calcSlDurCurrWakeUpDurationPercentStr'] =
        _currentWakeUpDurationPercentStr;
    map['calcSlDurCurrTotalDurationPercentStr'] =
        _currentTotalDurationPercentStr;
    map['calcSlDurStatus'] = _status;
    map['calcSlDurSleepTimeStrHistory'] = _sleepTimeStrHistory;
    map['calcSlDurWakeUpTimeStrHistory'] = _wakeUpTimeStrHistory;
    map['calcSlDurCurrSleepPrevDayTotalPercentStr'] =
        _currentSleepPrevDayTotalPercentStr;
    map['calcSlDurCurrWakeUpPrevDayTotalPercentStr'] =
        _currentWakeUpPrevDayTotalPercentStr;
    map['calcSlDurCurrTotalPrevDayTotalPercentStr'] =
        _currentTotalPrevDayTotalPercentStr;

    _buildSleepWakeUpHistoryStr();

    _transferDataViewModel.updateAndSaveTransferData();

    return map;
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

    _newDateTimeStr = dateTimeStr;

    setState(() {});

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

    _newDateTimeController.text = _newDateTimeStr;

    setState(() {});

    _updateTransferDataMap();
  }

  /// Private method called when clicking on 'Reset' button.
  void _resetScreen() {
    String okButtonStr = 'Ok';
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context, 'Cancel'),
    );
    Widget okButton = TextButton(
      child: Text(okButtonStr),
      onPressed: () => Navigator.pop(context, okButtonStr),
    );

    showAlertDialog(
      buttonList: [cancelButton, okButton],
      dialogTitle: 'WARNING - Reset will erase everything',
      dialogContent: 'Click on Cancel to avoid resetting',
      okValueStr: okButtonStr,
      okFunction: _applyReset,
      context: context,
    );
  }

  /// Private method called when 'Reset' is confirmed.
  void _applyReset() {
    // before resetting the current new date time string, its
    // value, which is the last wake up time, is copied to the
    // date time difference duration start date time map entry.
    // The effect is not updating the screen field, but adding
    // the value to the Sel available values.
    _transferDataMap['dtDiffStartDateTimeStr'] = _newDateTimeStr;

    _newDateTimeStr = frenchDateTimeFormat.format(DateTime.now());
    _newDateTimeController.text = _newDateTimeStr;
    _previousDateTimeStr = '';
    _previousDateTimeController.text = _previousDateTimeStr;
    _beforePreviousDateTimeStr = '';
    _beforePreviousDateTimeController.text = _beforePreviousDateTimeStr;
    _currentSleepDurationStr = '';
    _currentSleepDurationController.text = _currentSleepDurationStr;
    _currentWakeUpDurationStr = '';
    _currentWakeUpDurationController.text = _currentWakeUpDurationStr;
    _currentTotalDurationStr = '';
    _currentTotalDurationController.text = _currentTotalDurationStr;
    _currentSleepDurationPercentStr = '';
    _currentSleepDurationPercentController.text =
        _currentSleepDurationPercentStr;
    _currentWakeUpDurationPercentStr = '';
    _currentWakeUpDurationPercentController.text =
        _currentWakeUpDurationPercentStr;
    _currentTotalDurationPercentStr = '';
    _currentTotalDurationPercentController.text =
        _currentTotalDurationPercentStr;
    _status = Status.wakeUp;
    _sleepTimeStrHistory = [];
    _wakeUpTimeStrHistory = [];
    _sleepWakeUpHistoryController.text = '';

    _currentSleepPrevDayTotalPercentStr = '';
    _currentSleepPrevDayTotalPercentController.text =
        _currentSleepPrevDayTotalPercentStr;
    _currentWakeUpPrevDayTotalPercentStr = '';
    _currentWakeUpPrevDayTotalPercentController.text =
        _currentWakeUpPrevDayTotalPercentStr;
    _currentTotalPrevDayTotalPercentStr = '';
    _currentTotalPrevDayTotalPercentController.text =
        _currentTotalPrevDayTotalPercentStr;
    _prevDayTotalController.text = _prevDayTotalWakeUpStr;
    _prevDayEmptyTotalController.text = '';

    setState(() {});

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

        // Without using applying ! bang operator to the newDateTime variable,
        // the compiler displays this error: 'The argument type 'DateTime?'
        // can't be assigned to the parameter type DateTime
        _previousDateTimeStr = newDateTimeStr;
        _previousDateTimeController.text = _previousDateTimeStr;
        _status = Status.sleep;

        setState(() {});
      } else {
        DateTime? previousDateTime;

        previousDateTime = frenchDateTimeFormat.parse(_previousDateTimeStr);

        if (!_validateNewDateTime(newDateTime, previousDateTime)) {
          return;
        }

        if (_wakeUpTimeStrHistory.isEmpty ||
            !isDateTimeStrValid(_wakeUpTimeStrHistory.first)) {
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

        Duration? currentTotalDuration =
            DateTimeParser.parseHHmmDuration(_currentTotalDurationStr);

        if (currentTotalDuration == null) {
          currentTotalDuration = currentWakeUpDuration;
        } else {
          currentTotalDuration += wakeUpDuration;
        }

        _currentWakeUpDurationStr = currentWakeUpDuration.HHmm();
        _currentWakeUpDurationController.text = _currentWakeUpDurationStr;
        _currentTotalDurationStr = currentTotalDuration.HHmm();
        _currentTotalDurationController.text = _currentTotalDurationStr;
        _beforePreviousDateTimeStr = _previousDateTimeStr;
        _beforePreviousDateTimeController.text = _beforePreviousDateTimeStr;
        _previousDateTimeStr = _newDateTimeStr;
        _previousDateTimeController.text = _previousDateTimeStr;
        _status = Status.sleep;
        _wakeUpTimeStrHistory.add(wakeUpDuration.HHmm());
        _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();

        setState(() {});
      }
    } else {
      // status == status.sleep
      DateTime? previousDateTime;

      previousDateTime = frenchDateTimeFormat.parse(_previousDateTimeStr);

      if (!_validateNewDateTime(newDateTime, previousDateTime)) {
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

      Duration? currentTotalDuration =
          DateTimeParser.parseHHmmDuration(_currentTotalDurationStr);

      if (currentTotalDuration == null) {
        currentTotalDuration = currentSleepDuration;
      } else {
        currentTotalDuration += sleepDuration;
      }

      _currentSleepDurationStr = currentSleepDuration.HHmm();
      _currentSleepDurationController.text = _currentSleepDurationStr;
      _currentTotalDurationStr = currentTotalDuration.HHmm();
      _currentTotalDurationController.text = _currentTotalDurationStr;
      _beforePreviousDateTimeStr = _previousDateTimeStr;
      _beforePreviousDateTimeController.text = _beforePreviousDateTimeStr;
      _previousDateTimeStr = _newDateTimeStr;
      _previousDateTimeController.text = _previousDateTimeStr;
      _sleepTimeStrHistory.add(sleepDuration.HHmm());
      _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();
      _status = Status.wakeUp;

      setState(() {});
    }

    _updateTransferDataMap();
  }

  bool _validateNewDateTime(DateTime newDateTime, DateTime previousDateTime) {
    if (newDateTime.isBefore(previousDateTime)) {
      openWarningDialog(context,
          'New date time can\'t be before previous date time ($_newDateTimeStr < $_previousDateTimeStr). Please increase it and retry !');
      return false;
    }

    if (newDateTime == previousDateTime) {
      openWarningDialog(context,
          'New date time can\'t be equal to previous date time ($_newDateTimeStr = $_previousDateTimeStr). Please increase it and retry !');
      return false;
    }

    return true;
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
      Duration? currentTotalDuration =
          DateTimeParser.parseHHmmDuration(_currentTotalDurationStr);

      if (durationStr.contains('-')) {
        if (currentWakeUpDuration == null) {
          currentWakeUpDuration = -addDuration;
        } else {
          currentWakeUpDuration -= addDuration;
        }
      } else {
        if (currentTotalDuration == null) {
          currentTotalDuration = addDuration;
        } else {
          currentTotalDuration += addDuration;
        }
      }

      currentSleepDuration =
          _addDurationToCurrentSleepDuration(currentSleepDuration, addDuration);

      if (durationStr.contains('-')) {
        _currentWakeUpDurationStr = currentWakeUpDuration!.HHmm();
        _currentWakeUpDurationController.text = _currentWakeUpDurationStr;
        _wakeUpTimeStrHistory.add(durationStr.replaceFirst('-', ''));
      }

      _currentSleepDurationStr = currentSleepDuration.HHmm();
      _currentSleepDurationController.text = _currentSleepDurationStr;
      _currentTotalDurationStr =
          (currentTotalDuration != null) ? currentTotalDuration.HHmm() : '';
      _currentTotalDurationController.text = _currentTotalDurationStr;
      _sleepTimeStrHistory.add(durationStr);
      _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();

      setState(() {});

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
    final screenHeight = MediaQuery.of(context).size.height;

    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: ScreenMixin.app_computed_vertical_top_margin),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
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
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0), // val 5 is
//                                            compliant with current value 5 of
//                                            APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          cursorColor: ScreenMixin.appTextAndIconColor,
                        ),
                      ),
                      child: TextField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        style: valueTextStyle,
                        keyboardType: TextInputType.datetime,
                        controller: _newDateTimeController, // links the
                        //                         TextField content to pressing
                        //                         the button 'Now'. '+' or '-'
                        onChanged: (val) {
                          // called when manually updating the TextField
                          // content or when pasting
                          _setStateNewDateTimeDependentFields(val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kVerticalFieldDistance,
                  ),
                  Row(
                    children: [
                      Text(
                        'Previous date time',
                        style: labelTextStyle,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Date time before prev',
                        style: labelTextStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(0, 5, 0, 0), // val 5 is
//                                            compliant with current value 5 of
//                                            APP_LABEL_TO_TEXT_DISTANCE
                        child: SizedBox(
                          width: 156,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: selectionColor,
                                // commenting cursorColor discourage manually
                                // editing the TextField !
                                // cursorColor: ScreenMixin.appTextAndIconColor,
                              ),
                            ),
                            child: TextField(
                              style: valueTextStyle,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              controller: _previousDateTimeController,
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(0, 5, 0, 0), // val 5 is
                        //                                            compliant with current value 5 of
                        //                                            APP_LABEL_TO_TEXT_DISTANCE
                        child: SizedBox(
                          width: 155,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: selectionColor,
                                // commenting cursorColor discourage manually
                                // editing the TextField !
                                // cursorColor: ScreenMixin.appTextAndIconColor,
                              ),
                            ),
                            child: TextField(
                              style: valueTextStyle,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              controller: _beforePreviousDateTimeController,
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: kVerticalFieldDistance,
                  ),
                  ResultDuration(
                    resultDurationTitle: 'Sleep duration',
                    resultDurationController: _currentSleepDurationController,
                    resultDurationPercentController:
                        _currentSleepDurationPercentController,
                    previousDayPercentTitle: 'Prev day %',
                    prevDayTotalPercentController:
                        _currentSleepPrevDayTotalPercentController,
                    prevDayTotalController: _prevDayTotalController,
                  ),
                  ResultDuration(
                    resultDurationTitle: 'Wake up duration',
                    resultDurationController: _currentWakeUpDurationController,
                    resultDurationPercentController:
                        _currentWakeUpDurationPercentController,
                    prevDayTotalPercentController:
                        _currentWakeUpPrevDayTotalPercentController,
                    prevDayTotalController: _prevDayEmptyTotalController,
                  ),
                  ResultDuration(
                    resultDurationTitle: 'Total duration',
                    resultDurationController: _currentTotalDurationController,
                    resultDurationPercentController:
                        _currentTotalDurationPercentController,
                    prevDayTotalPercentController:
                        _currentTotalPrevDayTotalPercentController,
                    prevDayTotalController: _prevDayEmptyTotalController,
                  ),
                  Text(
                    'Sleep and wake up history',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0), // val 5 is
//                                            compliant with current value 5 of
//                                            APP_LABEL_TO_TEXT_DISTANCE
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: selectionColor,
                          // commenting cursorColor discourage manually
                          // editing the TextField !
                          // cursorColor: ScreenMixin.appTextAndIconColor,
                        ),
                      ),
                      child: TextField(
                        maxLines: null, // must be set, otherwise multi lines
//                                         not displayed
                        style: valueTextStyle,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        controller: _sleepWakeUpHistoryController,
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight *
                  ScreenMixin.APP_VERTICAL_TOP_RESET_BUTTON_MARGIN_PROPORTION,
            ),
            ResetButton(
              onPress: _resetScreen,
            ),
            Positioned(
              right: 0,
              top: -4,
              child: Column(
                children: [
                  Text(
                    _statusStr(_status),
                    style: labelTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 160,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          String dateTimeStr =
                              frenchDateTimeFormat.format(DateTime.now());
                          _newDateTimeController.text = dateTimeStr;
                          _newDateTimeStr = dateTimeStr;

                          setState(() {});
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
                            icon: const Icon(
                              Icons.add,
                              color: ScreenMixin.appTextAndIconColor,
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
                            icon: const Icon(
                              Icons.remove,
                              color: ScreenMixin.appTextAndIconColor,
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
                    height: 89,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 265,
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
                ],
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
