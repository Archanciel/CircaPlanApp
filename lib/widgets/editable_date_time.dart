import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:circa_plan/screens/screen_mixin.dart';

/// Widget which displays DateTimePicker as well as a 'Now' and a
/// 'Sel' button.
/// 
/// Clicking on the DateTimePicker field opens the date time
/// selection dialog. 'Now' button sets the DateTimePicker to now,
/// 'Sel' button displays a date time selection menu in order to
/// choose the date time value to set in the DateTimePicker field.
class EditableDateTime extends StatelessWidget with ScreenMixin {
  final String _dateTimeTitle;
  final TextEditingController _dateTimePickerController;
  final Function _handleDateTimeModification;

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
  })  : _dateTimeTitle = dateTimeTitle,
        _dateTimePickerController = dateTimePickerController,
        _handleDateTimeModification = handleDateTimeModificationFunction,
        _transferDataMap = transferDataMap,
        _handleSelectedDateTimeStr = handleSelectedDateTimeStrFunction,
        _topSelMenuPosition = topSelMenuPosition;

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
                  onChanged: (val) => _handleDateTimeModification(),
                ),
              ),
            ),
            const SizedBox(
              height: 25, //  required for correct Now and Sel buttons
              //              positioning.
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: appElevatedButtonBackgroundColor,
                  shape: appElevatedButtonRoundedShape),
              onPressed: () {
                _dateTimePickerController.text = DateTime.now().toString();
                _handleDateTimeModification();
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
                      transferDataMap: _transferDataMap, mostRecentFirst: true),
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
