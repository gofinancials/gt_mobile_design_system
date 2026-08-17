import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPinInput code', type: GtPinInput)
Widget playgroundGtPinInputUseCase(BuildContext context) {
  return const _GtPinInputPlayground();
}

class _GtPinInputPlayground extends GtStatefulWidget {
  const _GtPinInputPlayground();

  @override
  State<_GtPinInputPlayground> createState() => _GtPinInputPlaygroundState();
}

class _GtPinInputPlaygroundState extends State<_GtPinInputPlayground> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GtSpringShakeController _shakeController = GtSpringShakeController();

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enableEntryAnimation = context.knobs.boolean(
      label: 'Enable Entry Animation',
      initialValue: true,
    );
    final enableCompletionHaptic = context.knobs.boolean(
      label: 'Enable Completion Haptic',
      initialValue: false,
    );

    return GtWidgetDocPage(
      title: 'GtPinInput',
      description: 'Documentation for GtPinInput',
      code:
          '''
GtPinInput(
  controller: TextEditingController(),
  shakeController: shakeController,
  enableEntryAnimation: $enableEntryAnimation,
  completionHapticFeedbackType: ${enableCompletionHaptic ? '.medium' : 'null'},
  onFieldSubmitted: (value) {
   // handle submission 
  }
  length: 4,
  alignment: .center,
  size: .medium,
)
''',
      child: GtForm(
        formKey: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            GtText(
              "Pin Input Example",
              style: context.textStyles.bodyS(),
              textAlign: .center,
            ),
            const GtGap.yLg(),
            GtPinInput(
              shakeController: _shakeController,
              enableEntryAnimation: enableEntryAnimation,
              completionHapticFeedbackType: enableCompletionHaptic
                  ? .medium
                  : null,
              onFieldSubmitted: (value) {
                context.showToast("Completed input with value $value");
              },
              validator: (value) => "Pin Is Invalid",
            ),
            const GtGap.ySectionSm(),
            GtRaisedButton(
              onPressed: () => context.validateForm(
                _formKey,
                onValidationFailure: _shakeController.shake,
              ),
              text: "Simulate Error",
              alignment: .center,
              size: .medium,
            ),
          ],
        ),
      ),
    );
  }
}
