import 'dart:io';

import 'package:circa_plan/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants.dart';
import 'screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/screens/date_time_difference_duration.dart';
import 'package:circa_plan/screens/time_calculator.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // It was necessary to place here the asynchronous
  // TransferDataViewModel instanciation instead of locating it
  // in [_MainAppState.build()] or [_MainAppState.initState()],
  // reference is done at the beginning of the
  //_MainAppState.build() method.
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName:
          '${Utility.getPlaylistDownloadHomePath()}${Platform.pathSeparator}$kDefaultJsonFileName');

  runApp(MyApp(transferDataViewModel: transferDataViewModel));
}

class MyApp extends StatelessWidget with ScreenMixin {
  final TransferDataViewModel _transferDataViewModel;

  MyApp({
    Key? key,
    required TransferDataViewModel transferDataViewModel,
  })  : _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ScreenMixin.APP_TITLE,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
          selectionColor: selectionColor,
          selectionHandleColor: selectionColor,
        ),
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(ScreenMixin.APP_ROUNDED_BOARDER_RADIUS),
            ),
          ),
        ),
      ),
      home: MainApp(transferDataViewModel: _transferDataViewModel),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class MainApp extends StatefulWidget {
  final TransferDataViewModel transferDataViewModel;

  // used for widget testing only
  late _MainAppState stateInstance;
  _MainAppState get mainAppStateInstance => stateInstance;

  MainApp({
    Key? key,
    required this.transferDataViewModel,
  }) : super(key: key);

  @override
  State<MainApp> createState() {
    stateInstance = _MainAppState();

    return stateInstance;
  }
}

class _MainAppState extends State<MainApp> with ScreenMixin {
  final _navigationKey = GlobalKey<CurvedNavigationBarState>();
  int _currentIndex = 0; // initial selected screen
  final ScreenNavigTransData _screenNavigTransData =
      ScreenNavigTransData(transferDataMap: {});
  final TextEditingController _medicAlarmTimeController =
      TextEditingController();
  final TextEditingController _medicAlarmDateTimeController =
      TextEditingController();

  // data for CurvedNavigationBar

  late List<StatefulWidget> _screensLst;

  late List<String> _screenTitlesLst;

  late List<Widget> _curvedNavigationBarItemIconsLst;

  @override
  void dispose() {
    super.dispose();

    _medicAlarmTimeController.dispose();
    _medicAlarmDateTimeController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // data for CurvedNavigationBar

    _screensLst = [
      CalculateSleepDuration(
          screenNavigTransData: _screenNavigTransData,
          transferDataViewModel: widget.transferDataViewModel),
      DateTimeDifferenceDuration(
        screenNavigTransData: _screenNavigTransData,
        transferDataViewModel: widget.transferDataViewModel,
      ),
      AddDurationToDateTime(
        screenNavigTransData: _screenNavigTransData,
        transferDataViewModel: widget.transferDataViewModel,
      ),
      TimeCalculator(
        screenNavigTransData: _screenNavigTransData,
        transferDataViewModel: widget.transferDataViewModel,
      ),
    ];

    _screenTitlesLst = [
      ScreenMixin.CALCULATR_SLEEP_DURATION_TITLE,
      ScreenMixin.DATE_TIME_DIFF_DURATION_TITLE,
      ScreenMixin.APP_DURATION_TO_DATE_TIME_TITLE,
      ScreenMixin.TIME_CALCULATOR_TITLE,
    ];

    _curvedNavigationBarItemIconsLst = [
      KeyedSubtree(
        key: const ValueKey('navBarCalcSleepDurationPageOne'),
        child: Image.asset(
          "images/calc_sleep_duration_blue_trans.png",
          width: 36,
          height: 36,
        ),
      ),
      KeyedSubtree(
        key: const ValueKey('navBarWakeUpDurationPageTwo'),
        child: Image.asset(
          "images/time_difference_blue_trans.png",
          width: 35,
          height: 35,
        ),
      ),
      KeyedSubtree(
        key: const ValueKey('navBarAddDurationToDateTimePageThree'),
        child: Image.asset(
          "images/add_duration_to_date_time_blue_trans.png",
          width: 36,
          height: 36,
        ),
      ),
      KeyedSubtree(
        key: const ValueKey('navBarTimeCalculatorPageFour'),
        child: Image.asset(
          "images/calculate_time_blue_trans.png",
          width: 38,
          height: 38,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenMixin.setAppVerticalTopMargin(screenHeight);
    TransferDataViewModel transferDataViewModel = widget.transferDataViewModel;
    transferDataViewModel.transferDataMap =
        _screenNavigTransData.transferDataMap;

    /// For iOS platform: SafeArea and ClipRect needed
    return SafeArea(
      child: Container(
        color: ScreenMixin.APP_LIGHT_BLUE_COLOR,
        child: Scaffold(
          extendBody: true,
          backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
          appBar: AppBar(
            backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
            title: Text(
              _screenTitlesLst[_currentIndex],
              style: TextStyle(
                color: ScreenMixin.APP_LIGHTER_YELLOW_COLOR,
              ),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: DraggableScrollableSheet(
            initialChildSize: 1.0, // necessary to use full screen surface
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                // necessary for scrolling to work
                child: GestureDetector(
                  // enables that when clicking above or below a
                  // TextField, the keyboard is hidden. Otherwise,
                  // the keyboard remains open !
                  onTap: () {
                    // call this method here to hide soft keyboard
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: ScreenMixin.APP_LIGHT_BLUE_COLOR,
                        ),
                        child: SizedBox(
                            height: screenHeight - 80, // ok on S8
                            child: _screensLst[_currentIndex]),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: screenHeight - 193, // ok on S8
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            iconTheme: IconThemeData(
                              color: ScreenMixin.APP_DARK_BLUE_COLOR,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    key: const Key('resetButton'),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            appElevatedButtonBackgroundColor,
                                        shape: appElevatedButtonRoundedShape),
                                    onPressed: _resetScreen,
                                    child: const Text(
                                      'Reset',
                                      style: TextStyle(
                                        fontSize:
                                            ScreenMixin.APP_TEXT_FONT_SIZE,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurvedNavigationBar(
                                key: _navigationKey,
                                color: Colors.white,
                                buttonBackgroundColor:
                                    ScreenMixin.APP_LIGHT_YELLOW_COLOR,
                                backgroundColor: Colors.transparent,
                                height: 55,
                                animationCurve: Curves.easeInOut,
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                index: _currentIndex,
                                items: _curvedNavigationBarItemIconsLst,
                                onTap: (index) => setState(() {
                                  _currentIndex = index;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _resetScreen() {
    _screenNavigTransData.transferDataMap['currentScreenStateInstance']
        .resetScreen();
  }
}

// how can I switch to another app page in an integration test
