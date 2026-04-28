import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standardized wrapper for modal pickers.
///
/// Provides a consistent layout with a cancel button, a content area for the
/// picker, and an optional select button.
class GtBasePicker extends GtStatelessWidget {
  /// The main picker widget to display.
  final Widget picker;

  /// A callback invoked when the select button is pressed.
  final VoidCallback? onSelect;

  /// Custom text for the select button. Defaults to "Select".
  final String? selectText;

  /// Creates a new [GtBasePicker].
  const GtBasePicker({
    super.key,
    required this.picker,
    this.onSelect,
    this.selectText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GtCard(
        margin: context.insets.defaultAllInsets,
        constraints: BoxConstraints.tightFor(
          width: double.infinity,
          height: context.fractionalHeight(50),
        ),
        padding: context.insets.allDp(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(children: [GtCancelButton()]),
            const GtGap.yBase(),
            Expanded(child: picker),
            if (onSelect != null) ...[
              const GtGap.yBase(),
              GtOutlineButton(
                onPressed: () => onSelect?.call(),
                text: selectText ?? "select".ctr(),
                size: .medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A reusable wheel scroll sheet for custom pickers.
class WheelScrollSheet<T> extends GtStatefulWidget {
  final ValueChanged<T> onSelect;
  final FixedExtentScrollController controller;
  final List<GtWheelScrollData<T>> items;
  final T? selectedData;

  const WheelScrollSheet({
    required this.onSelect,
    required this.controller,
    required this.items,
    this.selectedData,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => WheelScrollSheetState<T>();
}

class WheelScrollSheetState<T> extends State<WheelScrollSheet>
    with AppTaskMixin {
  late ValueNotifier<int> _selectionTracker;

  WheelScrollSheetState();

  @override
  void initState() {
    super.initState();
    int selectionIndex;
    if (widget.selectedData == null) {
      selectionIndex = 0;
    } else {
      selectionIndex = widget.items.indexWhere(
        (it) => it.data == widget.selectedData,
      );
    }
    _selectionTracker = ValueNotifier(
      selectionIndex == -1 ? 0 : selectionIndex,
    );
  }

  void onSelect(dynamic data) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tryRunThrowableTask(() {
        widget.onSelect(data as T);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: context.dp(40.px),
      useMagnifier: true,
      overAndUnderCenterOpacity: .4,
      physics: const FixedExtentScrollPhysics(),
      magnification: 1.1,
      onSelectedItemChanged: (val) {
        _selectionTracker.value = val;
        onSelect(widget.items[val].data);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final item = widget.items.elementAt(index);

          return ValueListenableBuilder<int?>(
            valueListenable: _selectionTracker,
            builder: (context, val, _) {
              final isSelected = index == val;
              return Container(
                padding: context.insets.symmetricDp(horizontal: 2.px),
                margin: context.insets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: isSelected
                          ? context.palette.stroke.sub
                          : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                ),
                child: Center(
                  child: GtText(
                    item.label,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyS(
                      color: isSelected
                          ? context.palette.highlighted.base
                          : context.palette.text.sub,
                    ),
                  ),
                ),
              );
            },
          );
        },
        childCount: widget.items.length,
      ),
      controller: widget.controller,
    );
  }
}
