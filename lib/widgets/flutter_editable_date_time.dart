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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterEditableDateTimeScreen(),
    );
  }
}

class FlutterEditableDateTimeScreen extends StatefulWidget with ScreenMixin {
  FlutterEditableDateTimeScreen({Key? key}) : super(key: key);

  TextEditingController editableDateTimeController =
      TextEditingController(text: '');
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kDownloadAppDir${Platform.pathSeparator}$kDefaultJsonFileName');

  // used to fill the display select = ion popup menu
  final Map<String, dynamic> transferDataMap = {};
  final Function(String) handleSelectedDateTimeStr = (String val) => print(val);

  double topSelMenuPosition = 200;

  @override
  State<FlutterEditableDateTimeScreen> createState() =>
      _FlutterEditableDateTimeScreenState();

  void handleDateTimeModification(String nowStr) {
    print(nowStr);
  }
}

class _FlutterEditableDateTimeScreenState
    extends State<FlutterEditableDateTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenMixin.APP_LIGHT_BLUE_COLOR,
      appBar: AppBar(
        title: const Text('Date Timer Picker'),
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
                  EditableDateTime(),
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
  }) : super(key: key);

  String dateTimeTitle = 'Start date time';
  TextEditingController editableDateTimeController =
      TextEditingController(text: '');
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '$kDownloadAppDir${Platform.pathSeparator}$kDefaultJsonFileName');

  // used to fill the display select = ion popup menu
  final Map<String, dynamic> transferDataMap = {};
  final Function(String) handleSelectedDateTimeStr = (String val) => print(val);

  double topSelMenuPosition = 200;

  @override
  State<EditableDateTime> createState() => _EditableDateTimeState();

  void handleDateTimeModification(String nowStr) {
    print(nowStr);
  }
}

class _EditableDateTimeState extends State<EditableDateTime> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );

    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }

    return selectedTime;
  }

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
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
              style: widget.labelTextStyle,
            ),
            const SizedBox(
              height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
            ),
            SizedBox(
              // Required to fix Row exception
              // layoutConstraints.maxWidth < double.infinity.
              width: 155,
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: widget.selectionColor,
                  ),
                ),
                child: GestureDetector(
                  child: Text(
                    getDateTime(),
                    style: widget.valueTextStyle,
                  ),
                  onTap: () {
                    _selectDateTime(context);
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
        Row(
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
        ),
      ],
    );
  }
}
