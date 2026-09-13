import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the visual scale of a [GtWheelScroll].
enum GtWheelScrollSize {
  /// Compact rows with body text, sized for wheels placed side by side, such
  /// as a day, month and year picker.
  regular,

  /// A taller selected row with large text, sized for a wheel shown on its
  /// own, such as a year picker.
  large,
}

/// A vertical wheel picker that scrolls through a list of [GtWheelScrollData].
///
/// The selected item sits in a highlighted band at the centre of the wheel
/// while its neighbours fade out above and below it. Scrolling snaps to an
/// item and reports it through [onChanged]. Screen readers step through the
/// items with the increase and decrease gestures.
///
/// Place several wheels side by side with [GtWheelScrollGroup], or present
/// them in a bottom sheet with [GtWheelScrollModal].
class GtWheelScroll<T> extends GtStatefulWidget {
  /// The items the wheel scrolls through, in display order.
  final List<GtWheelScrollData<T>> items;

  /// The [GtWheelScrollData.data] of the selected item.
  ///
  /// When it changes, the wheel scrolls to the matching item. If no item
  /// matches, the first item is shown.
  final T? value;

  /// Callback fired when a new item reaches the selection band.
  final OnChanged<GtWheelScrollData<T>>? onChanged;

  /// An optional header displayed above the wheel, such as "Day".
  final String? label;

  /// The label read by screen readers. Falls back to [label].
  final String? semanticsLabel;

  /// The visual scale of the wheel. Defaults to [GtWheelScrollSize.regular].
  final GtWheelScrollSize size;

  /// The text style of the selected item.
  ///
  /// Defaults to a style chosen by [size].
  final TextStyle? selectedStyle;

  /// The text style of the items around the selected one.
  final TextStyle? itemStyle;

  /// The text style of the [label] header.
  final TextStyle? labelStyle;

  /// The decoration of the band behind the selected item.
  ///
  /// Defaults to a rounded band in the theme's white background color.
  final Decoration? selectedDecoration;

  /// The gradient that fades the items above and below the selected one.
  ///
  /// It masks the wheel, so only its opacity matters: opaque stops show the
  /// items and transparent stops hide them. Defaults to a vertical fade that
  /// keeps the middle third fully visible.
  final Gradient? fadeGradient;

  /// Whether the wheel responds to scrolling. Defaults to true.
  final bool isEnabled;

  /// Creates a [GtWheelScroll].
  const GtWheelScroll({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.semanticsLabel,
    this.size = .regular,
    this.selectedStyle,
    this.itemStyle,
    this.labelStyle,
    this.selectedDecoration,
    this.fadeGradient,
    this.isEnabled = true,
  });

  @override
  State<GtWheelScroll<T>> createState() => _GtWheelScrollState<T>();
}

/// The state for [GtWheelScroll].
class _GtWheelScrollState<T> extends State<GtWheelScroll<T>> {
  /// The controller that keeps the wheel positioned on the selected item.
  late final FixedExtentScrollController _controller;

