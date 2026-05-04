import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A type alias for a static list of [GtDropdownData] or a future that resolves to it.
typedef OptionsHolder<T> = FutureOr<List<GtDropdownData<T>>>;

/// A signature for a builder function that takes three values and returns a [Widget].
typedef ValueBuilder3<T, K, O> = Widget Function(T value, K value2, O value3);

/// A text input field that provides a dropdown selection interface via a bottom sheet.
///
/// [GtDropdownField] allows users to select an item from a provided list of [options].
/// When tapped, it opens a draggable bottom sheet containing a search field and the list of items.
class GtDropdownField<T> extends GtStatefulWidget {
  /// The controller used to read and manipulate the input text.
  final GtDropdownInputController<T>? controller;

  /// A static list of options or a future that resolves to a list of options.
  final OptionsHolder<T> options;

  /// The title displayed at the top of the dropdown selection sheet.
  final String? sheetTitle;

  /// Custom visual styling for the input.
  ///
  /// If null, defaults to [GtInputStyles.transferInputStyle] from the current theme.
  final GtInputDecoration? decoration;

  /// An optional label displayed above the input field.
  final String? label;

  /// An optional builder to customize the appearance of individual option items in the list.
  final ValueBuilder2<GtDropdownData, GtDropdownInputController>? optionBuilder;

  /// An optional builder to entirely customize the list view of the dropdown options.
  final ValueBuilder3<
    List<GtDropdownData>,
    GtDropdownInputController,
    ScrollController
  >?
  optionsBuilder;

  /// Callback invoked when an item is selected from the dropdown list.
  /// Passes the selected [GtDropdownData] item.
  final OnChanged<GtDropdownData<T>?>? onChange;

  /// How the text should be aligned horizontally. Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Whether the input field is interactive. Defaults to true.
  final bool isEnabled;

  /// Optional validator for the selected value or typed text.
  final OnValidate<String?>? validator;

  /// Optional hint text displayed in the field when it is empty.
  final String? hintText;

  /// The action to perform when the keyboard's "done" or "next" button is pressed.
  /// Defaults to [TextInputAction.next].
  final TextInputAction textInputAction;

  /// An optional widget to display at the leading edge of the field (e.g., a search icon).
  final Widget? prefix;

  /// An optional widget to display at the trailing edge of the field (e.g., a clear icon).
  final Widget? suffix;

  /// Whether the dropdown modal should open automatically when the widget builds.
  final bool autoFocus;

  /// The duration to wait before filtering options after the user stops typing.
  /// Defaults to 2 seconds.
  final Duration? debounceTime;

  /// The vertical spacing applied between individual options in the dropdown list.
  /// Defaults to a large vertical gap ([GtGap.yLg()]).
  final GtGap optionsGap;

  /// Creates a dropdown field with the provided [options].
  const GtDropdownField({
    super.key,
    this.controller,
    required this.options,
    this.sheetTitle,
    this.optionBuilder,
    this.optionsBuilder,
    this.label,
    this.onChange,
    this.validator,
    this.isEnabled = true,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.hintText,
    this.textInputAction = TextInputAction.next,
    this.prefix,
    this.suffix,
    this.debounceTime,
    this.autoFocus = false,
    this.optionsGap = const GtGap.yLg(),
  }) : assert(
         optionBuilder == null || optionsBuilder == null,
         'Cannot provide both optionBuilder and optionsBuilder.',
       );

  @override
  State<GtDropdownField<T>> createState() => _GtDropdownFieldState<T>();
}

class _GtDropdownFieldState<T> extends State<GtDropdownField<T>>
    with GtBottomSheetMixin {
  /// The controller managing the text and focus state.
  late final GtDropdownInputController<T> controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GtDropdownInputController();
    focusNode = controller.focusNode;
    if (!widget.autoFocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.unfocus();
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GtDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      controller = widget.controller!;
    }
  }

  void _showSheet() {
    if (!widget.isEnabled) return;
    showDraggableSheet(
      context,
      builder: (scrollController) => GtDropDownModal(
        scrollController,
        controller: controller,
        title: widget.sheetTitle,
        gap: widget.optionsGap,
        options: widget.options,
        listBuilder: widget.optionsBuilder,
        debounceTime: widget.debounceTime ?? 500.milliseconds,
        builder: widget.optionBuilder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showSheet,
      onFocusChange: (value) {
        if (!value) return;
        _showSheet();
      },
      child: IgnorePointer(
        child: GtTextField(
          decoration: widget.decoration,
          isEnabled: widget.isEnabled,
          label: widget.label,
          hintText: widget.hintText,
          controller: controller,
          validator: widget.validator,
          textAlign: widget.textAlign,
          textInputAction: widget.textInputAction,
          prefix: widget.prefix,
          onChanged: (query) async {
            widget.onChange?.call(controller.selection);
          },
          suffix: widget.suffix,
        ),
      ),
    );
  }
}

