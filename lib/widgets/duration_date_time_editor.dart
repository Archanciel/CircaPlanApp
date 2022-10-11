import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:flutter/services.dart';

import '../utils/utility.dart';

/// HH:MM editable widget with a '+' button changeable to '-'
/// button. Adds or subtracts the defined duration value to
/// the included ResultDateTime widget. Additionally,
class DurationDateTimeEditor extends StatefulWidget with ScreenMixin {
  /// Function passed to this DurationResultDateTime widget.
  //final Function _durationChangeFunction;

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  final String dateTimeTitle;
  final double topSelMenuPosition;
  final TransferDataViewModel transferDataViewModel;

  // instance variables used to pass values to the
  // _DurationDateTimeEditorState constructor
  final String _widgetName;
  final String _nowDateTimeEnglishFormatStr;
  final Map<String, dynamic> _transferDataMap;
  final DurationDateTimeEditor? _nextAddSubtractResultableDuration;
  final bool saveTransferDataIfModified; // is true only for last widget

  DurationDateTimeEditor({
    Key? key,
    required String widgetName,
    required this.dateTimeTitle,
    required this.topSelMenuPosition,
    required String nowDateTimeEnglishFormatStr,
    required this.transferDataViewModel,
    required Map<String, dynamic> transferDataMap,
    required DurationDateTimeEditor? nextAddSubtractResultableDuration,
    this.saveTransferDataIfModified = false,
  })  : _widgetName = widgetName,
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

  void setDuration(String duration) {
    stateInstance.setDuration(duration);
  }
}

class _DurationDateTimeEditorState extends State<DurationDateTimeEditor> {
  IconData _durationIcon = Icons.add;
  Color _durationIconColor = DurationDateTimeEditor.durationPositiveColor;
  Color _durationTextColor = DurationDateTimeEditor.durationPositiveColor;

  final String _widgetName;
  final Map<String, dynamic> _transferDataMap;
  String _durationStr;
  int _durationSign;
  String _startDateTimeStr;
  String _endDateTimeStr;
  final DurationDateTimeEditor? _nextAddSubtractResultableDuration;
  final bool _saveTransferDataIfModified; // is true only for last widget

  final TextEditingController _durationTextFieldController =
      TextEditingController();
  final TextEditingController _dateTimePickerController =
      TextEditingController();

