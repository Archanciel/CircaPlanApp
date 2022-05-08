import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'screens/screen_mixin.dart';

import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/screens/date_time_difference_duration.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget with ScreenMixin {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: ScreenMixin.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: appTextAndIconColor, // requires with ScreenMixin !
          ),
        ),
        home: MainApp(),
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

class MainApp extends StatefulWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with ScreenMixin {
  final _navigationKey = GlobalKey<CurvedNavigationBarState>();
  int _index = 0; // initial selected screen
  final ScreenNavigTransData _screenNavigTransData =
      ScreenNavigTransData(transferDataMap: {});

  @override
  Widget build(BuildContext context) {
    final screens = [
      AddDurationToDateTime(screenNavigTransData: _screenNavigTransData),
      DateTimeDifferenceDuration(screenNavigTransData: _screenNavigTransData),
      CalculateSleepDuration(screenNavigTransData: _screenNavigTransData),
    ];

    final items = <Widget>[
      Image.asset(
        "images/add_duration_to_date_time_blue_trans.png",
        width: 36,
        height: 36,
      ),
      Image.asset(
        "images/time_difference_blue_trans.png",
        width: 35,
        height: 35,
      ),
      Image.asset(
        "images/calc_sleep_duration_blue_trans.png",
        width: 36,
        height: 36,
      ),
    ];

    /// For iOS platform: SafeArea and ClipRect needed
    return Container(
      color: Colors.blue,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.blue.shade900,
            appBar: AppBar(
              backgroundColor: Colors.blue.shade900,
              title: Text(
                ScreenMixin.appTitle,
                style: TextStyle(color: Colors.yellow.shade200),
              ),
              elevation: 0,
              centerTitle: true,
            ),
            body: screens[_index],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(color: Colors.blue.shade900),
              ),
              child: CurvedNavigationBar(
                key: _navigationKey,
                color: Colors.white,
                buttonBackgroundColor: Colors.yellow.shade200,
                backgroundColor: Colors.transparent,
                height: 55,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 500),
                index: _index,
                items: items,
                onTap: (index) => setState(() => _index = index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
