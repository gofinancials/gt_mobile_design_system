import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A highly customizable, stateful text input field for the Go Tech design system.
///
/// This widget wraps Flutter's native [TextField] within a [FormField] to provide
/// seamless validation, error handling, and specialized styling via [GtInputDecoration].
class GtTextField<T> extends GtStatefulWidget {
  /// An optional controller to manage the text editing state and focus.
  final GtInputController? controller;

  /// Whether the text field is interactive.
  final bool isEnabled;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The visual styling configuration for this text field.
  final GtInputDecoration? decoration;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  final TextCapitalization? textCapitalization;

  /// Optional text that describes the input field.
  final String? label;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autoFocus;

  /// Whether to enable auto-correction.
  final bool autoCorrect;

  /// Optional text displayed below the input field to guide the user.
  final String? helperText;

  /// Optional widget to display after the input field's text.
  final Widget? suffix;

  /// Optional widget to display before the input field's text.
  final Widget? prefix;

  /// An optional method that validates the input text.
  final OnValidate<String?>? validator;

  /// The type of information for which to optimize the text input control.
  final TextInputType? keyboardType;

  /// Optional input formatters that format the text being edited.
  final List<TextInputFormatter>? inputFormatters;

  /// The maximum number of lines the text field can occupy.
  final int? maxLines;

  /// The minimum number of lines the text field should occupy.
  final int? minLines;

  /// The maximum number of characters the text field can accept.
  final int? maxLength;

  /// Called when the user changes the text in the field.
  final OnChanged<String?>? onChanged;

  /// Called when the user indicates that they are done editing the text in the field.
  final OnChanged<String?>? onFieldSubmitted;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// A semantic label for the text field, used by accessibility frameworks.
  final String? semanticsLabel;

  /// Used to enable/disable this form field's auto validation and update its error text.
  final AutovalidateMode? autovalidateMode;

  /// A list of strings that helps the autofill service identify the type of this text input.
  final List<String>? autofillHints;

  /// Gets the provided [controller], or instantiates a new one if null.
  GtInputController get ctrl => controller ?? GtInputController();

