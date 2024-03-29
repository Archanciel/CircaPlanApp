import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/utils/utility.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/widgets/editable_duration.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';
import '../widgets/editable_duration_percent.dart';
import '../widgets/non_editable_date_time.dart';

class DateTimeDifferenceDuration extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;
  final TransferDataViewModel _transferDataViewModel;

  const DateTimeDifferenceDuration({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
    required TransferDataViewModel transferDataViewModel,
  })  : _screenNavigTransData = screenNavigTransData,
        _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  _DateTimeDifferenceDurationState createState() {
    return _DateTimeDifferenceDurationState(
        transferDataMap: _screenNavigTransData.transferDataMap,
        transferDataViewModel: _transferDataViewModel);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _DateTimeDifferenceDurationState extends State<DateTimeDifferenceDuration>
    with ScreenMixin {
  _DateTimeDifferenceDurationState(
      {required Map<String, dynamic> transferDataMap,
      required TransferDataViewModel transferDataViewModel})
      : _transferDataMap = transferDataMap,
        _transferDataViewModel = transferDataViewModel,
        _startDateTimeStr = transferDataMap['dtDiffStartDateTimeStr'] ??
            DateTime.now().toString(),
        _endDateTimeStr = transferDataMap['dtDiffEndDateTimeStr'] ??
            DateTime.now().toString(),
        _durationStr = transferDataMap['dtDiffDurationStr'] ?? '',
        _addTimeStr = transferDataMap['dtDiffAddTimeStr'] ?? '',
        _finalDurationStr = transferDataMap['dtDiffFinalDurationStr'] ?? '',
        _wakingAtDateTimeStr =
            transferDataMap['dtDiffWakingAtDateTimeStr'] ?? '',
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _startDateTimeStr = '';
  String _endDateTimeStr = '';
  String _durationStr = '';
  String _addTimeStr = '';
  String _finalDurationStr = '';
  String _wakingAtDateTimeStr = '';

  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;
  late TextEditingController _durationTextFieldController;
  late TextEditingController _addTimeDialogController;
  late TextEditingController _addTimeTextFieldController;
  late TextEditingController _finalDurationTextFieldController;
  late TextEditingController _wakingAtDateTimeController;

  late EditableDurationPercent _editableDurationPercentSleep;
  late EditableDurationPercent _editableDurationPercentTotal;

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
    _updateWidgets();

    // Re-enabling the next five lines of code no longer prevent
    // Undo to work since _editableDurationPercentWidget line
    // 135 has been commented out !
    if (_finalDurationStr.isNotEmpty) {
      _editableDurationPercentSleep.setDurationStr(_finalDurationStr);
      _editableDurationPercentTotal.setDurationStr(_finalDurationStr);
    } else {
      _editableDurationPercentSleep.setDurationStr(_durationStr);
      _editableDurationPercentTotal.setDurationStr(_durationStr);
    }

    _editableDurationPercentSleep.callSetState();
    _editableDurationPercentTotal.callSetState();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // The reference to the stateful widget State instance stored in
    // the transfer data map is used in the
    // _MainAppState.handleSelectedLoadFileName() method executed after
    // the file to load has been selected in the AppBar load ... sub menu
    // in order to call the current instance callSetState() method.
    _transferDataMap['currentScreenStateInstance'] = this;

    _updateWidgets();

    // The next instruction enables updating duration % value
    // when going back to the date time difference screen.
    // As a consequence, the duration % value does not need to
    // be stored in the transfer data map !
    String editableDurationPercentWidgetDurationStr =
        (_finalDurationStr.isNotEmpty) ? _finalDurationStr : _durationStr;

    _editableDurationPercentSleep = EditableDurationPercent(
      dateTimeTitle: 'Duration %',
      transferDataMapPercentKey: 'dtDurationPercentStr',
      durationStr: editableDurationPercentWidgetDurationStr,
      topSelMenuPosition: 343.0,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      handleChangeDurationFunction: (String _) => _,
    );

    _editableDurationPercentTotal = EditableDurationPercent(
      dateTimeTitle: 'Duration %',
      transferDataMapPercentKey: 'dtDurationTotalPercentStr',
      durationStr: editableDurationPercentWidgetDurationStr,
      topSelMenuPosition: 411.0,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      handleChangeDurationFunction: handleChangeDurationFunction,
    );
  }

  void _updateWidgets() {
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();

    _startDateTimeStr =
        _transferDataMap['dtDiffStartDateTimeStr'] ?? nowDateTimeStr;
    _startDateTimeController = TextEditingController(
        text: DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: _startDateTimeStr) ??
            '');
    _endDateTimeStr =
        _transferDataMap['dtDiffEndDateTimeStr'] ?? nowDateTimeStr;
    _endDateTimeController = TextEditingController(
        text: DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: _endDateTimeStr) ??
            '');
    _durationStr = _transferDataMap['dtDiffDurationStr'] ?? '';
    _durationTextFieldController = TextEditingController(text: _durationStr);
    _addTimeDialogController = TextEditingController();
    _addTimeStr = _transferDataMap['dtDiffAddTimeStr'] ?? '';
    _addTimeTextFieldController = TextEditingController(text: _addTimeStr);
    _finalDurationStr = _transferDataMap['dtDiffFinalDurationStr'] ?? '';
    _finalDurationTextFieldController =
        TextEditingController(text: _finalDurationStr);
    _wakingAtDateTimeStr =
        _transferDataMap['dtDiffWakingAtDateTimeStr'] ?? '20-11-2022 6:57';
    _wakingAtDateTimeController =
        TextEditingController(text: _wakingAtDateTimeStr);
  }

  @override
  void dispose() {
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    _durationTextFieldController.dispose();
    _addTimeDialogController.dispose();
    _addTimeTextFieldController.dispose();
    _finalDurationTextFieldController.dispose();
    _wakingAtDateTimeController.dispose();

    if (_transferDataMap['currentScreenStateInstance'] == this) {
      _transferDataMap['currentScreenStateInstance'] = null;
    }

    super.dispose();
  }

  _updateTransferDataMap() {
    _transferDataMap['dtDiffStartDateTimeStr'] = _startDateTimeStr;
    _transferDataMap['dtDiffEndDateTimeStr'] = _endDateTimeStr;
    _transferDataMap['dtDiffDurationStr'] = _durationStr;
    _transferDataMap['dtDiffAddTimeStr'] = _addTimeStr;
    _transferDataMap['dtDiffFinalDurationStr'] = _finalDurationStr;
    _transferDataMap['dtDiffWakingAtDateTimeStr'] = _wakingAtDateTimeStr;

    _transferDataViewModel.updateAndSaveTransferData();
  }

  /// Public method called when clicking on Main screen'Reset' button.
  void resetScreen() {
    _startDateTimeStr = '';
    _endDateTimeStr = '';
    _durationStr = '';
    _addTimeStr = '';
    _finalDurationStr = '';

    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();
    _startDateTimeStr = nowDateTimeStr;
    _startDateTimeController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: _startDateTimeStr) ??
            '';
    _durationStr = '';
    _durationTextFieldController.text = _durationStr;
    _editableDurationPercentSleep.setDurationStr(_durationStr);
    _editableDurationPercentTotal.setDurationStr(_durationStr);
    _addTimeStr = '';
    _addTimeTextFieldController.text = _addTimeStr;
    _finalDurationStr = '';
    _finalDurationTextFieldController.text = _finalDurationStr;
    _wakingAtDateTimeStr = '';
    _wakingAtDateTimeController.text = _wakingAtDateTimeStr;
    _endDateTimeStr = nowDateTimeStr;
    _endDateTimeController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                englishFormatDateTimeStr: _endDateTimeStr) ??
            '';

    setState(() {});

    _updateTransferDataMap();
  }

  /// Private method called each time one of the elements
  /// implied in calculating the Duration value is changed.
  void _setStateDiffDuration(_) {
    String frenchFormatStartDateTimeStr = _startDateTimeController.text;
    _startDateTimeStr =
        DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
                frenchFormatDateTimeStr: frenchFormatStartDateTimeStr) ??
            '';
    DateTime startDateTime =
        frenchDateTimeFormat.parse(frenchFormatStartDateTimeStr);
    String frenchFormatEndDateTimeStr = _endDateTimeController.text;
    _endDateTimeStr =
        DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
                frenchFormatDateTimeStr: frenchFormatEndDateTimeStr) ??
            '';
    DateTime endDateTime =
        frenchDateTimeFormat.parse(frenchFormatEndDateTimeStr);
    Duration diffDuration;

    if (endDateTime.isAfter(startDateTime)) {
      diffDuration = endDateTime.difference(startDateTime);
    } else {
      diffDuration = startDateTime.difference(endDateTime);
    }

    Duration? finalDuration;
    Duration? addTimeDuration = DateTimeParser.parseHHMMDuration(_addTimeStr);

    if (addTimeDuration != null) {
      finalDuration = diffDuration + addTimeDuration;
    }

    _durationStr = diffDuration.HHmm();
    _durationTextFieldController.text = _durationStr;
    _finalDurationStr = finalDuration?.HHmm() ?? '';
    _finalDurationTextFieldController.text = _finalDurationStr;

    // Re-enabling the next five lines of code no longer prevent
    // Undo to work since _editableDurationPercentWidget line
    // 145 has been commented out !
    if (_finalDurationStr.isNotEmpty) {
      _editableDurationPercentSleep.setDurationStr(_finalDurationStr);
      _editableDurationPercentTotal.setDurationStr(_finalDurationStr);
    } else {
      _editableDurationPercentSleep.setDurationStr(_durationStr);
      _editableDurationPercentTotal.setDurationStr(_durationStr);
    }

    setState(() {});

    _updateTransferDataMap();
  }

  void _addPosOrNegTimeToCurrentDuration(

      /// Private method called when clicking on 'Add' button located at right
      /// of the duration TextField.
      BuildContext context,
      String dialogTimeStr) {
    dialogTimeStr = Utility.formatStringDuration(
      durationStr: dialogTimeStr,
      removeMinusSign: false,
    );
    Duration? dialogTimeDuration =
        DateTimeParser.parseHHMMDuration(dialogTimeStr);

    if (dialogTimeDuration == null) {
      displayWarningDialog(context,
          'You entered an incorrectly formated (-)HH:mm time ($dialogTimeStr). Please retry !');
      return;
    } else {
      Duration? existingAddTimeDuration =
          DateTimeParser.parseHHMMDuration(_addTimeStr);

      if (existingAddTimeDuration == null) {
        existingAddTimeDuration = dialogTimeDuration;
      } else {
        existingAddTimeDuration += dialogTimeDuration;
      }

      Duration? startEndDateTimeDiffDuration =
          DateTimeParser.parseHHMMDuration(_durationStr);
      Duration? finalDuration;

      if (startEndDateTimeDiffDuration != null) {
        finalDuration = startEndDateTimeDiffDuration + existingAddTimeDuration;
      }

      _addTimeStr = existingAddTimeDuration.HHmm();
      _addTimeTextFieldController.text = _addTimeStr;
      _finalDurationStr = finalDuration?.HHmm() ?? '';
      _finalDurationTextFieldController.text = _finalDurationStr;

      _editableDurationPercentSleep.setDurationStr(_finalDurationStr);
      _editableDurationPercentTotal.setDurationStr(_finalDurationStr);

      setState(() {});

      _updateTransferDataMap();
    }
  }

  void _deleteAddedTimeDuration() {
    _addTimeStr = '';
    _addTimeTextFieldController.text = _addTimeStr;
    _finalDurationStr = '';
    _finalDurationTextFieldController.text = _finalDurationStr;

    _editableDurationPercentSleep.setDurationStr(_durationStr);
    _editableDurationPercentTotal.setDurationStr(_durationStr);

    setState(() {});

    _updateTransferDataMap();
  }

  void _handleSelectedStartDateTimeStr(String selectedDateTimeStr) {
    _startDateTimeController.text = selectedDateTimeStr;

    _setStateDiffDuration(selectedDateTimeStr);
  }

  void _handleSelectedEndDateTimeStr(String selectedDateTimeStr) {
    _endDateTimeController.text = selectedDateTimeStr;

    _setStateDiffDuration(selectedDateTimeStr);
  }

  void handleChangeDurationFunction(String durationStr) {
    String frenchFormatEndDateTimeStr = _endDateTimeController.text;
    DateTime endDateTime =
        frenchDateTimeFormat.parse(frenchFormatEndDateTimeStr);
    Duration? durationToAdd = DateTimeParser.parseHHMMDuration(durationStr);

    if (durationToAdd != null) {
      DateTime wakingAtDateTime = endDateTime.add(durationToAdd);
      _wakingAtDateTimeController.text =
          DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: wakingAtDateTime.toString()) ??
              '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    height: 15,
                  ),
                  EditableDateTime(
                    key: const Key('wakeUpDurationStartDateTimeKey'),
                    dateTimeTitle: 'Start date time',
                    dateTimePickerController: _startDateTimeController,
                    handleDateTimeModificationFunction: _setStateDiffDuration,
                    transferDataMap: _transferDataMap,
                    handleSelectedDateTimeStrFunction:
                        _handleSelectedStartDateTimeStr,
                    topSelMenuPosition: 135.0,
                    transferDataViewModel: _transferDataViewModel,
                    position: ToastGravity.TOP,
                  ),
                  EditableDateTime(
                    dateTimeTitle: 'End date time',
                    dateTimePickerController: _endDateTimeController,
                    handleDateTimeModificationFunction: _setStateDiffDuration,
                    transferDataMap: _transferDataMap,
                    handleSelectedDateTimeStrFunction:
                        _handleSelectedEndDateTimeStr,
                    topSelMenuPosition: 203.0,
                    transferDataViewModel: _transferDataViewModel,
                    position: ToastGravity.TOP,
                  ),
                  EditableDuration(
                    dateTimeTitle: 'Duration',
                    transferDataMap: _transferDataMap,
                    durationTextFieldController: _durationTextFieldController,
                    addTimeTextFieldController: _addTimeTextFieldController,
                    addTimeDialogController: _addTimeDialogController,
                    finalDurationTextFieldController:
                        _finalDurationTextFieldController,
                    addPosOrNegTimeToCurrentDurationFunction:
                        _addPosOrNegTimeToCurrentDuration,
                    deleteAddedTimeDurationFunction: _deleteAddedTimeDuration,
                    position: ToastGravity.TOP,
                  ),
                  _editableDurationPercentSleep,
                  _editableDurationPercentTotal,
                  NonEditableDateTime(
                    dateTimeTitle: 'Waking at',
                    dateTimeController: _wakingAtDateTimeController,
                    transferDataMap: _transferDataMap,
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
