import 'package:smart_listview_builder/smart_item_controller.dart';

class DataBuilder {
  static DataBuilder? _instance;

  DataBuilder._internal();

  factory DataBuilder() {
    _instance ??= DataBuilder._internal();
    return _instance!;
  }

  final items = <int, Map<int, int>>{};

  int get space => 30;

  int get maxActivePages => 3;

  void refreshList(SmartItemController smartItemController) {
    final maps = items.values.toList();
    final m = <int, int>{};
    for (var map in maps) {
      m.addAll(map);
    }
    smartItemController.addItems(m, clearPrevious: true);
  }

  void addOlderPage(SmartItemController smartItemController) async {
    await Future.delayed(const Duration(seconds: 5));

    final lastPage = maxPage();
    if (items.length >= maxActivePages) {
      items.remove(minPage());
    }

    int startKey = maxOfPage(lastPage) + 1;
    Map<int, int> newPage = {};
    for (int i = startKey; i < startKey + space; i++) {
      newPage[i] = i;
    }
    items[lastPage + 1] = newPage;

    refreshList(smartItemController);
  }

  void addNewestPage(SmartItemController smartItemController) async {
    await Future.delayed(const Duration(seconds: 8));
    final firstPage = minPage();
    if (firstPage == 1) {
      refreshList(smartItemController);
      return;
    }
    if (items.length >= maxActivePages) {
      items.remove(maxPage());
    }

    int startKey = minOfPage(firstPage) - 1;
    Map<int, int> newPage = {};
    for (int i = startKey; i > startKey - space; i--) {
      newPage[i] = i;
    }
    items[firstPage - 1] = newPage;

    refreshList(smartItemController);
  }

  int maxPage() {
    if (items.isEmpty) {
      return 0;
    }
    final keys = items.keys.toList();
    int max = keys.first;
    for (int i = 1; i < keys.length; i++) {
      if (keys[i] > max) {
        max = keys[i];
      }
    }
    return max;
  }

  int minPage() {
    if (items.isEmpty) {
      return 0;
    }
    final keys = items.keys.toList();
    int min = keys.first;
    for (int i = 1; i < keys.length; i++) {
      if (keys[i] < min) {
        min = keys[i];
      }
    }
    return min;
  }

  int maxOfPage(int page) {
    if (items[page] == null) {
      return 0;
    }
    final keys = items[page]?.keys.toList() ?? [];
    int max = keys.first;
    for (int i = 1; i < keys.length; i++) {
      if (keys[i] > max) {
        max = keys[i];
      }
    }
    return max;
  }

  int minOfPage(int page) {
    if (items[page] == null) {
      return 0;
    }

    final keys = items[page]?.keys.toList() ?? [];
    int min = keys.first;
    for (int i = 1; i < keys.length; i++) {
      if (keys[i] < min) {
        min = keys[i];
      }
    }
    return min;
  }
}
