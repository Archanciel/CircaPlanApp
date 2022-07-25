import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/duration_result_date_time.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/widgets/result_date_time.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:intl/intl.dart';

import 'package:circa_plan/utils/date_time_parser.dart';

class AddDurationToDateTime extends StatefulWidget {
  final ScreenNavigTransData _screenNavigTransData;
  final TransferDataViewModel _transferDataViewModel;

  const AddDurationToDateTime({
    Key? key,
    required ScreenNavigTransData screenNavigTransData,
    required TransferDataViewModel transferDataViewModel,
  })  : _screenNavigTransData = screenNavigTransData,
        _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  _AddDurationToDateTimeState createState() {
    return _AddDurationToDateTimeState(
        transferDataMap: _screenNavigTransData.transferDataMap,
        transferDataViewModel: _transferDataViewModel);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _AddDurationToDateTimeState extends State<AddDurationToDateTime>
    with ScreenMixin {
  _AddDurationToDateTimeState(
      {required Map<String, dynamic> transferDataMap,
      required TransferDataViewModel transferDataViewModel})
      : _transferDataMap = transferDataMap,
        _transferDataViewModel = transferDataViewModel,
        _durationIcon = transferDataMap['durationIconData'] ?? Icons.add,
        _durationIconColor =
            transferDataMap['durationIconColor'] ?? durationPositiveColor,
        _durationSign = transferDataMap['durationSign'] ?? 1,
        _durationTextColor =
            transferDataMap['durationTextColor'] ?? durationPositiveColor,
        _startDateTimeStr = transferDataMap['addDurStartDateTimeStr'] ??
            DateTime.now().toString(),
        _durationStr = transferDataMap['durationStr'] ?? '00:00',
        _endDateTimeStr = transferDataMap['endDateTimeStr'] ?? '',
        super();

  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  IconData _durationIcon;
  Color _durationIconColor;
  Color _durationTextColor;
  int _durationSign;
  String _startDateTimeStr = '';
  String _durationStr = '';
  String _endDateTimeStr = '';

  late TextEditingController _startDateTimeController;
  late TextEditingController _durationTextFieldController;
  late TextEditingController _endDateTimeTextFieldController;

  // Although defined in ScreenMixin, must be defined here since it is used in the
  // constructor where accessing to mixin data is not possible !
  final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();

    _startDateTimeController = TextEditingController(
        text: _transferDataMap['addDurStartDateTimeStr'] ?? nowDateTimeStr);
    _durationTextFieldController =
        TextEditingController(text: _transferDataMap['durationStr'] ?? '00:00');
    _endDateTimeTextFieldController =
        TextEditingController(text: _transferDataMap['endDateTimeStr'] ?? '');

    _endDateTimeStr = _transferDataMap['endDateTimeStr'] ?? '';
  }

  @override
  void dispose() {
    _startDateTimeController.dispose();
    _durationTextFieldController.dispose();
    _endDateTimeTextFieldController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    Map<String, dynamic> map = _transferDataMap;

    map['durationIconData'] = _durationIcon;
    map['durationIconColor'] = _durationIconColor;
    map['durationSign'] = _durationSign;
    map['durationTextColor'] = _durationTextColor;
    map['addDurStartDateTimeStr'] = _startDateTimeStr;
    map['durationStr'] = _durationStr;
    map['endDateTimeStr'] = _endDateTimeStr;

    _transferDataViewModel.updateAndSaveTransferData();

    return map;
  }

  void _resetScreen() {
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();
    _startDateTimeStr = nowDateTimeStr;
    _startDateTimeController.text = _startDateTimeStr;
    _durationStr = '00:00';
    _durationTextFieldController.text = _durationStr;
    _endDateTimeStr = '';
    _endDateTimeTextFieldController.text = _endDateTimeStr;

    setState(() {});

    _updateTransferDataMap();
  }

  void _handleSelectedDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _startDateTimeController.text = selectedDateTime.toString();

    _setStateEndDateTime();
  }

  void _setStateEndDateTimeForDurationSign(
    int durationSign,
    IconData durationIcon,
    Color durationIconColor,
    Color durationTextColor,
  ) {
    _durationSign = durationSign;
    _durationIcon = durationIcon;
    _durationIconColor = durationIconColor;
    _durationTextColor = durationTextColor;

    _setStateEndDateTime();
  }

  /// Private method called each time one of the elements
  /// implied in calculating the End date time value is
  /// changed.
  void _setStateEndDateTime() {
    _durationStr = _durationTextFieldController.text;
    Duration? duration = DateTimeParser.parseHHmmDuration(_durationStr);
    _startDateTimeStr = _startDateTimeController.text;
    DateTime startDateTime = englishDateTimeFormat.parse(_startDateTimeStr);
    DateTime endDateTime;

    if (duration != null) {
      if (_durationSign > 0) {
        endDateTime = startDateTime.add(duration);
      } else {
        endDateTime = startDateTime.subtract(duration);
      }

      _endDateTimeStr = frenchDateTimeFormat.format(endDateTime);
      _endDateTimeTextFieldController.text = _endDateTimeStr;

      setState(() {});

      _updateTransferDataMap();
    }
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
                  Row(
                    children: [
                      Text(
                        'Start date time',
                        style: TextStyle(
                          color: appLabelColor,
                          fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                          fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: selectionColor,
                      ),
                    ),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTime,
                      dateMask: 'dd-MM-yyyy HH:mm',
                      use24HourFormat: true,
                      controller: _startDateTimeController,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(
                        Icons.event,
                        color: appTextAndIconColor,
                        size: 30,
                      ),
                      decoration: const InputDecoration.collapsed(hintText: ''),
                      style: TextStyle(
                        color: appTextAndIconColor,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT,
                      ),
                      onChanged: (val) => _setStateEndDateTime(),
                    ),
                  ),
                  DurationResultDateTime(
                    resultDateTimeController: _endDateTimeTextFieldController,
                    durationTextFieldController: _durationTextFieldController,
                    updateTransferDataMapFunction: _updateTransferDataMap,
                    durationChangeFunction: _setStateEndDateTimeForDurationSign,
                    durationIcon: _durationIcon,
                    durationIconColor: _durationIconColor,
                    durationTextColor: _durationTextColor,
                    durationSign: _durationSign,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 26, // val 28 is compliant with current value 5
//                                  of APP_LABEL_TO_TEXT_DISTANCE
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          _startDateTimeController.text =
                              DateTime.now().toString();
                          _setStateEndDateTime();
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
                        style: ButtonStyle(
                            backgroundColor: appElevatedButtonBackgroundColor,
                            shape: appElevatedButtonRoundedShape),
                        onPressed: () {
                          displaySelPopupMenu(
                            context: context,
                            selectableStrItemLst: buildSortedAppDateTimeStrList(
                                transferDataMap: _transferDataMap,
                                mostRecentFirst: true),
                            posRectangleLTRB: const RelativeRect.fromLTRB(
                              1.0,
                              130.0,
                              0.0,
                              0.0,
                            ),
                            handleSelectedItem: _handleSelectedDateTimeStr,
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
              ),
            ),
            SizedBox(
              height: screenHeight *
                  ScreenMixin.APP_VERTICAL_TOP_RESET_BUTTON_MARGIN_PROPORTION,
            ),
            ResetButton(
              onPress: _resetScreen,
            ),
/*            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.fromLTRB(240, 404, 0, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: appElevatedButtonBackgroundColor,
                      shape: appElevatedButtonRoundedShape),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: ScreenMixin.appTextFontSize,
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
