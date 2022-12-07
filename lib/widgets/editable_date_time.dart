// https://flutterguide.com/date-and-time-picker-in-flutter/#:~:text=To%20create%20a%20DatePicker%20and,the%20user%20confirms%20the%20dialog.

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../buslog/transfer_data_view_model.dart';

class EditableDateTime extends StatefulWidget {
  EditableDateTime({
    Key? key,
    required this.dateTimeTitle,
    required this.topSelMenuPosition,
    required this.transferDataViewModel,
    required this.transferDataMap,
    required this.dateTimePickerController,
    required this.handleDateTimeModificationFunction,
    required this.handleSelectedDateTimeStrFunction,
    this.displayFixDateTimeCheckbox = false,
    this.widgetPrefix = '',
    this.position = ToastGravity.CENTER,
  }) : super(key: key) {
    if (dateTimePickerController.text == '') {
      dateTimePickerController.text =
          ScreenMixin.frenchDateTimeFormat.format(DateTime.now());
    }
  }

  final String dateTimeTitle;
  final TransferDataViewModel transferDataViewModel;

  // used to fill the display select date time popup menu
  final Map<String, dynamic> transferDataMap;

  final double topSelMenuPosition;
  final TextEditingController dateTimePickerController;
  final Function handleDateTimeModificationFunction;
  final Function(String) handleSelectedDateTimeStrFunction;

  final bool displayFixDateTimeCheckbox;
  final String widgetPrefix;
  final ToastGravity position;

  /// This variable enables the EditableDurationPercent
  /// instance to execute the callSetState() method of its
  /// _EditableDurationPercentState instance in order to
  /// redraw the widget to display the values modified by
  /// loading a json file.
  late final _EditableDateTimeState stateInstance;

  @override
  State<EditableDateTime> createState() {
    stateInstance = _EditableDateTimeState();

    return stateInstance;
  }

  bool get isEndDateTimeFixed {
    return stateInstance._twoButtonsWidget.isEndDateTimeFixed;
  }

  set isEndDateTimeFixed(bool value) {
    stateInstance._twoButtonsWidget.isEndDateTimeFixed = value;
    stateInstance._twoButtonsWidget.stateInstance.setState(() {});
  }
}

class _EditableDateTimeState extends State<EditableDateTime> with ScreenMixin {
  DateTime _selectedDate = DateTime.now();

  TimeOfDay _selectedTime = TimeOfDay.now();

  DateTime _dateTime = DateTime.now();

  late TwoButtonsWidget _twoButtonsWidget;

  @override
  void initState() {
    super.initState();

    _twoButtonsWidget = TwoButtonsWidget(
      topSelMenuPosition: widget.topSelMenuPosition,
      transferDataViewModel: widget.transferDataViewModel,
      transferDataMap: widget.transferDataMap,
      handleDateTimeModification: handleDateTimeNowButtonPressed,
      handleSelectedDateTimeStr: handleSelectDateTimeButtonPressed,
      displayFixDateTimeCheckbox: widget.displayFixDateTimeCheckbox,
      widgetPrefix: widget.widgetPrefix,
    );
  }

  void handleSelectDateTimeButtonPressed(String frenchFormatSelectedDateTimeStr,
      [BuildContext? context]) {
    _dateTime =
        ScreenMixin.frenchDateTimeFormat.parse(frenchFormatSelectedDateTimeStr);
    _updateDateTimePickerValues();

    widget.handleSelectedDateTimeStrFunction(frenchFormatSelectedDateTimeStr);
  }

  void handleDateTimeNowButtonPressed(String nowStr) {
    _dateTime = ScreenMixin.englishDateTimeFormat.parse(nowStr);
    _updateDateTimePickerValues();

    widget.handleDateTimeModificationFunction(nowStr);
  }

