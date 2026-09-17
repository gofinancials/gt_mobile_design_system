import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum _BodyLength { short, tall }

const _viewportHeight = 360.0;

@widgetbook.UseCase(name: 'GtScrollableBody', type: GtScrollableBody)
Widget playgroundGtScrollableBodyUseCase(BuildContext context) {
  final length = context.knobs.object.dropdown<_BodyLength>(
    label: 'Content Length',
    options: _BodyLength.values,
    initialOption: _BodyLength.short,
    labelBuilder: (v) => v.name,
  );
  final fillViewport = context.knobs.boolean(
    label: 'Fill Viewport',
    initialValue: true,
  );
  final alwaysScrollable = context.knobs.boolean(
    label: 'Always Scrollable Physics',
    initialValue: false,
  );
  final hasPadding = context.knobs.boolean(
    label: 'Default Padding',
    initialValue: true,
  );

  final isShort = length == _BodyLength.short;

  // A pinned bottom action under a Spacer is the shape fillViewport exists for,
  // and the shape that throws without it — so the short body only reaches for
  // the Spacer while the flag is on.
  final body = Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      GtText('Confirm your details', style: context.textStyles.subHeadS()),
      const GtGap.ySm(),
      GtText(
        isShort
            ? 'This body is shorter than its viewport.'
            : 'This body is taller than its viewport, so it scrolls.',
        style: context.textStyles.bodyS(color: context.palette.text.sub),
      ),
      if (!isShort) ...[
        for (var i = 1; i <= 12; i++) ...[
          const GtGap.yMd(),
          GtInfoListTile('Field $i', text: 'Value $i'),
        ],
      ],
      if (isShort && fillViewport) const Spacer() else const GtGap.yLg(),
      GtRaisedButton(text: 'Continue', onPressed: () {}),
    ],
  );

  return GtWidgetDocPage(
    title: 'GtScrollableBody',
    description:
        'A scrolling page body with the design system gutter, a controller and physics pass-through, and a fill-viewport flag. With Fill Viewport on, a body shorter than the screen is stretched to exactly one viewport — so a Spacer above a pinned action resolves — and it still does not scroll by its own padding.',
    code:
        '''
GtScrollableBody(
  fillViewport: $fillViewport,${alwaysScrollable ? '\n  physics: const AlwaysScrollableScrollPhysics(),' : ''}${hasPadding ? '' : '\n  padding: EdgeInsets.zero,'}
  child: Column(
    children: [
      const GtText('Confirm your details'),
      const Spacer(),
      GtRaisedButton(text: 'Continue', onPressed: submit),
    ],
  ),
)''',
    child: GtCard(
      padding: .zero,
      child: GtSizedBox(
        height: _viewportHeight,
        child: GtScrollableBody(
          fillViewport: fillViewport,
          physics: alwaysScrollable
              ? const AlwaysScrollableScrollPhysics()
              : null,
          padding: hasPadding ? null : EdgeInsets.zero,
          child: body,
        ),
      ),
    ),
  );
}
