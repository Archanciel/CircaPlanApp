import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'screens/screen_mixin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with ScreenMixin {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ScreenMixin.appTitle,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: appTextAndIconColor, // requires with ScreenMixin !
        ),
      ),
      home: AddDurationToDateTime(
        screenNavigTransData: ScreenNavigTransData(transferDataMap: {}),
      ),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''),
        Locale('en', ''),
      ],
    );
  }
}