  /// The index of the item currently in the selection band.
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _indexOf(widget.value);
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void didUpdateWidget(covariant GtWheelScroll<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = _indexOf(widget.value);
    if (index == _selectedIndex) return;

    _selectedIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      if (_controller.selectedItem == index) return;
      _controller.jumpToItem(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Returns the position of the item whose data equals [value], or `0` when
  /// no item matches.
  int _indexOf(T? value) {
    final index = widget.items.indexWhere((it) => it.data == value);
    if (index < 0) return 0;
    return index;
  }

  /// Selects the item at [index] when it reaches the selection band.
  void _onSelectedItemChanged(int index) {
    if (index == _selectedIndex) return;
    if (index >= widget.items.length) return;

    setState(() => _selectedIndex = index);
    HapticFeedback.selectionClick();
    widget.onChanged?.call(widget.items[index]);
  }

  /// Scrolls the wheel by [step] items, for screen reader gestures.
  void _scrollBy(int step) {
    _controller.animateToItem(
      _selectedIndex + step,
      duration: GtMotion.normal,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final styles = context.textStyles;
    final items = widget.items;

    final itemExtent = switch (widget.size) {
      .large => context.dp(48.px),
      .regular => context.dp(36.px),
    };
    final selectedStyle =
        widget.selectedStyle ??
        switch (widget.size) {
          .large => styles.subHeadM(weight: .w600, color: palette.text.sub),
          .regular => styles.subHeadS(color: palette.text.sub, weight: .w600),
        };
    final itemStyle =
        widget.itemStyle ?? styles.subHeadS(color: palette.text.disabled);
    final labelStyle =
        widget.labelStyle ??
        styles.titleS(weight: .w600, color: palette.text.strong);
    final selectedDecoration =
        widget.selectedDecoration ??
        BoxDecoration(
          color: palette.bg.white,
          borderRadius: context.borderRadiusMd,
        );
    final visible = palette.bg.strong;
    final fadeGradient =
        widget.fadeGradient ??
        LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          stops: const [0, 1 / 3, 2 / 3, 1],
          colors: [
            visible.setOpacity(0),
            visible,
            visible,
            visible.setOpacity(0),
          ],
        );

    ScrollPhysics physics = const FixedExtentScrollPhysics();
    if (!widget.isEnabled) {
      physics = const NeverScrollableScrollPhysics();
    }

    GtWheelScrollData<T>? previous;
    if (_selectedIndex > 0) {
      previous = items[_selectedIndex - 1];
    }
    final selected = items.elementAtOrNull(_selectedIndex);
    final next = items.elementAtOrNull(_selectedIndex + 1);
    final canDecrease = widget.isEnabled && previous != null;
    final canIncrease = widget.isEnabled && next != null;

    return GtDisabledOverlay(
      !widget.isEnabled,
      child: Column(
        mainAxisSize: .min,
        spacing: context.spacingMd,
        crossAxisAlignment: .stretch,
        children: [
          if (widget.label.hasValue)
            ExcludeSemantics(
              child: GtText(
                widget.label.value,
                style: labelStyle,
                textAlign: .center,
              ),
            ),
          Semantics(
            label: widget.semanticsLabel ?? widget.label,
            value: selected?.label,
            decreasedValue: previous?.label,
            increasedValue: next?.label,
            enabled: widget.isEnabled,
            onDecrease: canDecrease ? () => _scrollBy(-1) : null,
            onIncrease: canIncrease ? () => _scrollBy(1) : null,
            child: ExcludeSemantics(
              child: SizedBox(
                height: itemExtent * 3,
                child: Stack(
                  alignment: .center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: itemExtent,
                      child: DecoratedBox(decoration: selectedDecoration),
                    ),
                    ShaderMask(
                      blendMode: .dstIn,
                      shaderCallback: fadeGradient.createShader,
                      child: ListWheelScrollView.useDelegate(
                        controller: _controller,
                        itemExtent: itemExtent,
                        physics: physics,
                        diameterRatio: 8,
                        onSelectedItemChanged: _onSelectedItemChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: items.length,
                          builder: (context, index) {
                            final isSelected = index == _selectedIndex;
                            return Container(
                              padding: context.insets.symmetricDp(
                                horizontal: isSelected ? 8.px : 0,
                              ),
                              alignment: .center,
                              child: GtText(
                                items[index].label,
                                style: isSelected ? selectedStyle : itemStyle,
                                textAlign: .center,
                                maxLines: 1,
                                overflow: .ellipsis,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A card that lays out [GtWheelScroll]s side by side.
///
/// Each wheel takes an equal share of the width and is centred in it, capped
/// at the width of the selection band in the design.
class GtWheelScrollGroup extends GtStatelessWidget {
  /// The wheels to display, from left to right.
  final List<Widget> children;

  /// The background color of the card.
  ///
  /// Defaults to the [GtCard] background.
  final Color? color;

  /// The padding inside the card.
  ///
  /// Defaults to 16 logical pixels above and below the wheels.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtWheelScrollGroup].
  const GtWheelScrollGroup({
    super.key,
    required this.children,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final maxWheelWidth = context.dp(92.px);

    return GtCard(
      color: color,
      borderRadius: context.borderRadiusXl,
      padding: padding ?? context.insets.symmetricDp(vertical: 16.px),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          for (final child in children)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWheelWidth),
                  child: child,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A bottom sheet body that presents wheel pickers under a header with a close
/// button.
///
/// Wheels apply their changes as they scroll, so the modal only offers a way to
/// close it. Present it with [GtBottomSheetMixin.showDraggableSheet], which
/// keeps the sheet compact and anchored to the bottom edge on every platform.
class GtWheelScrollModal extends GtStatelessWidget {
  /// The scroll controller provided by the draggable sheet.
  final ScrollController scrollController;

  /// The optional title displayed at the top of the modal.
  final String? title;

  /// The wheel content, typically a [GtWheelScrollGroup] or a
  /// [GtDateWheelScroll].
  final Widget child;

  /// Creates a [GtWheelScrollModal].
  const GtWheelScrollModal(
    this.scrollController, {
    super.key,
    this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget header = Align(alignment: .centerRight, child: GtCancelButton());
    if (title.hasValue) {
      header = GtTitleAppBar(
        title: title.value,
        trailing: GtOptionalWidgetPair(tail: GtCancelButton()),
      );
    }

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px),
        child: Column(
          mainAxisSize: .min,
          spacing: context.spacingLg,
          crossAxisAlignment: .stretch,
          children: [header, child],
        ),
      ),
    );
  }
}
