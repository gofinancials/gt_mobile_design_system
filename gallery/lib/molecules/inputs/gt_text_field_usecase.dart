import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTextField', type: GtTextField)
Widget playgroundGtTextFieldUseCase(BuildContext context) {
  return const _GtTextFieldPlayground();
}

class _GtTextFieldPlayground extends GtStatefulWidget {
  const _GtTextFieldPlayground();

  @override
  State<_GtTextFieldPlayground> createState() => _GtTextFieldPlaygroundState();
}

class _GtTextFieldPlaygroundState extends State<_GtTextFieldPlayground> {
  final GtInputController<void> _controller = GtInputController<void>();
  final GtSpringShakeController _shakeController = GtSpringShakeController();

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = context.knobs.string(label: 'Label', initialValue: 'Name');
    final hintText = context.knobs.string(
      label: 'Hint Text',
      initialValue: 'Enter your name',
    );
    final isEnabled = context.knobs.boolean(
      label: 'Enabled',
      initialValue: true,
    );
    final helperText = context.knobs.string(
      label: 'Helper Text',
      initialValue: 'Enter the name shown on your ID.',
    );
    final decoration = context.knobs.object
        .dropdown<(String, GtInputDecoration)>(
          label: 'Input Style',
          options: context.inputStyles.all,
          initialOption: context.inputStyles.all.first,
          labelBuilder: (v) => v.$1,
        );

    final codeSnippet =
        '''
GtTextField(
  controller: GtInputController(),
  label: "$label",
  hintText: "$hintText",
  isEnabled: $isEnabled,
  helperText: "$helperText",
  shakeController: shakeController,
  decoration: /* Selected: ${decoration.$1} */,
)''';

    return GtWidgetDocPage(
      title: 'GtTextField',
      description:
          'A customizable text input field conforming to the design system styling.',
      code: codeSnippet,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          GtTextField(
            controller: _controller,
            label: label,
            hintText: hintText.isEmpty ? null : hintText,
            helperText: helperText.isEmpty ? null : helperText,
            isEnabled: isEnabled,
            decoration: decoration.$2,
            shakeController: _shakeController,
          ),
          const GtGap.yLg(),
          GtRaisedButton(
            text: 'TRIGGER SHAKE',
            onPressed: _shakeController.shake,
            size: .small,
            alignment: .center,
          ),
        ],
      ),
    );
  }
}
