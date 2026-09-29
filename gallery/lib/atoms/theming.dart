import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Scoped Themes', type: GtThemedScope)
Widget playgroundGtThemedScopeUseCase(BuildContext context) {
  final scoped = context.knobs.object.dropdown(
    label: "Scoped Brand",
    options: kAllThemes,
    initialOption: kFlexTheme,
    labelBuilder: (value) => value.name,
  );
  final nested = context.knobs.object.dropdown(
    label: "Nested Brand",
    options: kAllThemes,
    initialOption: kProTheme,
    labelBuilder: (value) => value.name,
  );

  return GtWidgetDocPage(
    title: 'GtThemedScope',
    description:
        'Brands part of the tree with a GtTheme. A surface takes its palette '
        'from the Material Theme and its fonts, radii, grid and input styles '
        'from the GtThemeProvider, so the scope installs both at once. Change '
        'the app brand from the theme addon and compare it with the cards '
        'below. Sheets and dialogs opened from inside a scope keep its brand, '
        'because GtThemeProvider is an InheritedTheme and travels with the '
        'route. The stock themes share their fonts and radii, so only the '
        'palette changes between the cards below; an app theme that overrides '
        'them would differ in every row.',
    code: '''
// A route rendered in the Flex brand inside an app that is otherwise Personal.
GtThemedScope(
  theme: kFlexTheme,
  child: const FlexOnboardingScreen(),
);

// Scopes nest, so a section of a branded screen can carry its own brand.
GtThemedScope(
  theme: kFlexTheme,
  child: GtThemedScope(
    theme: kProTheme,
    child: const ProUpsellCard(),
  ),
);

// The brightness follows the ambient Theme unless it is given explicitly.
GtThemedScope(
  theme: kFlexTheme,
  brightness: Brightness.dark,
  child: const AlwaysDarkPanel(),
);
''',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.spacingLg,
      children: [
        const _BrandCard(
          label: "App brand",
          rider: "No scope. Follows the theme addon.",
        ),
        GtThemedScope(
          theme: scoped,
          child: _BrandCard(
            label: "Scoped brand",
            rider: "Wrapped in a GtThemedScope for ${scoped.name}.",
          ),
        ),
        GtThemedScope(
          theme: scoped,
          child: GtThemedScope(
            theme: nested,
            child: _BrandCard(
              label: "Nested brand",
              rider: "A ${nested.name} scope inside the ${scoped.name} one.",
            ),
          ),
        ),
      ],
    ),
  );
}

class _BrandCard extends StatelessWidget
    with GtBottomSheetMixin, GtConfirmDialogMixin {
  final String label;
  final String rider;

  const _BrandCard({required this.label, required this.rider});

  @override
  Widget build(BuildContext context) {
    return GtCard(
      borderRadius: context.borderRadiusLg,
      color: context.palette.primary.alpha10,
      padding: context.insets.allDp(16.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.spacingBase,
        children: [
          GtText(
            label.upper,
            textAlign: .start,
            style: context.textStyles.h7(),
          ),
          GtText(
            rider,
            textAlign: .start,
            style: context.textStyles.bodyXs(color: context.palette.text.sub),
          ),
          const _BrandReadout(),
          Row(
            spacing: context.spacingBase,
            children: [
              Expanded(
                child: GtRaisedButton(
                  text: "Open sheet",
                  onPressed: () => showSheet(
                    context,
                    maxHeightFraction: .5,
                    child: Padding(
                      padding: context.insets.allDp(16.px),
                      child: const SafeArea(top: false, child: _SheetBody()),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GtRaisedButton(
                  text: "Confirm",
                  variant: GtButtonVariant.secondary,
                  onPressed: () => confirmAction(
                    context,
                    title: "Keep this brand?",
                    description:
                        "This dialog was opened from a ${context.themeData.name} "
                        "surface and is drawn in the same brand.",
                    onContinue: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.spacingBase,
      children: [
        GtText(
          "Sheet".upper,
          textAlign: .start,
          style: context.textStyles.h7(),
        ),
        GtText(
          "Pushed onto the root navigator, above the scope that opened it. "
          "Both halves of the styling came along.",
          textAlign: .start,
          style: context.textStyles.bodyXs(color: context.palette.text.sub),
        ),
        const _BrandReadout(),
        GtRaisedButton(
          text: "Close",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _BrandReadout extends StatelessWidget {
  const _BrandReadout();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final primary = palette.primary.dark;
    final hex = (primary.toARGB32() & 0xFFFFFF)
        .toRadixString(16)
        .padLeft(6, "0")
        .toUpperCase();
    final rows = <(String, String)>[
      ("GtThemeProvider", context.themeData.name),
      ("Palette", palette.runtimeType.toString()),
      ("Title font", context.fonts.title),
      ("Primary", "#$hex"),
    ];

    return GtCard(
      borderRadius: context.borderRadiusSm,
      color: context.palette.bg.white,
      padding: context.insets.allDp(12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.spacingXs,
        children: [
          for (final row in rows)
            Row(
              children: [
                Expanded(
                  child: GtText(
                    row.$1,
                    textAlign: .start,
                    style: context.textStyles.bodyXs(
                      color: context.palette.text.sub,
                    ),
                  ),
                ),
                Expanded(
                  child: GtText(
                    row.$2,
                    textAlign: .end,
                    style: context.textStyles.bodyXs(
                      color: context.palette.primary.dark,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
