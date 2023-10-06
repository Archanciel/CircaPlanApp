// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import '../constants.dart';
import '../utils/utility.dart';

enum SettingType {
  appTheme,
  language,
  playlists,
}

enum AppTheme {
  light,
  dark,
}

enum Language {
  english,
  french,
}

enum Playlists {
  rootPath,
  pathLst,
  orderedTitleLst,
  isMusicQualityByDefault,
  defaultAudioSort,
}

enum AudioSortCriterion { audioDownloadDateTime, validVideoTitle }

/// ChatGPT recommanded: Use JSON serialization libraries like
/// json_serializable to simplify the JSON encoding and decoding
/// process. This will also help you avoid writing manual string
/// parsing code.
class SettingsDataService {
  // default settings are set in the constructor, namely default language
  // and default theme
  final Map<SettingType, Map<dynamic, dynamic>> _settings = {
    SettingType.appTheme: {SettingType.appTheme: AppTheme.dark},
    SettingType.language: {SettingType.language: Language.english},
    SettingType.playlists: {
      Playlists.rootPath: kCircadianAppDir,
      Playlists.pathLst: ["/EMPTY", "/BOOKS", "/MUSIC"],
      Playlists.orderedTitleLst: [],
      Playlists.isMusicQualityByDefault: false,
      Playlists.defaultAudioSort: AudioSortCriterion.audioDownloadDateTime,
    },
  };
  Map<SettingType, Map<dynamic, dynamic>> get settings => _settings;

  final List<dynamic> _allSettingsKeyLst = [
    ...SettingType.values,
    ...AppTheme.values,
    ...Language.values,
    ...Playlists.values,
    ...AudioSortCriterion.values,
  ];

  final bool _isTest;

  SettingsDataService({bool isTest = false}) : _isTest = isTest;

  dynamic get({
    required SettingType settingType,
    required dynamic settingSubType,
  }) {
    return _settings[settingType]![settingSubType];
  }

  /// Usage examples:
  ///
  /// initialSettings.set(
  ///     settingType: SettingType.appTheme,
  ///     settingSubType: SettingType.appTheme,
  ///     value: AppTheme.dark);
  ///
  /// initialSettings.set(
  ///     settingType: SettingType.language,
  ///     settingSubType: SettingType.language,
  ///     value: Language.french);
  ///
  /// initialSettings.set(
  ///     settingType: SettingType.playlists,
  ///     settingSubType: Playlists.rootPath,
  ///     value: kDownloadAppTestDirWindows);
  ///
  /// initialSettings.set(
  ///     settingType: SettingType.playlists,
  ///     settingSubType: Playlists.pathLst,
  ///     value: ['\\one', '\\two']);
  ///
  /// initialSettings.set(
  ///     settingType: SettingType.playlists,
  ///     settingSubType: Playlists.isMusicQualityByDefault,
  ///     value: true);
  ///
  /// initialSettings.set(
  ///     settingType: SettingType.playlists,
  ///     settingSubType: Playlists.defaultAudioSort,
  ///     value: AudioSortCriterion.validVideoTitle);
  void set({
    required SettingType settingType,
    required dynamic settingSubType,
    required dynamic value,
  }) {
    _settings[settingType]![settingSubType] = value;
  }

  void savePlaylistOrder({
    required List<String> playlistOrder,
  }) {
    _settings[SettingType.playlists]![Playlists.orderedTitleLst] =
        playlistOrder;

    String jsonPathFileName =
        '${Utility.getApplicationDataPath(isTest: _isTest)}${Platform.pathSeparator}$kSettingsFileName';

    saveSettingsToFile(jsonPathFileName: jsonPathFileName);
  }

  // Save settings to a JSON file
  void saveSettingsToFile({
    required String jsonPathFileName,
  }) {
    final File file = File(jsonPathFileName);
    final Map<String, dynamic> convertedSettings = _settings.map((key, value) {
      return MapEntry(
        key.toString(),
        value.map((subKey, subValue) =>
            MapEntry(subKey.toString(), subValue.toString())),
      );
    });

    final String jsonString = jsonEncode(convertedSettings);

    file.writeAsStringSync(jsonString);
  }

  /// Load settings from a JSON file
  void loadSettingsFromFile({
    required String jsonPathFileName,
  }) {
    final File file = File(jsonPathFileName);
    try {
      if (file.existsSync()) {
        // if settings json file not exist, then the default Settings values
        // set in the Settings constructor are used ...
        final String jsonString = file.readAsStringSync();
        final Map<String, dynamic> decodedSettings = jsonDecode(jsonString);
        decodedSettings.forEach((key, value) {
          final settingType = _parseEnumValue(SettingType.values, key);
          final subSettings =
              (value as Map<String, dynamic>).map((subKey, subValue) {
            return MapEntry(
              _parseEnumValue(_allSettingsKeyLst, subKey),
              _parseJsonValue(_allSettingsKeyLst, subValue),
            );
          });
          _settings[settingType] = subSettings;
        });
      }
    } on PathAccessException catch (e) {
      // the case when installing the app and running it for the first
      // time. The app will start with the default settings. When the
      // user changes the settings, the settings file will be created
      // and the settings will loaded the next time the app is started.
      print(e.toString());
    }
  }

