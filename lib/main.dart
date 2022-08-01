import 'dart:io';

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
import 'package:circa_plan/widgets/circadian_snackbar.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  List<String> myArgs = [];

  if (args.isNotEmpty) {
    myArgs = args;
  } else {
    // myArgs = ["delAppDir"]; // used to empty dir on emulator
    //                            app dir
  }

  bool deleteAppDir = false;

  if (myArgs.isNotEmpty) {
    if (myArgs.contains("delAppDir")) {
      deleteAppDir = true;
    }
  }
  // It was necessary to place here the asynchronous
  // TransferDataViewModel instanciation instead of locating it
  // in [_MainAppState.build()] or [_MainAppState.initState()],
  // two methods which could not be declared async !
  //
  // Setting the TransferDataViewModel transfer data Map
  // reference is done at the beginning of the
  //_MainAppState.build() method.
  TransferDataViewModel transferDataViewModel =
      await instanciateTransferDataViewModel(deleteAppDir);

  runApp(MyApp(transferDataViewModel: transferDataViewModel));
}

/// Async main method which instanciates and loads the
/// TransferDataViewModel.
Future<TransferDataViewModel> instanciateTransferDataViewModel(
    bool deleteAppDir) async {
  String path = kDownloadAppDir;
  final Directory directory = Directory(path);
  bool directoryExists = await directory.exists();

  if (deleteAppDir) {
    if (directoryExists) {
      TransferDataViewModel.deleteFilesInDir(path);
    }
  }

  if (!directoryExists) {
    await directory.create();
  }

  String transferDataJsonFilePathName =
      '$path${Platform.pathSeparator}circadian.json';
  TransferDataViewModel transferDataViewModel = TransferDataViewModel(
      transferDataJsonFilePathName: transferDataJsonFilePathName);

  bool jsonFileExists = await File(transferDataJsonFilePathName).exists();

  if (jsonFileExists) {
    transferDataViewModel.loadTransferData();
  }

  return transferDataViewModel;
}

class MyApp extends StatelessWidget with ScreenMixin {
  final TransferDataViewModel _transferDataViewModel;
  MyApp({Key? key, required TransferDataViewModel transferDataViewModel})
      : _transferDataViewModel = transferDataViewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ScreenMixin.APP_TITLE,
      theme: ThemeData(
        primarySwatch:
            ScreenMixin.APP_LIGHT_BLUE_COLOR, // var untyped ScreenMixin const !
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ScreenMixin.appTextAndIconColor, // requires with ScreenMixin !
        ),
      ),
      home: MainApp(transferDataViewModel: _transferDataViewModel),
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

class MainApp extends StatefulWidget {
  final TransferDataViewModel transferDataViewModel;

