// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/buslog/transfer_data_view_model.dart';
import 'package:circa_plan/widgets/circadian_snackbar.dart';
import '../model/menu_item_data.dart';

/// This mixin class contains UI parameters used by all the Circa
/// application screens. Since it is not possible to define a
/// base class for the statefull widgets, using a mixin class
/// to add those common instance variables to the statefull
/// widgets solves the problem.
mixin ScreenMixin {
  static Color APP_DARK_BLUE_COLOR = Colors.blue.shade900;
  static MaterialColor APP_MATERIAL_APP_DARK_BLUE_COLOR = MaterialColor(
    APP_DARK_BLUE_COLOR.value,
    {
      500: APP_DARK_BLUE_COLOR,
    },
  );
  static Color APP_LIGHT_BLUE_COLOR = Colors.blue;
  static MaterialColor APP_MATERIAL_APP_LIGHT_BLUE_COLOR = Colors.blue;
  static Color APP_LIGHT_YELLOW_COLOR = Colors.yellow.shade300;
  static Color APP_LIGHTER_YELLOW_COLOR = Colors.yellow.shade200;
  static MaterialColor APP_MATERIAL_APP_LIGHTER_YELLOW_COLOR = MaterialColor(
    APP_LIGHTER_YELLOW_COLOR.value,
    {
      500: APP_LIGHTER_YELLOW_COLOR,
    },
  );
  static double app_computed_vertical_top_margin = 0;
  static const String APP_TITLE = 'Circadian Calculator';
  static const Color APP_TEXT_AND_ICON_COLOR = Colors.white;
  static const FontWeight APP_TEXT_FONT_WEIGHT = FontWeight.normal;
  static const double APP_LABEL_TO_TEXT_DISTANCE = 5;
  static const double APP_TEXT_FONT_SIZE = 18;
  static const double APP_VERTICAL_TOP_MARGIN_PROPORTION = 0.03;
  static const String APP_DURATION_TO_DATE_TIME_TITLE =
      'Add Duration To Date Time';
  static const String DATE_TIME_DIFF_DURATION_TITLE = 'Wake Up Duration';
  static const String CALCULATR_SLEEP_DURATION_TITLE =
      'Calculate Sleep Duration';
  static const String TIME_CALCULATOR_TITLE = 'Time Calculator';
  static const double APP_VERTICAL_TOP_RESET_BUTTON_MARGIN_PROPORTION = 0.755;

  static DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
  static DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
  static const double APP_ROUNDED_BOARDER_RADIUS = 18.0;
  static const double BUTTON_SEP_WIDTH = 10.0;
  static const double CHECKBOX_WIDTH_HEIGHT = 35.0;
  static const double CHECKBOX_WIDTH_HEIGHT_REDUCTION = 13.0; // (48 - 35)
  final Color appLabelColor = ScreenMixin.APP_LIGHT_YELLOW_COLOR;
  final Color selectionColor = ScreenMixin.APP_DARK_BLUE_COLOR;
  final MaterialStateProperty<Color?> appElevatedButtonBackgroundColor =
      MaterialStateProperty.all(ScreenMixin.APP_DARK_BLUE_COLOR);
  final MaterialStateProperty<RoundedRectangleBorder>
      appElevatedButtonRoundedShape =
      MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ScreenMixin.APP_ROUNDED_BOARDER_RADIUS)));
  final TextStyle labelTextStyle = TextStyle(
    color: ScreenMixin.APP_LIGHT_YELLOW_COLOR,
    fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
  );
  final TextStyle valueTextStyle = const TextStyle(
    color: ScreenMixin.APP_TEXT_AND_ICON_COLOR,
    fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
    fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT,
  );

  static void setAppVerticalTopMargin(double screenHeight) {
    app_computed_vertical_top_margin =
        screenHeight * APP_VERTICAL_TOP_MARGIN_PROPORTION;
  }

  void openWarningDialog(BuildContext context, String message) {
    /// Located in ScreenMixin in order to be usable in any screen.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WARNING'),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Extract date time string's from the passed transfer data map and return
  /// them in a list sorted with most recent first or last according to the
  /// mostRecentFirst bool paraneter.
  MenuItemData buildSortedAppDateTimeStrList({
    required Map<String, dynamic> transferDataMap,
    required bool mostRecentFirst,
    required TransferDataViewModel transferDataViewModel,
  }) {
    final DateTime twoThousandDateTime = DateTime(2000);
    List<DateTime> appDateTimeLst = [];

    for (var value in transferDataMap.values) {
      if (value is String && isDateTimeStrValid(value)) {
        DateTime? dateTime = parseDateTime(value);

        if (dateTime == null) {
          continue;
        }

        if (dateTime.isBefore(twoThousandDateTime)) {
          // the case is the parsed date time string was obtained from a
          // DatePickerField
          dateTime = englishDateTimeFormat.parse(value);
        }

        addDateTimeIfNotExist(appDateTimeLst, dateTime);
      } else if (value is List<String> &&
          value.isNotEmpty &&
          isDateTimeStrValid(value.first)) {
        // adding to the DateTime list the first date time value of the
        // sleep and wake-up history list
        DateTime? dateTime = parseDateTime(value.first);

        if (dateTime == null) {
          continue;
        }

        addDateTimeIfNotExist(appDateTimeLst, dateTime);
      }
    }

    // now adding the last json date time file name to the Sel menu

    final String lastCreatedJsonFileNameDateTimeStr =
        getLastCreatedJsonFileNameDateTimeStr(transferDataViewModel);

    if (lastCreatedJsonFileNameDateTimeStr.isNotEmpty) {
      // else, the app dir contains no yyyy-MM.dd HH.mm.json file !
      final DateTime lastCreatedJsonFileNameDateTime =
          parseDateTime(lastCreatedJsonFileNameDateTimeStr)!;

      if (!appDateTimeLst.contains(lastCreatedJsonFileNameDateTime)) {
        appDateTimeLst.add(lastCreatedJsonFileNameDateTime);
      }
    }

    // now sorting the DateTime list

    if (mostRecentFirst) {
      appDateTimeLst.sort((a, b) =>
          b.millisecondsSinceEpoch.compareTo(a.millisecondsSinceEpoch));
    } else {
      appDateTimeLst.sort((a, b) =>
          a.millisecondsSinceEpoch.compareTo(b.millisecondsSinceEpoch));
    }

    // and converting it to String list

    List<String> sortedAppDateTimeStrLst =
        appDateTimeLst.map((e) => frenchDateTimeFormat.format(e)).toList();

    return MenuItemData(
      itemDataStrLst: sortedAppDateTimeStrLst,
      stylableItemValueStr: lastCreatedJsonFileNameDateTimeStr,
    );
  }

  bool isDateTimeStrValid(String dateTimeStr) {
    /// Returns true if the passed dateTimeStr is either in french format
    /// (02-11-2022 03:55) or in english format (2022-11-21 09:34). Else,
    /// returns false.
    final RegExp regExpFrenchYYYYDateTime =
        RegExp(r'^(\d+-\d+-\d{4})\s(\d+:\d{2})');
    final RegExp regExpEnglishYYYYDateTime =
        RegExp(r'^(\d{4}-\d+-\d+)\s(\d+:\d{2})');

    RegExpMatch? match = regExpFrenchYYYYDateTime.firstMatch(dateTimeStr);

    if (match != null && match.groupCount == 2) {
      return true;
    } else {
      match = regExpEnglishYYYYDateTime.firstMatch(dateTimeStr);
      if (match != null && match.groupCount == 2) {
        return true;
      }
    }

    return false;
  }

  DateTime? parseDateTime(String dateTimeStr) {
    /// Returns a DateTime instance or null if parsing the dateTimeStr throws
    /// a FormatException
    DateTime dateTime;

    try {
      dateTime = frenchDateTimeFormat.parse(dateTimeStr);
    } on FormatException catch (_) {
      return null;
    }

    return dateTime;
  }

  void addDateTimeIfNotExist(
      List<DateTime> appDateTimeList, DateTime dateTime) {
    if (!appDateTimeList.contains(dateTime)) {
      // avoid inserting several same DateTime values
      appDateTimeList.add(dateTime);
    }
  }

  void showAlertDialog(
      {required List<Widget> buttonList,
      required String dialogTitle,
      String dialogContent = '',
      required String okValueStr,
      required Function okFunction,
      required BuildContext context}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogContent),
        actions: buttonList,
      ),
    ).then((value) {
      if (value == okValueStr) {
        okFunction();
      }
    });
  }

  /// Method called by the 'Sel' and 1st screen heart buttons.
  void displayPopupMenu({
    required BuildContext context,
    required MenuItemData selMenuDateTimeItemData,
    required RelativeRect posRectangleLTRB,
    required void Function(
      String,
      BuildContext?, // useful if selecting a popup menu item
      //                like Add in 1st screen favorite
      //                durations popup menu which opens a new popup
      //                menu, action which need passing the
      //                BuildContext. This argument is not always
      //                required, reason why it is positiponal
      //                optional !
    )
        handleSelectedItemFunction,
  }) {
    List<String> selectableStrItemLst = selMenuDateTimeItemData.itemDataStrLst;

    if (selectableStrItemLst.isEmpty) {
      return;
    }

    List<PopupMenuEntry<String>> itemLst = [];
    int i = 0;

    for (String selectableStrItem in selectableStrItemLst) {
      PopupMenuItem<String> popupMenuItem;

      if (selectableStrItem == selMenuDateTimeItemData.stylableItemValueStr) {
        popupMenuItem = PopupMenuItem<String>(
          value: i.toString(),
          child: Text(
            selectableStrItem,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        popupMenuItem = PopupMenuItem<String>(
          value: i.toString(),
          child: Text(selectableStrItem),
        );
      }
      itemLst.add(
        popupMenuItem,
      );
      i++;
    }

    showMenu<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(ScreenMixin.APP_ROUNDED_BOARDER_RADIUS),
        ),
      ),
      position:
          posRectangleLTRB, // position where you want to show the menu on screen
      items: itemLst,
      elevation: 8.0,
    ).then<void>(
      (String? itemSelected) {
        if (itemSelected == null) {
          return;
        }

        String selectedItemStr = selectableStrItemLst[int.parse(itemSelected)];

        handleSelectedItemFunction(
          selectedItemStr,
          context,
        );
      },
    );
  }

  Future<void> copyToClipboard(
      {required BuildContext context,
      required TextEditingController controller,
      bool extractHHmmFromCopiedStr = false}) async {
    // avoiding selecting the value copied to clipboard !
    // controller.selection = TextSelection(
    //     baseOffset: 0, extentOffset: controller.value.text.length);

    String selectedText = controller.text;

    if (extractHHmmFromCopiedStr) {
      selectedText = selectedText.substring(selectedText.length - 5);

      // fixes bug copying dd-mm-yyyy H:mm as ' H:mm' like
      // 16-11-2022 8:39. '8:39' must be pasted, not ' 8:39' !
      selectedText = selectedText.trimLeft();
    } else {
      // useful in case copying Calculate Sleep Duration screen percent values
      selectedText = selectedText.replaceAll(' %', '');

      if (selectedText.contains('=')) {
        // the case if copyToClipboard() was applied on result
        // TextField of the TimeCalculator screen and that the field
        // contained a string like 01:10:05 = 40:05. In this situation,
        // 40.05 is copied to clipboard !
        List<String> selectedTextLst = selectedText.split(' = ');
        selectedText = selectedTextLst.last;
      }
    }

    await Clipboard.setData(ClipboardData(text: selectedText));

    final CircadianSnackBar snackBar =
        CircadianSnackBar(message: '$selectedText copied to clipboard');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Method returning the sorted list of app data
  /// files located in the app data dir.
  List<String> getSortedFileNameLstInDir(
      {required TransferDataViewModel transferDataViewModel,
      required bool addCircadianJsonFileNameToLst}) {
    List<String?> nullablefileNameLst = transferDataViewModel
        .getFileNameInDirLst(transferDataViewModel.getTransferDataJsonPath());

    List<String> nonNullablefileNameLst =
        nullablefileNameLst.whereType<String>().toList();

    List<String> sortedFileNameLst = [];

    if (addCircadianJsonFileNameToLst) {
      sortedFileNameLst.add(nonNullablefileNameLst
          .firstWhere((element) => element == 'circadian.json'));
    }

    RegExp regExp = RegExp(r'^[\d\- \.]+json');
    List<String> dateTimeFileNameSortedLst =
        nonNullablefileNameLst.where((e) => regExp.hasMatch(e)).toList();
    dateTimeFileNameSortedLst.sort();
    sortedFileNameLst.addAll(dateTimeFileNameSortedLst.reversed);

    return sortedFileNameLst;
  }

  /// Returns the date time string component of the most recently
  /// created yyyy-MM.dd HH.mm.json file in french format
  /// dd-MM-yyyy HH:mm.
  ///
  /// If the app data dir contains no yyyy-MM.dd HH.mm.json file,
  /// empty String '' is returned.
  String getLastCreatedJsonFileNameDateTimeStr(
      TransferDataViewModel transferDataViewModel) {
    final List<String> jsonFileNameLst = getSortedFileNameLstInDir(
        transferDataViewModel: transferDataViewModel,
        addCircadianJsonFileNameToLst: false);

    if (jsonFileNameLst.isEmpty) {
      return '';
    }

    final String lastCreatedJsonFileNameDateTime =
        jsonFileNameLst.first.replaceFirst('.json', '');
    final String frenchFornattedDateTimeStr = transferDataViewModel
        .reformatEnglishDateTimeStrWithPointToFrenchFormattedDateTimeStr(
            lastCreatedJsonFileNameDateTime);
    return frenchFornattedDateTimeStr;
  }

  /// Code executed on double tapping a duration TextField located
  /// in a DurationDateTimeEditor widget. This code paste from
  /// clipboard or copy to clipboard according to the
  /// transferDataMap['clipboardLastAction'] current value.
  ///
  /// The purpose is to enable to copy or paste the TextField
  /// value in another editable TextField value.
  Future<void> handleClipboardDataDurationDateTimeEditor({
    required BuildContext context,
    required TextEditingController textEditingController,
    required Map<String, dynamic> transferDataMap,
    required void Function(
            [String? durationStr,
            int? durationSign,
            bool? wasDurationSignButtonPressed])
        handleDataChangeFunction, // the unique difference with
    //                               the other handleClipboardData
    //                               method
  }) async {
    var clipboardLastAction = transferDataMap['clipboardLastAction'];

    if (clipboardLastAction == ClipboardLastAction.copy) {
      await pasteFromClipboard(
        controller: textEditingController,
      );

      transferDataMap['clipboardLastAction'] = ClipboardLastAction.paste;

      handleDataChangeFunction(textEditingController.text);
    } else {
      await copyToClipboard(
          context: context, controller: textEditingController);

      transferDataMap['clipboardLastAction'] = ClipboardLastAction.copy;
    }
  }

  /// Code executed on double tapping a duration TextField located
  /// in an EditableDuration widget. This code paste from
  /// clipboard or copy to clipboard according to the
  /// transferDataMap['clipboardLastAction'] current value.
  ///
  /// The purpose is to enable to copy or paste the TextField
  /// value in another editable TextField value.
  Future<void> handleClipboardDataEditableDuration({
    required BuildContext context,
    required TextEditingController textEditingController,
    required Map<String, dynamic> transferDataMap,
    required void Function(
      BuildContext context,
      String dialogTimeStr,
    )
        handleDataChangeFunction, // the unique difference with
    //                               the other handleClipboardData
    //                               method
  }) async {
    var clipboardLastAction = transferDataMap['clipboardLastAction'];

    if (clipboardLastAction == ClipboardLastAction.copy) {
      await pasteFromClipboard(
        controller: textEditingController,
      );

      transferDataMap['clipboardLastAction'] = ClipboardLastAction.paste;

      handleDataChangeFunction(context, textEditingController.text);
    } else {
      await copyToClipboard(
          context: context, controller: textEditingController);

      transferDataMap['clipboardLastAction'] = ClipboardLastAction.copy;
    }
  }

  Future<void> pasteFromClipboard(
      {required TextEditingController controller}) async {
    controller.selection = TextSelection(
        baseOffset: 0, extentOffset: controller.value.text.length);
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    String copiedtext = (cdata != null) ? cdata.text ?? '' : '';
    controller.text = copiedtext;
  }

  Future<String?> openAddTimeDialog(
      {required BuildContext context,
      required TextEditingController addTimeController}) {
    void submit() {
      Navigator.of(context).pop(addTimeController.text);

      addTimeController.clear();
    }

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time to add'),
        content: TextField(
          autofocus: true,
          style: const TextStyle(
              fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
              fontWeight: ScreenMixin.APP_TEXT_FONT_WEIGHT),
          decoration: const InputDecoration(hintText: '(-)HH:mm'),
          controller: addTimeController,
          onSubmitted: (_) => submit(),
          keyboardType: TextInputType.datetime,
        ),
        actions: [
          TextButton(
            onPressed: submit,
            child: const Text('Add time'),
          ),
        ],
      ),
    );
  }
}
