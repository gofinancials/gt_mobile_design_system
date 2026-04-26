import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template screen widget that features a prominent duotone gradient header with an illustration.
///
/// Typically used for onboarding, featured announcements, or success/completion states.
/// It includes a large top section with a gradient and image, followed by a title,
/// description, an optional footer, and a main action button.
class GtDuotoneScreen extends GtStatelessWidget {
  /// The primary illustration or image displayed in the upper gradient section of the screen.
  final AppImageData illustration;

  /// The primary heading text displayed below the illustration.
  final String title;

  /// The secondary descriptive text displayed below the title.
  final String description;

  /// The visual variant determining the color scheme of the top gradient.
  final GtCardVariant variant;

  /// The callback triggered when the main action button is pressed.
  final OnPressed onTap;

  /// The text displayed on the main action button.
  final String buttonText;

  /// An optional widget displayed below the description, typically used for extra information.
  final Widget? footer;

  /// Creates a [GtDuotoneScreen].
  const GtDuotoneScreen({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    required this.buttonText,
    this.variant = .featured,
    required this.onTap,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = variant.getGradient(context);
    final bgColor = context.palette.bg.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      appBar: GtActionAppBar(
        implyLeading: false,
        trailing: GtOptionalWidgetPair(tail: GtCancelButton(color: bgColor)),
      ),
      key: ValueKey('gt-duotone-screen-$title-$buttonText'),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(gradient: gradient),
              child: GtImage(
                image: illustration,
                height: context.dp(400.px),
                alignment: .bottomCenter,
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: context.insets.fromLTRBDp(16.px, 40.px, 16.px, 10.px),
              child: Column(
                spacing: context.spacingMd,
                mainAxisAlignment: .start,
                crossAxisAlignment: .stretch,
                children: [
                  GtText(
                    title.upper,
                    style: context.textStyles.h4(),
                    overflow: .ellipsis,
                    maxLines: 1,
                    textAlign: .center,
                  ),
                  GtText(
                    description,
                    style: context.textStyles.bodyM(
                      color: context.palette.text.darkerSub,
                    ),
                    textAlign: .center,
                  ),
                  if (footer != null) ...[const GtGap.yBase(), ?footer],
                  const Spacer(),
                  SafeArea(
                    top: false,
                    child: GtRaisedButton(onPressed: onTap, text: buttonText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
