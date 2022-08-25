import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

/// HH:MM editable widget with a '+' button changeable to '-'
/// button. Adds or subtracts the defined duration value to
/// the included ResultDateTime widget. Additionally,
class AddSubtractDuration extends StatefulWidget with ScreenMixin {
  /// Function passed to this DurationResultDateTime widget.
  //final Function _durationChangeFunction;

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  final String dateTimeTitle;
  final double topSelMenuPosition;
  final TransferDataViewModel transferDataViewModel;

  // instance variables used to pass values to the
  // _AddSubtractResultableDurationState constructor
  final String _widgetName;
  final String _nowDateTimeEnglishFormatStr;
  final Map<String, dynamic> _transferDataMap;
  final AddSubtractDuration? _nextAddSubtractResultableDuration;
  final bool saveTransferDataIfModified; // is true only for last widget

  AddSubtractDuration({
    Key? key,
    required String widgetName,
    required this.dateTimeTitle,
    required this.topSelMenuPosition,
    required String nowDateTimeEnglishFormatStr,
    required this.transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
    required AddSubtractDuration? nextAddSubtractResultableDuration,
    bool this.saveTransferDataIfModified = false,
  })  : _widgetName = widgetName,
        _nowDateTimeEnglishFormatStr = nowDateTimeEnglishFormatStr,
        _transferDataMap = transferDataMap,
        _nextAddSubtractResultableDuration = nextAddSubtractResultableDuration,
        super(key: key);

  /// This variable enables the AddSubtractResultableDuration
  /// instance to execute the callSetState() method of its
  /// _AddSubtractResultableDurationState instance in order
  /// redraw the widget to display the value modified by the
  /// user.
  late final _AddSubtractDurationState stateInstance;

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
    stateInstance.callSetState();
  }

  @override
  State<AddSubtractDuration> createState() {
    stateInstance = _AddSubtractDurationState(
      widgetName: _widgetName,
      nowDateTimeEnglishFormatStr: _nowDateTimeEnglishFormatStr,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _nextAddSubtractResultableDuration,
      saveTransferDataIfModified: saveTransferDataIfModified,
    );

    return stateInstance;
  }

  /// Calls the _AddSubtractResultableDurationState.reset() method.
  void reset() {
    stateInstance.reset();
  }

  /// Calls the _AddSubtractResultableDurationState.setStartDateTimeStr() method.
  void setStartDateTimeStr({required String englishFormatStartDateTimeStr}) {
    stateInstance.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);
  }
}

class _AddSubtractDurationState extends State<AddSubtractDuration> {
  IconData _durationIcon = Icons.add;
  Color _durationIconColor = AddSubtractDuration.durationPositiveColor;
  Color _durationTextColor = AddSubtractDuration.durationPositiveColor;

  final String _widgetName;
  final Map<String, dynamic> _transferDataMap;
  String _durationStr;
  int _durationSign;
  String _startDateTimeStr;
  String _endDateTimeStr;
  final AddSubtractDuration? _nextAddSubtractResultableDuration;
  final bool _saveTransferDataIfModified; // is true only for last widget

  final TextEditingController _durationTextFieldController =
      TextEditingController();
  final TextEditingController _dateTimePickerController =
      TextEditingController();

  _AddSubtractDurationState({
    required String widgetName,
    required String nowDateTimeEnglishFormatStr,
    required Map<String, dynamic> transferDataMap,
    required AddSubtractDuration? nextAddSubtractResultableDuration,
    bool saveTransferDataIfModified = false,
  })  : _widgetName = widgetName,
        _transferDataMap = transferDataMap,
        _durationIcon =
            transferDataMap['${widgetName}DurationIconData'] ?? Icons.add,
        _durationIconColor =
            transferDataMap['${widgetName}DurationIconColor'] ??
                AddSubtractDuration.durationPositiveColor,
        _durationSign = transferDataMap['${widgetName}DurationSign'] ?? 1,
        _durationTextColor =
            transferDataMap['${widgetName}DurationTextColor'] ??
                AddSubtractDuration.durationPositiveColor,
        _durationStr = transferDataMap['${widgetName}DurationStr'] ?? '00:00',
        _startDateTimeStr = transferDataMap['${widgetName}StartDateTimeStr'] ??
            nowDateTimeEnglishFormatStr,
        _endDateTimeStr = transferDataMap['${widgetName}EndDateTimeStr'] ??
            nowDateTimeEnglishFormatStr,
        _nextAddSubtractResultableDuration = nextAddSubtractResultableDuration,
        _saveTransferDataIfModified = saveTransferDataIfModified;

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
    final DateTime dateTimeNow = DateTime.now();

    // String value used to initialize DateTimePicker field
    String nowDateTimeEnglishFormatStr = dateTimeNow.toString();

