import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/add_subtract_duration.dart';
import 'package:circa_plan/widgets/add_subtract_resultable_duration.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
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
            AddSubtractDuration.durationPositiveColor,
        _firstDurationSign = transferDataMap['firstDurationSign'] ?? 1,
        _firstDurationTextColor = transferDataMap['firstDurationTextColor'] ??
            AddSubtractDuration.durationPositiveColor,
        _firstDurationStr = transferDataMap['firstDurationStr'] ?? '00:00',
        _firstEndDateTimeStr = transferDataMap['firstEndDateTimeStr'] ?? '',
        _secondDurationIcon =
            transferDataMap['secondDurationIconData'] ?? Icons.add,
        _secondDurationIconColor = transferDataMap['secondDurationIconColor'] ??
            AddSubtractDuration.durationPositiveColor,
        _secondDurationSign = transferDataMap['secondDurationSign'] ?? 1,
        _secondDurationTextColor = transferDataMap['secondDurationTextColor'] ??
            AddSubtractDuration.durationPositiveColor,
        _secondDurationStr = transferDataMap['secondDurationStr'] ?? '00:00',
        _secondEndDateTimeStr = transferDataMap['secondEndDateTimeStr'] ?? '',
        _thirdDurationIcon =
            transferDataMap['thirdDurationIconData'] ?? Icons.add,
        _thirdDurationIconColor = transferDataMap['thirdDurationIconColor'] ??
            AddSubtractDuration.durationPositiveColor,
        _thirdDurationSign = transferDataMap['thirdDurationSign'] ?? 1,
        _thirdDurationTextColor = transferDataMap['thirdDurationTextColor'] ??
            AddSubtractDuration.durationPositiveColor,
        _thirdDurationStr = transferDataMap['thirdDurationStr'] ?? '00:00',
        _thirdEndDateTimeEnglishFormatStr =
            transferDataMap['thirdEndDateTimeStr'] ?? '',
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

  IconData _thirdDurationIcon;
  Color _thirdDurationIconColor;
  Color _thirdDurationTextColor;
  int _thirdDurationSign;
  String _thirdDurationStr = '';
  String _thirdEndDateTimeEnglishFormatStr = '';

  late TextEditingController _startDateTimePickerController;

  late TextEditingController _firstDurationTextFieldController;
  late TextEditingController _firstEndDateTimeTextFieldController;

  late TextEditingController _secondDurationTextFieldController;
  late TextEditingController _secondEndDateTimeTextFieldController;

  late TextEditingController _thirdDurationTextFieldController;
  late TextEditingController _thirdEndDateTimePickerController;

  late AddSubtractResultableDuration _firstAddSubtractResultableDurationWidget;
  late AddSubtractResultableDuration _secondAddSubtractResultableDurationWidget;
  late AddSubtractResultableDuration _thirdAddSubtractResultableDurationWidget;

  // Although defined in ScreenMixin, must be defined here since it is used in the
  // constructor where accessing to mixin data is not possible !
  final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();

    // String value used to initialize DateTimePicker field
    String nowEnglishFormatDateTimeStr = dateTimeNow.toString();

    // String value used to initialize TextField field
    String nowDateTimeStr = frenchDateTimeFormat.format(dateTimeNow);

    String startDateTimeStr =
        _transferDataMap['addDurStartDateTimeStr'] ?? nowEnglishFormatDateTimeStr;

    _startDateTimePickerController =
        TextEditingController(text: startDateTimeStr);

    String firstDurationStr = _transferDataMap['firstDurationStr'] ?? '00:00';

    _firstDurationTextFieldController =
        TextEditingController(text: firstDurationStr);
    _firstEndDateTimeStr =
        _transferDataMap['firstEndDateTimeStr'] ?? nowDateTimeStr;
    _firstEndDateTimeTextFieldController =
        TextEditingController(text: _firstEndDateTimeStr);

    String secondDurationStr = _transferDataMap['secondDurationStr'] ?? '00:00';

    _secondDurationTextFieldController =
        TextEditingController(text: secondDurationStr);
    _secondEndDateTimeStr =
        _transferDataMap['secondEndDateTimeStr'] ?? nowDateTimeStr;
    _secondEndDateTimeTextFieldController =
        TextEditingController(text: _secondEndDateTimeStr);

    String thirdDurationStr = _transferDataMap['thirdDurationStr'] ?? '00:00';

    _thirdDurationTextFieldController =
        TextEditingController(text: thirdDurationStr);
    _thirdEndDateTimeEnglishFormatStr =
        _transferDataMap['thirdEndDateTimeStr'] ?? nowEnglishFormatDateTimeStr;
    _thirdEndDateTimePickerController =
        TextEditingController(text: _thirdEndDateTimeEnglishFormatStr);

   String nowDateTimeEnglishFormatStr = dateTimeNow.toString();

    _thirdAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      widgetName: 'third',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 550.0,
      startDateTimeStr: nowDateTimeEnglishFormatStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: null,
    );

    _secondAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      widgetName: 'second',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 350.0,
      startDateTimeStr: nowDateTimeEnglishFormatStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration:
          _thirdAddSubtractResultableDurationWidget,
    );

    _firstAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      widgetName: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 250.0,
      startDateTimeStr: nowDateTimeEnglishFormatStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration:
          _secondAddSubtractResultableDurationWidget,
    );
  }

  @override
  void dispose() {
    _startDateTimePickerController.dispose();
    _firstDurationTextFieldController.dispose();
    _firstEndDateTimeTextFieldController.dispose();
    _secondDurationTextFieldController.dispose();
    _secondEndDateTimeTextFieldController.dispose();
    _thirdDurationTextFieldController.dispose();
    _thirdEndDateTimePickerController.dispose();

    super.dispose();
  }

  Map<String, dynamic> _updateTransferDataMap() {
    _transferDataMap['addDurStartDateTimeStr'] = _startDateTimeStr;

    _transferDataViewModel.updateAndSaveTransferData();

    return _transferDataMap;
  }

  void _resetScreen() {
    final DateTime dateTimeNow = DateTime.now();
    // String value used to initialize DateTimePicker field
    String nowDateTimePickerStr = dateTimeNow.toString();

    // String value used to initialize TextField field
    String nowDateTimeStr = frenchDateTimeFormat.format(dateTimeNow);

    _startDateTimeStr = nowDateTimePickerStr;
    _startDateTimePickerController.text = _startDateTimeStr;

    _firstAddSubtractResultableDurationWidget.reset();

    setState(() {});
    _updateTransferDataMap();
  }

  void _handleSelectedStartDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    String englishFormatStartDateTimeStr = selectedDateTime.toString();

    _startDateTimePickerController.text = englishFormatStartDateTimeStr;
    _firstAddSubtractResultableDurationWidget.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);

    _computeEndDateTimes('');
  }

  void _handleSelectedThirdEndDateTimeStr(String selectedDateTimeStr) {
    DateTime selectedDateTime = frenchDateTimeFormat.parse(selectedDateTimeStr);
    _thirdEndDateTimeEnglishFormatStr =
        englishDateTimeFormat.format(selectedDateTime);
    _thirdEndDateTimePickerController.text = _thirdEndDateTimeEnglishFormatStr;

    _updateThirdDuration(_thirdEndDateTimeEnglishFormatStr);
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

    _computeEndDateTimes('');
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

    _computeEndDateTimes('');
  }

  /// Method passed to the third DurationResultDateTime widget
  /// and called when the duration +/- button is pressed or when
  /// the duration value is changed.
  ///
  /// The important method parameter is durationSign which has
  /// a value of 1 or -1. The 3 other parameters will be removed
  /// once the transfer data map will be suppressed.
  void setThirdStateEndDateTimeForThirdDurationSign(
    int durationSign,
    IconData durationIcon,
    Color durationIconColor,
    Color durationTextColor,
  ) {
    _thirdDurationSign = durationSign;
    _thirdDurationIcon = durationIcon;
    _thirdDurationIconColor = durationIconColor;
    _thirdDurationTextColor = durationTextColor;

    _computeEndDateTimes('');
  }

  /// Private method called each time when the third End date
  /// time value is changed.
  void _updateThirdDuration(String thirdEndDateTimeEnglishFormatStr) {
    final String secondEndDateTimeStr =
        _secondEndDateTimeTextFieldController.text;
    DateTime? secondEndDateTime;

    try {
      secondEndDateTime = frenchDateTimeFormat.parse(secondEndDateTimeStr);
    } on FormatException {}

    _thirdEndDateTimeEnglishFormatStr = thirdEndDateTimeEnglishFormatStr;
    DateTime? thirdEndDateTime;

    try {
      thirdEndDateTime =
          englishDateTimeFormat.parse(_thirdEndDateTimeEnglishFormatStr);
    } on FormatException {}

    Duration thirdDuration;

    if (secondEndDateTime != null && thirdEndDateTime != null) {
      Duration thirdDuration = thirdEndDateTime.difference(secondEndDateTime);
      _thirdDurationStr = thirdDuration.HHmm().replaceAll('-', '');
      _thirdDurationTextFieldController.text = _thirdDurationStr;
      _setThirdDurationAppearance(isNegative: thirdDuration.isNegative);

      setState(() {});
      _updateTransferDataMap();
    }
  }

  void _setFirstDurationAppearance({required bool isNegative}) {
    if (isNegative) {
      _firstDurationIcon = Icons.remove;
      _firstDurationIconColor = AddSubtractDuration.durationNegativeColor;
      _firstDurationSign = -1;
      _firstDurationTextColor = AddSubtractDuration.durationNegativeColor;
    } else {
      _firstDurationIcon = Icons.add;
      _firstDurationIconColor = AddSubtractDuration.durationPositiveColor;
      _firstDurationSign = 1;
      _firstDurationTextColor = AddSubtractDuration.durationPositiveColor;
    }
  }

  void _setSecondDurationAppearance({required bool isNegative}) {
    if (isNegative) {
      _secondDurationIcon = Icons.remove;
      _secondDurationIconColor = AddSubtractDuration.durationNegativeColor;
      _secondDurationSign = -1;
      _secondDurationTextColor = AddSubtractDuration.durationNegativeColor;
    } else {
      _secondDurationIcon = Icons.add;
      _secondDurationIconColor = AddSubtractDuration.durationPositiveColor;
      _secondDurationSign = 1;
      _secondDurationTextColor = AddSubtractDuration.durationPositiveColor;
    }
  }

  void _setThirdDurationAppearance({required bool isNegative}) {
    if (isNegative) {
      _thirdDurationIcon = Icons.remove;
      _thirdDurationIconColor = AddSubtractDuration.durationNegativeColor;
      _thirdDurationSign = -1;
      _thirdDurationTextColor = AddSubtractDuration.durationNegativeColor;
    } else {
      _thirdDurationIcon = Icons.add;
      _thirdDurationIconColor = AddSubtractDuration.durationPositiveColor;
      _thirdDurationSign = 1;
      _thirdDurationTextColor = AddSubtractDuration.durationPositiveColor;
    }
  }

  void handleStartDateTimeChange(String englishFormatStartDateTimeStr) {
    _startDateTimeStr = englishFormatStartDateTimeStr;
    _firstAddSubtractResultableDurationWidget.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);

    setState(() {});
    _updateTransferDataMap();
  }

  /// Private method called each time one of the elements
  /// implied in calculating the first an the second End date
  /// time values is changed.
  void _computeEndDateTimes(String endDatimeStr) {
    _startDateTimeStr = _startDateTimePickerController.text;
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

        _thirdDurationStr = _thirdDurationTextFieldController.text;
        Duration? thirdDuration =
            DateTimeParser.parseHHmmDuration(_thirdDurationStr);
        DateTime thirdEndDateTime;

        if (thirdDuration != null) {
          if (_thirdDurationSign > 0) {
            thirdEndDateTime = secondEndDateTime.add(thirdDuration);
          } else {
            thirdEndDateTime = secondEndDateTime.subtract(thirdDuration);
          }

          // since the controller is linked to a DateTimePicker
          // instance, the date time string must be in english format,
          // instead of french format !
          _thirdEndDateTimeEnglishFormatStr =
              englishDateTimeFormat.format(thirdEndDateTime);
          _thirdEndDateTimePickerController.text =
              _thirdEndDateTimeEnglishFormatStr;

          setState(() {});
          _updateTransferDataMap();
        }
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
                  EditableDateTime(
                    dateTimeTitle: 'Start date time',
                    dateTimePickerController: _startDateTimePickerController,
                    handleDateTimeModificationFunction:
                        handleStartDateTimeChange,
                    transferDataMap: _transferDataMap,
                    handleSelectedDateTimeStrFunction:
                        _handleSelectedStartDateTimeStr,
                    topSelMenuPosition: 135.0,
                    transferDataViewModel: _transferDataViewModel,
                  ),
                  // First duration addition/subtraction
                  _firstAddSubtractResultableDurationWidget,
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistanceAddSubScreen,
                  ),
                  // Second duration addition/subtraction
                  _secondAddSubtractResultableDurationWidget,
                  const SizedBox(
                    //  necessary since
                    //                  EditableDateTime must
                    //                  include a SizedBox of kVerticalFieldDistanceAddSubScreen
                    //                  height ...
                    height: kVerticalFieldDistanceAddSubScreen,
                  ),
                  // Second duration addition/subtraction
                  _thirdAddSubtractResultableDurationWidget,
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Column(
                children: [],
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
