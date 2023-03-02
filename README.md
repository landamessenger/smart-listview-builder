# SmartListView

ListView Builder which notifies different positions.

Example:

```dart
@override
Widget build(BuildContext context) {
return SmartListView(
  physics: const BouncingScrollPhysics(),
  addAutomaticKeepAlives: true,
  addRepaintBoundaries: true,
  itemCount: 3,
  reverse: true,
  itemBuilder: (BuildContext content, int index) {
    return Container(
      padding: const EdgeInsets.all(7.5),
      child: Text('$index item'),
    );
  },
  onStart: () {
    // initial position
  },
  onMedium: () {
    // medium position
  },
  onEnd: () {
    // end position
  },
);
}
```