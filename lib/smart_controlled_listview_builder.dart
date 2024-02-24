library smartlistview;

import 'package:flutter/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'smart_item_controller.dart';

class SmartControllerListViewBuilder<A, T> extends StatefulWidget {
  final Function()? onStart;
  final Function()? onMedium;
  final Function()? onEnd;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final bool? reverse;
  final bool? shrinkWrap;
  final Axis? scrollDirection;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? semanticChildCount;

  final ScrollPhysics? physics;
  final SmartItemController<A, T> itemController;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  SmartControllerListViewBuilder({
    Key? key,
    required this.itemController,
    this.scrollDirection,
    this.reverse,
    this.shrinkWrap,
    this.physics,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    required this.itemBuilder,
    this.addSemanticIndexes = true,
    this.semanticChildCount,
    this.onStart,
    this.onMedium,
    this.onEnd,
  }) : super(key: key);

  @override
  State<SmartControllerListViewBuilder> createState() =>
      SmartControllerListViewBuilderState<A, T>();
}

class SmartControllerListViewBuilderState<A, T>
    extends State<SmartControllerListViewBuilder<A, T>> {
  final lockDuration = const Duration(seconds: 2);
  final animationDuration = const Duration(milliseconds: 100);

  double? pixel;

  @override
  Widget build(BuildContext context) {
    widget.itemController.parent = this;
    bool reverse = widget.reverse ?? false;

    bool showNext = widget.itemController.loadingNext &&
        widget.itemController.itemCount > 0;
    bool showPrevious = widget.itemController.loadingPrevious &&
        widget.itemController.itemCount > 0;

    final items = widget.itemController.listItems;
    return Flex(
      mainAxisSize: MainAxisSize.max,
      direction: Axis.vertical,
      children: [
        if (reverse)
          AnimatedContainer(
            duration: animationDuration,
            height: showNext ? 100 : 0,
            child: AnimatedOpacity(
              duration: animationDuration,
              opacity: showNext ? 1 : 0,
              child: const Center(
                child: Text('Loading next items..'),
              ),
            ),
          ),
        if (!reverse)
          AnimatedContainer(
            duration: animationDuration,
            height: showPrevious ? 100 : 0,
            child: AnimatedOpacity(
              duration: animationDuration,
              opacity: showPrevious ? 1 : 0,
              child: const Center(
                child: Text('Loading previous items..'),
              ),
            ),
          ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            child: ScrollablePositionedList.builder(
              scrollDirection: widget.scrollDirection ?? Axis.vertical,
              reverse: widget.reverse ?? false,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap ?? false,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addRepaintBoundaries: widget.addRepaintBoundaries,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.itemBuilder(
                    context, index, items[index]);
              },
              addSemanticIndexes: widget.addSemanticIndexes,
              semanticChildCount: widget.semanticChildCount,
              itemScrollController: widget.itemScrollController,
              scrollOffsetController: widget.scrollOffsetController,
              itemPositionsListener: widget.itemPositionsListener,
              scrollOffsetListener: widget.scrollOffsetListener,
            ),
            onNotification: (ScrollNotification notification) {
              pixel ??= notification.metrics.pixels;
              if (pixel == notification.metrics.pixels) {
                // ignoring, no scroll change
                return false;
              }

              AxisDirection axis = (pixel ?? 0) > notification.metrics.pixels
                  ? AxisDirection.up
                  : AxisDirection.down;

              pixel = notification.metrics.pixels;


              // print(pixel);
              if (notification.metrics.atEdge) {
                if (notification.metrics.pixels > 0 &&
                    axis == AxisDirection.down) {
                  onEnd();
                } else if (axis == AxisDirection.up) {
                  onStart();
                }
              } else {
                onMedium();
              }
              return true;
            },
          ),
        ),
        if (reverse)
          AnimatedContainer(
            duration: animationDuration,
            height: showPrevious ? 100 : 0,
            child: AnimatedOpacity(
              duration: animationDuration,
              opacity: showPrevious ? 1 : 0,
              child: const Center(
                child: Text('Loading previous items..'),
              ),
            ),
          ),
        if (!reverse)
          AnimatedContainer(
            duration: animationDuration,
            height: showNext ? 100 : 0,
            child: AnimatedOpacity(
              duration: animationDuration,
              opacity: showNext ? 1 : 0,
              child: const Center(
                child: Text('Loading next items..'),
              ),
            ),
          ),
      ],
    );
  }

  void onStart() {
    if (widget.itemController.internalLoad) {
      return;
    }

    widget.onStart?.call();

    if (!widget.itemController.loadingPrevious) {
      widget.itemController.internalLoad = true;
      widget.itemController.loadingPrevious = true;
      widget.itemController.onLoadingPrevious();
      lock();
    }
  }

  void onMedium() {
    if (widget.itemController.internalLoad) {
      return;
    }

    widget.onMedium?.call();

    if (widget.itemController.loadingNext ||
        widget.itemController.loadingPrevious) {
      widget.itemController.internalLoad = true;
      widget.itemController.loadingNext = false;
      widget.itemController.loadingPrevious = false;
      lock();
    }
  }

  void onEnd() {
    if (widget.itemController.internalLoad) {
      return;
    }

    widget.onEnd?.call();

    if (!widget.itemController.loadingNext) {
      widget.itemController.internalLoad = true;
      widget.itemController.loadingNext = true;
      widget.itemController.onLoadingNext();
      lock();
    }
  }

  void lock() {
    widget.itemController.internalLoad = true;
    unlock();
    refresh();
  }

  void unlock() {
    Future.delayed(lockDuration, () {
      widget.itemController.internalLoad = false;
      refresh();
    });
  }

  bool reversed() => widget.reverse ?? false;

  void refresh([int? index]) {
    if (index != null) {
      // TODO fix aligned
      widget.itemScrollController.jumpTo(index: index, alignment: reversed() ? .8 : .2);
      lock();
    }
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {});
      }
    });
  }
}
