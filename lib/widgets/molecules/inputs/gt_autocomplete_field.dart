import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A text input field that provides a list of selectable suggestions as the user types.
///
/// [GtAutocompleteField] supports providing a static list of suggestions or dynamically
/// fetching suggestions via a builder function. It wraps Flutter's [Autocomplete]
/// widget with the design system's [GtTextField] styling.
class GtAutocompleteField<T> extends GtStatefulWidget {
  /// The controller used to read and manipulate the input text.
  final GtInputController? controller;

  /// A static list of autocomplete items to display.
  final List<GtAutocompleteItem<T>>? _suggestions;

  /// A dynamic builder function to fetch autocomplete items based on the search query.
  final SuggestionBuilder<T>? _suggestionsBuilder;

  /// Custom visual styling for the input.
  ///
  /// If null, defaults to [GtInputStyles.transferInputStyle] from the current theme.
  final GtInputDecoration? decoration;

  /// An optional label displayed above the input field.
  final String? label;

  /// Callback invoked when an item is selected from the autocomplete list,
  /// or when the input text changes. Passes `null` if the text doesn't exactly match an item.
  final OnChanged<GtAutocompleteItem<T>?>? onChange;

  /// How the text should be aligned horizontally. Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Whether the input field is interactive. Defaults to true.
  final bool isEnabled;

  /// Optional validator for the selected value or typed text.
  final OnValidate<String?>? validator;

  /// Optional hint text displayed in the field when it is empty.
  final String? hintText;

  /// A list of strings that helps the autofill service identify the type of this input.
  final List<String>? autofillHints;

  /// The type of keyboard to use for editing the text. Defaults to [TextInputType.text].
  final TextInputType keyboardType;

  /// The action to perform when the keyboard's "done" or "next" button is pressed.
  /// Defaults to [TextInputAction.next].
  final TextInputAction textInputAction;

  /// An optional widget to display at the leading edge of the field (e.g., a search icon).
  final Widget? prefix;

  /// An optional widget to display at the trailing edge of the field (e.g., a clear icon).
  final Widget? suffix;

  /// The duration to wait before triggering the [onChange] callback after the user stops typing.
  /// Defaults to 2 seconds.
  final Duration? debounceTime;

  /// Creates an autocomplete field with a static list of [suggestions].
  const GtAutocompleteField({
    super.key,
    this.controller,
    required List<GtAutocompleteItem<T>> suggestions,
    this.label,
    this.onChange,
    this.validator,
    this.isEnabled = true,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.hintText,
    this.autofillHints,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefix,
    this.suffix,
    this.debounceTime,
  }) : _suggestions = suggestions,
       _suggestionsBuilder = null;

  /// Creates an autocomplete field that dynamically fetches suggestions using a [builder].
  const GtAutocompleteField.builder({
    super.key,
    this.controller,
    required SuggestionBuilder<T> builder,
    this.label,
    this.onChange,
    this.validator,
    this.isEnabled = true,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.hintText,
    this.autofillHints,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefix,
    this.suffix,
    this.debounceTime,
  }) : _suggestionsBuilder = builder,
       _suggestions = null;

  /// The dynamic builder function, if one was provided.
  SuggestionBuilder<T>? get suggestionBuilder => _suggestionsBuilder;

  /// The static list of suggestions, if one was provided.
  List<GtAutocompleteItem<T>>? get suggestions => _suggestions;

  /// Returns true if this field uses a dynamic builder for suggestions.
  bool get useBuilder => _suggestionsBuilder != null;

  @override
  State<GtAutocompleteField<T>> createState() => _GtAutocompleteFieldState<T>();
}

class _GtAutocompleteFieldState<T> extends State<GtAutocompleteField<T>> {
  /// The controller managing the text and focus state.
  late final GtInputController controller;

  late final FocusNode focusNode;

  /// The debouncer used to delay search queries and autocomplete triggering.
  late final AppDebouncer debouncer;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GtInputController();
    focusNode = controller.focusNode;
    debouncer = AppDebouncer(widget.debounceTime ?? 2.seconds);
  }

  @override
  void dispose() {
    focusNode.unfocus();
    debouncer.abort();
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GtAutocompleteField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      controller = widget.controller!;
    }
  }

  /// Filter the suggestions based on the query.
  FutureOr<List<GtAutocompleteItem<T>>> _filterSuggestions(String query) async {
    if (!widget.isEnabled || !query.hasValue) return [];

    if (widget.suggestionBuilder != null) {
      return await widget.suggestionBuilder?.call(query) ?? [];
    }

    final options = widget.suggestions;

    return options.whereList((it) {
      return it.computedLabel.includes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<GtAutocompleteItem<T>>(
      key: GlobalObjectKey(controller),
      optionsViewOpenDirection: .mostSpace,
      optionsBuilder: (value) => _filterSuggestions(value.text),
      onSelected: (value) {
        debouncer.abort();
        controller.text = value.computedLabel;
        widget.onChange?.call(value);
      },
      focusNode: controller.focusNode,
      textEditingController: controller.controller,
      fieldViewBuilder: (context, ctrl, focusNode, onFieldSubmitted) {
        return GtTextField(
          decoration: widget.decoration,
          isEnabled: widget.isEnabled,
          label: widget.label,
          hintText: widget.hintText,
          controller: controller,
          validator: widget.validator,
          textAlign: widget.textAlign,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          textInputAction: widget.textInputAction,
          prefix: widget.prefix,
          onChanged: (query) async {
            debouncer.abort();
            final matches = await _filterSuggestions(query.value);
            GtAutocompleteItem<T>? match = matches.tryFirstWhere(
              (it) => it.computedLabel.equals(query.value),
            );
            match ??= matches.tryFirst;
            debouncer.run(() {
              widget.onChange?.call(match);
              controller.text = match?.computedLabel ?? controller.text;
            });
          },
          suffix: widget.suffix,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        if (!widget.isEnabled) return Offstage();
        final decoration =
            widget.decoration ?? context.inputStyles.defaultDecoration;

        return GtCard(
          margin: context.insets.symmetricDp(vertical: 12.px),
          constraints: BoxConstraints(maxHeight: 200),
          padding: .zero,
          shadows: context.shadows.md(),
          child: ListView(
            padding: context.insets.defaultAllInsets,
            shrinkWrap: true,
            children: [
              for (final option in options)
                GtBaseListTileTemplate(
                  title: GtText(
                    option.computedLabel,
                    style: decoration.textStyle,
                  ),
                  onTap: () => onSelected(option),
                ),
            ],
          ),
        );
      },
    );
  }
}
