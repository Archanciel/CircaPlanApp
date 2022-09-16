// https://flutterguide.com/date-and-time-picker-in-flutter/#:~:text=To%20create%20a%20DatePicker%20and,the%20user%20confirms%20the%20dialog.

import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../buslog/transfer_data_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('MyApp.build()');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterEditableDateTimeScreen(),
    );
  }
}

class FlutterEditableDateTimeScreen extends StatefulWidget with ScreenMixin {
  FlutterEditableDateTimeScreen({Key? key}) : super(key: key);

  final TextEditingController editableDateTimeController =
      TextEditingController(text: '');
  final TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kDownloadAppDir${Platform.pathSeparator}$kDefaultJsonFileName');
  Map<String, dynamic> transferDataMap = {
    "firstDurationIconData": Icons.add,
    "firstDurationIconColor": Colors.green.shade200,
    "firstDurationSign": 1,
    "firstDurationTextColor": Colors.green.shade200,
    "addDurStartDateTimeStr": "2022-07-12 16:00:26.486627",
    "firstDurationStr": "00:50",
    "firstStartDateTimeStr": "12-07-2022 16:00",
    "firstEndDateTimeStr": "12-07-2022 16:50",
    "secondDurationIconData": Icons.remove,
    "secondDurationIconColor": Colors.red.shade200,
    "secondDurationSign": -1,
    "secondDurationTextColor": Colors.red.shade200,
    "secondDurationStr": "02:00",
    "secondStartDateTimeStr": "12-07-2022 16:00",
    "secondEndDateTimeStr": "12-07-2022 14:00",
    "thirdDurationIconData": Icons.remove,
    "thirdDurationIconColor": Colors.red.shade200,
    "thirdDurationSign": -1,
    "thirdDurationTextColor": Colors.red.shade200,
    "thirdDurationStr": "00:00",
    "thirdStartDateTimeStr": "12-07-2022 16:00",
    "thirdEndDateTimeStr": "12-07-2022 16:00",
    "calcSlDurNewDateTimeStr": '14-07-2022 13:09',
    "calcSlDurPreviousDateTimeStr": '14-07-2022 13:13',
    "calcSlDurBeforePreviousDateTimeStr": '14-07-2022 13:12',
    "calcSlDurCurrSleepDurationStr": '12:36',
    "calcSlDurCurrWakeUpDurationStr": '0:02',
    "calcSlDurCurrTotalDurationStr": '12:38',
    "calcSlDurCurrSleepDurationPercentStr": '99.74 %',
    "calcSlDurCurrWakeUpDurationPercentStr": '0.26 %',
    "calcSlDurCurrTotalDurationPercentStr": '100 %',
    "calcSlDurCurrSleepPrevDayTotalPercentStr": '79.74 %',
    "calcSlDurCurrWakeUpPrevDayTotalPercentStr": '1.26 %',
    "calcSlDurCurrTotalPrevDayTotalPercentStr": '81 %',
    "calcSlDurStatus": Status.sleep,
    "calcSlDurSleepTimeStrHistory": ['10_07_2022 00:58', '05:35', '04:00'],
    "calcSlDurWakeUpTimeStrHistory": ['10_07_2022 05:58', '00:35', '01:00'],
  };

  @override
  State<FlutterEditableDateTimeScreen> createState() =>
      _FlutterEditableDateTimeScreenState();
}

class _FlutterEditableDateTimeScreenState
    extends State<FlutterEditableDateTimeScreen> {
  @override
  Widget build(BuildContext context) {
    // print('_FlutterEditableDateTimeScreenState.build()');
    return Scaffold(
      backgroundColor: ScreenMixin.APP_LIGHT_BLUE_COLOR,
      appBar: AppBar(
        title: const Text('Flutter Date Timer Picker'),
        centerTitle: true,
        backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
      ),
      body: Container(
        color: ScreenMixin.APP_LIGHT_BLUE_COLOR,
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: ScreenMixin.app_computed_vertical_top_margin),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  EditableDateTime(
                    dateTimeTitle: 'Start date time',
                    topSelMenuPosition: 120,
                    transferDataViewModel: widget.transferDataViewModel,
                    transferDataMap: widget.transferDataMap,
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

class EditableDateTime extends StatefulWidget with ScreenMixin {
  EditableDateTime({
    Key? key,
    required this.dateTimeTitle,
    required this.topSelMenuPosition,
    required this.transferDataViewModel,
    required this.transferDataMap,
  }) : super(key: key);

  final String dateTimeTitle;
  final TextEditingController editableDateTimeController =
      TextEditingController(text: '');
  final TransferDataViewModel transferDataViewModel;

  // used to fill the display select date time popup menu
  final Map<String, dynamic> transferDataMap;

  final double topSelMenuPosition;

  /// This variable enables the DurationDateTimeEditor
  /// instance to execute the callSetState() method of its
  /// _DurationDateTimeEditorState instance in order to
  /// redraw the widget to display the values modified by
  /// loading a json file.
  late final _EditableDateTimeState stateInstance;

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
  State<EditableDateTime> createState() {
    stateInstance = _EditableDateTimeState();

    return stateInstance;
  }

  void handleSelectedDateTimeStr(String selectedDateTimeStr) {
    stateInstance._dateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _updateDateTimePickerValues();

    stateInstance.callSetState();
  }

  void handleDateTimeModification(String nowStr) {
    stateInstance._dateTime = englishDateTimeFormat.parse(nowStr);
    _updateDateTimePickerValues();

    stateInstance.callSetState();
  }

  void _updateDateTimePickerValues() {
    stateInstance._selectedDate = stateInstance._dateTime;
    stateInstance._selectedTime = TimeOfDay(
        hour: stateInstance._dateTime.hour,
        minute: stateInstance._dateTime.minute);
  }
}

class _EditableDateTimeState extends State<EditableDateTime> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();

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
    setState(() {});
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

    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _getDateTimeStr() {
    return widget.frenchDateTimeFormat.format(_dateTime);
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
              widget.dateTimeTitle,
              style: widget.labelTextStyle,
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
                    selectionColor: widget.selectionColor,
                  ),
                ),
                child: GestureDetector(
                  child: Text(
                    key: const Key('editableDateTimeText'),
                    _getDateTimeStr(),
                    style: widget.valueTextStyle,
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
          topSelMenuPosition: widget.topSelMenuPosition,
          transferDataViewModel: widget.transferDataViewModel,
          transferDataMap: widget.transferDataMap,
          handleDateTimeModification: widget.handleDateTimeModification,
          handleSelectedDateTimeStr: widget.handleSelectedDateTimeStr,
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

  final TextEditingController editableDateTimeController =
      TextEditingController(text: '');
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
  @override
  Widget build(BuildContext context) {
    // print('_TwoButtonsWidgetState.build()');
    return Row(
      children: [
        ElevatedButton(
          key: const Key('editableDateTimeNowButton'),
          style: ButtonStyle(
              backgroundColor: widget.appElevatedButtonBackgroundColor,
              shape: widget.appElevatedButtonRoundedShape),
          onPressed: () {
            String nowStr = DateTime.now().toString();
            widget.editableDateTimeController.text = nowStr;
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
  }
}
