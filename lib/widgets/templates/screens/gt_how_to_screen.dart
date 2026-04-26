import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtHowToTile extends GtStatelessWidget {
  final AppImageData leading;
  final String instruction;

  const GtHowToTile({
    super.key,
    required this.leading,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      spacing: context.spacingBase,
      children: [
        GtImage(image: leading, width: 24, height: 24),
        GtText(
          instruction,
          style: context.textStyles.subHeadM(color: context.palette.text.white),
          textAlign: .center,
        ),
      ],
    );
  }
}

class GtHowToScreen extends GtStatelessWidget {
  final String title;
  final String description;
  final String continueText;
  final List<GtHowToTile> instructions;
  final OnPressed? onContinue;

  const GtHowToScreen({
    super.key,
    required this.title,
    required this.description,
    required this.instructions,
    required this.continueText,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = palette.text.white;

    return Scaffold(
      backgroundColor: palette.bg.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: .center,
            children: [
              GtGap.yLg(),
              GtCancelButton(
                alignment: .topRight,
                size: 26,
                color: palette.icon.white,
              ),
              GtGap.ySection4xl(),
              GtGap.yXl(),
              GtText(
                title.upper,
                textAlign: .center,
                style: context.textStyles.h5(color: color),
              ),
              GtGap.yXl(),
              Padding(
                padding: context.insets.symmetricDp(horizontal: 10.px),
                child: GtText(
                  description,
                  textAlign: .center,
                  style: context.textStyles.subHeadM(color: palette.text.soft),
                ),
              ),
              GtGap.ySection4xl(),
              for (final instruction in instructions) ...[
                instruction,
                GtGap.ySectionSm(),
              ],
              GtGap.ySectionXl(),
              Align(
                alignment: .topCenter,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onContinue?.call();
                  },
                  child: Padding(
                    padding: context.insets.symmetricDp(vertical: 8.px),
                    child: GtText(
                      continueText,
                      style: context.textStyles.subHeadM(
                        color: palette.text.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