  _DurationDateTimeEditorState({
    required String widgetName,
    required String nowDateTimeEnglishFormatStr,
    required Map<String, dynamic> transferDataMap,
    required DurationDateTimeEditor? nextAddSubtractResultableDuration,
    bool saveTransferDataIfModified = false,
  })  : _widgetName = widgetName,
        _transferDataMap = transferDataMap,
        _durationIcon =
            transferDataMap['${widgetName}DurationIconData'] ?? Icons.add,
        _durationIconColor =
            transferDataMap['${widgetName}DurationIconColor'] ??
                DurationDateTimeEditor.durationPositiveColor,
        _durationSign = transferDataMap['${widgetName}DurationSign'] ?? 1,
        _durationTextColor =
            transferDataMap['${widgetName}DurationTextColor'] ??
                DurationDateTimeEditor.durationPositiveColor,
        _durationStr = transferDataMap['${widgetName}DurationStr'] ?? '00:00',
        _startDateTimeStr = transferDataMap['${widgetName}StartDateTimeStr'] ??
            nowDateTimeEnglishFormatStr,
        _endDateTimeStr = transferDataMap['${widgetName}EndDateTimeStr'] ??
            nowDateTimeEnglishFormatStr,
        _nextAddSubtractResultableDuration = nextAddSubtractResultableDuration,
        _saveTransferDataIfModified = saveTransferDataIfModified;

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
        _transferDataMap['${_widgetName}DurationIconData'] ?? Icons.add;
    _durationIconColor = _transferDataMap['${_widgetName}DurationIconColor'] ??
        DurationDateTimeEditor.durationPositiveColor;
    _durationSign = _transferDataMap['${_widgetName}DurationSign'] ?? 1;
    _durationTextColor = _transferDataMap['${_widgetName}DurationTextColor'] ??
        DurationDateTimeEditor.durationPositiveColor;
    _durationStr = _transferDataMap['${_widgetName}DurationStr'] ?? '00:00';
    _durationTextFieldController.text = _durationStr;
    _startDateTimeStr = _transferDataMap['${_widgetName}StartDateTimeStr'] ??
        nowDateTimeEnglishFormatStr;
    _endDateTimeStr = _transferDataMap['${_widgetName}EndDateTimeStr'] ??
        nowDateTimeEnglishFormatStr;
    _dateTimePickerController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: _endDateTimeStr)!;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _dateTimePickerController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: _endDateTimeStr)!;
  }

  String get frenchFormatEndDateTimeStr => _dateTimePickerController.text;

  void reset() {
    final DateTime dateTimeNow = DateTime.now();
    // String value used to initialize DateTimePicker field
    String nowDateTimeEnglishFormatStr = dateTimeNow.toString();

    _startDateTimeStr = nowDateTimeEnglishFormatStr;
    _endDateTimeStr = nowDateTimeEnglishFormatStr;
    _dateTimePickerController.text =
        DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
            englishFormatDateTimeStr: _endDateTimeStr)!;
    _durationStr = '00:00';
    _durationSign = 1;
    _durationIcon = Icons.add;
    _durationIconColor = DurationDateTimeEditor.durationPositiveColor;
    _durationTextColor = DurationDateTimeEditor.durationPositiveColor;
    _durationTextFieldController.text = _durationStr;

    _updateTransferDataMap(); // must be executed before calling
    // the next DurationDateTimeEditor widget reset method in
    // order for the transfer data map to be updated before the last
    // linked third DurationDateTimeEditor widget calls the
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

  void setDuration(String durationStr) {
    _durationStr = durationStr;
    _durationTextFieldController.text = _durationStr;
    handleDurationChange(durationStr: durationStr, durationSign: _durationSign);
  }

  void handleDurationChange({
    String? durationStr,
    int? durationSign,
    bool wasDurationSignButtonPressed = false,
  }) {
    if (durationSign != null) {
      _durationSign = durationSign;
    }

    DateTime? startDateTime;

    try {
      startDateTime =
          ScreenMixin.englishDateTimeFormat.parse(_startDateTimeStr);
    } on FormatException {}

    if (startDateTime == null) {
      return;
    }

    if (!wasDurationSignButtonPressed) {
      setDurationSignIconAndColor(
          durationIsNegative: _durationTextFieldController.text.contains('-'));
    }

    _durationStr = Utility.convertIntDuration(
        durationStr: _durationTextFieldController.text);

    // necessary in case the _durationStr was set to an
    // int value, like 2 instead of 2:00 !
    _durationTextFieldController.text = _durationStr;

    Duration? duration = DateTimeParser.parseHHmmDuration(_durationStr);
    DateTime endDateTime;

    if (duration != null) {
      if (_durationSign > 0) {
        endDateTime = startDateTime.add(duration);
      } else {
        endDateTime = startDateTime.subtract(duration);
      }

      _endDateTimeStr = ScreenMixin.englishDateTimeFormat.format(endDateTime);
      _dateTimePickerController.text =
          ScreenMixin.frenchDateTimeFormat.format(endDateTime);
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
      endDateTime =
          ScreenMixin.frenchDateTimeFormat.parse(endDateTimeFrenchFormatStr);
    } on FormatException {}

    if (endDateTime != null) {
      _endDateTimeStr = ScreenMixin.englishDateTimeFormat.format(endDateTime);
      processEndDateTimeChange(endDateTime);
    }
  }

  void handleEndDateTimeChange(String endDateTimeEnglishFormatStr) {
    _endDateTimeStr = endDateTimeEnglishFormatStr;
    DateTime? endDateTime;

    try {
      endDateTime =
          ScreenMixin.englishDateTimeFormat.parse(endDateTimeEnglishFormatStr);
    } on FormatException {}

    if (endDateTime != null) {
      processEndDateTimeChange(endDateTime);
    }
  }

  void processEndDateTimeChange(DateTime endDateTime) {
    DateTime? startDateTime;

    try {
      startDateTime =
          ScreenMixin.englishDateTimeFormat.parse(_startDateTimeStr);
    } on FormatException {}

    Duration duration;

    if (startDateTime != null) {
      duration = endDateTime.difference(startDateTime);
      _durationStr = duration.HHmm().replaceAll('-', ''); // removing minus sign
      //                                                 if duration is negative
      _durationTextFieldController.text = _durationStr;

      setDurationSignIconAndColor(durationIsNegative: duration.isNegative);
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
                  frenchFormatDateTimeStr: frenchFormatEndDateTimeStr)!);
    }
  }

  void setDurationSignIconAndColor({required bool durationIsNegative}) {
    if (durationIsNegative) {
      _durationSign = -1;
      _durationIcon = Icons.remove;
      _durationIconColor = DurationDateTimeEditor.durationNegativeColor;
      _durationTextColor = DurationDateTimeEditor.durationNegativeColor;
    } else {
      _durationSign = 1;
      _durationIcon = Icons.add;
      _durationIconColor = DurationDateTimeEditor.durationPositiveColor;
      _durationTextColor = DurationDateTimeEditor.durationPositiveColor;
    }
  }

  /// This method must be executed before calling the next
  /// DurationDateTimeEditor widget setStartDateTimeStr()
  /// or reset() method in order for the transfer data map to be
  /// updated before the last linked third
  /// DurationDateTimeEditor widget _updateTransferDataMap()
  /// method calls the
  /// TransferDataViewModel.updateAndSaveTransferData() method.
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
                        DurationDateTimeEditor.durationNegativeColor;
                    _durationSign = -1;
                    _durationTextColor =
                        DurationDateTimeEditor.durationNegativeColor;
                  } else {
                    _durationIcon = Icons.add;
                    _durationIconColor =
                        DurationDateTimeEditor.durationPositiveColor;
                    _durationSign = 1;
                    _durationTextColor =
                        DurationDateTimeEditor.durationPositiveColor;
                  }

                  handleDurationChange(
                      durationSign: _durationSign,
                      wasDurationSignButtonPressed: true);
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
                    await handleClipboardData(
                        context: context,
                        textEditingController: _durationTextFieldController,
                        transferDataMap: widget._transferDataMap,
                        handleDataChangeFunc: handleDurationChange);
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

  Future<void> handleClipboardData({
    required BuildContext context,
    required TextEditingController textEditingController,
    required Map<String, dynamic> transferDataMap,
    required void Function(
            {int? durationSign,
            String? durationStr,
            bool wasDurationSignButtonPressed})
        handleDataChangeFunc,
  }) async {
    var clipboardLastAction = widget._transferDataMap['clipboardLastAction'];

    if (clipboardLastAction == ClipboardLastAction.copy) {
      await pasteFromClipboard(
        controller: textEditingController,
      );

      transferDataMap['clipboardLastAction'] = ClipboardLastAction.paste;
    } else {
      await widget.copyToClipboard(
          context: context, controller: textEditingController);

      transferDataMap['clipboardLastAction'] = ClipboardLastAction.copy;
    }

    handleDataChangeFunc(durationStr: textEditingController.text);
  }

  Future<void> pasteFromClipboard(
      {required TextEditingController controller}) async {
    controller.selection = TextSelection(
        baseOffset: 0, extentOffset: controller.value.text.length);
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    String copiedtext = (cdata != null) ? cdata.text ?? '' : '';
    controller.text = copiedtext;
  }
}
