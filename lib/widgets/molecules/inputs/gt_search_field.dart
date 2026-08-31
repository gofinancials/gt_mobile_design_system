import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

/// A specialized text input field designed specifically for search functionality.
///
/// This widget provides a compact, pre-styled input tailored for searching.
/// By default, it utilizes [GtInputStyles.searchDecoration] to maintain
/// visual consistency across the application.
class GtSearchField extends GtStatefulWidget {
  /// The controller used to read and manipulate the search input text.
  final GtInputController? controller;

  /// Optional hint text that suggests what sort of input is expected.
  final String? hintText;

  /// Callback invoked whenever the search text changes.
  final OnChanged<String?>? onChange;

  /// Whether the input field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// Whether a valid input must be entered to pass validation. Defaults to true.
  final bool isRequired;

  /// Whether the input should automatically gain focus when built. Defaults to true.
  final bool autoFocus;

  /// An optional custom validator. Defaults to a URL validator if omitted.
  final OnValidate<String?>? validator;

  /// Optional text displayed below the input field to guide the user.
  final String? helperText;

  /// Custom visual styling for the input. Defaults to [GtInputStyles.searchDecoration].
  final GtInputDecoration? decoration;

  /// An optional widget to display at the start of the field (e.g., a search icon).
  final Widget? prefix;

  /// An optional widget to display at the end of the field (e.g., a clear icon).
  final Widget? suffix;

  /// An optional semantic label for the clear button.
  final String? clearSemanticLabel;

  /// Whether the field is in read-only action mode, initialized via [GtSearchField.forAction].
  final bool _readonly;

  /// The callback invoked when the field is tapped in action mode.
  final OnPressed? _onTap;

  /// An optional Hero animation tag used to animate transitions between screens.
  final String? _heroTag;

  /// An optional semantic label for the search field.
  final String? _actionSemanticsLabel;

  /// Creates a standard editable [GtSearchField].
  const GtSearchField({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.onChange,
    this.isRequired = true,
    this.decoration,
    this.helperText,
    this.isEnabled = true,
    this.prefix,
    this.suffix,
    this.clearSemanticLabel,
    this.autoFocus = true,
    OnPressed? onTap,
    bool readonly = false,
    String? heroTag,
  }) : _readonly = readonly,
       _onTap = onTap,
       _actionSemanticsLabel = null,
       _heroTag = heroTag;

  /// Creates a read-only [GtSearchField] that acts as an interactive button to trigger an action (e.g. opening a search page or modal).
  ///
  /// Disables direct text editing, sets [autoFocus] to `false`, and triggers [onTap] when pressed.
  /// An optional [heroTag] can be provided to participate in [Hero] route transitions.
  const GtSearchField.forAction({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.onChange,
    this.isRequired = true,
    this.decoration,
    this.helperText,
    this.isEnabled = true,
    this.prefix,
    this.suffix,
    this.clearSemanticLabel,
    required OnPressed onTap,
    String? actionSemanticsLabel,
    String? heroTag,
  }) : _readonly = true,
       autoFocus = false,
       _onTap = onTap,
       _actionSemanticsLabel = actionSemanticsLabel,
       _heroTag = heroTag;

  @override
  State<GtSearchField> createState() => _GtSearchFieldState();
}

class _GtSearchFieldState extends State<GtSearchField> {
  late final GtInputController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GtInputController();
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suffix = GenericListener(
      valueListenable: controller.controller,
      builder: (value) {
        if (value.text.isEmpty) return const Offstage();
        return GtInkWell(
          role: .button,
          semanticsLabel: widget.clearSemanticLabel,
          customBorder: CircleBorder(),
          onTap: () {
            controller.clear();
            widget.onChange?.call(null);
          },
          child: GtIcon(
            Icons.cancel_rounded,
            variant: .disabled,
            size: 19,
            alignment: .centerRight,
          ),
        );
      },
    );
    Widget child = GtTextField(
      isEnabled: widget.isEnabled,
      decoration: widget.decoration ?? context.inputStyles.searchDecoration,
      helperText: widget.helperText,
      autoCorrect: false,
      autoFocus: widget.autoFocus,
      hintText: widget.hintText,
      controller: controller,
      suffix: widget.suffix ?? suffix,
      prefix:
          widget.prefix ??
          ExcludeSemantics(child: GtIcon(GtIcons.magnifier, variant: .soft)),
      validator: widget.validator,
      textInputAction: .search,
      onChanged: widget.onChange,
    );

    if (widget._readonly) {
      child = GtInkWell(
        onTap: widget._onTap,
        role: .button,
        semanticsLabel: widget._actionSemanticsLabel,
        excludeDescendantSemantics: true,
        child: IgnorePointer(child: child),
      );
    }

    if (widget._heroTag.hasValue) {
      child = Material(
        type: .transparency,
        child: Hero(tag: widget._heroTag!, child: child),
      );
    }

    return child;
  }
}
