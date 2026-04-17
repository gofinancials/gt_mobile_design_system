import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Buttons',
  type: GtButton,
  path: "[Molecules]/GtButtons",
)
Widget playgroundButtonsUseCase(BuildContext context) {
  // --- Shared Knobs ---
  final text = context.knobs.string(
    label: "Button Text",
    initialValue: "LOGIN WITH CODE",
  );

  final isDisabled = context.knobs.boolean(
    label: "Disabled State",
    initialValue: false,
  );

  final isLoading = context.knobs.boolean(
    label: "Loading State",
    initialValue: false,
  );

  final iconOptions = [
    ("None", null),
    ("Add", GtIcons.add),
    ("Mobile", GtIcons.mobile),
    ("Chevron Left", GtIcons.chevronLeft),
    ("Chevron Right", GtIcons.chevronRight),
    ("Close", GtIcons.cancel),
    ("Delete", GtIcons.trash),
  ];

  final leadingIcon = context.knobs.object.dropdown<(String, IconData?)>(
    label: "Leading Icon",
    options: iconOptions,
    labelBuilder: (value) => value.$1,
    initialOption: iconOptions.first,
  );

  final trailingIcon = context.knobs.object.dropdown<(String, IconData?)>(
    label: "Trailing Icon",
    options: iconOptions,
    labelBuilder: (value) => value.$1,
    initialOption: iconOptions.first,
  );

  // --- GtIconButton Specific Knob ---
  final iconButtonIcon = context.knobs.object.dropdown<(String, IconData)>(
    label: "IconButton Icon",
    options: iconOptions
        .where((e) => e.$2 != null)
        .map((e) => (e.$1, e.$2!))
        .toList(),
    labelBuilder: (value) => value.$1,
    initialOption: ("Mobile", GtIcons.add),
  );

  // --- GtCancelButton Specific Knob ---
  final asHero = context.knobs.boolean(
    label: "Cancel Button as Hero",
    initialValue: false,
  );

  // --- Knobs for Interactive Examples ---
  final interactiveVariant = context.knobs.object.dropdown<GtButtonVariant>(
    label: "Interactive Variant",
    options: GtButtonVariant.values,
    labelBuilder: (value) => value.name,
    initialOption: GtButtonVariant.primary,
  );

  final interactiveSize = context.knobs.object.dropdown<GtButtonSize>(
    label: "Interactive Size",
    options: GtButtonSize.values,
    labelBuilder: (value) => value.name,
    initialOption: GtButtonSize.large,
  );

  final alignmentOptions = [
    ("None", null),
    ("Center", Alignment.center),
    ("Start", Alignment.centerLeft),
    ("End", Alignment.centerRight),
  ];

  final interactiveAlignment = context.knobs.object
      .dropdown<(String, AlignmentGeometry?)>(
        label: "Interactive Alignment",
        options: alignmentOptions,
        labelBuilder: (value) => value.$1,
        initialOption: alignmentOptions[0], // Default to Center
      );

  return Scaffold(
    key: const PageStorageKey("Buttons Playground"),
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        key: const PageStorageKey("Buttons Playground Scroll View"),
        slivers: [
          const SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "Buttons",
              rider: "A showcase of all button types in the design system.",
            ),
          ),

          // --- GtButton ---
          const SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtButton (Filled)"),
          ),
          SliverToBoxAdapter(
            child: _ButtonGrid(
              text: text,
              isDisabled: isDisabled,
              isLoading: isLoading,
              leading: leadingIcon,
              trailing: trailingIcon,
              buttonBuilder: (variant, size) {
                return GtButton(
                  text: text,
                  variant: variant,
                  size: size,
                  isDisabled: isDisabled,
                  isLoading: isLoading,
                  leading: leadingIcon.$2,
                  trailing: trailingIcon.$2,
                  onPressed: () =>
                      debugPrint("GtButton ($variant, $size) pressed"),
                );
              },
            ),
          ),

          // --- Interactive GtButton ---
          SliverToBoxAdapter(
            child: GtButton(
              text: text,
              variant: interactiveVariant,
              size: interactiveSize,
              alignment: interactiveAlignment.$2,
              isDisabled: isDisabled,
              isLoading: isLoading,
              onPressed: () => debugPrint("Interactive GtButton pressed"),
            ),
          ),

          // --- GtOutlineButton ---
          const SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtOutlineButton"),
          ),
          SliverToBoxAdapter(
            child: _ButtonGrid(
              text: text,
              isDisabled: isDisabled,
              isLoading: isLoading,
              leading: leadingIcon,
              trailing: trailingIcon,
              buttonBuilder: (variant, size) {
                return GtOutlineButton(
                  text: text,
                  variant: variant,
                  size: size,
                  isDisabled: isDisabled,
                  isLoading: isLoading,
                  leading: leadingIcon.$2,
                  trailing: trailingIcon.$2,
                  onPressed: () => debugPrint("GtOutlineButton pressed"),
                );
              },
            ),
          ),

          // --- Interactive GtOutlineButton ---
          SliverToBoxAdapter(
            child: GtOutlineButton(
              text: text,
              variant: interactiveVariant,
              size: interactiveSize,
              alignment: interactiveAlignment.$2,
              isDisabled: isDisabled,
              isLoading: isLoading,
              onPressed: () =>
                  debugPrint("Interactive GtOutlineButton pressed"),
            ),
          ),
          // --- GtTextButton ---
          const SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "GtTextButton"),
          ),
          SliverToBoxAdapter(
            child: _ButtonGrid(
              text: text,
              isDisabled: isDisabled,
              isLoading: isLoading,
              leading: leadingIcon,
              trailing: trailingIcon,
              buttonBuilder: (variant, size) {
                return GtTextButton(
                  text: text,
                  variant: variant,
                  size: size,
                  isDisabled: isDisabled,
                  isLoading: isLoading,
                  leading: leadingIcon.$2,
                  trailing: trailingIcon.$2,
                  onPressed: () => debugPrint("GtTextButton pressed"),
                );
              },
            ),
          ),

          // --- Interactive GtTextButton ---
          SliverToBoxAdapter(
            child: GtTextButton(
              text: text,
              variant: interactiveVariant,
              size: interactiveSize,
              alignment: interactiveAlignment.$2,
              isDisabled: isDisabled,
              isLoading: isLoading,
              onPressed: () => debugPrint("Interactive GtTextButton pressed"),
            ),
          ),
          // --- GtIconButton ---
          const SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "GtIconButton (NB: Tentative implementation)",
            ),
          ),
          SliverToBoxAdapter(
            child: _ButtonGrid(
              text: text,
              isDisabled: isDisabled,
              isLoading: isLoading,
              leading: leadingIcon,
              trailing: trailingIcon,
              buttonBuilder: (variant, size) {
                return GtIconButton(
                  variant: variant,
                  size: size,
                  isDisabled: isDisabled,
                  isLoading: isLoading,
                  icon: iconButtonIcon.$2,
                  onPressed: () => debugPrint("GtIconButton pressed"),
                );
              },
            ),
          ),

          // --- Interactive GtIconButton ---
          SliverToBoxAdapter(
            child: GtBoxDescriptionContainer(
              title: "Interactive GtIconButton",
              description:
                  "Use the 'Interactive' knobs to customize this button.",
              child: GtIconButton(
                variant: interactiveVariant,
                size: interactiveSize,
                alignment: interactiveAlignment.$2,
                isDisabled: isDisabled,
                isLoading: isLoading,
                icon: iconButtonIcon.$2,
                onPressed: () => debugPrint("Interactive GtIconButton pressed"),
              ),
            ),
          ),

          // --- Navigation Buttons ---
          const SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Navigation Buttons"),
          ),
          SliverToBoxAdapter(
            child: GtBoxDescriptionContainer(
              title: "GtBackButton & GtCancelButton",
              description:
                  "Specialized icon buttons for navigation actions like returning to a previous screen or dismissing a modal.",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const GtText(
                        "GtBackButton",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GtGap.ySm(),
                      GtBackButton(
                        action: () => debugPrint("GtBackButton pressed"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const GtText(
                        "GtCancelButton",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GtGap.ySm(),
                      GtCancelButton(
                        asHero: asHero,
                        onTap: () => debugPrint("GtCancelButton pressed"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

typedef ButtonBuilder =
    Widget Function(GtButtonVariant variant, GtButtonSize size);

class _ButtonGrid extends GtStatelessWidget {
  final String text;
  final bool isDisabled;
  final bool isLoading;
  final (String, IconData?) leading;
  final (String, IconData?) trailing;
  final ButtonBuilder buttonBuilder;

  const _ButtonGrid({
    required this.text,
    required this.isDisabled,
    required this.isLoading,
    required this.leading,
    required this.trailing,
    required this.buttonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.dp(16.px),
      runSpacing: context.dp(16.px),
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: GtButtonVariant.values.mapList((variant) {
        return Column(
          children: [
            GtText(
              variant.name.toUpperCase(),
              style: context.textStyles.bodyS(color: context.palette.text.sub),
            ),
            GtGap.yMd(),
            Column(
              children: GtButtonSize.values.map((size) {
                return Padding(
                  padding: context.insets.onlyDp(bottom: 16.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buttonBuilder(variant, size),
                      GtGap.yXs(),
                      GtText(
                        size.name.capitalise(),
                        style: context.textStyles.bodyXs(
                          color: context.palette.text.sub,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }),
    );
  }
}