/// A bottom sheet modal that presents a list of selectable options for a dropdown field.
///
/// This widget is typically used within a bottom sheet to provide a dedicated
/// interface for selecting an item from a list, including a search filter.
class GtDropDownModal<T> extends GtStatefulWidget {
  /// The scroll controller used for the modal's scrollable view.
  final ScrollController scrollController;

  /// The controller used to manage the dropdown's state and selection.
  final GtDropdownInputController<T> controller;

  /// The title displayed at the top of the modal.
  final String? title;

  /// The debounce duration for the search filter input.
  final Duration debounceTime;

  /// The list of options to display, or a future resolving to it.
  final OptionsHolder<T> options;

  /// An optional builder for individual option list tiles.
  final ValueBuilder2<GtDropdownData, GtDropdownInputController>? builder;

  /// An optional builder to completely override the list rendering.
  final ValueBuilder3<
    List<GtDropdownData>,
    GtDropdownInputController,
    ScrollController
  >?
  listBuilder;

  /// The vertical spacing applied between individual options in the dropdown list.
  final GtGap gap;

  /// Creates a [GtDropDownModal].
  const GtDropDownModal(
    this.scrollController, {
    super.key,
    this.title,
    this.builder,
    this.listBuilder,
    required this.options,
    required this.controller,
    required this.debounceTime,
    this.gap = const GtGap.yLg(),
  });

  @override
  State<GtDropDownModal> createState() => _GtDropDownModalState<T>();
}

class _GtDropDownModalState<T> extends State<GtDropDownModal>
    with AppTaskMixin {
  late final AppDebouncer debouncer;
  List<GtDropdownData<T>> options = [];
  late final ValueNotifier<List<GtDropdownData<T>>> presentedOptions;
  late final Future<List<GtDropdownData<T>>> _optionsFuture;

  @override
  void initState() {
    super.initState();
    debouncer = AppDebouncer(widget.debounceTime);
    presentedOptions = ValueNotifier(options);
    _optionsFuture = _getOptions();
  }

  @override
  void dispose() {
    debouncer.abort();
    presentedOptions.dispose();
    super.dispose();
  }

  Future<List<GtDropdownData<T>>> _getOptions() async {
    final data = await tryRunThrowableTask(() async => await widget.options);
    options = (data ?? []) as List<GtDropdownData<T>>;
    presentedOptions.value = options;
    return options;
  }

  void _filterOptions(String? query) {
    debouncer.abort();
    debouncer.run(() {
      if (!query.hasValue) {
        presentedOptions.value = options;
        return;
      }

      presentedOptions.value = options.whereList((it) {
        return it.computedLabel.includes(query.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GtDropdownData<T>>>(
      future: _optionsFuture,
      builder: (context, task) {
        final hasData = task.hasData || options.hasValue;
        final isLoading = !hasData && task.isLoading;

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            if (widget.title.hasValue) ...[
              GtModalAppBar(title: widget.title),
              const GtGap.ySectionSm(),
            ] else
              const GtGap.ySectionSm(),
            if (hasData)
              Padding(
                padding: context.insets.defaultHorizontalInsets,
                child: Row(
                  crossAxisAlignment: .center,
                  spacing: context.spacingMd,
                  children: [
                    Expanded(
                      child: GtSearchField(
                        onChange: _filterOptions,
                        decoration: context.inputStyles.smWhiteSearchDecoration,
                      ),
                    ),
                    if (!widget.title.hasValue) GtCancelButton(size: 20),
                  ],
                ),
              ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  presentedOptions,
                  widget.controller.selectionNotifier,
                ]),
                builder: (_, child) {
                  final options = presentedOptions.value;

                  if (isLoading) return GtSpinner();

                  if (widget.listBuilder != null) {
                    return widget.listBuilder!(
                      options,
                      widget.controller,
                      widget.scrollController,
                    );
                  }

                  // TODO: Work on empty state

                  return ListView.separated(
                    padding: context.insets.allDp(16.px),
                    separatorBuilder: (context, index) => widget.gap,
                    controller: widget.scrollController,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final value = options[index];
                      final isSelected = widget.controller.selection == value;

                      if (widget.builder != null) {
                        return widget.builder!(
                          options[index],
                          widget.controller,
                        );
                      }
                      return GtSelectionListTile(
                        value.computedLabel,
                        value: value,
                        isSelected: isSelected,
                        onSelect: (value) {
                          widget.controller.selection = value;
                          context.maybePop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
