import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/constants.dart';
import 'package:circa_plan/widgets/add_subtract_resultable_duration.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/widgets/reset_button.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';

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
        super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _transferDataMap;
  final TransferDataViewModel _transferDataViewModel;

  String _startDateTimeStr = '';

  late TextEditingController _startDateTimePickerController;

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

    String startDateTimeStr = _transferDataMap['addDurStartDateTimeStr'] ??
        nowEnglishFormatDateTimeStr;

    _startDateTimePickerController =
        TextEditingController(text: startDateTimeStr);

    _thirdAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      widgetName: 'third',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 550.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: null,
    );

    _secondAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      widgetName: 'second',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 350.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _thirdAddSubtractResultableDurationWidget,
    );

    _firstAddSubtractResultableDurationWidget = AddSubtractResultableDuration(
      widgetName: 'first',
      dateTimeTitle: 'End date time',
      topSelMenuPosition: 250.0,
      nowDateTimeEnglishFormatStr: nowEnglishFormatDateTimeStr,
      transferDataViewModel: _transferDataViewModel,
      transferDataMap: _transferDataMap,
      nextAddSubtractResultableDuration: _secondAddSubtractResultableDurationWidget,
    );
  }

  @override
  void dispose() {
    _startDateTimePickerController.dispose();

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

    setState(() {});
    _updateTransferDataMap();
  }

  /// Private method called each time when the third End date
  /// time value is changed.
  void _updateThirdDuration(String thirdEndDateTimeEnglishFormatStr) {}

  void handleStartDateTimeChange(String englishFormatStartDateTimeStr) {
    _startDateTimeStr = englishFormatStartDateTimeStr;
    _firstAddSubtractResultableDurationWidget.setStartDateTimeStr(
        englishFormatStartDateTimeStr: englishFormatStartDateTimeStr);

    setState(() {});
    _updateTransferDataMap();
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
