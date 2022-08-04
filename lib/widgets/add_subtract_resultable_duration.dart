import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/widgets/result_date_time.dart';

/// HH:MM editable widget with a '+' button changeable to '-'
/// button. Adds or subtracts the defined duration value to
/// the included ResultDateTime widget.
class AddSubtractResultableDuration extends StatelessWidget with ScreenMixin {
  static Color durationPositiveColor = Colors.green.shade200;
  static Color durationNegativeColor = Colors.red.shade200;

  /// TextEditingController passed to this DurationResultDateTime
  /// widget.
  final TextEditingController _durationTextFieldController;

  /// Function passed to this DurationResultDateTime widget.
  final Function _durationChangeFunction;

  IconData _durationIcon;
  Color _durationIconColor;
  Color _durationTextColor;
  int _durationSign;

  final String _dateTimeTitle;
  final TextEditingController _dateTimePickerController;
  final Function _handleDateTimeModificationFunction;
  final TransferDataViewModel _transferDataViewModel;

  // used to fill the display selection popup menu
  final Map<String, dynamic> _transferDataMap;

  final Function(String) _handleSelectedDateTimeStrFunction;
  final double _topSelMenuPosition;

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
  AddSubtractResultableDuration({
    required String dateTimeTitle,
    required TextEditingController endDateTimeController,
    required Function handleDateTimeModificationFunction,
    required Map<String, dynamic> transferDataMap,
    required Function(String) handleSelectedEndDateTimeStrFunction,
    required TransferDataViewModel transferDataViewModel,
    required double topSelMenuPosition,
    required TextEditingController durationTextFieldController,
    required Function durationChangeFunction,
    required IconData durationIcon,
    required Color durationIconColor,
    required Color durationTextColor,
    required int durationSign,
  })  : _dateTimeTitle = dateTimeTitle,
        _dateTimePickerController = endDateTimeController,
        _handleDateTimeModificationFunction =
            handleDateTimeModificationFunction,
        _transferDataMap = transferDataMap,
        _handleSelectedDateTimeStrFunction =
            handleSelectedEndDateTimeStrFunction,
        _topSelMenuPosition = topSelMenuPosition,
        _transferDataViewModel = transferDataViewModel,
        _durationTextFieldController = durationTextFieldController,
        _durationChangeFunction = durationChangeFunction,
        _durationIcon = durationIcon,
        _durationIconColor = durationIconColor,
        _durationTextColor = durationTextColor,
        _durationSign = durationSign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: labelTextStyle,
        ),
        Stack(
          children: [
            Positioned(
              left: -18,
              top: -10,
              child: TextButton.icon(
                icon: Icon(
                  _durationIcon,
                  size: 30,
                  color: _durationIconColor,
                ),
                label: const Text(''),
                onPressed: () {
                  if (_durationIcon == Icons.add) {
                    _durationIcon = Icons.remove;
                    _durationIconColor =
                        AddSubtractResultableDuration.durationNegativeColor;
                    _durationSign = -1;
                    _durationTextColor =
                        AddSubtractResultableDuration.durationNegativeColor;
                  } else {
                    _durationIcon = Icons.add;
                    _durationIconColor =
                        AddSubtractResultableDuration.durationPositiveColor;
                    _durationSign = 1;
                    _durationTextColor =
                        AddSubtractResultableDuration.durationPositiveColor;
                  }
                  _durationChangeFunction(
                    _durationSign,
                    _durationIcon,
                    _durationIconColor,
                    _durationTextColor,
                  );
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
                    selectionColor: selectionColor,
                    cursorColor: ScreenMixin.appTextAndIconColor,
                  ),
                ),
                child: GestureDetector(
                  child: TextField(
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: TextStyle(
                        color: _durationTextColor,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                    keyboardType: TextInputType.datetime,
                    controller: _durationTextFieldController,
                    onChanged: (val) {
                      _durationChangeFunction(
                        _durationSign,
                        _durationIcon,
                        _durationIconColor,
                        _durationTextColor,
                      );
                    },
                  ),
                  onDoubleTap: () async {
                    await copyToClipboard(
                        context: context,
                        controller: _durationTextFieldController);
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
          dateTimeTitle: _dateTimeTitle,
          dateTimePickerController: _dateTimePickerController,
          handleDateTimeModificationFunction:
              _handleDateTimeModificationFunction,
          transferDataMap: _transferDataMap,
          handleSelectedDateTimeStrFunction: _handleSelectedDateTimeStrFunction,
          topSelMenuPosition: _topSelMenuPosition,
          transferDataViewModel: _transferDataViewModel,
        ),
      ],
    );
  }
}
