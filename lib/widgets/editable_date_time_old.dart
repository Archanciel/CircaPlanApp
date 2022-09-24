import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

/// Widget which displays a DateTimePicker as well as a 'Now' and a
/// 'Sel' button.
///
/// Clicking on the DateTimePicker field opens the date time
/// selection dialog. 'Now' button sets the DateTimePicker to now,
/// 'Sel' button displays a date time selection menu in order to
/// choose the date time value to set in the DateTimePicker field.
///
/// This widget is included in the AddSubtractResultableDuration
/// widget.
class EditableDateTime extends StatelessWidget with ScreenMixin {
  final String _dateTimeTitle;
  final TextEditingController _dateTimePickerController;
  final Function _handleDateTimeModification;
  final TransferDataViewModel _transferDataViewModel;

  // used to fill the display selection popup menu
  final Map<String, dynamic> _transferDataMap;

  final Function(String) _handleSelectedDateTimeStr;
  final double _topSelMenuPosition;

  EditableDateTime({
    required String dateTimeTitle,
    required TextEditingController dateTimePickerController,
    required Function handleDateTimeModificationFunction,
    required Map<String, dynamic> transferDataMap,
    required Function(String) handleSelectedDateTimeStrFunction,
    required double topSelMenuPosition,
    required TransferDataViewModel transferDataViewModel,
  })  : _dateTimeTitle = dateTimeTitle,
        _dateTimePickerController = dateTimePickerController,
        _handleDateTimeModification = handleDateTimeModificationFunction,
        _transferDataMap = transferDataMap,
        _handleSelectedDateTimeStr = handleSelectedDateTimeStrFunction,
        _topSelMenuPosition = topSelMenuPosition,
        _transferDataViewModel = transferDataViewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dateTimeTitle,
              style: labelTextStyle,
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
                    selectionColor: selectionColor,
                  ),
                ),
                child: DateTimePicker(
                  key: const Key('editableDateTimePickerValue'),
                  type: DateTimePickerType.dateTime,
                  dateMask: 'dd-MM-yyyy HH:mm',
                  use24HourFormat: true,
                  controller: _dateTimePickerController,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: const Icon(
                    Icons.event,
                    color: ScreenMixin.appTextAndIconColor,
                    size: 30,
                  ),
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  style: valueTextStyle,
                  onChanged: (val) => _handleDateTimeModification(val),
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
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () {
                String nowStr = DateTime.now().toString();
                _dateTimePickerController.text = nowStr;
                _handleDateTimeModification(nowStr);
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
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () {
                displaySelPopupMenu(
                  context: context,
                  selectableStrItemLst: buildSortedAppDateTimeStrList(
                      transferDataMap: _transferDataMap,
                      mostRecentFirst: true,
                      transferDataViewModel: _transferDataViewModel),
                  posRectangleLTRB: RelativeRect.fromLTRB(
                    1.0,
                    _topSelMenuPosition,
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
    );
  }
}