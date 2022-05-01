class ScreenNavigTransData {
  /// This class stores the screen data in order for the screen state
  /// to be maintained when shifting to another screen and then coming
  /// back to the previous screen.
  final Map<String, dynamic> _transferDataMap;

  const ScreenNavigTransData({required Map<String, dynamic> transferDataMap})
      : _transferDataMap = transferDataMap;

  Map<String, dynamic> get transferDataMap => _transferDataMap;
}
