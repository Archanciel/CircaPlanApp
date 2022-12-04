class MenuItemData {
  List<String> itemDataStrLst;
  String? stylableItemValueStr;

  MenuItemData({
    required this.itemDataStrLst,

    // the item value equals to this string value will be
    // displayed with a specific style, bold for example.
    this.stylableItemValueStr,
  });
}
