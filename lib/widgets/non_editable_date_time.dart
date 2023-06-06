import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../constants.dart';
import '../screens/screen_mixin.dart';

class NonEditableDateTime extends StatelessWidget with ScreenMixin {
  NonEditableDateTime({
    Key? key,
    required this.dateTimeTitle,
    required TextEditingController dateTimeController,
    required Map<String, dynamic> transferDataMap,
    this.position = ToastPosition.center,
  })  : _dateTimeController = dateTimeController,
        _transferDataMap = transferDataMap,
        super(key: key);

  final String dateTimeTitle;
  final TextEditingController _dateTimeController;
  final Map<String, dynamic> _transferDataMap;
  final ToastPosition position;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateTimeTitle,
          style: labelTextStyle,
        ),
        const SizedBox(
          height: ScreenMixin.APP_LABEL_TO_TEXT_DISTANCE,
        ),
        GestureDetector(
          child: TextField(
            style: valueTextStyle,
            decoration: const InputDecoration.collapsed(hintText: ''),
            // prevents displaying copy paste menu !
            toolbarOptions: const ToolbarOptions(
                copy: false, paste: false, cut: false, selectAll: false),
            controller: _dateTimeController,
            readOnly: true,
          ),
          onDoubleTap: () async {
            await copyToClipboard(
              context: context,
              controller: _dateTimeController,
              extractHHmmFromCopiedStr: true,
              position: position,
            );
            _transferDataMap['clipboardLastAction'] = ClipboardLastAction.copy;
          },
        ),
      ],
    );
  }
}
