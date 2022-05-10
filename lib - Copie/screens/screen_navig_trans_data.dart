class ScreenNavigTransData {
  /// This class stores the screen data in order for the screen state
  /// to be maintained when shifting to another screen and then coming
  /// back to the previous screen.
  ///
  /// WARNING: If its constructor is set to const, then going to
  /// another screen fails since the Map is no longer modifyable.
  Map<String, dynamic> _transferDataMap;

  ScreenNavigTransData({required Map<String, dynamic> transferDataMap})
      : _transferDataMap = transferDataMap;

  Map<String, dynamic> get transferDataMap => _transferDataMap;
  set transferDataMap(Map<String, dynamic> transferDataMap) =>
      _transferDataMap = transferDataMap;
}
