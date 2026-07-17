import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Documentation', type: GtPopScope)
Widget playgroundGtPopScopeDoc(BuildContext context) {
  final canPop = context.knobs.boolean(label: 'canPop', initialValue: true);

  final codeSnippet = '''
GtPopScope(
  canPop: $canPop,
  onPopInvoked: (didPop) {
    if (!didPop) {
      // Handle custom confirmation or state saving
    }
  },
  child: myPageContent,
)

// For root level navigation confirmation:
GtRootPopScope(
  child: myRootScaffold,
)
''';

  return GtWidgetDocPage(
    title: 'GtPopScope',
    description: '''
<b>GtPopScope</b> intercepts back-navigation gestures and system back buttons.

<b>Variants:</b>
• <b>GtPopScope</b> — Standard wrapper for custom back logic.
• <b>GtRootPopScope</b> — Wrapper that automatically shows a double-press or confirmation exit modal at the app's root.''',
    code: codeSnippet,
    child: SizedBox(
      width: 320.px,
      height: 120.px,
      child: Center(
        child: GtText(
          'Select "Interactive Preview" in the sidebar\nto test navigation intercepts.',
          style: context.textStyles.bodyM(color: context.palette.text.sub),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