  const MainApp({
    Key? key,
    required this.transferDataViewModel,
  }) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with ScreenMixin {
  final _navigationKey = GlobalKey<CurvedNavigationBarState>();
  int _currentIndex = 0; // initial selected screen
  final ScreenNavigTransData _screenNavigTransData =
      ScreenNavigTransData(transferDataMap: {});

  Future<void> _handleSelectedFileName(String selectedFileNameStr) async {
    TransferDataViewModel transferDataViewModel = widget.transferDataViewModel;
    await transferDataViewModel.loadTransferData(
        jsonFileName: selectedFileNameStr);

    final CircadianSnackBar snackBar =
        CircadianSnackBar(message: '$selectedFileNameStr loaded');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenMixin.setAppVerticalTopMargin(screenHeight);
    TransferDataViewModel transferDataViewModel = widget.transferDataViewModel;
    transferDataViewModel.transferDataMap =
        _screenNavigTransData.transferDataMap;

    // data for CurvedNavigationBar

    final List<StatefulWidget> screensLst = [
      AddDurationToDateTime(
        screenNavigTransData: _screenNavigTransData,
        transferDataViewModel: transferDataViewModel,
      ),
      DateTimeDifferenceDuration(
        screenNavigTransData: _screenNavigTransData,
        transferDataViewModel: transferDataViewModel,
      ),
      CalculateSleepDuration(
        screenNavigTransData: _screenNavigTransData,
        transferDataViewModel: transferDataViewModel,
      ),
      TimeCalculator(
        screenNavigTransData: _screenNavigTransData,
        transferDataViewModel: transferDataViewModel,
      ),
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
          appBar: AppBar(
            backgroundColor: ScreenMixin.APP_DARK_BLUE_COLOR,
            title: Text(
              screenTitlesLst[_currentIndex],
              style: TextStyle(color: ScreenMixin.APP_LIGHTER_YELLOW_COLOR),
            ),
            elevation: 0,
            centerTitle: true,
            actions: [
              PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
                  String saveAsFileName = _getSaveAsFileName();

                  if (saveAsFileName == '') {
                    saveAsFileName = kDefaultJsonFileName;
                  }

                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Save as $saveAsFileName"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Load ..."),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Upload to cloud"),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: Text("Download from cloud"),
                    ),
                    const PopupMenuItem<int>(
                      value: 4,
                      child: Text("Settings"),
                    ),
                  ];
                },
                onSelected: (value) async {
                  switch (value) {
                    case 0:
                      {
                        bool transferDataJsonFileCreated =
                            await transferDataViewModel.saveAsTransferData();
                        String snackBarMsg;

                        if (transferDataJsonFileCreated) {
                          snackBarMsg = '${_getSaveAsFileName()} created';
                        } else {
                          snackBarMsg = '${_getSaveAsFileName()} updated';
                        }

                        final CircadianSnackBar snackBar =
                            CircadianSnackBar(message: snackBarMsg);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        break;
                      }
                    case 1:
                      {
                        List<String> nonNullablefileNameLst =
                            _getSortedFileNameLstInDir(transferDataViewModel);

                        displaySelPopupMenu(
                          context: context,
                          selectableStrItemLst: nonNullablefileNameLst,
                          posRectangleLTRB: const RelativeRect.fromLTRB(
                            1.0,
                            130.0,
                            0.0,
                            0.0,
                          ),
                          handleSelectedItem: _handleSelectedFileName,
                        );
// not working                              setState(() {});
                        break;
                      }
                    case 2:
                      {
                        print("Upload is selected.");
                        break;
                      }
                    case 3:
                      {
                        print("Download is selected.");
                        break;
                      }
                    case 4:
                      {
                        print("Settings is selected.");
                        break;
                      }
                    default:
                      {}
                  }
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: screenHeight,
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
                    iconTheme:
                        IconThemeData(color: ScreenMixin.APP_DARK_BLUE_COLOR),
                  ),
                  child: CurvedNavigationBar(
                    key: _navigationKey,
                    color: Colors.white,
                    buttonBackgroundColor: ScreenMixin.APP_LIGHT_YELLOW_COLOR,
                    backgroundColor: Colors.transparent,
                    height: 55,
                    animationCurve: Curves.easeInOut,
                    animationDuration: const Duration(milliseconds: 500),
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

  /// Private method returning the Save as file name string.
  String _getSaveAsFileName() {
    Map<String, dynamic> transferDataMap =
        _screenNavigTransData.transferDataMap;

    if (transferDataMap.isEmpty) {
      return '';
    }

    String? calcSlDurNewDateTimeStr =
        transferDataMap['calcSlDurNewDateTimeStr'];

    if (calcSlDurNewDateTimeStr != null) {
      return '${calcSlDurNewDateTimeStr.replaceFirst(':', '.')}.json';
    } else {
      return '';
    }
  }

  /// Private method returning the sorted list of app data
  /// files located in the app data dir.
  List<String> _getSortedFileNameLstInDir(
      TransferDataViewModel transferDataViewModel) {
    List<String?> nullablefileNameLst =
        transferDataViewModel.getFileNameInDirLst(kDownloadAppDir);

    List<String> nonNullablefileNameLst =
        nullablefileNameLst.whereType<String>().toList();

    List<String> sortedFileNameLst = [];

    sortedFileNameLst.add(nonNullablefileNameLst
        .firstWhere((element) => element == 'circadian.json'));

    RegExp regExp = RegExp(r'^[\d\- \.]+json');
    List<String> dateTimeFileNameSortedLst =
        nonNullablefileNameLst.where((e) => regExp.hasMatch(e)).toList();
    dateTimeFileNameSortedLst.sort();
    sortedFileNameLst.addAll(dateTimeFileNameSortedLst.reversed);

    return sortedFileNameLst;
  }
}
