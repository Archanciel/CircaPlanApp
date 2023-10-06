class MenuItemData {
  List<String> itemDataStrLst;
  String? stylableItemValueStr;
  bool doNotTranslate;

  MenuItemData({
    required this.itemDataStrLst,

    // the item value equals to this string value will be
    // displayed with a specific style, bold for example
    this.stylableItemValueStr,

    // if true or not passed, the item values stored in
    // itemDataStrLst will be translated once the multi
    // language feature will be implemented
    this.doNotTranslate = false,
  });
}
