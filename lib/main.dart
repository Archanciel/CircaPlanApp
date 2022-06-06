import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'screens/screen_mixin.dart';

import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/screens/date_time_difference_duration.dart';
import 'package:circa_plan/screens/time_calculator.dart';

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
        title: ScreenMixin.APP_TITLE,
        theme: ThemeData(
          primarySwatch: Colors.blue, // using ScreenMixin.APP_LIGHT_BLUE_COLOR
//                                       not possible I don't know why !
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
  int _currentIndex = 0; // initial selected screen
  final ScreenNavigTransData _screenNavigTransData =
      ScreenNavigTransData(transferDataMap: {});

  _updateTransferDataMap() => _screenNavigTransData.transferDataMap;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenMixin.setAppVerticalTopMargin(screenHeight);

    // data for CurvedNavigationBar

    final List<StatefulWidget> screensLst = [
      AddDurationToDateTime(screenNavigTransData: _screenNavigTransData),
      DateTimeDifferenceDuration(screenNavigTransData: _screenNavigTransData),
      CalculateSleepDuration(screenNavigTransData: _screenNavigTransData),
      TimeCalculator(screenNavigTransData: _screenNavigTransData),
    ];

    final List<String> screenTitlesLst = [
      ScreenMixin.APP_DURATION_TO_DATE_TIME_TITLE,
      ScreenMixin.DATE_TIME_DIFF_DURATION_TITLE,
      ScreenMixin.CALCULATR_SLEEP_DURATION_TITLE,
      ScreenMixin.TIME_CALCULATOR_TITLE,
    ];

    final List<Widget> curvedNavigationBarItemIconsLst = [
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
      Image.asset(
        "images/calculate_time_blue_trans.png",
        width: 38,
        height: 38,
      ),
    ];

    /// For iOS platform: SafeArea and ClipRect needed
    return SafeArea(
      child: Container(
        color: ScreenMixin.APP_LIGHT_BLUE_COLOR,
        child: Scaffold(
          extendBody: true,
          backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 4,
                height: screenHeight * 0.09,
                child: AppBar(
                  backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
                  title: Text(
                    screenTitlesLst[_currentIndex],
                    style: TextStyle(color: ScreenMixin.APP_LIGHTER_YELLOW_COLOR),
                  ),
                  elevation: 0,
                  centerTitle: true,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: screenHeight * 0.09,
                height: screenHeight * 0.91,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ScreenMixin.APP_LIGHT_BLUE_COLOR,
                  ),
                  child: screensLst[_currentIndex],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(color: ScreenMixin.APP_DARK_BLUE_COLOR),
                  ),
                  child: CurvedNavigationBar(
                    key: _navigationKey,
                    color: Colors.white,
                    buttonBackgroundColor: ScreenMixin.APP_LIGHT_YELLOW_COLOR,
                    backgroundColor: Colors.transparent,
                    height: 55,
                    animationCurve: Curves.easeInOut,
                    animationDuration: Duration(milliseconds: 500),
                    index: _currentIndex,
                    items: curvedNavigationBarItemIconsLst,
                    onTap: (index) => setState(() {
                      _currentIndex = index;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
