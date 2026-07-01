import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized text input field designed specifically for phone numbers.
///
/// This widget automatically applies phone number formatting, uses a phone
/// keyboard, and includes built-in validation for phone numbers. It integrates
/// with a country code selector. By default, it uses [GtInputStyles.phoneInputDecoration].
class GtPhoneField extends GtStatefulWidget {
  /// The controller used to read and manipulate the input text and selected country code.
  final GtInputController<Country>? controller;

  /// An optional label displayed for the input field.
  final String? label;

  /// An optional hint text displayed when the input field is empty.
  final String? hintText;

  /// Callback invoked whenever the input text changes.
  final OnChanged<String?>? onChange;

  /// How the text should be aligned horizontally. Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Whether the input field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// Whether a valid phone number must be entered to pass validation. Defaults to true.
  final bool isRequired;

  /// An optional widget to display when there are no options.
  final Widget? emptyWidget;

  /// An optional widget to display while loading options.
  final Widget? loadingWidget;

  /// An optional widget to display when error occurs when getting options.
  final Widget? errorWidget;

  /// Indicates whether the country code should be displayed.
  final bool showCountryCode;

  /// An optional method that validates the input text.
  final OnValidate<String?>? validator;

  /// Creates a new [GtPhoneField].
  const GtPhoneField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.onChange,
    this.isRequired = true,
    this.isEnabled = true,
    this.textAlign = .start,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.showCountryCode = true,
    this.validator,
  });
  @override
  State<GtPhoneField> createState() => _GtPhoneFieldState();
}

class _GtPhoneFieldState extends State<GtPhoneField> {
  late final GtInputController<Country> controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GtInputController<Country>();
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  String? _validator([String? value]) {
    if (widget.validator != null) {
      return widget.validator!(value ?? controller.text);
    }
    return AppValidators.phoneValidator(
      value ?? controller.text,
      countryCode: controller.selection?.value.countryCode ?? '',
      isRequired: widget.isRequired,
    );
  }

  @override
  Widget build(BuildContext context) {
    final decor = context.inputStyles.phoneInputDecoration;
    final prefix = GenericListener(
      valueListenable: controller.selectionNotifier,
      builder: (country) {
        if (!widget.showCountryCode) return const Offstage();

        return GtText(
          country?.value.countryCode ?? config.countryCode,
          style: decor.hintStyle,
        );
      },
    );

    return ListenableBuilder(
      listenable: controller.selectionNotifier,
      child: GtTextField(
        decoration: decor,
        isEnabled: widget.isEnabled,
        label: widget.label,
        hintText: widget.hintText,
        inputFormatters: [AppPhoneNumberFormatter()],
        maxLength: 15,
        controller: controller,
        validator: (value) {
          final error = _validator(value);
          if (error != null) return "";
          return error;
        },
        prefix: widget.showCountryCode ? prefix : null,
        suffix: GenericListener(
          valueListenable: controller.controller,
          builder: (value) {
            final chars = value.text.withoutWhiteSpaceAndSpecialChar.length;
            return GtAnimatedFade(
              child1: GtIcon(
                GtIcons.checkBox,
                variant: .success,
                alignment: .centerRight,
              ),
              child2: const Offstage(),
              showFirst: chars >= 10,
            );
          },
        ),
        textAlign: widget.textAlign,
        autoCorrect: false,
        keyboardType: TextInputType.phone,
        onChanged: widget.onChange,
        autofillHints: const [AutofillHints.telephoneNumberNational],
      ),
      builder: (context, child) {
        return FormField(
          initialValue: controller.value,
          validator: (value) => _validator(),
          builder: (state) {
            return Column(
              spacing: context.spacingBase,
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  spacing: context.spacingBase,
                  children: [
                    if (widget.showCountryCode)
                      GtCountryCodeField(controller: controller),
                    Expanded(child: child!),
                  ],
                ),
                if (state.hasError)
                  Text.rich(
                    maxLines: 1,
                    overflow: .ellipsis,
                    TextSpan(
                      style: decor.errorStyle,
                      children: [
                        WidgetSpan(
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: GtIcon(
                              GtIcons.help,
                              variant: .error,
                              size: context.dp(18.px),
                            ),
                          ),
                          alignment: .middle,
                        ),
                        TextSpan(text: " "),
                        TextSpan(text: state.errorText),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

/// A widget that displays a country flag and allows the user to select a country code.
///
/// This widget is typically used alongside a phone number input field to provide
/// a visual representation of the selected country and a dropdown for changing it.
class GtCountryCodeField extends GtStatefulWidget {
  /// The controller used to read and manipulate the selected country.
  final GtInputController<Country> controller;

  final Widget? emptyWidget;

  /// An optional widget to display while loading options.
  final Widget? loadingWidget;

  /// An optional widget to display when error occurs when getting options.
  final Widget? errorWidget;

  /// Creates a new [GtCountryCodeField].
  const GtCountryCodeField({
    super.key,
    required this.controller,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<GtCountryCodeField> createState() => _GtCountryCodeFieldState();
}

class _GtCountryCodeFieldState extends State<GtCountryCodeField>
    with GtBottomSheetMixin {
  late Future<Country> _countryFuture;
  late final GtDropdownInputController<Country> controller;

  Country get _fallbackCountry {
    return Country(dial: "234", iSO31661Alpha2: "NG", countryName: "Nigeria");
  }

  Future<Country> get _activeCountry async {
    if (controller.selection?.value != null) {
      return controller.selection!.value;
    }
    final match = await AppCountryUtility.searchCountries(config.countryCode);
    final country = match.tryFirst ?? _fallbackCountry;
    widget.controller.selection = GtDropdownData(
      value: country,
      label: country.displayName,
    );
    return country;
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
  void didUpdateWidget(covariant GtCountryCodeField oldWidget) {
    _countryFuture = _activeCountry;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _countryFuture = _activeCountry;
    controller = GtDropdownInputController<Country>(
      selection: widget.controller.selection,
    );
  }

  void _showSheet() {
    showDraggableSheet(
      context,
      builder: (scrollController) => GtDropDownModal<Country>(
        autoFocus: true,
        scrollController,
        controller: controller,
        options: _allCountries,
        debounceTime: 500.milliseconds,
        emptyWidget: widget.emptyWidget,
        loadingWidget: widget.loadingWidget,
        errorWidget: widget.errorWidget,
        builder: (value, value2) {
          return GtCountrySelectionListTile(
            value.value,
            isSelected: value == value2.selection,
            onSelect: (val) {
              value2.selection = value;
              widget.controller.selection = value as GtDropdownData<Country>?;
              context.maybePop();
            },
            showCountryCode: true,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration = context.inputStyles.phoneCodeDecoration;

    return GtInkWell(
      borderRadius: context.borderRadiusXl,
      hapticFeedbackType: .medium,
      onTap: _showSheet,
      child: Container(
        constraints: decoration.constraints,
        padding: decoration.padding,
        decoration: decoration.decoration,
        alignment: .center,
        child: FutureBuilder(
          future: _countryFuture,
          builder: (context, task) {
            final country = task.data ?? _fallbackCountry;
            final size = context.dp(32.px);

            return Row(
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              spacing: context.spacingBase,
              mainAxisSize: .min,
              children: [
                ClipOval(
                  child: GtNetworkImage(
                    country.rasterFlagUrl,
                    fit: .fill,
                    width: size,
                    height: size,
                  ),
                ),
                GtIcon(
                  GtIcons.chevronDown,
                  size: context.dp(16.px),
                  variant: .soft,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
