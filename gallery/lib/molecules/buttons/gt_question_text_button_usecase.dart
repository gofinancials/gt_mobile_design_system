import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtQuestionTextButton',
  type: GtQuestionTextButton,
)
Widget playgroundGtQuestionTextButtonUseCase(BuildContext context) {
  final question = context.knobs.string(
    label: 'Question Text',
    initialValue: "Don't have an account?",
  );
  final action = context.knobs.string(
    label: 'Action Text',
    initialValue: 'Sign Up',
  );
  final (questionStyleName, questionStyle) =
      context.knobs.object.dropdown<(String, TextStyle?)>(
    label: 'Question Style',
    initialOption: ('Default', null),
    options: [
      ('Default', null),
      ('bodyS', context.textStyles.bodyS()),
      ('bodyM', context.textStyles.bodyM()),
      ('subHeadS', context.textStyles.subHeadS()),
      ('labelM', context.textStyles.labelM()),
    ],
    labelBuilder: (v) => v.$1,
  );
  final (actionStyleName, actionStyle) =
      context.knobs.object.dropdown<(String, TextStyle?)>(
    label: 'Action Style',
    initialOption: ('Default', null),
    options: [
      ('Default', null),
      (
        'subHeadS (Primary)',
        context.textStyles.subHeadS(color: context.palette.primary.base)
      ),
      ('h6', context.textStyles.h6()),
      (
        'bodyM Bold',
        context.textStyles.bodyM().copyWith(fontWeight: FontWeight.bold)
      ),
      (
        'labelM Underline',
        context.textStyles.labelM(decoration: TextDecoration.underline)
      ),
    ],
    labelBuilder: (v) => v.$1,
  );
  final textAlign = context.knobs.objectOrNull.dropdown<TextAlign?>(
    label: 'Text Align',
    initialOption: null,
    options: const [
      null,
      TextAlign.start,
      TextAlign.center,
      TextAlign.end,
    ],
    labelBuilder: (v) => v?.name ?? 'Default (Center)',
  );

  final qStyleParam = questionStyle == null
      ? ''
      : '\n  questionStyle: context.textStyles.$questionStyleName(),';
  final aStyleParam = actionStyle == null
      ? ''
      : '\n  actionStyle: context.textStyles.$actionStyleName,';
  final alignParam = textAlign == null
      ? ''
      : '\n  textAlign: TextAlign.${textAlign.name},';

  final codeSnippet = '''
GtQuestionTextButton(
  "$question",
  action: "$action",$qStyleParam$aStyleParam$alignParam
  onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtQuestionTextButton',
    description: '''
<b>GtQuestionTextButton</b> is an interactive text button combining a question or prompt with a prominent action link.
Commonly used at the bottom of authentication forms and onboarding flows (e.g. <i>"Don't have an account? Sign Up"</i>).''',
    code: codeSnippet,
    child: Center(
      child: GtQuestionTextButton(
        question,
        action: action,
        questionStyle: questionStyle,
        actionStyle: actionStyle,
        textAlign: textAlign,
        onPressed: () {},
      ),
    ),
  );
}
