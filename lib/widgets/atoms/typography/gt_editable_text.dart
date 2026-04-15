import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtEditableText extends GtStatefulWidget {
  final TextStyle? style;
  final TextAlign? textAlign;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final bool autofocus;
  final int? maxLines;
  final TextDirection? textDirection;
  final bool readonly;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final OnChanged<String>? onSubmit;
  final OnChanged<String>? onChanged;
  final TextCapitalization textCapitalization;

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
