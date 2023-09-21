// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'utils/date_time_computer.dart';
import 'package:circa_plan/utils/utility.dart';
import 'constants.dart';
import 'screens/screen_mixin.dart';
import 'package:circa_plan/screens/screen_navig_trans_data.dart';
import 'package:circa_plan/screens/add_duration_to_datetime.dart';
import 'package:circa_plan/screens/calculate_sleep_duration.dart';
import 'package:circa_plan/screens/date_time_difference_duration.dart';
import 'package:circa_plan/screens/time_calculator.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/circadian_snackbar.dart';
import 'model/menu_item_data.dart';
import 'package:circa_plan/widgets/circadian_flutter_toast.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  List<String> myArgs = [];

  if (args.isNotEmpty) {
    myArgs = args;
  } else {
    // myArgs = ["delAppDir"]; // used to empty dir on emulator
    //                            app dir
  }

  // two methods which could not be declared async !
  //
  // Setting the TransferDataViewModel transfer data Map
  bool deleteAppDir = false;

  if (myArgs.isNotEmpty) {
    if (myArgs.contains("delAppDir")) {
      deleteAppDir = true;
    }
  }

  // It was necessary to place here the asynchronous
  // TransferDataViewModel instanciation instead of locating it
  // in [_MainAppState.build()] or [_MainAppState.initState()],
  // reference is done at the beginning of the
  //_MainAppState.build() method.
  TransferDataViewModel transferDataViewModel =
      await instanciateTransferDataViewModel(isAppDirToBeDeleted: deleteAppDir);

  runApp(MyApp(transferDataViewModel: transferDataViewModel));
}

