library smartlistview;

import 'package:flutter/material.dart';

class SmartListView extends ListView {
  final Function()? onStart;
  final Function()? onMedium;
  final Function()? onEnd;
  final IndexedWidgetBuilder itemBuilder;
  final int? itemCount;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  SmartListView({
    Key? key,
    super.scrollDirection,
    super.reverse,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.itemExtent,
    super.prototypeItem,
    super.controller,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.itemCount,
    required this.itemBuilder,
    this.addSemanticIndexes = true,
    super.cacheExtent,
    super.children,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    this.onStart,
    this.onMedium,
    this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: ListView.builder(
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemExtent: itemExtent,
        prototypeItem: prototypeItem,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
      ),
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.atEdge) {
          if (notification.metrics.pixels != 0) {
            if (onEnd != null) {
              onEnd!();
            }
          } else if (notification.metrics.pixels == 0) {
            if (onStart != null) {
              onStart!();
            }
          }
        } else {
          if (onMedium != null) {
            onMedium!();
          }
        }
        return true;
      },
    );
  }
}
