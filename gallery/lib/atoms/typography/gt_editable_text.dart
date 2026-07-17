import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtEditableText', type: GtEditableText)
Widget playgroundGtEditableTextUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: "Initial Text",
    initialValue: "You can edit this text...",
  );

  final readonly = context.knobs.boolean(
    label: "Readonly",
    initialValue: false,
  );

  final textAlign = context.knobs.object.dropdown<TextAlign>(
    label: "Text Alignment",
    initialOption: null,
    options: [
      TextAlign.start,
      TextAlign.center,
      TextAlign.end,
      TextAlign.justify,
    ],
    labelBuilder: (val) => val.name,
  );

  return GtWidgetDocPage(
    title: 'GtEditableText',
    description:
        'A foundational editable text widget for the Go Tech design system.',
    code:
        '''
final controller = TextEditingController(text: '$text');

GtEditableText(
  controller: controller,
  readonly: $readonly,
  textAlign: $textAlign,
  onChanged: (val) {
    // Handle change
  },
)
''',
    child: _EditableTextDemo(
      initialText: text,
      readonly: readonly,
      textAlign: textAlign,
    ),
  );
}

class _EditableTextDemo extends GtStatefulWidget {
  final String initialText;
  final bool readonly;
  final TextAlign? textAlign;

  const _EditableTextDemo({
    required this.initialText,
    required this.readonly,
    this.textAlign,
  });

  @override
  State<_EditableTextDemo> createState() => _EditableTextDemoState();
}

class _EditableTextDemoState extends State<_EditableTextDemo> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void didUpdateWidget(_EditableTextDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText) {
      _controller.text = widget.initialText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GtCard(
      variant: GtCardVariant.normal,
      child: GtEditableText(
        controller: _controller,
        readonly: widget.readonly,
        textAlign: widget.textAlign,
      ),
    );
  }
}
