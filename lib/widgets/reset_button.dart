import 'package:flutter/material.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/screens/screen_mixin.dart';

/// 'Reset' button widget included in all Circadian Calculator
/// screens.
/// 
/// The widget has the advantage that the 'Reset' button is located
/// at the same position in all screens.
class ResetButton extends StatelessWidget with ScreenMixin {
  final void Function() _onPress;

  ResetButton({
    required void Function() onPress,
    Key? key,
  })  : _onPress = onPress,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: kResetButtonBottomDistance,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: appElevatedButtonBackgroundColor,
            shape: appElevatedButtonRoundedShape),
        onPressed: _onPress,
        child: const Text(
          'Reset',
          style: TextStyle(
            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
          ),
        ),
      ),
    );
  }
}
