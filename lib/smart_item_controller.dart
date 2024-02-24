import 'smart_controlled_listview_builder.dart';

class SmartItemController<A, T> {
  bool internalLoad = false;

  bool loadingNext = true;

  bool loadingPrevious = true;

  void Function() onLoadingNext = () {};

  void Function() onLoadingPrevious = () {};
  int Function(T, T) sortValues = (a, b) {
    return 0;
  };

  int Function(A, A) sortKeys = (a, b) {
    return 0;
  };

  final _items = <A, T>{};

  int get itemCount => _items.length;

  List<A> get listKeys {
    var list = _items.keys.toList();
    list.sort((a, b) => sortKeys(a, b));
    return list;
  }

  List<T> get listItems {
    var list = _items.values.toList();
    list.sort((a, b) => sortValues(a, b));
    return list;
  }

  SmartControllerListViewBuilderState? parent;

  SmartItemController();

  void addItems(Map<A, T> items, {bool clearPrevious = false}) {
    var list = listItems;

    T? reference;
    if (list.isNotEmpty) {
      if (loadingPrevious) {
        reference = list.first;
      } else {
        reference = list.last;
      }
    }

    if (clearPrevious) {
      this._items.clear();
    }

    this._items.addAll(items);

    loadingNext = false;
    loadingPrevious = false;
    parent?.refresh(clearPrevious ? _keepOnIndex(listItems, reference) : null);
  }

  int? _keepOnIndex(List<T> list, T? item) {
    if (item == null) {
      return null;
    }
    return list.indexOf(item);
  }
}