    _durationIcon =
        _transferDataMap['${_widgetName}DurationIconData'] ?? Icons.add;
    _durationIconColor = _transferDataMap['${_widgetName}DurationIconColor'] ??
        AddSubtractDuration.durationPositiveColor;
    _durationSign = _transferDataMap['${_widgetName}DurationSign'] ?? 1;
    _durationTextColor = _transferDataMap['${_widgetName}DurationTextColor'] ??
        AddSubtractDuration.durationPositiveColor;
    _durationStr = _transferDataMap['${_widgetName}DurationStr'] ?? '00:00';
    _startDateTimeStr = _transferDataMap['${_widgetName}StartDateTimeStr'] ??
        nowDateTimeEnglishFormatStr;
    _endDateTimeStr = _transferDataMap['${_widgetName}EndDateTimeStr'] ??
        nowDateTimeEnglishFormatStr;
    _dateTimePickerController.text = _endDateTimeStr;

    setState(() {});
  }

  @override
  void initState() {
    _dateTimePickerController.text = _endDateTimeStr;
  }

  String get endDateTimeStr => _dateTimePickerController.text;

  void reset() {
    final DateTime dateTimeNow = DateTime.now();
    // String value used to initialize DateTimePicker field
    String nowDateTimeEnglishFormatStr = dateTimeNow.toString();

    _startDateTimeStr = nowDateTimeEnglishFormatStr;
    _endDateTimeStr = nowDateTimeEnglishFormatStr;
    _dateTimePickerController.text = _endDateTimeStr;
    _durationStr = '00:00';
    _durationSign = 1;
    _durationIcon = Icons.add;
    _durationIconColor = AddSubtractDuration.durationPositiveColor;
    _durationTextColor = AddSubtractDuration.durationPositiveColor;
    _durationTextFieldController.text = _durationStr;

    _updateTransferDataMap(); // must be executed before calling
    // the next AddSubtractResultableDuration widget reset method in
    // order for the transfer data map to be updated before the last
    // linked third AddSubtractResultableDuration widget calls the
    // TransferDataViewModel.updateAndSaveTransferData() method !

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!.reset();
    }
  }

  void setStartDateTimeStr({required String englishFormatStartDateTimeStr}) {
    _startDateTimeStr = englishFormatStartDateTimeStr;

    handleDurationChange(
      durationStr: _durationStr,
      durationSign: _durationSign,
    );
  }

  void handleDurationChange({String? durationStr, int? durationSign}) {
    if (durationSign != null) {
      _durationSign = durationSign;
    }

    DateTime? startDateTime;

    try {
      startDateTime = widget.englishDateTimeFormat.parse(_startDateTimeStr);
    } on FormatException {}

    if (startDateTime == null) {
      return;
    }

    _durationStr = _durationTextFieldController.text;
    _durationStr = _durationStr.replaceAll(RegExp(r'[+\-]+'), '');

    if (int.tryParse(_durationStr) != null) {
      // the case if a one or two digits duration was entered ...
      _durationStr = '$_durationStr:00';
    }

    // necessary in case the _durationStr was modified
    _durationTextFieldController.text = _durationStr;

    Duration? duration = DateTimeParser.parseHHmmDuration(_durationStr);
    DateTime endDateTime;

    if (duration != null) {
      if (_durationSign > 0) {
        endDateTime = startDateTime.add(duration);
      } else {
        endDateTime = startDateTime.subtract(duration);
      }

      _endDateTimeStr = widget.englishDateTimeFormat.format(endDateTime);
      _dateTimePickerController.text = _endDateTimeStr;
    }

    _updateTransferDataMap(); // must be executed before calling
    // the next AddSubtractResultableDuration widget
    // setStartDateTimeStr() method in order for the transfer data
    // map to be updated before the last linked third
    // AddSubtractResultableDuration widget _updateTransferDataMap()
    // method calls the TransferDataViewModel.updateAndSaveTransferData()
    // method !

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!
          .setStartDateTimeStr(englishFormatStartDateTimeStr: endDateTimeStr);
    }
  }

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
    DateTime? endDateTime;

    try {
      endDateTime =
          widget.frenchDateTimeFormat.parse(endDateTimeFrenchFormatStr);
    } on FormatException {}

    if (endDateTime != null) {
      _endDateTimeStr = widget.englishDateTimeFormat.format(endDateTime);
      _dateTimePickerController.text = _endDateTimeStr;
      processEndDateTimeChange(endDateTime);
    }
  }

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
    _endDateTimeStr = endDateTimeEnglishFormatStr;
    DateTime? endDateTime;

    try {
      endDateTime =
          widget.englishDateTimeFormat.parse(endDateTimeEnglishFormatStr);
    } on FormatException {}

    if (endDateTime != null) {
      processEndDateTimeChange(endDateTime);
    }
  }

  void processEndDateTimeChange(DateTime endDateTime) {
    DateTime? startDateTime;

    try {
      startDateTime = widget.englishDateTimeFormat.parse(_startDateTimeStr);
    } on FormatException {}

    Duration duration;

    if (startDateTime != null) {
      duration = endDateTime.difference(startDateTime);
      _durationStr = duration.HHmm().replaceAll('-', ''); // removing minus sign
      //                                                 if duration is negative
      _durationTextFieldController.text = _durationStr;

      if (duration.isNegative) {
        _durationSign = -1;
        _durationIcon = Icons.remove;
        _durationIconColor = AddSubtractDuration.durationNegativeColor;
        _durationTextColor = AddSubtractDuration.durationNegativeColor;
      } else {
        _durationSign = 1;
        _durationIcon = Icons.add;
        _durationIconColor = AddSubtractDuration.durationPositiveColor;
        _durationTextColor = AddSubtractDuration.durationPositiveColor;
      }
    }

    _updateTransferDataMap(); // must be executed before calling
    // the next AddSubtractResultableDuration widget
    // setStartDateTimeStr() method in order for the transfer data
    // map to be updated before the last linked third
    // AddSubtractResultableDuration widget _updateTransferDataMap()
    // method calls the TransferDataViewModel.updateAndSaveTransferData()
    // method !

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!
          .setStartDateTimeStr(englishFormatStartDateTimeStr: endDateTimeStr);
    }
  }

  /// This method must be executed before calling the next
  /// AddSubtractResultableDuration widget setStartDateTimeStr() or
  /// reset() method in order for the transfer data map to be updated
  /// before the last linked third AddSubtractResultableDuration
  /// widget _updateTransferDataMap() method calls the
  /// TransferDataViewModel.updateAndSaveTransferData() method !
  void _updateTransferDataMap() {
    _transferDataMap['${_widgetName}DurationIconData'] = _durationIcon;
    _transferDataMap['${_widgetName}DurationIconColor'] = _durationIconColor;
    _transferDataMap['${_widgetName}DurationSign'] = _durationSign;
    _transferDataMap['${_widgetName}DurationTextColor'] = _durationTextColor;
    _transferDataMap['${_widgetName}DurationStr'] = _durationStr;
    _transferDataMap['${_widgetName}StartDateTimeStr'] = _startDateTimeStr;
    _transferDataMap['${_widgetName}EndDateTimeStr'] = _endDateTimeStr;

    setState(() {});

    if (_saveTransferDataIfModified) {
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
                key: const Key('durationSignButton'),
                icon: Icon(
                  _durationIcon,
                  size: 30,
                  color: _durationIconColor,
                ),
                label: const Text(''),
                onPressed: () {
                  if (_durationSign > 0) {
                    _durationIcon = Icons.remove;
                    _durationIconColor =
                        AddSubtractDuration.durationNegativeColor;
                    _durationSign = -1;
                    _durationTextColor =
                        AddSubtractDuration.durationNegativeColor;
                  } else {
                    _durationIcon = Icons.add;
                    _durationIconColor =
                        AddSubtractDuration.durationPositiveColor;
                    _durationSign = 1;
                    _durationTextColor =
                        AddSubtractDuration.durationPositiveColor;
                  }

                  handleDurationChange(durationSign: _durationSign);
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
                    cursorColor: ScreenMixin.appTextAndIconColor,
                  ),
                ),
                child: GestureDetector(
                  child: TextField(
                    key: const Key('durationTextField'),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: TextStyle(
                        color: _durationTextColor,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                    keyboardType: TextInputType.datetime,
                    controller: _durationTextFieldController,
                    onSubmitted: (val) {
                      // solve the unsolvable problem of onChange()
                      // which set cursor at TextField start position !
                      handleDurationChange(durationStr: val);
                    },
                  ),
                  onDoubleTap: () async {
                    await widget.copyToClipboard(
                        context: context,
                        controller: _durationTextFieldController);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: kVerticalFieldDistance, // required for correct Now and Sel
          //                                 buttons positioning.
        ),
        EditableDateTime(
          dateTimeTitle: widget.dateTimeTitle,
          dateTimePickerController: _dateTimePickerController,
          handleDateTimeModificationFunction: handleEndDateTimeChange,
          transferDataMap: widget._transferDataMap,
          handleSelectedDateTimeStrFunction: handleEndDateTimeSelected,
          topSelMenuPosition: widget.topSelMenuPosition,
          transferDataViewModel: widget.transferDataViewModel,
        ),
      ],
    );
  }
}
