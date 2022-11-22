import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/screen_mixin.dart';

class NonEditableDateTime extends StatelessWidget with ScreenMixin {
  NonEditableDateTime({
    Key? key,
    required this.dateTimeTitle,
    required TextEditingController dateTimeController,
    required Map<String, dynamic> transferDataMap,
  })  : _dateTimeController = dateTimeController,
        _transferDataMap = transferDataMap,
        super(key: key);

  final String dateTimeTitle;
  final TextEditingController _dateTimeController;
  final Map<String, dynamic> _transferDataMap;

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
            controller: _dateTimeController,
            readOnly: true,
          ),
          onDoubleTap: () async {
            await copyToClipboard(
              context: context,
              controller: _dateTimeController,
              extractHHmmFromCopiedStr: true,
            );
            _transferDataMap['clipboardLastAction'] = ClipboardLastAction.copy;
          },
        ),
      ],
    );
  }
}
