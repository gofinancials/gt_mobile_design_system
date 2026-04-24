import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

// -----------------------------------------------------------------------------
// Status variant
// -----------------------------------------------------------------------------

/// Visual outcome for [GtStatusState]: drives status icon and icon tint tokens.
enum GtStatusStateVariant {
  /// Positive completion — success palette on the status glyph.
  success,

  /// Failure or blocking error — error palette on the status glyph.
  error,
}

// -----------------------------------------------------------------------------
// Status screen
// -----------------------------------------------------------------------------

class GtStatusState extends GtStatelessWidget {
  /// Success vs error — controls icon choice and semantic icon color.
  final GtStatusStateVariant variant;

  /// Optional app bar line; forwarded to [GtModalAppBar] (leading title image
  /// stays null on the standard constructor). Use `null` or `''` for no title.
  final String? appBarTitle;

  /// Primary headline under the icon (e.g. "Transfer complete").
  final String messageTitle;

  /// Supporting copy under [messageTitle].
  final String subtitle;

  /// Label for the footer [GtRaisedButton] (e.g. "Done", "Try again").
  final String actionLabel;

  /// Invoked when the footer button is pressed.
  final OnPressed onActionPressed;

  /// Optional variant for the footer button; defaults to [GtButtonVariant.primary].
  final GtButtonVariant actionVariant;

  /// Creates a [GtStatusState] configured for the given [variant] and copy.
  const GtStatusState({
    super.key,
    required this.variant,
    this.appBarTitle,
    required this.messageTitle,
    required this.subtitle,
    required this.actionLabel,
    required this.onActionPressed,
    this.actionVariant = GtButtonVariant.primary,
  });

  /// Convenience constructor for [GtStatusStateVariant.success].
  const GtStatusState.success({
    Key? key,
    String? appBarTitle,
    required String messageTitle,
    required String subtitle,
    required String actionLabel,
    required OnPressed onActionPressed,
    GtButtonVariant actionVariant = GtButtonVariant.primary,
  }) : this(
         key: key,
         variant: GtStatusStateVariant.success,
         appBarTitle: appBarTitle,
         messageTitle: messageTitle,
         subtitle: subtitle,
         actionLabel: actionLabel,
         onActionPressed: onActionPressed,
         actionVariant: actionVariant,
       );

  /// Convenience constructor for [GtStatusStateVariant.error].
  const GtStatusState.error({
    Key? key,
    String? appBarTitle,
    required String messageTitle,
    required String subtitle,
    required String actionLabel,
    required OnPressed onActionPressed,
    GtButtonVariant actionVariant = GtButtonVariant.primary,
  }) : this(
         key: key,
         variant: GtStatusStateVariant.error,
         appBarTitle: appBarTitle,
         messageTitle: messageTitle,
         subtitle: subtitle,
         actionLabel: actionLabel,
         onActionPressed: onActionPressed,
         actionVariant: actionVariant,
       );

  /// Maps [variant] to the status glyph shown above the titles.
  String _statusIcon() {
    return switch (variant) {
      GtStatusStateVariant.success => GtVectorIllustrations.success,
      GtStatusStateVariant.error => GtVectorIllustrations.failed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final horizontal = context.insets.defaultHorizontalInsets;
    final iconSize = context.dp(130.px);

    final barTitle = appBarTitle;
    final modalBarTitle = (barTitle == null || barTitle.isEmpty)
        ? null
        : barTitle;

    // [GtModalAppBar] is not an [AppBar] slot here — give it a fixed height from
    // [PreferredSizeWidget.preferredSize] so it paints correctly in the column.
    final modalAppBar = GtModalAppBar(title: modalBarTitle);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        modalAppBar,
        Expanded(
          child: Padding(
            padding: horizontal,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: context.spacingLg,
                      ),
                      child: Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .center,
                        spacing: context.spacingBase,
                        children: [
                          GtSvg(
                            _statusIcon(),
                            width: iconSize,
                            height: iconSize,
                          ),
                          const GtGap.yXl(),
                          GtText(
                            messageTitle.upper,
                            textAlign: TextAlign.center,
                            style: context.textStyles.h4(
                              color: palette.text.strong,
                            ),
                          ),
                          GtText(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: context.textStyles.bodyS(
                              color: palette.text.strong,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: context.spacingLg),
                  child: GtRaisedButton(
                    text: actionLabel,
                    onPressed: onActionPressed,
                    variant: actionVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
