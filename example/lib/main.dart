import 'package:example/data_builder.dart';
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

  @override
  void initState() {
    super.initState();

    smartItemController.sortValues = (a, b) => a.compareTo(b);

    smartItemController.onRefresh = () {
      setState(() {});
    };

    smartItemController.onLoadingNext =
        () => DataBuilder().addOlderPage(smartItemController);

    smartItemController.onLoadingPrevious =
        () => DataBuilder().addNewestPage(smartItemController);
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
        reverse: false,
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
        onPressed: () => DataBuilder().addOlderPage(smartItemController),
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
