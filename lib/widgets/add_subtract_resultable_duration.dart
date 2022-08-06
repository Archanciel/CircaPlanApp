import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/editable_date_time.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

/// HH:MM editable widget with a '+' button changeable to '-'
/// button. Adds or subtracts the defined duration value to
/// the included ResultDateTime widget. Additionally, 
class AddSubtractResultableDuration extends StatefulWidget with ScreenMixin {
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
  State<AddSubtractResultableDuration> createState() => _AddSubtractResultableDurationState();
}

class _AddSubtractResultableDurationState extends State<AddSubtractResultableDuration> {
  @override
  Widget build(BuildContext context) {
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
                icon: Icon(
                  widget._durationIcon,
                  size: 30,
                  color: widget._durationIconColor,
                ),
                label: const Text(''),
                onPressed: () {
                  if (widget._durationIcon == Icons.add) {
                    widget._durationIcon = Icons.remove;
                    widget._durationIconColor =
                        AddSubtractResultableDuration.durationNegativeColor;
                    widget._durationSign = -1;
                    widget._durationTextColor =
                        AddSubtractResultableDuration.durationNegativeColor;
                  } else {
                    widget._durationIcon = Icons.add;
                    widget._durationIconColor =
                        AddSubtractResultableDuration.durationPositiveColor;
                    widget._durationSign = 1;
                    widget._durationTextColor =
                        AddSubtractResultableDuration.durationPositiveColor;
                  }
                  widget._durationChangeFunction(
                    widget._durationSign,
                    widget._durationIcon,
                    widget._durationIconColor,
                    widget._durationTextColor,
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
                    selectionColor: widget.selectionColor,
                    cursorColor: ScreenMixin.appTextAndIconColor,
                  ),
                ),
                child: GestureDetector(
                  child: TextField(
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: TextStyle(
                        color: widget._durationTextColor,
                        fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                        fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                    keyboardType: TextInputType.datetime,
                    controller: widget._durationTextFieldController,
                    onChanged: (val) {
                      widget._durationChangeFunction(
                        widget._durationSign,
                        widget._durationIcon,
                        widget._durationIconColor,
                        widget._durationTextColor,
                      );
                    },
                  ),
                  onDoubleTap: () async {
                    await widget.copyToClipboard(
                        context: context,
                        controller: widget._durationTextFieldController);
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
          dateTimeTitle: widget._dateTimeTitle,
          dateTimePickerController: widget._dateTimePickerController,
          handleDateTimeModificationFunction:
              widget._handleDateTimeModificationFunction,
          transferDataMap: widget._transferDataMap,
          handleSelectedDateTimeStrFunction: widget._handleSelectedDateTimeStrFunction,
          topSelMenuPosition: widget._topSelMenuPosition,
          transferDataViewModel: widget._transferDataViewModel,
        ),
      ],
    );
  }
}
