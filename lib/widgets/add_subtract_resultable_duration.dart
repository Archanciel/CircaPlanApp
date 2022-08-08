import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

/// HH:MM editable widget with a '+' button changeable to '-'
/// button. Adds or subtracts the defined duration value to
/// the included ResultDateTime widget. Additionally,
class AddSubtractResultableDuration extends StatefulWidget with ScreenMixin {
  /// Function passed to this DurationResultDateTime widget.
  //final Function _durationChangeFunction;

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  IconData _durationIcon = Icons.add;
  Color _durationIconColor =
      AddSubtractResultableDuration.durationPositiveColor;
  Color _durationTextColor =
      AddSubtractResultableDuration.durationPositiveColor;

  final String _widgetName;
  final String _dateTimeTitle;
  final double _topSelMenuPosition;
  String _startDateTimeStr;
  String _endDateTimeStr;
  String _durationStr;
  int _durationSign;
  final TransferDataViewModel _transferDataViewModel;

  // used to fill the display selection popup menu
  final Map<String, dynamic> _transferDataMap;

  AddSubtractResultableDuration? _nextAddSubtractResultableDuration;

  final TextEditingController _durationTextFieldController =
      TextEditingController();
  final TextEditingController _dateTimePickerController =
      TextEditingController();

  /// Constructor parms:
  ///
  /// resultDateTimeController      TextEditingController passed to
  ///                               the included ResultDateTime
  ///                               widget constructor.
  /// durationTextFieldController   TextEditingController linked
  ///                               to the duration TextField.
  /// durationChangeFunction        function of the including scn
  ///                               called when the duration +/-
  ///                               button is pressed or when the
  ///                               duration value is changed.
  /// transferDataMap               used to fill the display selection
  ///                               popup menu

  AddSubtractResultableDuration({
    required String widgetName,
    required String dateTimeTitle,
    required double topSelMenuPosition,
    required String startDateTimeStr,
    required TransferDataViewModel transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
    required AddSubtractResultableDuration? nextAddSubtractResultableDuration,
  })  : _widgetName = widgetName,
        _dateTimeTitle = dateTimeTitle,
        _topSelMenuPosition = topSelMenuPosition,
        _startDateTimeStr = startDateTimeStr,
        _transferDataViewModel = transferDataViewModel,
        _transferDataMap = transferDataMap,
        _nextAddSubtractResultableDuration = nextAddSubtractResultableDuration,
        _durationIcon =
            transferDataMap['${widgetName}DurationIconData'] ?? Icons.add,
        _durationIconColor =
            transferDataMap['${widgetName}DurationIconColor'] ??
                AddSubtractResultableDuration.durationPositiveColor,
        _durationSign = transferDataMap['${widgetName}DurationSign'] ?? 1,
        _durationTextColor =
            transferDataMap['${widgetName}DurationTextColor'] ??
                AddSubtractResultableDuration.durationPositiveColor,
        _durationStr = transferDataMap['${widgetName}DurationStr'] ?? '00:00',
        _endDateTimeStr = transferDataMap['${widgetName}EndDateTimeStr'] ?? '';

  /// this variable enables the CustomStatefullWidget instance to
  /// call the updateWidgetValues() method of its
  /// _CustomStatefullWidgetState instance in order to transmit
  /// to this instance the modified widget data.
  late final _AddSubtractResultableDurationState stateInstance;

  @override
  State<AddSubtractResultableDuration> createState() {
    stateInstance = _AddSubtractResultableDurationState();

    return stateInstance;
  }

  String get endDateTimeStr => _dateTimePickerController.text;

  void reset() {
    final DateTime dateTimeNow = DateTime.now();
    // String value used to initialize DateTimePicker field
    String nowDateTimeEnglishFormatStr = dateTimeNow.toString();

    _startDateTimeStr = nowDateTimeEnglishFormatStr;
    _dateTimePickerController.text = _startDateTimeStr;
    _durationStr = '00:00';
    _durationSign = 1;
    _durationTextFieldController.text = _durationStr;

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!.reset();
    }

    updateTransferDataMap();