  /// Creates a standard [GtTextField].
  const GtTextField({
    super.key,
    this.semanticsLabel,
    this.decoration,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization,
    this.controller,
    this.isEnabled = true,
    this.autoFocus = false,
    this.autoCorrect = true,
    this.inputFormatters,
    this.label,
    this.hintText,
    this.helperText,
    this.textAlign = TextAlign.left,
    this.maxLength,
    this.onChanged,
    this.obscureText = false,
    this.suffix,
    this.prefix,
    this.validator,
    this.keyboardType,
    this.onFieldSubmitted,
    this.autofillHints,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : minLines = 1,
       maxLines = 1;

  /// Creates a [GtTextField] optimized for multiline input.
  ///
  /// Sets the [keyboardType] to [TextInputType.multiline] and defaults to 1 minimum line.
  const GtTextField.multiline({
    super.key,
    this.semanticsLabel,
    this.decoration,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization,
    this.controller,
    this.isEnabled = true,
    this.autoFocus = false,
    this.autoCorrect = true,
    this.inputFormatters,
    this.label,
    this.hintText,
    this.helperText,
    this.textAlign = TextAlign.left,
    this.maxLength,
    this.onChanged,
    this.obscureText = false,
    this.suffix,
    this.prefix,
    this.validator,
    this.onFieldSubmitted,
    this.autofillHints,
    this.maxLines,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : keyboardType = TextInputType.multiline,
       minLines = 1;

  @override
  State<GtTextField> createState() => _GtTextFieldState();
}

class _GtTextFieldState extends State<GtTextField>
    with WidgetsBindingObserver, AppTaskMixin {
  FocusNode get _inputFocus => widget.ctrl.focusNode;
  TextEditingController get _ctrl => widget.ctrl.controller;
  GtInputDecoration? get _decoration => widget.decoration;

  /// Resolves the appropriate [BoxDecoration] based on the current input state.
  BoxDecoration resolveDecoration(
    BuildContext context,
    FormFieldState formState,
  ) {
    final decor = _decoration ?? context.inputStyles.defaultDecoration;
    final hasFocus = _inputFocus.hasFocus;
    if (!widget.isEnabled) return decor.disabledDecoration;
    if (formState.hasError) {
      return hasFocus ? decor.focusedErrorDecoration : decor.errorDecoration;
    }
    return hasFocus ? decor.focusedDecoration : decor.decoration;
  }

  @override
  Widget build(BuildContext context) {
    final decoration = _decoration ?? context.inputStyles.defaultDecoration;
    final style = decoration.textStyle;
    final hintStyle = decoration.hintStyle;
    final labelStyle = decoration.labelStyle ?? hintStyle;
    final helperStyle = decoration.helperStyle ?? hintStyle;
    final errorStyle =
        decoration.errorStyle ??
        helperStyle.copyWith(color: context.palette.error.base);

    return Semantics(
      label: widget.semanticsLabel ?? "Input Field",
      child: ListenableBuilder(
        listenable: Listenable.merge([_ctrl, _inputFocus]),
        builder: (context, child) {
          return FormField<TextEditingController>(
            validator: (value) {
              return widget.validator?.call(value?.text);
            },
            enabled: widget.isEnabled,
            onSaved: (newValue) {
              return widget.onFieldSubmitted?.call(newValue?.text);
            },
            onReset: () => _ctrl.clear(),
            autovalidateMode: widget.autovalidateMode,
            builder: (formState) {
              final decor = resolveDecoration(context, formState);
              final hasError = formState.hasError;
              final style = hasError ? errorStyle : helperStyle;
              final helpText = hasError
                  ? formState.errorText
                  : widget.helperText;
              final maxLines = hasError
                  ? decoration.errorMaxLines
                  : decoration.helperMaxLines;

              return GestureDetector(
                onTap: () => context.requestFocus(_inputFocus),
                behavior: .translucent,
                child: _GtTextFieldLayout(
                  decoration: decoration,
                  activeDecoration: decor,
                  helperText: helpText,
                  helperStyle: style,
                  focused: _inputFocus.hasFocus || _ctrl.hasValue,
                  maxLines: maxLines,
                  textAlign: widget.textAlign,
                  prefix: widget.prefix,
                  suffix: widget.suffix,
                  labelStyle: labelStyle,
                  labelText: widget.label,
                  child: child!,
                ),
              );
            },
          );
        },
        child: TextField(
          autocorrect: widget.autoCorrect,
          autofocus: widget.autoFocus,
          textDirection: .ltr,
          showCursor: true,
          textAlign: widget.textAlign ?? .left,
          focusNode: _inputFocus,
          textInputAction: widget.textInputAction ?? .done,
          textCapitalization: widget.textCapitalization ?? .none,
          style: style,
          maxLength: widget.maxLength,
          controller: _ctrl,
          enabled: widget.isEnabled,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType ?? .text,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          scrollPadding: .zero,
          onChanged: widget.onChanged,
          autofillHints: widget.autofillHints,
          decoration: context.inputStyles.inputStyle.copyWith(
            hintStyle: hintStyle,
            hintMaxLines: decoration.hintMaxLines,
            floatingLabelStyle: hintStyle,
            hintText: widget.hintText ?? widget.label,
            counter: null,
            enabled: widget.isEnabled,
          ),
        ),
      ),
    );
  }
}

/// An internal layout widget that structures the input container and its helper/error text.
class _GtTextFieldLayout extends GtStatelessWidget {
  final GtInputDecoration decoration;
  final BoxDecoration activeDecoration;
  final String? helperText;
  final TextStyle helperStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final int maxLines;
  final TextAlign? textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget child;
  final bool focused;

  const _GtTextFieldLayout({
    required this.decoration,
    required this.activeDecoration,
    required this.helperText,
    required this.helperStyle,
    required this.maxLines,
    required this.textAlign,
    required this.prefix,
    required this.suffix,
    required this.child,
    required this.focused,
    required this.labelStyle,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.spacingBase,
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        ClipRRect(
          borderRadius:
              decoration.decoration.borderRadius?.resolve(.ltr) ?? .zero,
          child: AnimatedContainer(
            duration: 300.milliseconds,
            constraints: decoration.constraints,
            padding: decoration.padding,
            // height: decoration.size.height,
            decoration: activeDecoration,
            alignment: .center,
            child: Column(
              crossAxisAlignment: .stretch,
              mainAxisAlignment: .center,
              spacing: context.spacingSm,
              mainAxisSize: .min,
              children: [
                if (focused && labelText.hasValue)
                  Flexible(
                    child: GtText(
                      labelText,
                      style: labelStyle,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ),
                Row(
                  spacing: context.spacingBase,
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  children: [
                    ?prefix,
                    Expanded(child: child),
                    ?suffix,
                  ],
                ),
              ],
            ),
          ),
        ),
        if (helperText.hasValue)
          GtText(
            helperText,
            style: helperStyle,
            textAlign: textAlign,
            maxLines: maxLines,
          ),
      ],
    );
  }
}
