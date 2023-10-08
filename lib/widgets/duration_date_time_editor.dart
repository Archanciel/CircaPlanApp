// ignore_for_file: no_logic_in_create_state

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/utility.dart';
import 'manually_selectable_text_field.dart';

/// HH:MM editable widget with a '+' button changeable to '-'
/// button. Adds or subtracts the defined duration value to
/// the included ResultDateTime widget. Additionally,
class DurationDateTimeEditor extends StatefulWidget with ScreenMixin {
  /// Function passed to this DurationResultDateTime widget.
  //final Function _durationChangeFunction;

  final String dateTimeTitle;
  final double topSelMenuPosition;
  final TransferDataViewModel transferDataViewModel;

  // instance variables used to pass values to the
  // _DurationDateTimeEditorState constructor
  final String _widgetPrefix;
  String get widgetPrefix => _widgetPrefix;

  final String _nowDateTimeEnglishFormatStr;
  final Map<String, dynamic> _transferDataMap;
  final DurationDateTimeEditor? _nextAddSubtractResultableDuration;
  final bool saveTransferDataIfModified; // is true only for last widget
  final ToastGravity position;

  Function? handleDateTimeModificationFunction;

  /// saveTransferDataIfModified is set to true only for
  /// the last DurationDateTimeEditor widget in order to
  /// avoid unuseful transfer data saving's.
  DurationDateTimeEditor({
    Key? key,
    required String widgetPrefix,
    required this.dateTimeTitle,
    required this.topSelMenuPosition,
    required String nowDateTimeEnglishFormatStr,
    required this.transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
    required DurationDateTimeEditor? nextAddSubtractResultableDuration,
    this.saveTransferDataIfModified = false,
    this.position = ToastGravity.CENTER,
    this.handleDateTimeModificationFunction,
  })  : _widgetPrefix = widgetPrefix,
        _nowDateTimeEnglishFormatStr = nowDateTimeEnglishFormatStr,
        _transferDataMap = transferDataMap,
        _nextAddSubtractResultableDuration = nextAddSubtractResultableDuration,
        super(key: key);

  /// This variable enables the DurationDateTimeEditor
  /// instance to execute the callSetState() method of its
  /// _DurationDateTimeEditorState instance in order to
  /// redraw the widget to display the values modified by
  /// loading a json file.
  late final _DurationDateTimeEditorState stateInstance;

  /// The method ensures that the current widget (screen or custom widget)
  /// setState() method is called in order for the loaded data to be
  /// displayed. Calling this method is necessary since the load function
  /// is performed after selecting a item in a menu displayed by the AppBar
  /// menu defined not by the current screen, but by the main app screen.
  ///
  /// The method is called when the _MainAppState.handleSelectedLoadFileName()
  /// method is executed after the file to load has been selected in the
  /// AppBar load ... sub menu.
  void callSetState() {
    stateInstance.callSetState();
  }

  @override
  State<DurationDateTimeEditor> createState() {
    stateInstance = _DurationDateTimeEditorState(
      widgetPrefix: _widgetPrefix,
      nowDateTimeEnglishFormatStr: _nowDateTimeEnglishFormatStr,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _nextAddSubtractResultableDuration,
      saveTransferDataIfModified: saveTransferDataIfModified,
    );

    return stateInstance;
  }

  /// This setter enables to temporarily set the last
  /// DurationDateTimeEditor widget saveTransferDataIfModified
  /// value to false. This avoids saving transfer
  /// data multiple times since setting the duration of a
  /// DurationDateTimeEditor causes the start date time of its
  /// next DurationDateTimeEditor, and so finaly the last one, to
  /// be updated. Saving transfer data multiple times trevents
  /// Undoing the application of the selected durations item.
  set saveTransferDataIfModified(bool doSave) {
    stateInstance.saveTransferDataIfModified = doSave;
  }

  /// For widget test only
  TextEditingController get dateTimePickerControllerTst =>
      stateInstance._dateTimePickerController;

  /// For widget test only
  String get durationStr => stateInstance._durationStr;

