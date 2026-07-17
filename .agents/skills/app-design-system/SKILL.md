---
name: gt-ui-system
description: Construct views utilizing `gt_mobile_ui` components, typography, colors, and spatial tokens. Use whenever creating or modifying UI components.
metadata:
  last_modified: Mon, 13 Jul 2026 18:39:23 GMT
---

# Strict UI Assembly & Token Integration

## Contents

- [Structuring UI Components](#structuring-ui-components)
- [Writing with Design Tokens](#writing-with-design-tokens)
- [Executing Layouts](#executing-layouts)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring UI Components

Mandate the consumption of design system primitives to maintain high performance and enforce brand consistency.

- Widgets MUST inherit from `GtStatelessWidget` or `GtStatefulWidget`[cite: 1].
- Bind UI to state natively using semantic wrappers like `ListListener`, `BoolListener`, or `NumberListener` instead of raw `ValueListenableBuilder`[cite: 1].

## Writing with Design Tokens

- NEVER use raw Flutter `Text` widgets; strictly use `GtText`[cite: 1].
- Apply typography by extracting styles via `context.textStyles` (e.g., `context.textStyles.body2Xs()`)[cite: 1].
- Extract all colors dynamically from the theme via `context.palette`[cite: 1]. Hardcoded colors (e.g., `Colors.red`) are prohibited.

## Executing Layouts

- NEVER use hardcoded padding, margins, or `SizedBox` heights with magic numbers.
- Implement structural gaps exclusively using `GtGap` primitives (e.g., `GtGap.ySectionSm()`, `GtGap.hLg()`)[cite: 1].
- Access responsive spacing tokens via `context.spacing` or `context.insets`[cite: 1].

## Implementation Workflow

- [ ] 1. Extend `GtStatelessWidget` or `GtStatefulWidget`[cite: 1].
- [ ] 2. Use semantic listener wrappers for reactive data binding[cite: 1].
- [ ] 3. Apply styles via `context.textStyles` and colors via `context.palette`[cite: 1].
- [ ] 4. Use `GtGap` instead of `SizedBox` for spacing[cite: 1].
- [ ] 5. Use `GtText` for all string rendering[cite: 1].

## Examples

### Perfect Adaptation Header

```dart
class FeatureHeader extends GtStatelessWidget {
  final String title;
  final String subTitle;

  const FeatureHeader(this.title, {super.key, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final headStyle = context.textStyles.subHeadXl();
    final subStyle = context.textStyles.body2Xs(color: palette.text.darkerSub);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.spacingBase,
      children: [
        GtText(title, style: headStyle),
        GtText(subTitle, style: subStyle),
      ],
    );
  }
}
```
