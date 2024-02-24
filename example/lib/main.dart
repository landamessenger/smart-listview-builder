import 'package:flutter/material.dart';
import 'package:smart_listview_builder/smart_controlled_listview_builder.dart';
import 'package:smart_listview_builder/smart_item_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final smartItemController = SmartItemController<int, int>();

  final items = <int, Map<int, int>>{};

  int get space => 30;

  int get maxActivePages => 3;

  void refreshList() {
    final maps = items.values.toList();
    final m = <int, int>{};
    for (var map in maps) {
      m.addAll(map);
    }
    smartItemController.addItems(m, clearPrevious: true);
  }

  void addOlderPage() {
    setState(() {
      final lastPage = maxPage();
      if (items.length >= maxActivePages) {
        items.remove(minPage());
      }

      int startKey = maxOfPage(lastPage) + 1;
      Map<int, int> newPage = {};
      for (int i = startKey; i < startKey + space; i++) {
        newPage[i] = i * 10;
      }
      items[lastPage + 1] = newPage;

      refreshList();
    });
  }

  void addNewestPage() {
    setState(() {
      final firstPage = minPage();
      if (firstPage == 1) {
        refreshList();
        return;
      }
      if (items.length >= maxActivePages) {
        items.remove(maxPage());
      }

      int startKey = minOfPage(firstPage) - 1;
      Map<int, int> newPage = {};
      for (int i = startKey; i > startKey - space; i--) {
        newPage[i] = i * 10;
      }
      items[firstPage - 1] = newPage;

      refreshList();
    });
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

  @override
  void initState() {
    super.initState();

    smartItemController.sortValues = (a, b) => a.compareTo(b);

    smartItemController.onLoadingNext = () {
      Future.delayed(const Duration(seconds: 3), addOlderPage);
    };

    smartItemController.onLoadingPrevious = () {
      Future.delayed(const Duration(seconds: 3), addNewestPage);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SmartControllerListViewBuilder<int, int>(
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        itemController: smartItemController,
        reverse: true,
        itemBuilder: (BuildContext content, int index, int item) {
          return Center(
            child: Text(
              '$item',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addOlderPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
