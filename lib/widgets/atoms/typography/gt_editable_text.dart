import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A foundational editable text widget for the Go Tech design system.
///
/// This widget acts as a styled wrapper around Flutter's [EditableText], providing
/// consistent defaults for text styles, cursor colors, and focus behavior based
/// on the current design system palette and theme.
class GtEditableText extends GtStatefulWidget {
  /// The style to use for the text being edited.
  ///
  /// If null, defaults to the `bodyM` text style from the current context.
  final TextStyle? style;

  /// How the text should be aligned horizontally. Defaults to [TextAlign.start].
  final TextAlign? textAlign;

  /// The locale used to select region-specific glyphs.
  final Locale? locale;

  /// The strut style used for the vertical layout.
  final StrutStyle? strutStyle;

  /// Whether this text field should focus itself if nothing else is already focused. Defaults to false.
  final bool autofocus;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text can be changed. When true, the text cannot be modified by the keyboard.
  final bool readonly;

  /// Controls the text being edited.
  final TextEditingController controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// Called when the user indicates that they are done editing the text in the field.
  final OnChanged<String>? onSubmit;

  /// Called whenever the text being edited changes.
  final OnChanged<String>? onChanged;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard. Defaults to [TextCapitalization.none].
  final TextCapitalization textCapitalization;

  /// Creates a new [GtEditableText].
  const GtEditableText({
    this.style,
    this.textAlign,
    this.locale,
    this.maxLines,
    this.strutStyle,
    this.textDirection,
    this.readonly = false,
    this.autofocus = false,
    this.onSubmit,
    this.onChanged,
    required this.controller,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GtEditableTextState();
}

class _GtEditableTextState extends State<GtEditableText> {
  @override
  Widget build(BuildContext context) {
    final computedStyle = widget.style != null
        ? widget.style!
        : context.textStyles.bodyM();
    final defaultCursorColor = Theme.of(context).textSelectionTheme.cursorColor;
    final computedCursorColor =
        defaultCursorColor ?? context.palette.primary.darker;

    return RepaintBoundary(
      child: EditableText(
        contextMenuBuilder: (context, state) {
          return AdaptiveTextSelectionToolbar.editableText(
            editableTextState: state,
          );
        },
        showCursor: true,
        onSubmitted: (value) {
          context.resetFocus();
          widget.onSubmit?.call(value);
        },
        onChanged: widget.onChanged,
        onEditingComplete: () {
          context.resetFocus();
          if (widget.onSubmit == null) return;
          widget.onSubmit!(widget.controller.text);
        },
        // hintLocales: context.locales,
        // locale: context.currentLocale,
        readOnly: widget.readonly,
        controller: widget.controller,
        focusNode: widget.focusNode ?? FocusNode(),
        cursorColor: computedCursorColor,
        backgroundCursorColor: computedCursorColor,
        style: computedStyle,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign ?? TextAlign.start,
        maxLines: widget.maxLines,
        textDirection: widget.textDirection,
        textInputAction: TextInputAction.done,
        onTapOutside: (event) => context.resetFocus(),
        autofocus: widget.autofocus,
        textCapitalization: widget.textCapitalization,
      ),
    );
  }
}