  void _updateDateTimePickerValues() {
    _selectedDate = _dateTime;
    _selectedTime = TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute);
    widget.dateTimePickerController.text =
        ScreenMixin.frenchDateTimeFormat.format(_dateTime);
  }

  // Select for Date
  Future<DateTime?> _selectDatePickerDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      // User clicked on Cancel button
      return null;
    } else {
      if (selectedDate != _selectedDate) {
        _selectedDate = selectedDate;
      }
    }

    return _selectedDate;
  }

  Future<TimeOfDay?> _selectDatePickerTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null) {
      // User clicked on Cancel button
      return null;
    } else {
      if (selectedTime != _selectedTime) {
        _selectedTime = selectedTime;
      }
    }

    return _selectedTime;
  }

  Future _selectDatePickerDateTime(BuildContext context) async {
    final DateTime? date = await _selectDatePickerDate(context);

    if (date == null) {
      // User clicked on date picker dialog Cancel button. In
      // this case, the time picker dialog is not displayed and
      // the _dateTime value is not modified.
      return;
    }

    final TimeOfDay? time = await _selectDatePickerTime(context);

    if (time == null) {
      // User clicked on time picker dialog Cancel button. In
      // this case, the _dateTime value is not modified.
      return;
    }

//    setState(() {
    _dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    //  });

    widget.dateTimePickerController.text =
        ScreenMixin.frenchDateTimeFormat.format(_dateTime);

    widget.handleDateTimeModificationFunction(
        ScreenMixin.englishDateTimeFormat.format(_dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dateTimeTitle,
              style: labelTextStyle,
            ),
            const SizedBox(
              height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
            ),
            SizedBox(
              // Required to fix Row exception
              // layoutConstraints.maxWidth < double.infinity.
              width: 140,
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: selectionColor,
                  ),
                ),
                child: GestureDetector(
                  child: TextField(
                    key: const Key('editableDateTimeTextField'),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: const TextStyle(
                        color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                    controller: widget.dateTimePickerController,
                    readOnly: true,
                    // prevents displaying copy paste menu !
                    toolbarOptions: const ToolbarOptions(
                        copy: false,
                        paste: false,
                        cut: false,
                        selectAll: false),
                    onTap: () {
                      // initializing the date and time dialogs with the
                      // currently displayed date time value ...
                      String frenchFormatDateTimeStr =
                          widget.dateTimePickerController.text;
                      DateTime dateTime = ScreenMixin.frenchDateTimeFormat
                          .parse(frenchFormatDateTimeStr);
                      _selectedTime = TimeOfDay(
                          hour: dateTime.hour, minute: dateTime.minute);
                      _selectedDate = dateTime;
                      _selectDatePickerDateTime(context);
                    },
                  ),
                  onDoubleTap: () async {
                    await copyToClipboard(
                      context: context,
                      controller: widget.dateTimePickerController,
                      extractHHmmFromCopiedStr: true,
                      position: widget.position,
                    );
                    widget.transferDataMap['clipboardLastAction'] =
                        ClipboardLastAction.copy;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: kVerticalFieldDistance, // required for correct
              //                                 Now and Sel buttons
              //                                 positioning.
            ),
          ],
        ),
        _twoButtonsWidget,
      ],
    );
  }
}

class TwoButtonsWidget extends StatefulWidget with ScreenMixin {
  TwoButtonsWidget({
    Key? key,
    required this.topSelMenuPosition,
    required this.transferDataViewModel,
    required this.transferDataMap,
    required this.handleDateTimeModification,
    required this.handleSelectedDateTimeStr,
    this.displayFixDateTimeCheckbox = false,
    this.widgetPrefix = '',
  })  : isEndDateTimeFixed =
            transferDataMap['${widgetPrefix}EndDateTimeCheckbox'] ?? false,
        super(key: key);

  final TransferDataViewModel transferDataViewModel;

  // used to fill the display select date time popup menu
  final Map<String, dynamic> transferDataMap;

  final double topSelMenuPosition;
  final void Function(String) handleDateTimeModification;
  final void Function(String, BuildContext?) handleSelectedDateTimeStr;

  final bool displayFixDateTimeCheckbox;
  bool isEndDateTimeFixed =
      false; // stores the end date time fix checkbox value
  final String widgetPrefix;

  late final _TwoButtonsWidgetState stateInstance;

  @override
  State<TwoButtonsWidget> createState() {
    stateInstance = _TwoButtonsWidgetState();

    return stateInstance;
  }
}

class _TwoButtonsWidgetState extends State<TwoButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // conditionally adding checkbox widget
        widget.displayFixDateTimeCheckbox
            ? Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white70,
                ),
                child: SizedBox(
                  width: ScreenMixin.CHECKBOX_WIDTH_HEIGHT,
                  height: ScreenMixin.CHECKBOX_WIDTH_HEIGHT,
                  child: Checkbox(
                    key: const Key('divideFirstBySecond'),
                    value: widget.isEndDateTimeFixed,
                    onChanged: (value) {
                      widget.transferDataMap[
                          '${widget.widgetPrefix}EndDateTimeCheckbox'] = value;
                      widget.transferDataViewModel.updateAndSaveTransferData();

                      setState(() {
                        widget.isEndDateTimeFixed = value!;
                      });
                    },
                  ),
                ),
              )
            : const SizedBox(width: 0.0),
        ElevatedButton(
          key: const Key('editableDateTimeNowButton'),
          style: ButtonStyle(
              backgroundColor: widget.appElevatedButtonBackgroundColor,
              shape: widget.appElevatedButtonRoundedShape),
          onPressed: () {
            String nowStr = DateTime.now().toString();
            widget.handleDateTimeModification(nowStr);
          },
          child: const Text(
            'Now',
            style: TextStyle(
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
            ),
          ),
        ),
        const SizedBox(
          width: ScreenMixin.BUTTON_SEP_WIDTH,
        ),
        ElevatedButton(
          key: const Key('editableDateTimeSelButton'),
          style: ButtonStyle(
              backgroundColor: widget.appElevatedButtonBackgroundColor,
              shape: widget.appElevatedButtonRoundedShape),
          onPressed: () {
            widget.displayPopupMenu(
              context: context,
              selMenuDateTimeItemData: widget.buildSortedAppDateTimeStrList(
                  transferDataMap: widget.transferDataMap,
                  mostRecentFirst: true,
                  transferDataViewModel: widget.transferDataViewModel),
              posRectangleLTRB: RelativeRect.fromLTRB(
                1.0,
                widget.topSelMenuPosition,
                0.0,
                0.0,
              ),
              handleSelectedItemFunction: widget.handleSelectedDateTimeStr,
            );
          },
          child: const Text(
            'Sel',
            style: TextStyle(
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
            ),
          ),
        ),
      ],
    );
  }
}
