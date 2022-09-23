// https://flutterguide.com/date-and-time-picker-in-flutter/#:~:text=To%20create%20a%20DatePicker%20and,the%20user%20confirms%20the%20dialog.

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import '../buslog/transfer_data_view_model.dart';

class EditableDateTime extends StatelessWidget with ScreenMixin {
  EditableDateTime({
    Key? key,
    required this.dateTimeTitle,
    required this.topSelMenuPosition,
    required this.transferDataViewModel,
    required this.transferDataMap,
    required this.handleDateTimeModificationFunction,
    required this.handleSelectedDateTimeStrFunction,
  }) : super(key: key);

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();

  final String dateTimeTitle;
  final TransferDataViewModel transferDataViewModel;

  // used to fill the display select date time popup menu
  final Map<String, dynamic> transferDataMap;

  final double topSelMenuPosition;
  final Function handleDateTimeModificationFunction;
  final Function(String) handleSelectedDateTimeStrFunction;

  void handleSelectDateTimeButtonPressed(String selectedDateTimeStr) {
    _dateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _updateDateTimePickerValues();

    handleSelectedDateTimeStrFunction(selectedDateTimeStr);
  }

  void handleDateTimeNowButtonPressed(String nowStr) {
    _dateTime = englishDateTimeFormat.parse(nowStr);
    _updateDateTimePickerValues();

    handleDateTimeModificationFunction(nowStr);
  }

  void _updateDateTimePickerValues() {
    _selectedDate = _dateTime;
    _selectedTime = TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute);
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

    handleDateTimeModificationFunction(englishDateTimeFormat.format(_dateTime));
  }

  String _getDateTimeStr() {
    return frenchDateTimeFormat.format(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // print('_EditableDateTimeState.build()');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateTimeTitle,
              style: labelTextStyle,
            ),
            const SizedBox(
              height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
            ),
            SizedBox(
              // Required to fix Row exception
              // layoutConstraints.maxWidth < double.infinity.
              width: 170,
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: selectionColor,
                  ),
                ),
                child: GestureDetector(
                  child: Text(
                    key: const Key('editableDateTimeText'),
                    _getDateTimeStr(),
                    style: valueTextStyle,
                  ),
                  onTap: () {
                    _selectDatePickerDateTime(context);
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
        TwoButtonsWidget(
          topSelMenuPosition: topSelMenuPosition,
          transferDataViewModel: transferDataViewModel,
          transferDataMap: transferDataMap,
          handleDateTimeModification: handleDateTimeNowButtonPressed,
          handleSelectedDateTimeStr: handleSelectDateTimeButtonPressed,
        ),
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
  }) : super(key: key);

  final TransferDataViewModel transferDataViewModel;

  // used to fill the display select date time popup menu
  final Map<String, dynamic> transferDataMap;

  final double topSelMenuPosition;
  final void Function(String) handleDateTimeModification;
  final void Function(String) handleSelectedDateTimeStr;

  @override
  State<TwoButtonsWidget> createState() => _TwoButtonsWidgetState();
}

class _TwoButtonsWidgetState extends State<TwoButtonsWidget> {
  Widget? _widgetBody;

  @override
  Widget build(BuildContext context) {
    if (_widgetBody != null) {
      // Since the TwoButtonsWidget layout is not modified
      // after it has been built, avoiding rebuilding it
      // each time its including widget is rebuilt improves
      // app performance
      return _widgetBody!;
    }

    // print('_TwoButtonsWidgetState.build()');
    _widgetBody = Row(
      children: [
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
          width: 20,
        ),
        ElevatedButton(
          key: const Key('editableDateTimeSelButton'),
          style: ButtonStyle(
              backgroundColor: widget.appElevatedButtonBackgroundColor,
              shape: widget.appElevatedButtonRoundedShape),
          onPressed: () {
            widget.displaySelPopupMenu(
              context: context,
              selectableStrItemLst: widget.buildSortedAppDateTimeStrList(
                  transferDataMap: widget.transferDataMap,
                  mostRecentFirst: true,
                  transferDataViewModel: widget.transferDataViewModel),
              posRectangleLTRB: RelativeRect.fromLTRB(
                1.0,
                widget.topSelMenuPosition,
                0.0,
                0.0,
              ),
              handleSelectedItem: widget.handleSelectedDateTimeStr,
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

    return _widgetBody!;
  }
}
