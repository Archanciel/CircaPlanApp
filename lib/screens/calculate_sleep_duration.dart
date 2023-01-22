import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/utils/utility.dart';
import 'package:circa_plan/widgets/result_duration.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/utils/date_time_parser.dart';
import '../utils/date_time_computer.dart';
import '../constants.dart';
import '../widgets/circadian_flutter_toast.dart';
import '../widgets/non_editable_date_time.dart';

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
    with ScreenMixin, WidgetsBindingObserver {
  // adding the WidgetsBindingObserver as mixin enables
  // _CalculateSleepDurationState to be added as observer to WidgetsBinding
  // in overridden method initState {
  _CalculateSleepDurationState(
      {required Map<String, dynamic> transferDataMap,
      required TransferDataViewModel transferDataViewModel})
      : _transferDataMap = transferDataMap,
        _transferDataViewModel = transferDataViewModel,
        _newFrenchFormatDateTimeStr =
            transferDataMap['calcSlDurNewDateTimeStr'] ??
                ScreenMixin.frenchDateTimeFormat.format(DateTime.now()),
        _lastFrenchFormatDateTimeStr =
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

  String _newFrenchFormatDateTimeStr = '';
  String _lastFrenchFormatDateTimeStr = '';
  String _previousDateTimeStr = '';
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

  TextEditingController _newDateTimeController = TextEditingController();
  late TextEditingController _lastDateTimeController;
  late TextEditingController _previousDateTimeController;
  late TextEditingController _addTimeDialogController;
  late TextEditingController _currentSleepDurationController;
  late TextEditingController _currentWakeUpDurationController;
  late TextEditingController _currentTotalDurationController;
  late TextEditingController _currentSleepDurationPercentController;
  late TextEditingController _currentWakeUpDurationPercentController;
  late TextEditingController _currentTotalDurationPercentController;
  late TextEditingController _sleepWakeUpHistoryController;
  late TextEditingController _sleepDurationCommentController;

  late TextEditingController _currentSleepPrevDayTotalPercentController;
  late TextEditingController _currentWakeUpPrevDayTotalPercentController;
  late TextEditingController _currentTotalPrevDayTotalPercentController;
  late TextEditingController _prevDayTotalController;
  late TextEditingController _prevDayEmptyTotalController;

  TextEditingController _medicAlarmController = TextEditingController();

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

    return '$sleepTimeHistoryStr\n$wakeUpTimeHistoryStr';
  }

  void _computeSleepWakeUpPercentDuration() {
    int? currentSleepDurationMinutes;
    int? currentWakeUpDurationMinutes;
    int? currentTotalDurationMinutes;

    if (_currentSleepDurationStr.isNotEmpty) {
      currentSleepDurationMinutes =
          DateTimeParser.parseHHMMDuration(_currentSleepDurationStr)!.inMinutes;
    }

    if (_currentWakeUpDurationStr.isNotEmpty) {
      currentWakeUpDurationMinutes =
          DateTimeParser.parseHHMMDuration(_currentWakeUpDurationStr)!
              .inMinutes;
    }

    if (currentSleepDurationMinutes != null &&
        currentWakeUpDurationMinutes != null) {
      currentTotalDurationMinutes =
          currentSleepDurationMinutes + currentWakeUpDurationMinutes;

      final double currentSleepDurationPercent =
          currentSleepDurationMinutes * 100 / currentTotalDurationMinutes;
      _currentSleepDurationPercentStr =
          '${currentSleepDurationPercent.toStringAsFixed(1)} %';
      _currentSleepDurationPercentController.text =
          _currentSleepDurationPercentStr;

      final double currentWakeUpDurationPercent =
          currentWakeUpDurationMinutes * 100 / currentTotalDurationMinutes;
      _currentWakeUpDurationPercentStr =
          '${currentWakeUpDurationPercent.toStringAsFixed(1)} %';
      _currentWakeUpDurationPercentController.text =
          _currentWakeUpDurationPercentStr;

      _currentTotalDurationPercentStr = '100 %';
      _currentTotalDurationPercentController.text =
          _currentTotalDurationPercentStr;
    }

    if (_prevDayTotalWakeUpStr.isEmpty) {
      // the case if Date Time Difference Duration screen
      // duration has no value
      _prevDayTotalWakeUpStr = '00:01';
    }

    final int prevDayTotalWakeUpDurationInMinutes =
        DateTimeParser.parseHHMMDuration(_prevDayTotalWakeUpStr)!.inMinutes;

    if (currentSleepDurationMinutes != null) {
      final double currentSleepPrevDayTotalPercent =
          currentSleepDurationMinutes *
              100 /
              prevDayTotalWakeUpDurationInMinutes;
      _currentSleepPrevDayTotalPercentStr =
          '${currentSleepPrevDayTotalPercent.toStringAsFixed(1)} %';
      _currentSleepPrevDayTotalPercentController.text =
          _currentSleepPrevDayTotalPercentStr;
    }

    if (currentWakeUpDurationMinutes != null) {
      final double currentWakeUpPrevDayTotalPercent =
          currentWakeUpDurationMinutes *
              100 /
              prevDayTotalWakeUpDurationInMinutes;
      _currentWakeUpPrevDayTotalPercentStr =
          '${currentWakeUpPrevDayTotalPercent.toStringAsFixed(1)} %';
      _currentWakeUpPrevDayTotalPercentController.text =
          _currentWakeUpPrevDayTotalPercentStr;
    }

    if (currentTotalDurationMinutes != null) {
      final double currentTotalPrevDayTotalPercent =
          currentTotalDurationMinutes *
              100 /
              prevDayTotalWakeUpDurationInMinutes;
      _currentTotalPrevDayTotalPercentStr =
          '${currentTotalPrevDayTotalPercent.toStringAsFixed(1)} %';
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

  /// The method ensures that the current widget (screen or custom widget)
  /// setState() method is called in order for the loaded data are
  /// displayed. Calling this method is necessary since the load function
  /// is performed after selecting a item in a menu displayed by the AppBar
  /// menu defined not by the current screen, but by the main app screen.
  ///
  /// The method is called when the _MainAppState.handleSelectedLoadFileName()
  /// method is executed after the file to load has been selected in the
  /// AppBar load ... sub menu.
  void callSetState() {
    // setting isAfterLoading to true avoids saving the transfer data map
    // as well as updating the undo json file, two actions which are not
    // useful and would not impact the success of the Undo action.
    _updateWidgets(isAfterLoading: true);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // adding the instance as observer to WidgetsBinding.instance causes the
    // overridden method didChangeAppLifecycleState() to be called each time
    // the current screen is displayed and the app status is resumed.
    WidgetsBinding.instance.addObserver(this);

    _handleMedics();

    // The reference to the stateful widget State instance stored in
    // the transfer data map is used in the
    // _MainAppState.handleSelectedLoadFileName() method executed after
    // the file to load has been selected in the AppBar load ... sub menu
    // in order to call the current instance callSetState() method.
    _transferDataMap['currentScreenStateInstance'] = this;

    _updateWidgets();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // the case if the screen is active and the app is reselected
      _handleMedics();
    }
  }

  /// Called each time the CalculateSleepDuration screen is selected or the
  /// app showing the CalculateSleepDuration screen resumes.
  void _handleMedics() {
    String? medicFrenchDateTimeStr = _transferDataMap['alarmMedicDateTimeStr'];

    if (_isAlarmToDisplay(medicFrenchDateTimeStr)) {
      setState(() {}); // not working on S8, i.e alarm medic code
      //                  not applied, I don't know why ! But once
      //                  I click on Now button, the alarm is displayed.
      // CircadianFlutterToast.showToast(
      //     message: "MEDICS AT $medicHHmmTimeStr O'CLOCK ?",
      //     backgroundColor: ScreenMixin.APP_WARNING_COLOR);
    }
  }

  bool _isAlarmToDisplay(String? medicFrenchDateTimeStr) {
    if (medicFrenchDateTimeStr == null || medicFrenchDateTimeStr == '') {
      // the case if the transferDataMap does not contain
      // the 'alarmMedicDateTimeStr' entry.
      return false;
    }

    String savedJsonFileName = getSaveAsFileName(
      transferDataMap: _transferDataMap,
      transferDataViewModel: _transferDataViewModel,
    );

    String transferDataJsonFilePathName =
        '$kDownloadAppDir${Platform.pathSeparator}$savedJsonFileName';

    if (Utility.fileExist(transferDataJsonFilePathName)) {
      // the case if loading the previous day json file at
      // a time which would cause the alarm to be displayed,
      // for example before 10:00 if the alarm time is 6:00.
      return false;
    }

    DateTime alarmDateTime = frenchDateTimeFormat.parse(medicFrenchDateTimeStr);
    DateTime alarmDateTimeMinusOneHour = DateTime(
        alarmDateTime.year,
        alarmDateTime.month,
        alarmDateTime.day,
        alarmDateTime.hour,
        alarmDateTime.minute - 60);
    DateTime alarmDateTimePlusFourHour = DateTime(
        alarmDateTime.year,
        alarmDateTime.month,
        alarmDateTime.day,
        alarmDateTime.hour,
        alarmDateTime.minute + 240);

    DateTime now = DateTime.now();

    bool result = now.isAfter(alarmDateTimeMinusOneHour) &&
        now.isBefore(alarmDateTimePlusFourHour);

    if (result) {
      _medicAlarmController.text =
          "MEDICS AT ${medicFrenchDateTimeStr.split(' ').last} ?";
    }

    return result;
  }

  void _updateWidgets({bool isAfterLoading = false}) {
    final DateTime dateTimeNow = DateTime.now();
    String nowFrenchDateTimeStr =
        ScreenMixin.frenchDateTimeFormat.format(dateTimeNow);

    _status = _transferDataMap['calcSlDurStatus'] ?? Status.wakeUp;
    _newFrenchFormatDateTimeStr =
        _transferDataMap['calcSlDurNewDateTimeStr'] ?? nowFrenchDateTimeStr;
    _newDateTimeController =
        TextEditingController(text: _newFrenchFormatDateTimeStr);
    _lastFrenchFormatDateTimeStr =
        _transferDataMap['calcSlDurPreviousDateTimeStr'] ?? '';
    _lastDateTimeController =
        TextEditingController(text: _lastFrenchFormatDateTimeStr);

    // setting _beforePreviousDateTimeStr value here fixes a
    // bug which happens when switching to another screen and
    // back to this screen !
    _previousDateTimeStr =
        _transferDataMap['calcSlDurBeforePreviousDateTimeStr'] ?? '';
    _previousDateTimeController =
        TextEditingController(text: _previousDateTimeStr);

    _currentSleepDurationStr =
        _transferDataMap['calcSlDurCurrSleepDurationStr'] ?? '';
    _currentSleepDurationController =
        TextEditingController(text: _currentSleepDurationStr);
    _currentWakeUpDurationStr =
        _transferDataMap['calcSlDurCurrWakeUpDurationStr'] ?? '';
    _currentWakeUpDurationController =
        TextEditingController(text: _currentWakeUpDurationStr);
    _currentTotalDurationStr =
        _transferDataMap['calcSlDurCurrTotalDurationStr'] ?? '';
    _currentTotalDurationController =
        TextEditingController(text: _currentTotalDurationStr);
    _currentSleepDurationPercentStr =
        _transferDataMap['calcSlDurCurrSleepDurationPercentStr'] ?? '';
    _currentSleepDurationPercentController =
        TextEditingController(text: _currentSleepDurationPercentStr);
    _currentWakeUpDurationPercentStr =
        _transferDataMap['calcSlDurCurrWakeUpDurationPercentStr'] ?? '';
    _currentWakeUpDurationPercentController =
        TextEditingController(text: _currentWakeUpDurationPercentStr);
    _currentTotalDurationPercentStr =
        _transferDataMap['calcSlDurCurrTotalDurationPercentStr'] ?? '';
    _currentTotalDurationPercentController =
        TextEditingController(text: _currentTotalDurationPercentStr);
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
    _prevDayTotalWakeUpStr = _transferDataMap['dtDiffFinalDurationStr'] ?? '';

    if (_prevDayTotalWakeUpStr.isEmpty) {
      _prevDayTotalWakeUpStr = _transferDataMap['dtDiffDurationStr'] ?? '00:01';
    }

    _prevDayTotalController =
        TextEditingController(text: _prevDayTotalWakeUpStr);
    _prevDayEmptyTotalController = TextEditingController(text: '');

    _medicAlarmController = TextEditingController(text: '');

    _sleepTimeStrHistory =
        _transferDataMap['calcSlDurSleepTimeStrHistory'] ?? [];
    _wakeUpTimeStrHistory =
        _transferDataMap['calcSlDurWakeUpTimeStrHistory'] ?? [];

    _computeSleepWakeUpPercentDuration();

    _sleepWakeUpHistoryController =
        TextEditingController(text: _buildSleepWakeUpHistoryStr());

    _sleepDurationCommentController = TextEditingController(
        text: _transferDataMap['sleepDurationCommentStr'] ?? '');
    _sleepDurationCommentController.selection =
        TextSelection.fromPosition(const TextPosition(offset: 0));

    _updateTransferDataMap(isAfterLoading: isAfterLoading);
  }

  @override
  void dispose() {
    _newDateTimeController.dispose();
    _lastDateTimeController.dispose();
    _previousDateTimeController.dispose();
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
    _medicAlarmController.dispose();
    _sleepDurationCommentController.dispose();

    if (_transferDataMap['currentScreenStateInstance'] == this) {
      _transferDataMap['currentScreenStateInstance'] = null;
    }

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap({
    bool isAfterLoading = false,
  }) {
    Map<String, dynamic> map = _transferDataMap;

    map['calcSlDurNewDateTimeStr'] = _newFrenchFormatDateTimeStr;
    map['calcSlDurPreviousDateTimeStr'] = _lastFrenchFormatDateTimeStr;
    map['calcSlDurBeforePreviousDateTimeStr'] = _previousDateTimeStr;
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

    // addfing a new line improves Comment last line display
    String sleepDurationCommentStr =
        '${_sleepDurationCommentController.text.trim()}\n';
    map['sleepDurationCommentStr'] = sleepDurationCommentStr;
    _sleepDurationCommentController.text = sleepDurationCommentStr;

    if (!isAfterLoading) {
      // necessary so that Undo works. In case of executing
      // _updateTransferDataMap() after a json file was loaded, the
      // calling _updateTransferDataMap() is not useful.
      _transferDataViewModel.updateAndSaveTransferData();
    }

    return map;
  }

  void _incDecNewDateTimeMinute(
      {required BuildContext context, required int minuteNb}) {
    /// Private method called each time the '+' or '-' button
    /// is pressed.
    DateTime? newDateTime;

    newDateTime =
        // parsing _newDateTimeController.text instead of _newDateTimeStr
        // enables the user to edit the New date time TextField and then
        // click on the + or - button with + or - to be implemented on
        // the edited value.
        //
        // Example:
        // click on Now -> 01-01-2023 16:31. Then edit it to 01-01-2023 16:00.
        // Then click on - button -> 01-01-2023 15:59 and not 01-01-2023 16:30 !
        DateTimeParser.parseDDMMYYYYDateTime(_newDateTimeController.text);

    if (newDateTime == null) {
      displayWarningDialog(context,
          'You are trying to increase/decrease an incorrectly formated dd-MM-yyyy HH:mm new date time ($_newFrenchFormatDateTimeStr). Please correct it and retry !');
      return;
    }

    if (minuteNb > 0) {
      newDateTime = newDateTime.subtract(Duration(minutes: -minuteNb));
    } else {
      newDateTime = newDateTime.add(Duration(minutes: minuteNb));
    }

    _newFrenchFormatDateTimeStr =
        ScreenMixin.frenchDateTimeFormat.format(newDateTime);

    _newDateTimeController.text = _newFrenchFormatDateTimeStr;

    setState(() {});

    _updateTransferDataMap();
  }

  /// Public method called when clicking on Main screen'Reset' button.
  void resetScreen() {
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
  void _applyReset(BuildContext _, String __) {
    // before resetting the current New date time string, its
    // value, which is the last wake up time, is copied to the
    // 2nd screen start date time map entry.
    //
    // Since when adding a date time for the first time also sets
    // the 2nd screen End date time to this added date time, the
    // 2nd screen will compute the previous wake day duration.
    _transferDataMap['dtDiffStartDateTimeStr'] =
        DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
            frenchFormatDateTimeStr: _newFrenchFormatDateTimeStr);

    _newFrenchFormatDateTimeStr =
        ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
    _newDateTimeController.text = _newFrenchFormatDateTimeStr;
    _lastFrenchFormatDateTimeStr = '';
    _lastDateTimeController.text = _lastFrenchFormatDateTimeStr;
    _previousDateTimeStr = '';
    _previousDateTimeController.text = _previousDateTimeStr;
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
    _sleepDurationCommentController.text = '';
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

  /// Private method called when clicking on 'Add' button located at right of
  /// new date time TextField.
  void _handleAddNewDateTimeButton(BuildContext context) {
    DateTime? newDateTime;

    _newFrenchFormatDateTimeStr = _newDateTimeController.text;
    newDateTime =
        DateTimeParser.parseDDMMYYYYDateTime(_newFrenchFormatDateTimeStr);

    if (newDateTime == null) {
      displayWarningDialog(context,
          'You entered an incorrectly formated dd-MM-yyyy HH:mm new date time ($_newFrenchFormatDateTimeStr). Please correct it and retry !');
      return;
    }

    if (_status == Status.wakeUp) {
      if (_lastFrenchFormatDateTimeStr == '') {
        // first click on 'Add' button after reinitializing
        // or restarting the app
        String newDateTimeStr =
            ScreenMixin.frenchDateTimeFormat.format(newDateTime);
        _addFirstDateTimeStrToHistorylst(_sleepTimeStrHistory, newDateTimeStr);

        _lastFrenchFormatDateTimeStr = newDateTimeStr;
        _lastDateTimeController.text = _lastFrenchFormatDateTimeStr;

        // Setting the 2nd screen End date time to the first
        // added date time makes sense since when resetting this
        // screen, the 2nd screen Start date time was set to the
        // current 3rd screen New date time value.
        String secondScreenEnglishFormatEndDateTimeStr =
            DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
                    frenchFormatDateTimeStr: newDateTimeStr) ??
                '';
        _transferDataMap['dtDiffEndDateTimeStr'] =
            secondScreenEnglishFormatEndDateTimeStr;

        // Having set the 2nd screen End date time, it is now
        // necessary to compute the resulting duration for two
        // purposes:
        //
        //  1/ to update the 2nd screen duration value which
        //     represents the previous day wake
        //     up duration value and
        //  2/ to set the current 3rd screen previous day wake
        //     up duration value
        String secondScreenEnglishFormatStartDateTimeStr = _transferDataMap[
                'dtDiffStartDateTimeStr'] ??
            secondScreenEnglishFormatEndDateTimeStr; // the secondScreenEnglishFormatStartDateTimeStr
        //                     is null in the case the app is started with the
        //                     circadian dir containing no circadian.json file

        DateTime secondScreenStartDateTime = ScreenMixin.englishDateTimeFormat
            .parse(secondScreenEnglishFormatStartDateTimeStr);
        DateTime secondScreenEndDateTime = ScreenMixin.englishDateTimeFormat
            .parse(secondScreenEnglishFormatEndDateTimeStr);
        Duration diffDuration =
            secondScreenEndDateTime.difference(secondScreenStartDateTime);
        String secondScreenDurationStr = diffDuration.HHmm();
        _transferDataMap['dtDiffDurationStr'] = secondScreenDurationStr;

        _prevDayTotalWakeUpStr = secondScreenDurationStr;
        _prevDayTotalController.text = _prevDayTotalWakeUpStr;
        _prevDayEmptyTotalController = TextEditingController(text: '');

        _status = Status.sleep;
      } else {
        DateTime? previousDateTime;

        previousDateTime = ScreenMixin.frenchDateTimeFormat
            .parse(_lastFrenchFormatDateTimeStr);

        if (!_validateNewDateTime(newDateTime, previousDateTime)) {
          return;
        }

        if (_wakeUpTimeStrHistory.isEmpty ||
            !isDateTimeStrValid(_wakeUpTimeStrHistory.first)) {
          // here, registering the first wake up time duration and ensuring
          // that the wake up time history list first item is the date time
          // when I waked up, i.e the _previousDateTimeStr
          _addFirstDateTimeStrToHistorylst(
              _wakeUpTimeStrHistory, _lastFrenchFormatDateTimeStr);
        }

        Duration wakeUpDuration = newDateTime.difference(previousDateTime);

        Duration? currentWakeUpDuration =
            DateTimeParser.parseHHMMDuration(_currentWakeUpDurationStr);

        if (currentWakeUpDuration == null) {
          currentWakeUpDuration = wakeUpDuration;
/*          if (_wakeUpTimeStrHistory.isEmpty) {
            _wakeUpTimeStrHistory.add(_previousDateTimeStr);
          } */
        } else {
          currentWakeUpDuration += wakeUpDuration;
        }

        Duration? currentTotalDuration =
            DateTimeParser.parseHHMMDuration(_currentTotalDurationStr);

        if (currentTotalDuration == null) {
          currentTotalDuration = currentWakeUpDuration;
        } else {
          currentTotalDuration += wakeUpDuration;
        }

        _currentWakeUpDurationStr = currentWakeUpDuration.HHmm();
        _currentWakeUpDurationController.text = _currentWakeUpDurationStr;
        _currentTotalDurationStr = currentTotalDuration.HHmm();
        _currentTotalDurationController.text = _currentTotalDurationStr;
        _previousDateTimeStr = _lastFrenchFormatDateTimeStr;
        _previousDateTimeController.text = _previousDateTimeStr;
        _lastFrenchFormatDateTimeStr = _newFrenchFormatDateTimeStr;
        _lastDateTimeController.text = _lastFrenchFormatDateTimeStr;
        _status = Status.sleep;
        _wakeUpTimeStrHistory.add(wakeUpDuration.HHmm());
        _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();
      }
    } else {
      // status == status.sleep
      DateTime? previousDateTime;

      previousDateTime =
          ScreenMixin.frenchDateTimeFormat.parse(_lastFrenchFormatDateTimeStr);

      if (!_validateNewDateTime(newDateTime, previousDateTime)) {
        return;
      }

      Duration sleepDuration = newDateTime.difference(previousDateTime);

      Duration? currentSleepDuration =
          DateTimeParser.parseHHMMDuration(_currentSleepDurationStr);

      if (currentSleepDuration == null) {
        currentSleepDuration = sleepDuration;
      } else {
        currentSleepDuration += sleepDuration;
      }

      Duration? currentTotalDuration =
          DateTimeParser.parseHHMMDuration(_currentTotalDurationStr);

      if (currentTotalDuration == null) {
        currentTotalDuration = currentSleepDuration;
      } else {
        currentTotalDuration += sleepDuration;
      }

      _currentSleepDurationStr = currentSleepDuration.HHmm();
      _currentSleepDurationController.text = _currentSleepDurationStr;
      _currentTotalDurationStr = currentTotalDuration.HHmm();
      _currentTotalDurationController.text = _currentTotalDurationStr;
      _previousDateTimeStr = _lastFrenchFormatDateTimeStr;
      _previousDateTimeController.text = _previousDateTimeStr;
      _lastFrenchFormatDateTimeStr = _newFrenchFormatDateTimeStr;
      _lastDateTimeController.text = _lastFrenchFormatDateTimeStr;
      _sleepTimeStrHistory.add(sleepDuration.HHmm());
      _sleepWakeUpHistoryController.text = _buildSleepWakeUpHistoryStr();
      _status = Status.wakeUp;
    }

    _computeSleepWakeUpPercentDuration();

    _updateTransferDataMap();
    setState(() {});
  }

  bool _validateNewDateTime(DateTime newDateTime, DateTime previousDateTime) {
    if (newDateTime.isBefore(previousDateTime)) {
      displayWarningDialog(context,
          'New date time can\'t be before previous date time ($_newFrenchFormatDateTimeStr < $_lastFrenchFormatDateTimeStr). Please increase it and retry !');
      return false;
    }

    if (newDateTime == previousDateTime) {
      displayWarningDialog(context,
          'New date time can\'t be equal to previous date time ($_newFrenchFormatDateTimeStr = $_lastFrenchFormatDateTimeStr). Please increase it and retry !');
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

  /// Private method called when clicking on 'Add' button located at right
  /// of current sleep duration TextField.
  void _addTimeToCurrentSleepAndWakeUpDuration(
    BuildContext context,
    String durationStr,
  ) {
    durationStr = Utility.formatStringDuration(
      durationStr: durationStr,
      removeMinusSign: false,
    );
    Duration? addDuration = DateTimeParser.parseHHMMDuration(durationStr);

    if (addDuration == null) {
      displayWarningDialog(context,
          'You entered an incorrectly formated HH:mm time ($durationStr). Please retry !');
      return;
    } else {
      Duration? currentSleepDuration =
          DateTimeParser.parseHHMMDuration(_currentSleepDurationStr);
      Duration? currentWakeUpDuration =
          DateTimeParser.parseHHMMDuration(_currentWakeUpDurationStr);
      Duration? currentTotalDuration =
          DateTimeParser.parseHHMMDuration(_currentTotalDurationStr);

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

      _computeSleepWakeUpPercentDuration();

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
                          cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                        ),
                      ),
                      child: GestureDetector(
                        child: TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          style: valueTextStyle,
                          // prevents displaying copy paste menu !
                          toolbarOptions: const ToolbarOptions(
                              copy: false,
                              paste: false,
                              cut: false,
                              selectAll: false),
                          keyboardType: TextInputType.datetime,
                          controller: _newDateTimeController, // links the
                          //                         TextField content to pressing
                          //                         the button 'Now'. '+' or '-'
                        ),
                        onDoubleTap: () async {
                          await copyToClipboard(
                            context: context,
                            controller: _newDateTimeController,
                            extractHHmmFromCopiedStr: true,
                            position: ToastGravity.TOP,
                          );
                          _transferDataMap['clipboardLastAction'] =
                              ClipboardLastAction.copy;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kVerticalFieldDistance,
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
                                // cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                              ),
                            ),
                            child: NonEditableDateTime(
                              dateTimeTitle: 'Last date time',
                              dateTimeController: _lastDateTimeController,
                              transferDataMap: _transferDataMap,
                              position: ToastGravity.TOP,
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
                                // cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                              ),
                            ),
                            child: NonEditableDateTime(
                              dateTimeTitle: 'Previous date time',
                              dateTimeController: _previousDateTimeController,
                              transferDataMap: _transferDataMap,
                              position: ToastGravity.TOP,
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
                    transferDataMap: _transferDataMap,
                    resultDurationController: _currentSleepDurationController,
                    resultDurationPercentController:
                        _currentSleepDurationPercentController,
                    previousDayPercentTitle: 'Prev day %',
                    prevDayTotalPercentController:
                        _currentSleepPrevDayTotalPercentController,
                    prevDayTotalController: _prevDayTotalController,
                    position: ToastGravity.TOP,
                  ),
                  ResultDuration(
                    resultDurationTitle: 'Wake up duration',
                    transferDataMap: _transferDataMap,
                    resultDurationController: _currentWakeUpDurationController,
                    resultDurationPercentController:
                        _currentWakeUpDurationPercentController,
                    prevDayTotalPercentController:
                        _currentWakeUpPrevDayTotalPercentController,
                    prevDayTotalController: _prevDayEmptyTotalController,
                  ),
                  ResultDuration(
                    resultDurationTitle: 'Total duration',
                    transferDataMap: _transferDataMap,
                    resultDurationController: _currentTotalDurationController,
                    resultDurationPercentController:
                        _currentTotalDurationPercentController,
                    prevDayTotalPercentController:
                        _currentTotalPrevDayTotalPercentController,
                    prevDayTotalController: _prevDayEmptyTotalController,
                  ),
                  Tooltip(
                    message: 'Simple click copies HH:mm to clipboard',
                    child: Text(
                      'Sleep and wake up history',
                      style: labelTextStyle,
                    ),
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
                          // cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                        ),
                      ),
                      child: TextField(
                        maxLines: null, // must be set, otherwise multi lines
                        //                 not displayed
                        style: valueTextStyle,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        controller: _sleepWakeUpHistoryController,
                        readOnly: true,
                        // prevents displaying copy paste menu !
                        toolbarOptions: const ToolbarOptions(
                            copy: false,
                            paste: false,
                            cut: false,
                            selectAll: false),
                        onTap: () async {
                          await copyToClipboardHHmmExtractedFromHistoryDuration(
                              context: context,
                              controller: _sleepWakeUpHistoryController);
                          _transferDataMap['clipboardLastAction'] =
                              ClipboardLastAction.copy;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _isAlarmToDisplay(_transferDataMap['alarmMedicDateTimeStr'])
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 455,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: alarmTextStyle,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        ScreenMixin.APP_ROUNDED_BOARDER_RADIUS,
                                      ),
                                    ),
                                    // required for contentPadding to be fully
                                    // applied
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    filled: true,
                                    fillColor: ScreenMixin.APP_WARNING_COLOR,
                                  ),
                                  controller: _medicAlarmController,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        appWarningButtonBackgroundColor,
                                    shape: appElevatedButtonRoundedShape),
                                onPressed: () {
                                  String? alarmMedicDateTimeStr =
                                      _transferDataMap['alarmMedicDateTimeStr'];

                                  if (alarmMedicDateTimeStr == null) {
                                    return;
                                  }

                                  String alarmFrenchDateTimeStr = DateTimeComputer
                                      .computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                                    alarmHHmmTimeStr:
                                        alarmMedicDateTimeStr.split(' ').last,
                                    setToTomorrow: true,
                                  );

                                  CircadianFlutterToast.showToast(
                                    message: alarmFrenchDateTimeStr,
                                    position: ToastGravity.BOTTOM,
                                  );

                                  _transferDataMap['alarmMedicDateTimeStr'] =
                                      alarmFrenchDateTimeStr;
                                  _transferDataViewModel
                                      .updateAndSaveTransferData();
                                  setState(() {});
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    padding:
                        const EdgeInsets.fromLTRB(0, 450, 0, 0), // val 450 =
//                                                               // 430 + 20
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comment',
                          style: labelTextStyle,
                        ),
                        const SizedBox(
                          height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
                        ),
                        Focus(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            autofocus: false,
                            style: valueTextStyle,
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            controller: _sleepDurationCommentController,
                          ),
                          onFocusChange: (bool value) {
                            // neither onSubmitted nor onEditingComplete
                            // work on multiline TextField !!!
                            if (!value) {
                              // value bis false if clicking outside the
                              // textField.
                              _updateTransferDataMap();
                            }
                          },
                        ),
                      ],
                    ),
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
                          String dateTimeStr = ScreenMixin.frenchDateTimeFormat
                              .format(DateTime.now());
                          _newDateTimeController.text = dateTimeStr;
                          _newFrenchFormatDateTimeStr = dateTimeStr;

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
                              color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
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
                              color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
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
                        onPressed: () => _handleAddNewDateTimeButton(context),
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
                        message: 'Add siesta or sleep reduction time',
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: appElevatedButtonBackgroundColor,
                              shape: appElevatedButtonRoundedShape),
                          onPressed: () async {
                            final timeStr = await openAddTimeDialog(
                                context: context,
                                addTimeController: _addTimeDialogController);
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

  Future<void> copyToClipboardHHmmExtractedFromHistoryDuration(
      {required BuildContext context,
      required TextEditingController controller,
      bool extractHHmmFromCopiedStr = false}) async {
    String historyStr = controller.text;
    String extractedHHmm = Utility.extractHHmmAtPosition(
      dataStr: historyStr,
      pos: controller.selection.start,
    );

    await Clipboard.setData(ClipboardData(text: extractedHHmm));

    CircadianFlutterToast.showToast(message: '$extractedHHmm to clipboard');
  }
}
