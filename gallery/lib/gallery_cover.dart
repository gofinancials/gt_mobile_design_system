import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Cover',
  type: DesignSystemCover,
  designLink: 'https://www.figma.com/file/xyz123/Design-System',
)
Widget buildCover(BuildContext context) {
  return const DesignSystemCover();
}

/// The main entry screen that merges the cover art and getting started guide.
class DesignSystemCover extends GtStatelessWidget {
  const DesignSystemCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: context.insets.symmetricDp(
            horizontal: 16.px,
            vertical: 16.px,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Cover Art
              Container(
                height: context.dp(400.px),
                width: double.infinity,
                padding: context.insets.allDp(32.px),
                decoration: BoxDecoration(
                  color: context.palette.coverColors.dark,
                  borderRadius: context.radii.lg.circularBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: context.palette.coverColors.dark.withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GtText(
                          'go',
                          style: context.textStyles.d1(
                            color: context.palette.coverColors.light,
                          ),
                        ),
                        GtText(
                          '01',
                          style: context.textStyles.d1(
                            color: context.palette.coverColors.light,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GtText(
                      'GT DESIGN SYSTEM',
                      style: context.textStyles
                          .h4(color: context.palette.coverColors.light)
                          .copyWith(letterSpacing: 2),
                    ),
                    GtGap.yMd(),
                    Divider(
                      height: context.dp(1.px),
                      thickness: context.dp(1.px),
                      color: context.palette.coverColors.light.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    GtGap.yMd(),
                    GtText(
                      'A comprehensive widget catalogue for building consistent Go Tech financial applications.'
                          .upper,
                      style: context.textStyles.h7(
                        color: context.palette.coverColors.light,
                      ),
                    ),
                  ],
                ),
              ),

              // Getting Started Content
              GridView(
                shrinkWrap: true,
                padding: context.insets.onlyDp(top: 64.px),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: context.dp(500.px),
                  mainAxisExtent: context.dp(180.px),
                  mainAxisSpacing: context.spacingMd,
                  crossAxisSpacing: context.spacingMd,
                  childAspectRatio: 20 / 9,
                ),
                children: [
                  _GuideSectionCard(
                    title: 'Browse Hierarchy',
                    icon: GtIcons.shapes,
                    content:
                        'Navigate the sidebar by component complexity from basic atoms up to templates.',
                  ),
                  _GuideSectionCard(
                    title: 'Tabbed Experience',
                    icon: GtIcons.fileContent,
                    content:
                        'Switch between the interactive "Visual Display" and copyable "Code Snippet" tabs on doc pages.',
                  ),
                  _GuideSectionCard(
                    title: 'Interactive Gallery',
                    icon: GtIcons.phone,
                    content:
                        'For complex screens and scaffolds, select the dedicated "Gallery" usecase to view them in full screen.',
                  ),
                  _GuideSectionCard(
                    title: 'Knob Playgrounds',
                    icon: GtIcons.gear,
                    content:
                        'Experiment with variants, sizes, colors, and states using live controls in the knobs panel.',
                  ),
                  _GuideSectionCard(
                    title: 'Copy-Paste Code',
                    icon: GtIcons.copy,
                    content:
                        'Instantly copy ready-to-use Flutter snippets that sync dynamically with your selected knobs.',
                  ),
                  _GuideSectionCard(
                    title: 'Clean Design Tokens',
                    icon: GtIcons.paintbrush,
                    content:
                        'All components are built using context.palette, context.textStyles, and GtGap tokens.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideSectionCard extends GtStatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _GuideSectionCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GtCard(
      padding: context.insets.allDp(16.px),
      variant: .normal,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        children: [
          Container(
            padding: context.insets.allDp(12.px),
            decoration: BoxDecoration(
              color: context.palette.primary.base.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: GtIcon.withColor(
              icon,
              size: 24,
              color: context.palette.primary.base,
            ),
          ),
          const GtGap.yLg(),
          GtText(title.upper, style: context.textStyles.h6()),
          const GtGap.ySm(),
          Flexible(
            child: GtText(
              content,
              style: context.textStyles.bodyXs(color: context.palette.text.sub),
            ),
          ),
        ],
      ),
    );
  }
}
