import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A tile used in [GtHowToLearnScreen] to display a single instruction.
///
/// [leading]: The image to display next to the instruction.
/// [instruction]: The instruction text to display.
/// [textColor]: The color of the instruction text.
class GtHowToLearnTile extends GtStatelessWidget {
  final AppImageData leading;
  final String instruction;
  final Color? textColor;

  const GtHowToLearnTile({
    super.key,
    required this.leading,
    required this.instruction,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.palette.staticColors.white;
    return Row(
      mainAxisAlignment: .center,
      spacing: context.spacingBase,
      children: [
        GtImage(image: leading, width: 24, height: 24),
        GtText(
          instruction,
          style: context.textStyles.subHeadM(color: textColor ?? color),
          textAlign: .center,
        ),
      ],
    );
  }
}

/// A full-screen template used to display "How to learn" instructions
/// with a centered layout, optional app bar action, and a prominent continue button.
///
/// [title]: The main title of the screen.
/// [description]: The description text displayed below the title.
/// [continueText]: The text for the continue button.
/// [instructions]: A list of [GtHowToLearnTile] widgets to display instructions.
/// [onContinue]: Callback for when the continue button is pressed.
class GtHowToLearnScreen extends GtStatelessWidget {
  final String title;
  final String description;
  final String continueText;
  final List<GtHowToLearnTile> instructions;
  final OnPressed? onContinue;

  const GtHowToLearnScreen({
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
    final color = palette.staticColors.white;
    final bgColor = GtColors.neutralGray800.value;
    final List<Widget> tiles = [
      for (final Widget instruction in instructions) instruction,
    ].intersperse(GtGap.ySectionSm()).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: GtActionAppBar(
        implyLeading: false,
        trailing: GtOptionalWidgetPair(
          tail: GtCancelButton(
            alignment: .topRight,
            size: .xLarge,
            color: palette.staticColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.insets.symmetricDp(horizontal: 36.px),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              GtSizedBox(height: 100),
              GtText(
                title.upper,
                textAlign: .center,
                style: context.textStyles.h4(color: color),
              ),
              GtGap.yMd(),
              GtText(
                description,
                textAlign: .center,
                style: context.textStyles.subHeadM(
                  color: GtColors.neutral400.value,
                ),
              ),
              GtGap.ySection4xl(),
              Column(children: tiles),
              GtGap.ySection4xl(),
              Align(
                alignment: .topCenter,
                child: GtInkWell(
                  borderRadius: context.borderRadius2Xl,
                  onTap: onContinue,
                  child: Padding(
                    padding: context.insets.allDp(16.px),
                    child: GtText(
                      continueText,
                      style: context.textStyles.subHeadS(
                        color: palette.staticColors.white,
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