    stateInstance.callSetState();
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
      startDateTime = englishDateTimeFormat.parse(_startDateTimeStr);
    } on FormatException {}

    if (startDateTime == null) {
      return;
    }

    _durationStr = _durationTextFieldController.text;
    Duration? duration = DateTimeParser.parseHHmmDuration(_durationStr);
    DateTime endDateTime;

    if (duration != null) {
      if (_durationSign > 0) {
        endDateTime = startDateTime.add(duration);
      } else {
        endDateTime = startDateTime.subtract(duration);
      }

      _endDateTimeStr = englishDateTimeFormat.format(endDateTime);
      _dateTimePickerController.text = _endDateTimeStr;
    }

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!
          .setStartDateTimeStr(englishFormatStartDateTimeStr: endDateTimeStr);
    }

    updateTransferDataMap();

    stateInstance.callSetState();
  }

  void handleEndDateTimeSelected(String endDateTimeFrenchFormatStr) {
    DateTime? endDateTime;

    try {
      endDateTime = frenchDateTimeFormat.parse(endDateTimeFrenchFormatStr);
    } on FormatException {}

    if (endDateTime != null) {
      _endDateTimeStr = englishDateTimeFormat.format(endDateTime);
      _dateTimePickerController.text = _endDateTimeStr;
      processEndDateTimeChange(endDateTime);
    }
  }

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
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
      startDateTime = englishDateTimeFormat.parse(_startDateTimeStr);
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
        _durationIconColor =
            AddSubtractResultableDuration.durationNegativeColor;
        _durationTextColor =
            AddSubtractResultableDuration.durationNegativeColor;
      } else {
        _durationSign = 1;
        _durationIcon = Icons.add;
        _durationIconColor =
            AddSubtractResultableDuration.durationPositiveColor;
        _durationTextColor =
            AddSubtractResultableDuration.durationPositiveColor;
      }
    }

    if (_nextAddSubtractResultableDuration != null) {
      _nextAddSubtractResultableDuration!
          .setStartDateTimeStr(englishFormatStartDateTimeStr: endDateTimeStr);
    }

    updateTransferDataMap();

    stateInstance.callSetState();
  }

  void updateTransferDataMap() {
    _transferDataMap['${_widgetName}DurationIconData'] = _durationIcon;
    _transferDataMap['${_widgetName}DurationIconColor'] = _durationIconColor;
    _transferDataMap['${_widgetName}DurationSign'] = _durationSign;
    _transferDataMap['${_widgetName}DurationTextColor'] = _durationTextColor;
    _transferDataMap['${_widgetName}StartDateTimeStr'] = _startDateTimeStr;
    _transferDataMap['${_widgetName}DurationStr'] = _durationStr;
    _transferDataMap['${_widgetName}EndDateTimeStr'] = _endDateTimeStr;

    _transferDataViewModel.updateAndSaveTransferData();
  }
}

class _AddSubtractResultableDurationState
    extends State<AddSubtractResultableDuration> {
  void callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    widget._dateTimePickerController.text = widget._endDateTimeStr;
  }

  @override
  Widget build(BuildContext context) {
    widget._durationTextFieldController.text = widget._durationStr;

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
                icon: Icon(
                  widget._durationIcon,
                  size: 30,
                  color: widget._durationIconColor,
                ),
                label: const Text(''),
                onPressed: () {
                  int durationSign;

                  if (widget._durationIcon == Icons.add) {
                    widget._durationIcon = Icons.remove;
                    widget._durationIconColor =
                        AddSubtractResultableDuration.durationNegativeColor;
                    widget._durationSign = -1;
                    widget._durationTextColor =
                        AddSubtractResultableDuration.durationNegativeColor;
                  } else {
                    widget._durationIcon = Icons.add;
                    widget._durationIconColor =
                        AddSubtractResultableDuration.durationPositiveColor;
                    widget._durationSign = 1;
                    widget._durationTextColor =
                        AddSubtractResultableDuration.durationPositiveColor;
                  }

                  widget.handleDurationChange(
                      durationSign: widget._durationSign);
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
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: TextStyle(
                        color: widget._durationTextColor,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                    keyboardType: TextInputType.datetime,
                    controller: widget._durationTextFieldController,
                    onChanged: (val) {
                      widget.handleDurationChange(durationStr: val);
                    },
                  ),
                  onDoubleTap: () async {
                    await widget.copyToClipboard(
                        context: context,
                        controller: widget._durationTextFieldController);
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
          dateTimeTitle: widget._dateTimeTitle,
          dateTimePickerController: widget._dateTimePickerController,
          handleDateTimeModificationFunction: widget.handleEndDateTimeChange,
          transferDataMap: widget._transferDataMap,
          handleSelectedDateTimeStrFunction: widget.handleEndDateTimeSelected,
          topSelMenuPosition: widget._topSelMenuPosition,
          transferDataViewModel: widget._transferDataViewModel,
        ),
      ],
    );
  }
}
