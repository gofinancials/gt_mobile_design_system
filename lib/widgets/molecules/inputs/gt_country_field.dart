import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A text input field that provides a dropdown selection interface via a bottom sheet.
///
/// [GtDropdownField] allows users to select an item from a provided list of [options].
/// When tapped, it opens a draggable bottom sheet containing a search field and the list of items.
class GtCountryField extends GtStatefulWidget {
  /// The controller used to read and manipulate the input text.
  final GtDropdownInputController<Country>? controller;

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

  /// An optional widget to display when there are no options.
  final Widget? emptyWidget;

  /// An optional widget to display while loading options.
  final Widget? loadingWidget;

  /// An optional widget to display when error occurs when getting options.
  final Widget? errorWidget;

  /// The size of the flag image.
  final double? flagSize;

  /// An optional builder to entirely customize the list view of the dropdown options.
  final ValueBuilder3<
    List<GtDropdownData>,
    GtDropdownInputController,
    ScrollController
  >?
  optionsBuilder;

  /// Callback invoked when an item is selected from the dropdown list.
  /// Passes the selected [GtDropdownData] item.
  final OnChanged<GtDropdownData<Country>?>? onChange;

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
  const GtCountryField({
    super.key,
    this.controller,
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
    this.flagSize,
    this.suffix,
    this.debounceTime,
    this.autoFocus = false,
    this.optionsGap = const GtGap.yLg(),
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
  }) : assert(
         optionBuilder == null || optionsBuilder == null,
         'Cannot provide both optionBuilder and optionsBuilder.',
       );

  @override
  State<GtCountryField> createState() => _GtCountryFieldState();
}

class _GtCountryFieldState extends State<GtCountryField>
    with GtBottomSheetMixin {
  /// The controller managing the text and focus state.
  late final GtDropdownInputController<Country> controller;
  late final FocusNode focusNode;
  late final OptionsHolder<Country> options;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GtDropdownInputController<Country>();
    options = _allCountries;
    focusNode = controller.focusNode;
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  FutureOr<List<GtDropdownData<Country>>> get _allCountries async {
    final countries = await AppCountryUtility.fetchCountries();
    return countries.mapList(
      (it) => GtDropdownData(
        value: it,
        label: it.displayName,
        filterDelegate: (query) {
          if (!query.hasValue) return true;
          final hasPhoneCode = it.countryCode.includes(query);
          final hasCountryName = it.displayName.includes(query);

          return hasPhoneCode || hasCountryName;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericListener(
      valueListenable: controller.selectionNotifier,
      builder: (selectedCountry) {
        Widget? prefix;

        if (selectedCountry != null) {
          prefix = ClipOval(
            child: GtNetworkImage(
              selectedCountry.value.rasterFlagUrl,
              fit: .fill,
              width: widget.flagSize ?? 20,
              height: widget.flagSize ?? 20,
            ),
          );
        }

        return GtDropdownField<Country>(
          controller: controller,
          decoration: widget.decoration,
          options: options,
          prefix: prefix,
          label: widget.label,
          sheetTitle: widget.sheetTitle,
          validator: widget.validator,
          textAlign: widget.textAlign,
          textInputAction: widget.textInputAction,
          suffix: widget.suffix,
          debounceTime: widget.debounceTime,
          autoFocus: widget.autoFocus,
          optionsGap: widget.optionsGap,
          emptyWidget: widget.emptyWidget,
          loadingWidget: widget.loadingWidget,
          errorWidget: widget.errorWidget,
          onChange: widget.onChange,
          optionBuilder: widget.optionBuilder,
          optionsBuilder: widget.optionsBuilder,
          isEnabled: widget.isEnabled,
        );
      },
    );
  }
}
