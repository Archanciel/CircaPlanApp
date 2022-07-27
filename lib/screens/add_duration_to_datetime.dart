import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/duration_result_date_time.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
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
        _startDateTimeStr = transferDataMap['addDurStartDateTimeStr'] ??
            DateTime.now().toString(),
        _firstDurationIcon =
            transferDataMap['firstDurationIconData'] ?? Icons.add,
        _firstDurationIconColor = transferDataMap['firstDurationIconColor'] ??
            DurationResultDateTime.durationPositiveColor,
        _firstDurationSign = transferDataMap['firstDurationSign'] ?? 1,
        _firstDurationTextColor = transferDataMap['firstDurationTextColor'] ??
            DurationResultDateTime.durationPositiveColor,
        _firstDurationStr = transferDataMap['firstDurationStr'] ?? '00:00',
        _firstEndDateTimeStr = transferDataMap['firstEndDateTimeStr'] ?? '',
        _secondDurationIcon =
            transferDataMap['secondDurationIconData'] ?? Icons.add,
        _secondDurationIconColor = transferDataMap['secondDurationIconColor'] ??
            DurationResultDateTime.durationPositiveColor,
        _secondDurationSign = transferDataMap['secondDurationSign'] ?? 1,
        _secondDurationTextColor = transferDataMap['secondDurationTextColor'] ??
            DurationResultDateTime.durationPositiveColor,
        _secondDurationStr = transferDataMap['secondDurationStr'] ?? '00:00',
        _secondEndDateTimeStr = transferDataMap['secondEndDateTimeStr'] ?? '',
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _startDateTimeStr = '';

  IconData _firstDurationIcon;
  Color _firstDurationIconColor;
  Color _firstDurationTextColor;
  int _firstDurationSign;
  String _firstDurationStr = '';
  String _firstEndDateTimeStr = '';

  IconData _secondDurationIcon;
  Color _secondDurationIconColor;
  Color _secondDurationTextColor;
  int _secondDurationSign;
  String _secondDurationStr = '';
  String _secondEndDateTimeStr = '';

  late TextEditingController _startDateTimeController;

  late TextEditingController _firstDurationTextFieldController;
  late TextEditingController _firstEndDateTimeTextFieldController;

  late TextEditingController _secondDurationTextFieldController;
  late TextEditingController _secondEndDateTimeTextFieldController;

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
    _firstDurationTextFieldController = TextEditingController(
        text: _transferDataMap['firstDurationStr'] ?? '00:00');
    _firstEndDateTimeStr = _transferDataMap['firstEndDateTimeStr'] ?? '';
    _firstEndDateTimeTextFieldController = TextEditingController(
        text: _firstEndDateTimeStr);
    _secondDurationTextFieldController = TextEditingController(
        text: _transferDataMap['secondDurationStr'] ?? '00:00');
    _secondEndDateTimeStr = _transferDataMap['secondEndDateTimeStr'] ?? '';
    _secondEndDateTimeTextFieldController = TextEditingController(
        text: _secondEndDateTimeStr);
  }

  @override
  void dispose() {
    _startDateTimeController.dispose();
    _firstDurationTextFieldController.dispose();
    _firstEndDateTimeTextFieldController.dispose();
    _secondDurationTextFieldController.dispose();
    _secondEndDateTimeTextFieldController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {

    _transferDataMap['addDurStartDateTimeStr'] = _startDateTimeStr;

    _transferDataMap['firstDurationIconData'] = _firstDurationIcon;
    _transferDataMap['firstDurationIconColor'] = _firstDurationIconColor;
    _transferDataMap['firstDurationSign'] = _firstDurationSign;
    _transferDataMap['firstDurationTextColor'] = _firstDurationTextColor;
    _transferDataMap['firstDurationStr'] = _firstDurationStr;
    _transferDataMap['firstEndDateTimeStr'] = _firstEndDateTimeStr;

    _transferDataMap['secondDurationIconData'] = _secondDurationIcon;
    _transferDataMap['secondDurationIconColor'] = _secondDurationIconColor;
    _transferDataMap['secondDurationSign'] = _secondDurationSign;
    _transferDataMap['secondDurationTextColor'] = _secondDurationTextColor;
    _transferDataMap['secondDurationStr'] = _secondDurationStr;
    _transferDataMap['secondEndDateTimeStr'] = _secondEndDateTimeStr;

    _transferDataViewModel.updateAndSaveTransferData();

    return _transferDataMap;
  }

  void _resetScreen() {
    final DateTime dateTimeNow = DateTime.now();
    String nowDateTimeStr = dateTimeNow.toString();
    _startDateTimeStr = nowDateTimeStr;
    _startDateTimeController.text = _startDateTimeStr;
    _firstDurationStr = '00:00';
    _firstDurationTextFieldController.text = _firstDurationStr;
    _firstEndDateTimeStr = '';
    _firstEndDateTimeTextFieldController.text = _firstEndDateTimeStr;
    _secondDurationStr = '00:00';
    _secondDurationTextFieldController.text = _secondDurationStr;
    _secondEndDateTimeStr = '';
    _secondEndDateTimeTextFieldController.text = _secondEndDateTimeStr;

    setState(() {});

    _updateTransferDataMap();
  }

  void _handleSelectedDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _startDateTimeController.text = selectedDateTime.toString();

    _computeEndDateTimes();
  }

  /// Method passed to the first DurationResultDateTime widget
  /// and called when the duration +/- button is pressed or when
  /// the duration value is changed.
  /// 
  /// The important method parameter is durationSign which has
  /// a value of 1 or -1. The 3 other parameters will be removed
  /// once the transfer data map will be suppressed.
  void setFirstStateEndDateTimeForFirstDurationSign(
    int durationSign,
    IconData durationIcon,
    Color durationIconColor,
    Color durationTextColor,
  ) {
    _firstDurationSign = durationSign;
    _firstDurationIcon = durationIcon;
    _firstDurationIconColor = durationIconColor;
    _firstDurationTextColor = durationTextColor;

    _computeEndDateTimes();
  }

  /// Method passed to the second DurationResultDateTime widget
  /// and called when the duration +/- button is pressed or when
  /// the duration value is changed.
  /// 
  /// The important method parameter is durationSign which has
  /// a value of 1 or -1. The 3 other parameters will be removed
  /// once the transfer data map will be suppressed.
  void setSecondStateEndDateTimeForSecondDurationSign(
    int durationSign,
    IconData durationIcon,
    Color durationIconColor,
    Color durationTextColor,
  ) {
    _secondDurationSign = durationSign;
    _secondDurationIcon = durationIcon;
    _secondDurationIconColor = durationIconColor;
    _secondDurationTextColor = durationTextColor;

    _computeEndDateTimes();
  }

  /// Private method called each time one of the elements
  /// implied in calculating the first an the second End date
  /// time values is changed.
  void _computeEndDateTimes() {
    _startDateTimeStr = _startDateTimeController.text;
    DateTime startDateTime = englishDateTimeFormat.parse(_startDateTimeStr);

    _firstDurationStr = _firstDurationTextFieldController.text;
    Duration? firstDuration =
        DateTimeParser.parseHHmmDuration(_firstDurationStr);
    DateTime firstEndDateTime;

    if (firstDuration != null) {
      if (_firstDurationSign > 0) {
        firstEndDateTime = startDateTime.add(firstDuration);
      } else {
        firstEndDateTime = startDateTime.subtract(firstDuration);
      }

      _firstEndDateTimeStr = frenchDateTimeFormat.format(firstEndDateTime);
      _firstEndDateTimeTextFieldController.text = _firstEndDateTimeStr;

      _secondDurationStr = _secondDurationTextFieldController.text;
      Duration? secondDuration =
          DateTimeParser.parseHHmmDuration(_secondDurationStr);
      DateTime secondEndDateTime;

      if (secondDuration != null) {
        if (_secondDurationSign > 0) {
          secondEndDateTime = firstEndDateTime.add(secondDuration);
        } else {
          secondEndDateTime = firstEndDateTime.subtract(secondDuration);
        }

        _secondEndDateTimeStr = frenchDateTimeFormat.format(secondEndDateTime);
        _secondEndDateTimeTextFieldController.text = _secondEndDateTimeStr;

        setState(() {});

        _updateTransferDataMap();
      }
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
                      onChanged: (val) => _computeEndDateTimes(),
                    ),
                  ),
                  // First duration addition/subtraction
                  DurationResultDateTime(
                    resultDateTimeController:
                        _firstEndDateTimeTextFieldController,
                    durationTextFieldController:
                        _firstDurationTextFieldController,
                    durationChangeFunction:
                        setFirstStateEndDateTimeForFirstDurationSign,
                    durationIcon: _firstDurationIcon,
                    durationIconColor: _firstDurationIconColor,
                    durationTextColor: _firstDurationTextColor,
                    durationSign: _firstDurationSign,
                  ),
                  // Second duration addition/subtraction
                  DurationResultDateTime(
                    resultDateTimeController:
                        _secondEndDateTimeTextFieldController,
                    durationTextFieldController:
                        _secondDurationTextFieldController,
                    durationChangeFunction:
                        setSecondStateEndDateTimeForSecondDurationSign,
                    durationIcon: _secondDurationIcon,
                    durationIconColor: _secondDurationIconColor,
                    durationTextColor: _secondDurationTextColor,
                    durationSign: _secondDurationSign,
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