  /// For widget test only
  int get durationSign => stateInstance._durationSign;

  /// For widget test only
  IconData get durationIcon => stateInstance._durationIcon;

  /// For widget test only
  Color get durationIconColor => stateInstance._durationIconColor;

  /// For widget test only
  Color get durationTextColor => stateInstance._durationTextColor;

  /// Calls the _DurationDateTimeEditorState.reset() method.
  void reset({required String resetDateTimeEnglishFormatStr}) {
    stateInstance.reset(
      resetDateTimeEnglishFormatStr: resetDateTimeEnglishFormatStr,
    );
  }

  /// Calls the _AddSubtractResultableDurationState.setStartDateTimeStr() method.
  void setStartDateTimeStr({
    required String englishFormatStartDateTimeStr,
    bool wasStartDateTimeButtonClicked = false,
  }) {
    stateInstance.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr,
        wasStartDateTimeButtonClicked: wasStartDateTimeButtonClicked);
  }

  void setDuration({
    required String durationStr,
    required durationSign,
    bool roundEndDateTime = false,
  }) {
    stateInstance.setDuration(
      durationStr: durationStr,
      durationSign: durationSign,
      roundEndDateTime: roundEndDateTime,
    );
  }

  /// For widget test only
  void handleEndDateTimeChangeTst(String endDateTimeEnglishFormatStr) {
    stateInstance.handleEndDateTimeChange(
      endDateTimeEnglishFormatStr,
      false, // parm value not used, but required by method signature
    );
  }
}

class _DurationDateTimeEditorState extends State<DurationDateTimeEditor> {
  IconData _durationIcon = Icons.add;
  Color _durationIconColor = ScreenMixin.DURATION_POSITIVE_COLOR;
  Color _durationTextColor = ScreenMixin.DURATION_POSITIVE_COLOR;

  final String _widgetPrefix;
  final Map<String, dynamic> _transferDataMap;
  String _durationStr;
  int _durationSign;
  String _startDateTimeEnglishFormatStr;
  String _endDateTimeStr;
  final DurationDateTimeEditor? _nextAddSubtractResultableDuration;
  bool saveTransferDataIfModified; // is true only for last widget

  final TextEditingController _durationTextFieldController =
      TextEditingController();
  final TextEditingController _dateTimePickerController =
      TextEditingController();
  final _durationTextfieldFocusNode = FocusNode();

  late ManuallySelectableTextField _manuallySelectableDurationTextField;
  late EditableDateTime _editableDateTime;

  _DurationDateTimeEditorState({
    required String widgetPrefix,
    required String nowDateTimeEnglishFormatStr,
    required Map<String, dynamic> transferDataMap,
    required DurationDateTimeEditor? nextAddSubtractResultableDuration,
    bool saveTransferDataIfModified = false,
  })  : _widgetPrefix = widgetPrefix,
        _transferDataMap = transferDataMap,
        _durationIcon =
            transferDataMap['${widgetPrefix}DurationIconData'] ?? Icons.add,
        _durationIconColor =
            transferDataMap['${widgetPrefix}DurationIconColor'] ??
                ScreenMixin.DURATION_POSITIVE_COLOR,
        _durationSign = transferDataMap['${widgetPrefix}DurationSign'] ?? 1,
        _durationTextColor =
            transferDataMap['${widgetPrefix}DurationTextColor'] ??
                ScreenMixin.DURATION_POSITIVE_COLOR,
        _durationStr = transferDataMap['${widgetPrefix}DurationStr'] ?? '00:00',
        _startDateTimeEnglishFormatStr =
            transferDataMap['${widgetPrefix}StartDateTimeStr'] ??
                nowDateTimeEnglishFormatStr,
        _endDateTimeStr = transferDataMap['${widgetPrefix}EndDateTimeStr'] ??
            nowDateTimeEnglishFormatStr,
        _nextAddSubtractResultableDuration = nextAddSubtractResultableDuration,
        saveTransferDataIfModified = saveTransferDataIfModified;

