import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAccountCopyPill', type: GtAccountCopyPill)
Widget playgroundGtAccountCopyPillUseCase(BuildContext context) {
  final accountNumber = context.knobs.string(
    label: 'Account number',
    initialValue: '0123456789',
  );
  final variant = context.knobs.object.dropdown<GtAccountCopyPillVariant>(
    label: 'Variant',
    options: GtAccountCopyPillVariant.values,
    initialOption: GtAccountCopyPillVariant.personal,
    labelBuilder: (value) => value.name,
  );
  final semanticsLabel = context.knobs.string(
    label: 'Semantics label',
    initialValue: 'Copy account number',
  );
  final semanticHint = context.knobs.string(
    label: 'Semantic hint',
    initialValue: 'Copies $accountNumber to the clipboard',
  );

  final codeSnippet =
      '''
GtAccountCopyPill(
  '$accountNumber',
  variant: GtAccountCopyPillVariant.${variant.name},
  semanticsLabel: ${semanticsLabel.isEmpty ? 'null' : "'$semanticsLabel'"},
  semanticHint: ${semanticHint.isEmpty ? 'null' : "'$semanticHint'"},
)''';

  return GtWidgetDocPage(
    title: 'GtAccountCopyPill',
    description:
        'A product-themed account-number pill that copies its value when tapped. The preview includes every product and icon-position variant.',
    code: codeSnippet,
    accessibilityNotes: const [
      'Set semanticsLabel to an action-oriented label such as “Copy account number”.',
      'The pill exposes button semantics and uses semanticHint as optional supporting guidance.',
      'Verify long account numbers at larger text scales using the Accessibility addon.',
    ],
    child: Column(
      crossAxisAlignment: .stretch,
      children: [
        GtText('Interactive preview', style: context.textStyles.subHeadS()),
        const GtGap.yMd(),
        Align(
          child: GtAccountCopyPill(
            accountNumber,
            variant: variant,
            semanticsLabel: semanticsLabel.isEmpty ? null : semanticsLabel,
            semanticHint: semanticHint.isEmpty ? null : semanticHint,
          ),
        ),
        const GtGap.ySectionSm(),
        GtText('All variants', style: context.textStyles.subHeadS()),
        const GtGap.yMd(),
        Wrap(
          spacing: context.spacingLg,
          runSpacing: context.spacingLg,
          children: [
            for (final item in GtAccountCopyPillVariant.values)
              _VariantPreview(accountNumber: accountNumber, variant: item),
          ],
        ),
      ],
    ),
  );
}

class _VariantPreview extends GtStatelessWidget {
  final String accountNumber;
  final GtAccountCopyPillVariant variant;

  const _VariantPreview({required this.accountNumber, required this.variant});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: context.spacingSm,
      children: [
        GtAccountCopyPill(
          accountNumber,
          variant: variant,
          semanticsLabel: 'Copy account number',
        ),
        GtText(
          variant.name,
          style: context.textStyles.bodyXs(color: context.palette.text.sub),
        ),
      ],
    );
  }
}
