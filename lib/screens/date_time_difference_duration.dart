import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/widgets/editable_duration.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/utils/date_time_parser.dart';

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

    _transferDataViewModel.updateAndSaveTransferData();

    return map;
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

  void _setStateDiffDuration() {
    /// Private method called each time one of the elements
    /// implied in calculating the Duration value is changed.
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

    _setStateDiffDuration();
  }

  void _handleSelectedEndDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _endDateTimeController.text = selectedDateTime.toString();

    _setStateDiffDuration();
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
                  ),
                  EditableDateTime(
                    dateTimeTitle: 'End date time',
                    dateTimePickerController: _endDateTimeController,
                    handleDateTimeModificationFunction: _setStateDiffDuration,
                    transferDataMap: _transferDataMap,
                    handleSelectedDateTimeStrFunction:
                        _handleSelectedEndDateTimeStr,
                    topSelMenuPosition: 200.0,
                  ),
                  EditableDuration(
                    dateTimeTitle: 'Duration',
                    durationTextFieldController: _durationTextFieldController,
                    addTimeTextFieldController: _addTimeTextFieldController,
                    addTimeDialogController: _addTimeDialogController,
                    finalDurationTextFieldController: _finalDurationTextFieldController,
                    addPosOrNegTimeToCurrentDurationFunction: _addPosOrNegTimeToCurrentDuration,
                    deleteAddedTimeDurationFunction: _deleteAddedTimeDuration,
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