/// Async main method which instanciates and loads the
/// TransferDataViewModel.
Future<TransferDataViewModel> instanciateTransferDataViewModel({
  bool isAppDirToBeDeleted = false,
}) async {
  String path = Utility.getPlaylistDownloadHomePath();
  final Directory directory = Directory(path);
  bool directoryExists = await directory.exists();

  if (isAppDirToBeDeleted) {
    if (directoryExists) {
      TransferDataViewModel.deleteFilesInDir(path);
    }
  }

  if (!directoryExists) {
    await directory.create();
  }

  String transferDataJsonFilePathName =
      '$path${Platform.pathSeparator}$kDefaultJsonFileName';
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
      supportedLocales: const [
        Locale('fr', ''),
        Locale('en', ''),
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

  /// Method called after choosing a file to load in the load
  /// file popup menu opened after selecting the Load ... AppBar
  /// menu item.
  ///
  /// The method is also called when selecting the Undo AppBar
  /// menu item.
  ///
  /// Finally, the method is called when starting the
  /// application in order for the first screen to display the
  /// current circadian.json transfer data.
  void loadFileName(String selectedFileNameStr, [BuildContext? context]) {
    if (context == null) {
      return;
    }

    loadFileNameNoMsg(selectedFileNameStr);

    final CircadianSnackBar snackBar =
        CircadianSnackBar(message: '$selectedFileNameStr loaded');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Method called after choosing a file to delete in the
  /// delete file popup menu opened after selecting the
  /// Delete ... AppBar menu item.
  void _deleteFileName(String selectedFileNameStr, [BuildContext? context]) {
    if (context == null) {
      return;
    }

    String okButtonStr = 'Ok';
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context, 'Cancel'),
    );
    Widget okButton = TextButton(
      child: Text(okButtonStr),
      onPressed: () => Navigator.pop(context, okButtonStr),
    );

    showAlertDialog(
      buttonList: [cancelButton, okButton],
      dialogTitle: 'WARNING - $selectedFileNameStr will be deleted',
      dialogContent: 'Click on Cancel to avoid deleting $selectedFileNameStr',
      okValueStr: okButtonStr,
      okFunction: _applyDelete,
      context: context,
    );
  }

  void _applyDelete(
    BuildContext context,
    String dialogContentEndingWithDeletedFileName,
  ) {
    String fileName = Utility.extractFileName(
      filePathName: dialogContentEndingWithDeletedFileName,
    );
    String filePathName =
        '${Utility.getPlaylistDownloadHomePath()}${Platform.pathSeparator}$fileName';
    TransferDataViewModel.deleteFile(filePathName);

    final CircadianSnackBar snackBar =
        CircadianSnackBar(message: '$fileName deleted');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Method called in two situations:
  ///
  /// 1/ directly, when selecting Undo AppBar menu item
  /// 2/ indirectly, when loading a json file
  Future<void> loadFileNameNoMsg(String selectedFileNameStr) async {
    TransferDataViewModel transferDataViewModel = widget.transferDataViewModel;
    await transferDataViewModel.loadTransferData(
        jsonFileName: selectedFileNameStr);

    _screenNavigTransData.transferDataMap['currentScreenStateInstance']
        ?.callSetState();

    // fixes two Undo bugs which in fact have the same
    // cause:
    //
    // 1/ Undo repeated 3rd time had no effect and
    // 2/ first Undo after loading another json file
    //    twice had no effect
    transferDataViewModel.updateAndSaveTransferData();
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
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarCalcSleepDurationPageOne'),
        child: Image.asset(
          "images/calc_sleep_duration_blue_trans.png",
          width: 36,
          height: 36,
        ),
      ),
      KeyedSubtree(
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarWakeUpDurationPageTwo'),
        child: Image.asset(
          "images/time_difference_blue_trans.png",
          width: 35,
          height: 35,
        ),
      ),
      KeyedSubtree(
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarAddDurationToDateTimePageThree'),
        child: Image.asset(
          "images/add_duration_to_date_time_blue_trans.png",
          width: 36,
          height: 36,
        ),
      ),
      KeyedSubtree(
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarTimeCalculatorPageFour'),
        child: Image.asset(
          "images/calculate_time_blue_trans.png",
          width: 38,
          height: 38,
        ),
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Adds a call back function called after the _MainAppState
      // build() method has been executed. This solves the problem
      // of the first screen not displaying the values contained in
      // the circadian.json file.
      //
      // This anonymous function is called only once, when the app
      // is launched (or restarted).
      loadFileNameNoMsg('circadian.json');
    });
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
            actions: [
              PopupMenuButton(
                key: const Key('appBarPopupMenuButton'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(ScreenMixin.APP_ROUNDED_BOARDER_RADIUS),
                  ),
                ),
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
                  String saveAsFileName = getSaveAsFileName(
                    transferDataMap: _screenNavigTransData.transferDataMap,
                    transferDataViewModel: widget.transferDataViewModel,
                  );

                  if (saveAsFileName == '') {
                    saveAsFileName = kDefaultJsonFileName;
                  }

                  return [
                    const PopupMenuItem<int>(
                      key: Key('appBarMenuUndo'),
                      value: 0,
                      child: Text("Undo"),
                    ),
                    PopupMenuItem<int>(
                      key: const Key('appBarMenuSaveAs'),
                      value: 1,
                      child: Text("Save as $saveAsFileName"),
                    ),
                    const PopupMenuItem<int>(
                      key: Key('appBarMenuLoad'),
                      value: 2,
                      child: Text("Load ..."),
                    ),
                    const PopupMenuItem<int>(
                      key: Key('appBarMenuUploadToCloud'),
                      value: 3,
                      child: Text("Upload to cloud"),
                    ),
                    const PopupMenuItem<int>(
                      value: 4,
                      key: Key('appBarMenuDownloadFromCloud'),
                      child: Text("Download from cloud"),
                    ),
                    const PopupMenuItem<int>(
                      key: Key('appBarMenuDelete'),
                      value: 5,
                      child: Text("Delete ..."),
                    ),
                    const PopupMenuItem<int>(
                      key: Key('appBarMenuSettings'),
                      value: 6,
                      child: Text("Settings ..."),
                    ),
                    const PopupMenuItem<int>(
                      key: Key('appBarMenuAbout'),
                      value: 7,
                      child: Text("About ..."),
                    ),
                  ];
                },
                onSelected: (value) async {
                  switch (value) {
                    case 0:
                      {
                        // Undo selected ...
                        loadFileNameNoMsg('$kDefaultJsonFileName-1');
                        widget.transferDataViewModel
                            .updateAndSaveTransferData();

                        break;
                      }
                    case 1:
                      {
                        // Save as yyyy-mm-dd HH.mm.json selected ...
                        bool transferDataJsonFileCreated =
                            await transferDataViewModel.saveAsTransferData();
                        String snackBarMsg;

                        String saveAsFileName = getSaveAsFileName(
                          transferDataMap:
                              _screenNavigTransData.transferDataMap,
                          transferDataViewModel: widget.transferDataViewModel,
                        );

                        if (transferDataJsonFileCreated) {
                          snackBarMsg = '$saveAsFileName created';
                        } else {
                          snackBarMsg = '$saveAsFileName updated';
                        }

                        final CircadianSnackBar snackBar =
                            CircadianSnackBar(message: snackBarMsg);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        break;
                      }
                    case 2:
                      {
                        // Load selected ...
                        List<String> nonNullablefileNameLst =
                            getSortedFileNameLstInDir(
                                transferDataViewModel: transferDataViewModel,
                                addCircadianJsonFileNameToLst: true);

                        String? lastCreatedJsonFileNameStr;

                        if (nonNullablefileNameLst.isEmpty) {
                          displayWarningDialog(
                              context, 'No file available to load !');
                          return;
                        }

                        if (nonNullablefileNameLst.isNotEmpty) {
                          lastCreatedJsonFileNameStr =
                              nonNullablefileNameLst[0];
                        }

                        displayPopupMenu(
                          context: context,
                          selMenuDateTimeItemData: MenuItemData(
                            itemDataStrLst: nonNullablefileNameLst,
                            stylableItemValueStr: lastCreatedJsonFileNameStr,
                          ),
                          posRectangleLTRB: const RelativeRect.fromLTRB(
                            1.0,
                            130.0,
                            0.0,
                            0.0,
                          ),
                          handleSelectedItemFunction: loadFileName,
                        );

                        break;
                      }
                    case 3:
                      {
                        // Upload to cloud selected ...
                        print("Upload to cloud is selected.");

                        break;
                      }
                    case 4:
                      {
                        // Download from cloud selected ...
                        print("Download from cloud is selected.");

                        break;
                      }
                    case 5:
                      {
                        // Delete selected ...
                        List<String> nonNullablefileNameLst =
                            getSortedFileNameLstInDir(
                                transferDataViewModel: transferDataViewModel,
                                addCircadianJsonFileNameToLst: true);

                        String? lastCreatedJsonFileNameStr;

                        if (nonNullablefileNameLst.isEmpty) {
                          displayWarningDialog(
                              context, 'No file available to load !');
                          return;
                        }

                        if (nonNullablefileNameLst.isNotEmpty) {
                          lastCreatedJsonFileNameStr =
                              nonNullablefileNameLst[0];
                        }

                        displayPopupMenu(
                          context: context,
                          selMenuDateTimeItemData: MenuItemData(
                            itemDataStrLst: nonNullablefileNameLst,
                            stylableItemValueStr: lastCreatedJsonFileNameStr,
                          ),
                          posRectangleLTRB: const RelativeRect.fromLTRB(
                            1.0,
                            130.0,
                            0.0,
                            0.0,
                          ),
                          handleSelectedItemFunction: _deleteFileName,
                        );

                        break;
                      }
                    case 6:
                      {
                        // Settings selected ...
                        displayPopupMenu(
                          context: context,
                          selMenuDateTimeItemData: _buildSettingsMenuItemLst(),
                          posRectangleLTRB: const RelativeRect.fromLTRB(
                            1.0,
                            130.0,
                            0.0,
                            0.0,
                          ),
                          handleSelectedItemFunction: _applySettingsMenuItem,
                        );

                        break;
                      }
                    case 7:
                      {
                        showAboutDialog(
                          context: context,
                          applicationName: kApplicationName,
                          applicationVersion: kApplicationVersion,
                          applicationIcon:
                              Image.asset('images/circadian_app_icon.png'),
                          children: [
                            const Text('Author:'),
                            const Text('Jean-Pierre Schnyder / Switzerland'),
                          ],
                        );

                        break;
                      }
                    default:
                      {}
                  }
                },
              ),
            ],
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

  /// The user clicked on the Reset button on the screen
  /// whose instance is stored in the ScreenNavigTransData
  /// transferDataMap.
  void _resetScreen() {
    _screenNavigTransData.transferDataMap['currentScreenStateInstance']
        .resetScreen();
  }

  MenuItemData _buildSettingsMenuItemLst() {
    return MenuItemData(itemDataStrLst: ['Set medic time']);
  }

  Future<void> _applySettingsMenuItem(
      String menuItemStr, BuildContext? context) async {
    if (context == null) {
      return;
    }

    switch (menuItemStr) {
      case 'Set medic time':
        {
          String alarmMedicDateTimeStr =
              _screenNavigTransData.transferDataMap['alarmMedicDateTimeStr'] ??
                  '';
          _medicAlarmTimeController.text =
              alarmMedicDateTimeStr.split(' ').last;
          _medicAlarmDateTimeController.text = alarmMedicDateTimeStr;
          await _openSetMedicTimeDialog(context: context);
          String alarmTimeStr = _medicAlarmTimeController.text;

          if (alarmTimeStr == '') {
            // the case if Cancel button was pressed or if Clear
            // button was pressed and no time was entered
            return;
          }

          String medicAlarmDateTimeStr =
              DateTimeComputer.computeTodayOrTomorrowNextAlarmFrenchDateTimeStr(
            alarmHHmmTimeStr: alarmTimeStr,
          );

          if (medicAlarmDateTimeStr == '') {
            // the case if the entered alarmTimeStr is invalid
            CircadianFlutterToast.showToast(
              message: "Invalid alarm time $alarmTimeStr ignored !",
              positionWorkingOnOldAndroid: ToastGravity.TOP,
              isError: true,
            );

            return;
          }

          CircadianFlutterToast.showToast(
            message: medicAlarmDateTimeStr,
            positionWorkingOnOldAndroid: ToastGravity.TOP,
          );

          _screenNavigTransData.transferDataMap['alarmMedicDateTimeStr'] =
              medicAlarmDateTimeStr;
          widget.transferDataViewModel.updateAndSaveTransferData();

          var currentScreenInstance = _screenNavigTransData
              .transferDataMap['currentScreenStateInstance'];

          if (currentScreenInstance.widget is CalculateSleepDuration) {
            currentScreenInstance?.callSetState();
          }

          break;
        }
      default:
        break;
    }
  }

  Future<String?> _openSetMedicTimeDialog({required BuildContext context}) {
    void submit() {
      Navigator.of(context).pop();
    }

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        double settingsFieldWidth = 230;
        return AlertDialog(
          title: Text(
            'Set medic time',
            style: alertDialogTextStyle,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: settingsFieldWidth,
                    child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                          fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                          fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                      decoration: const InputDecoration(
                        hintText: 'HH:mm',
                      ),
                      controller: _medicAlarmTimeController,
                      onSubmitted: (_) => submit(),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: settingsFieldWidth,
                    child: TextField(
                      readOnly: true,
                      style: const TextStyle(
                          fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
                          fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
                      decoration: const InputDecoration(hintText: ''),
                      controller: _medicAlarmDateTimeController,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _medicAlarmTimeController.text = '';
                    submit();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _medicAlarmTimeController.text = '';
                    _medicAlarmDateTimeController.text = '';
                  },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: submit,
                  child: const Text('Set time'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
