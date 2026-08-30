import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSearchField', type: GtSearchField)
Widget playgroundGtSearchFieldUseCase(BuildContext context) {
  final isActionMode = context.knobs.boolean(
    label: "Action Mode (forAction)",
    initialValue: false,
  );
  final hintText = context.knobs.string(
    label: "Hint Text",
    initialValue: "Search transactions, beneficiaries...",
  );
  final autoFocus = context.knobs.boolean(
    label: "Auto Focus (Standard)",
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(label: "Enabled", initialValue: true);
  final isRequired = context.knobs.boolean(
    label: "Required",
    initialValue: true,
  );
  final helperText = context.knobs.string(
    label: "Helper Text",
    initialValue: "",
  );
  final useHero = context.knobs.boolean(
    label: "Use Hero Animation Tag",
    initialValue: false,
  );
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[5],
    labelBuilder: (v) => v.$1,
  );

  final heroTag = useHero ? 'search_bar_hero' : null;
  final helperParam = helperText.isNotEmpty
      ? '\n  helperText: "$helperText",'
      : '';
  final heroParam = heroTag != null ? '\n  heroTag: "$heroTag",' : '';

  final codeSnippet = isActionMode
      ? '''
GtSearchField.forAction(
  hintText: "$hintText",
  isEnabled: $isEnabled,
  isRequired: $isRequired,$helperParam$heroParam
  onTap: () {
    // Navigate to dedicated search screen
  },
)'''
      : '''
GtSearchField(
  controller: GtInputController(),
  hintText: "$hintText",
  autoFocus: $autoFocus,
  isEnabled: $isEnabled,
  isRequired: $isRequired,$helperParam
  onChange: (value) {},
)''';

  return GtWidgetDocPage(
    title: 'GtSearchField',
    description: '''
<b>GtSearchField</b> is a specialized text input field designed specifically for search queries.
It supports both direct inline editing and an action-only mode (<b>GtSearchField.forAction</b>) that triggers callbacks (e.g. opening search overlays or route transitions with Hero support).''',
    code: codeSnippet,
    child: isActionMode
        ? GtSearchField.forAction(
            hintText: hintText.isEmpty ? null : hintText,
            isEnabled: isEnabled,
            isRequired: isRequired,
            helperText: helperText.isEmpty ? null : helperText,
            decoration: decoration.$2,
            heroTag: heroTag,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search action triggered (onTap)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          )
        : GtSearchField(
            controller: GtInputController(),
            hintText: hintText.isEmpty ? null : hintText,
            autoFocus: autoFocus,
            isEnabled: isEnabled,
            isRequired: isRequired,
            helperText: helperText.isEmpty ? null : helperText,
            decoration: decoration.$2,
          ),
  );
}