  /// The method ensures that the current widget (screen or custom widget)
  /// setState() method is called in order for the loaded data to be
  /// displayed. Calling this method is necessary since the load function
  /// is performed after selecting an item in a menu displayed by the AppBar
  /// menu defined not by the current screen, but by the main app screen.
  ///
  /// The method is called when the _MainAppState.handleSelectedLoadFileName()
  /// method is executed after the file to load has been selected in the
  /// AppBar load ... sub menu.
  void callSetState() {
    final DateTime dateTimeNow = DateTime.now();

    // String value used to initialize DateTimePicker field
    String nowDateTimeEnglishFormatStr = dateTimeNow.toString();

    _durationIcon =
        _transferDataMap['${_widgetPrefix}DurationIconData'] ?? Icons.add;
    _durationIconColor =
        _transferDataMap['${_widgetPrefix}DurationIconColor'] ??
            ScreenMixin.DURATION_POSITIVE_COLOR;
    _durationSign = _transferDataMap['${_widgetPrefix}DurationSign'] ?? 1;
    _durationTextColor =
        _transferDataMap['${_widgetPrefix}DurationTextColor'] ??
            ScreenMixin.DURATION_POSITIVE_COLOR;

    _manuallySelectableDurationTextField.setTextColor(_durationTextColor);

    _durationStr = _transferDataMap['${_widgetPrefix}DurationStr'] ?? '00:00';
    _durationTextFieldController.text = _durationStr;
    _startDateTimeEnglishFormatStr =
        _transferDataMap['${_widgetPrefix}StartDateTimeStr'] ??
            nowDateTimeEnglishFormatStr;
    _endDateTimeStr = _transferDataMap['${_widgetPrefix}EndDateTimeStr'] ??
        nowDateTimeEnglishFormatStr;
    _dateTimePickerController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: _endDateTimeStr)!;
    _editableDateTime.isEndDateTimeLocked =
        _transferDataMap['${_widgetPrefix}EndDateTimeCheckbox'] ?? false;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _dateTimePickerController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: _endDateTimeStr)!;

    _manuallySelectableDurationTextField = ManuallySelectableTextField(
      transferDataViewModel: widget.transferDataViewModel,
      textFieldController: _durationTextFieldController,
      handleTextFieldChangeFunction: _handleDurationChange,
      widgetPrefixOrName: _widgetPrefix,
      position: widget.position,
    );

    _editableDateTime = EditableDateTime(
      dateTimeTitle: widget.dateTimeTitle,
      dateTimePickerController: _dateTimePickerController,
      handleDateTimeModificationFunction: handleEndDateTimeChange,
      transferDataMap: widget._transferDataMap,
      handleSelectedDateTimeStrFunction: handleEndDateTimeSelected,
      topSelMenuPosition: widget.topSelMenuPosition,
      transferDataViewModel: widget.transferDataViewModel,
      displayFixDateTimeCheckbox: true,
      widgetPrefix: _widgetPrefix,
      position: widget.position,
    );
  }

  @override
  void dispose() {
    _durationTextFieldController.dispose();
    _dateTimePickerController.dispose();

    _durationTextfieldFocusNode.dispose();

    super.dispose();
  }

  String get frenchFormatEndDateTimeStr => _dateTimePickerController.text;

  void reset({required String resetDateTimeEnglishFormatStr}) {
    _startDateTimeEnglishFormatStr = resetDateTimeEnglishFormatStr;
    _endDateTimeStr = resetDateTimeEnglishFormatStr;
    _dateTimePickerController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: _endDateTimeStr)!;
    _durationStr = '00:00';
    _durationSign = 1;
    _durationIcon = Icons.add;
    _durationIconColor = ScreenMixin.DURATION_POSITIVE_COLOR;
    _durationTextColor = ScreenMixin.DURATION_POSITIVE_COLOR;
    _manuallySelectableDurationTextField.setTextColor(_durationTextColor);
    _durationTextFieldController.text = _durationStr;
    _editableDateTime.isEndDateTimeLocked = false;

    _updateTransferDataMap(); // must be executed before calling
    // the next DurationDateTimeEditor widget reset method in
    // order for the transfer data map to be updated before the last
    // linked third DurationDateTimeEditor widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!.reset(
        resetDateTimeEnglishFormatStr: resetDateTimeEnglishFormatStr,
      );
    }
  }

  void setStartDateTimeStr({
    required String englishFormatStartDateTimeStr,
    required bool wasStartDateTimeButtonClicked,
  }) {
    _startDateTimeEnglishFormatStr = englishFormatStartDateTimeStr;

    _handleDurationChange(
      _durationStr,
      _durationSign,
      null, // optional wasDurationSignButtonPressed
      null, // optional mustEndDateTimeBeRounded
      wasStartDateTimeButtonClicked,
    );
  }

  void setDuration({
    required String durationStr,
    required durationSign,
    bool roundEndDateTime = false,
  }) {
    _durationStr = durationStr;
    _durationTextFieldController.text = _durationStr;
    _durationSign = durationSign;
    _applyDurationSign(_durationSign);
    _handleDurationChange(
      durationStr,
      _durationSign,
      null, // optional wasDurationSignButtonPressed
      roundEndDateTime,
    );
  }

  /// This method is called when the user selects a date and time
  /// in the DateTimePicker widget. In this case, the
  /// {wasDurationSignButtonPressed} is null.
  ///
  /// This method is also called when the user presses the
  /// duration sign button. In this case, the
  /// {wasDurationSignButtonPressed} is true.
  ///
  /// This method is passed as a parameter to the
  /// ManuallySelectableTextField widget. It is called when the
  /// user changes the duration in the ManuallySelectableTextField
  /// widget.
  ///
  /// Since the ManuallySelectableTextField widget is also used in
  /// the TimeCalculator screen, the {wasDurationSignButtonPressed}
  /// and the {durationSign} parameters of the TimeCalculator
  /// screen method passed to the ManuallySelectableTextField
  /// widget are not used and so are null. Those are the reasons
  /// why these parameters are optional.
  void _handleDurationChange([
    String? durationStr,
    int? durationSign,
    bool? wasDurationSignButtonPressed,
    bool? mustEndDateTimeBeRounded,
    bool? wasStartDateTimeButtonClicked,
  ]) {
    if (durationSign != null) {
      _durationSign = durationSign;
    }

    DateTime? startDateTime;

    try {
      startDateTime =
          englishDateTimeFormat.parse(_startDateTimeEnglishFormatStr);
    } on FormatException {}

    if (startDateTime == null) {
      return;
    }

    if (durationSign == null &&
        (wasDurationSignButtonPressed == null ||
            !wasDurationSignButtonPressed)) {
      bool durationIsNegative =
          _durationIconColor == ScreenMixin.DURATION_NEGATIVE_COLOR ||
              _durationTextFieldController.text.contains('-');
      setDurationSignIconAndColors(durationIsNegative: durationIsNegative);
    }

    // useful in case the _durationStr was set to an
    // int value, like 2 instead of 2:00 !
    _durationStr = Utility.formatStringDuration(
        durationStr: _durationTextFieldController.text);
    _durationTextFieldController.text = _durationStr;

    Duration? duration = DateTimeParser.parseHHMMDuration(_durationStr);
    DateTime endDateTime;

    if (duration != null) {
      if (_editableDateTime.isEndDateTimeLocked) {
        DateTime? endDateTime;

        try {
          endDateTime = englishDateTimeFormat.parse(_endDateTimeStr);
        } on FormatException {}

        if ((wasStartDateTimeButtonClicked ?? false) ||
            widget.handleDateTimeModificationFunction == null) {
          // duration must be changed
          if (endDateTime != null) {
            duration = endDateTime.difference(startDateTime);
            _durationStr =
                duration.HHmm().replaceAll('-', ''); // removing minus sign
            //                                          if duration is negative;
            _durationTextFieldController.text = _durationStr;
            setDurationSignIconAndColors(
                durationIsNegative: duration.isNegative);
          }
        } else {
          // computing start date time according to the new
          // duration sign. As the duration value was modified
          // in the situation were the end date time is locked,
          // the start date time must be changed. If the duration
          // sign is positive, the duration must be subtracted
          // from the start date time so that start date time
          // + duration = end date time. If the duration sign is
          // negative, the duration must be added to the start
          // date time so that start date time - duration =
          // end date time.
          if (durationSign == null || durationSign > 0) {
            startDateTime = endDateTime!.subtract(duration);
            setDurationSignIconAndColors(durationIsNegative: false);
          } else {
            startDateTime = endDateTime!.add(duration);
            setDurationSignIconAndColors(durationIsNegative: true);
          }
          _startDateTimeEnglishFormatStr =
              englishDateTimeFormat.format(startDateTime);
          widget.handleDateTimeModificationFunction!(
              _startDateTimeEnglishFormatStr);
        }
      } else {
        // end date time must be changed
        if (_durationSign > 0) {
          endDateTime = startDateTime.add(duration);
          setDurationSignIconAndColors(durationIsNegative: false);
        } else {
          endDateTime = startDateTime.subtract(duration);
          setDurationSignIconAndColors(durationIsNegative: true);
        }

        if (mustEndDateTimeBeRounded != null && mustEndDateTimeBeRounded) {
          endDateTime = DateTimeParser.roundDateTimeToHour(
            endDateTime,
          );
          duration = endDateTime.difference(startDateTime);
          _durationStr =
              duration.HHmm().replaceAll('-', ''); // removing minus sign
          //                                          if duration is negative;
          _durationTextFieldController.text = _durationStr;
          setDurationSignIconAndColors(durationIsNegative: duration.isNegative);
        }

        _endDateTimeStr = englishDateTimeFormat.format(endDateTime);
        _dateTimePickerController.text =
            frenchDateTimeFormat.format(endDateTime);
      }
    }

    _updateTransferDataMap(); // must be executed before calling
    // the next DurationDateTimeEditor widget
    // setStartDateTimeStr() method in order for the transfer
    // data map to be updated before the last linked third
    // DurationDateTimeEditor widget
    // _updateTransferDataMap() method calls the
    // TransferDataViewModel.updateAndSaveTransferData()
    // method !

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!
          .setStartDateTimeStr(englishFormatStartDateTimeStr: _endDateTimeStr);
    }
  }

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
    DateTime? endDateTime;

    try {
      endDateTime = frenchDateTimeFormat.parse(endDateTimeFrenchFormatStr);
    } on FormatException {}

    if (endDateTime != null) {
      _endDateTimeStr = englishDateTimeFormat.format(endDateTime);
      processEndDateTimeChange(endDateTime);
    }
  }

  void handleEndDateTimeChange(
    String endDateTimeEnglishFormatStr,
    bool notUsed, // parm required since the method is passed
    //               to the EditableDateTime widget constructor
  ) {
    _endDateTimeStr = endDateTimeEnglishFormatStr;
    DateTime? endDateTime;

    try {
      endDateTime = englishDateTimeFormat.parse(endDateTimeEnglishFormatStr);
    } on FormatException {}

    if (endDateTime != null) {
      processEndDateTimeChange(endDateTime);
    }
  }

  void processEndDateTimeChange(DateTime endDateTime) {
    DateTime? startDateTime;

    try {
      startDateTime =
          englishDateTimeFormat.parse(_startDateTimeEnglishFormatStr);
    } on FormatException {}

    Duration duration;

    if (startDateTime != null) {
      duration = endDateTime.difference(startDateTime);
      _durationStr = duration.HHmm().replaceAll('-', ''); // removing minus sign
      //                                                 if duration is negative
      _durationTextFieldController.text = _durationStr;

      setDurationSignIconAndColors(durationIsNegative: duration.isNegative);
    }

    _updateTransferDataMap(); // must be executed before calling
    // the next DurationDateTimeEditor widget
    // setStartDateTimeStr() method in order for the transfer
    // data map to be updated before the last linked third
    // DurationDateTimeEditor widget _updateTransferDataMap()
    // method calls the
    // TransferDataViewModel.updateAndSaveTransferData() method.

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!.setStartDateTimeStr(
        englishFormatStartDateTimeStr:
            DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
                frenchFormatDateTimeStr: frenchFormatEndDateTimeStr)!,
      );
    }
  }

  void setDurationSignIconAndColors({required bool durationIsNegative}) {
    if (durationIsNegative) {
      _durationSign = -1;
      _durationIcon = Icons.remove;
      _durationIconColor = ScreenMixin.DURATION_NEGATIVE_COLOR;
      _durationTextColor = ScreenMixin.DURATION_NEGATIVE_COLOR;
    } else {
      _durationSign = 1;
      _durationIcon = Icons.add;
      _durationIconColor = ScreenMixin.DURATION_POSITIVE_COLOR;
      _durationTextColor = ScreenMixin.DURATION_POSITIVE_COLOR;
    }

    _manuallySelectableDurationTextField.setTextColor(_durationTextColor);
  }

  /// This method must be executed before calling the next
  /// DurationDateTimeEditor widget setStartDateTimeStr()
  /// or reset() method in order for the transfer data map to be
  /// updated before the last linked third
  /// DurationDateTimeEditor widget _updateTransferDataMap()
  /// method calls the
  /// TransferDataViewModel.updateAndSaveTransferData() method.
  void _updateTransferDataMap() {
    _transferDataMap['${_widgetPrefix}DurationIconData'] = _durationIcon;
    _transferDataMap['${_widgetPrefix}DurationIconColor'] = _durationIconColor;
    _transferDataMap['${_widgetPrefix}DurationSign'] = _durationSign;
    _transferDataMap['${_widgetPrefix}DurationTextColor'] = _durationTextColor;
    _transferDataMap['${_widgetPrefix}DurationStr'] = _durationStr;
    _transferDataMap['${_widgetPrefix}StartDateTimeStr'] =
        _startDateTimeEnglishFormatStr;
    _transferDataMap['${_widgetPrefix}EndDateTimeStr'] = _endDateTimeStr;
    _transferDataMap['${_widgetPrefix}EndDateTimeCheckbox'] =
        _editableDateTime.isEndDateTimeLocked;

    setState(() {});

    if (saveTransferDataIfModified) {
      // is true only for last widget in order to avoid unuseful
      // multiple transfer data saving.
      widget.transferDataViewModel.updateAndSaveTransferData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _durationTextFieldController.text = _durationStr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: widget.labelTextStyle,
        ),
        Stack(
          children: [
            Positioned(
              left: -18,
              top: -10,
              child: TextButton.icon(
                key: Key('${_widgetPrefix}DurationSignButton'),
                icon: Icon(
                  _durationIcon,
                  size: 30,
                  color: _durationIconColor,
                ),
                label: const Text(''),
                onPressed: () {
                  _durationSign = -1 * _durationSign;

                  _applyDurationSign(_durationSign);

                  _handleDurationChange(
                    null, // optional durationStr
                    _durationSign,
                    true, // optional wasDurationSignButtonPressed
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 4, 0, 0), // val
//                                          4 is compliant with current value 5
//                                          of APP_LABEL_TO_TEXT_DISTANCE
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: widget.selectionColor,
                    cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                  ),
                ),
                child: _manuallySelectableDurationTextField,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: kVerticalFieldDistance, // required for correct Now and Sel
          //                                 buttons positioning.
        ),
        _editableDateTime,
      ],
    );
  }

  void _applyDurationSign(int durationSign) {
    if (durationSign < 0) {
      _durationIcon = Icons.remove;
      _durationIconColor = ScreenMixin.DURATION_NEGATIVE_COLOR;
      _durationTextColor = ScreenMixin.DURATION_NEGATIVE_COLOR;
    } else {
      _durationIcon = Icons.add;
      _durationIconColor = ScreenMixin.DURATION_POSITIVE_COLOR;
      _durationTextColor = ScreenMixin.DURATION_POSITIVE_COLOR;
    }

    _manuallySelectableDurationTextField.setTextColor(_durationTextColor);
  }
}