  T _parseEnumValue<T>(List<T> enumValues, String stringValue) {
    T setting = enumValues[0];

    setting = enumValues.firstWhere((e) => e.toString() == stringValue);

    return setting;
  }

  /// This method is responsible for parsing a JSON value. Since the
  /// JSON value can be a variety of types, this method attempts to
  /// determine the type and parse accordingly.
  ///
  /// - If the JSON value is a list (e.g. "[1, 2, 3]"), the method
  ///   recursively calls itself to parse each element in the list.
  ///
  /// - If the JSON value is a boolean (either "true" or "false"), it
  ///   directly returns Dart's true or false respectively.
  ///
  /// - If the JSON value represents a file path (containing either a
  ///   forward slash '/' or a backslash '\\'), it directly returns the
  ///   value as it's assumed to be a string.
  ///
  /// - For all other cases, it assumes the JSON value represents an
  ///   enumeration value and attempts to parse it using the
  ///   `_parseEnumValue` method.
  ///
  /// The parameter `enumValues` is a list containing all possible enum
  /// values that are valid. `stringValue` is the raw string value from
  /// the JSON data.
  ///
  /// The return type is dynamic because the JSON value could map to
  /// several different Dart types (bool, String, List, or an enumeration
  /// type).
  dynamic _parseJsonValue(List<dynamic> enumValues, String stringValue) {
    if (stringValue.startsWith('[') && stringValue.endsWith(']')) {
      List<String> stringList =
          stringValue.substring(1, stringValue.length - 1).split(', ');
      return stringList
          .map((element) => _parseJsonValue(enumValues, element))
          .toList();
    } else if (stringValue == 'true') {
      // Handle JSON true
      return true;
    } else if (stringValue == 'false') {
      // Handle JSON false
      return false;
    } else if (_isFilePath(stringValue)) {
      // Handle file paths
      return stringValue;
    } else if (_allSettingsKeyLst
        .map((e) => e.toString())
        .contains(stringValue)) {
      // Handle enums
      return _parseEnumValue(enumValues, stringValue);
    } else {
      // Return the string value if it's not an enum
      return stringValue;
    }
  }

  bool _isFilePath(String value) {
    // A simple check to determine if the value is a file path.
    // You can adjust the condition as needed.
    return value.contains('\\') || value.contains('/');
  }
}

void main(List<String> args) {
  SettingsDataService initialSettings = SettingsDataService();

  // print initialSettings created with Settings initial values
  print('**** InitialSettings created with Settings initial values\n');

  print(
      '${initialSettings.get(settingType: SettingType.appTheme, settingSubType: SettingType.appTheme)}');
  print(
      '${initialSettings.get(settingType: SettingType.language, settingSubType: SettingType.language)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.rootPath)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.pathLst)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.orderedTitleLst)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.isMusicQualityByDefault)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.defaultAudioSort)}');

  // modify initialSettings values

  initialSettings.set(
      settingType: SettingType.appTheme,
      settingSubType: SettingType.appTheme,
      value: AppTheme.dark);

  initialSettings.set(
      settingType: SettingType.language,
      settingSubType: SettingType.language,
      value: Language.french);

  initialSettings.set(
      settingType: SettingType.playlists,
      settingSubType: Playlists.rootPath,
      value: kCircadianAppTestDirWindows);

  initialSettings.set(
      settingType: SettingType.playlists,
      settingSubType: Playlists.pathLst,
      value: ['\\one', '\\two']);

  initialSettings.set(
      settingType: SettingType.playlists,
      settingSubType: Playlists.orderedTitleLst,
      value: ['audio_learn', 'audio_learn2', 'audio_learn3']);

  initialSettings.set(
      settingType: SettingType.playlists,
      settingSubType: Playlists.isMusicQualityByDefault,
      value: true);

  initialSettings.set(
      settingType: SettingType.playlists,
      settingSubType: Playlists.defaultAudioSort,
      value: AudioSortCriterion.validVideoTitle);

  // print initialSettings after modifying its values

  print('\n**** Modified initialSettings\n');

  print(
      '${initialSettings.get(settingType: SettingType.appTheme, settingSubType: SettingType.appTheme)}');
  print(
      '${initialSettings.get(settingType: SettingType.language, settingSubType: SettingType.language)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.rootPath)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.pathLst)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.orderedTitleLst)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.isMusicQualityByDefault)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.defaultAudioSort)}');

  initialSettings.saveSettingsToFile(jsonPathFileName: 'settings.json');

  SettingsDataService loadedSettings = SettingsDataService();
  loadedSettings.loadSettingsFromFile(jsonPathFileName: 'settings.json');

  print('\n**** Reloaded modified initialSettings\n');

  print(
      '${loadedSettings.get(settingType: SettingType.appTheme, settingSubType: SettingType.appTheme)}');
  print(
      '${loadedSettings.get(settingType: SettingType.language, settingSubType: SettingType.language)}');
  print(
      '${loadedSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.rootPath)}');
  print(
      '${loadedSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.pathLst)}');
  print(
      '${initialSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.orderedTitleLst)}');
  print(
      '${loadedSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.isMusicQualityByDefault)}');
  print(
      '${loadedSettings.get(settingType: SettingType.playlists, settingSubType: Playlists.defaultAudioSort)}');
}
