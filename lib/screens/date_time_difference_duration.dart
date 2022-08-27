import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/utils/utility.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/widgets/editable_duration.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/utils/date_time_parser.dart';

import '../widgets/editable_duration_percent.dart';

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
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

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
  }

  void _updateWidgets() {
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();

    _startDateTimeStr =
        _transferDataMap['dtDiffStartDateTimeStr'] ?? nowDateTimeStr;
    _startDateTimeController = TextEditingController(text: _startDateTimeStr);
    _endDateTimeStr =
        _transferDataMap['dtDiffEndDateTimeStr'] ?? nowDateTimeStr;
    _endDateTimeController = TextEditingController(text: _endDateTimeStr);
    _durationStr = _transferDataMap['dtDiffDurationStr'] ?? '';
    _durationTextFieldController = TextEditingController(text: _durationStr);
    _addTimeDialogController = TextEditingController();
    _addTimeStr = _transferDataMap['dtDiffAddTimeStr'] ?? '';
    _addTimeTextFieldController = TextEditingController(text: _addTimeStr);
    _finalDurationStr = _transferDataMap['dtDiffFinalDurationStr'] ?? '';
    _finalDurationTextFieldController =
        TextEditingController(text: _finalDurationStr);
  }

  @override
  void dispose() {
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    _durationTextFieldController.dispose();
    _addTimeDialogController.dispose();
    _addTimeTextFieldController.dispose();
    _finalDurationTextFieldController.dispose();

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

    _transferDataViewModel.updateAndSaveTransferData();
  }

  void _resetScreen() {
    _startDateTimeStr = '';
    _endDateTimeStr = '';
    _durationStr = '';
    _addTimeStr = '';
    _finalDurationStr = '';

    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();
    _startDateTimeStr = nowDateTimeStr;
    _startDateTimeController.text = _startDateTimeStr;
    _durationStr = '';
    _durationTextFieldController.text = _durationStr;
    _addTimeStr = '';
    _addTimeTextFieldController.text = _addTimeStr;
    _finalDurationStr = '';
    _finalDurationTextFieldController.text = _finalDurationStr;
    _endDateTimeStr = nowDateTimeStr;
    _endDateTimeController.text = _endDateTimeStr;

    setState(() {});

    _updateTransferDataMap();
  }

  /// Private method called each time one of the elements
  /// implied in calculating the Duration value is changed.
  void _setStateDiffDuration(_) {
    _startDateTimeStr = _startDateTimeController.text;
    DateTime startDateTime = englishDateTimeFormat.parse(_startDateTimeStr);
    _endDateTimeStr = _endDateTimeController.text;
    DateTime endDateTime = englishDateTimeFormat.parse(_endDateTimeStr);
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

    _durationStr = diffDuration.HHmm();
    _durationTextFieldController.text = _durationStr;
    _finalDurationStr = finalDuration?.HHmm() ?? '';
    _finalDurationTextFieldController.text = _finalDurationStr;

    setState(() {});

    _updateTransferDataMap();
  }

  void _addPosOrNegTimeToCurrentDuration(

      /// Private method called when clicking on 'Add' button located at right
      /// of the duration TextField.
      BuildContext context,
      String dialogTimeStr) {
    dialogTimeStr = Utility.convertIntDuration(
      durationStr: dialogTimeStr,
      removeMinusSign: false,
    );
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

      _addTimeStr = existingAddTimeDuration.HHmm();
      _addTimeTextFieldController.text = _addTimeStr;
      _finalDurationStr = finalDuration?.HHmm() ?? '';
      _finalDurationTextFieldController.text = _finalDurationStr;

      setState(() {});

      _updateTransferDataMap();
    }
  }

  void _deleteAddedTimeDuration() {
    _addTimeStr = '';
    _addTimeTextFieldController.text = _addTimeStr;
    _finalDurationStr = '';
    _finalDurationTextFieldController.text = _finalDurationStr;

    setState(() {});

    _updateTransferDataMap();
  }

  void _handleSelectedStartDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _startDateTimeController.text = selectedDateTime.toString();

    _setStateDiffDuration(selectedDateTimeStr);
  }

  void _handleSelectedEndDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _endDateTimeController.text = selectedDateTime.toString();

    _setStateDiffDuration(selectedDateTimeStr);
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
                    height: 15,
                  ),
                  EditableDateTime(
                    dateTimeTitle: 'Start date time',
                    dateTimePickerController: _startDateTimeController,
                    handleDateTimeModificationFunction: _setStateDiffDuration,
                    transferDataMap: _transferDataMap,
                    handleSelectedDateTimeStrFunction:
                        _handleSelectedStartDateTimeStr,
                    topSelMenuPosition: 135.0,
                    transferDataViewModel: _transferDataViewModel,
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
                  ),
                  EditableDuration(
                    dateTimeTitle: 'Duration',
                    durationTextFieldController: _durationTextFieldController,
                    addTimeTextFieldController: _addTimeTextFieldController,
                    addTimeDialogController: _addTimeDialogController,
                    finalDurationTextFieldController:
                        _finalDurationTextFieldController,
                    addPosOrNegTimeToCurrentDurationFunction:
                        _addPosOrNegTimeToCurrentDuration,
                    deleteAddedTimeDurationFunction: _deleteAddedTimeDuration,
                  ),
                  EditableDurationPercent(
                    dateTimeTitle: 'Duration %',
                    durationTextFieldController: _durationTextFieldController,
                    addTimeTextFieldController: _addTimeTextFieldController,
                    addTimeDialogController: _addTimeDialogController,
                    finalDurationTextFieldController:
                        _finalDurationTextFieldController,
                    addPosOrNegTimeToCurrentDurationFunction:
                        _addPosOrNegTimeToCurrentDuration,
                    deleteAddedTimeDurationFunction: _deleteAddedTimeDuration,
                    topSelMenuPosition: 343.0,
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
}
