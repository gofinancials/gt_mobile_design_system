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

  /// Custom state that must provide its own [GtStatusState.statusIcon].
  other,
}

// -----------------------------------------------------------------------------
// Status screen
// -----------------------------------------------------------------------------

class GtStatusState extends GtStatelessWidget {
  /// Success, error, or custom state — controls icon resolution behavior.
  final GtStatusStateVariant variant;

  /// Optional app bar line; forwarded to [GtModalAppBar] (leading title image
  /// stays null on the standard constructor). Use `null` or `''` for no title.
  final String? appBarTitle;

  /// Primary headline under the icon (e.g. "Transfer complete").
  final String messageTitle;

  /// Supporting copy under [messageTitle].
  final String subtitle;

  /// Optional illustration override for the status glyph.
  ///
  /// When null, a default illustration is resolved from [variant].
  final String? statusIcon;

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
    this.statusIcon,
    required this.actionLabel,
    required this.onActionPressed,
    this.actionVariant = GtButtonVariant.primary,
  }) : assert(
         variant != GtStatusStateVariant.other ||
             (statusIcon != null && statusIcon != ''),
         'statusIcon is required when variant is GtStatusStateVariant.other',
       );

  /// Convenience constructor for [GtStatusStateVariant.success].
  const GtStatusState.success({
    Key? key,
    String? appBarTitle,
    required String messageTitle,
    required String subtitle,
    String? statusIcon,
    required String actionLabel,
    required OnPressed onActionPressed,
    GtButtonVariant actionVariant = GtButtonVariant.primary,
  }) : this(
         key: key,
         variant: GtStatusStateVariant.success,
         appBarTitle: appBarTitle,
         messageTitle: messageTitle,
         subtitle: subtitle,
         statusIcon: statusIcon,
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
    String? statusIcon,
    required String actionLabel,
    required OnPressed onActionPressed,
    GtButtonVariant actionVariant = GtButtonVariant.primary,
  }) : this(
         key: key,
         variant: GtStatusStateVariant.error,
         appBarTitle: appBarTitle,
         messageTitle: messageTitle,
         subtitle: subtitle,
         statusIcon: statusIcon,
         actionLabel: actionLabel,
         onActionPressed: onActionPressed,
         actionVariant: actionVariant,
       );

  /// Convenience constructor for [GtStatusStateVariant.other].
  ///
  /// [statusIcon] is required for this variant.
  const GtStatusState.other({
    Key? key,
    String? appBarTitle,
    required String messageTitle,
    required String subtitle,
    required String statusIcon,
    required String actionLabel,
    required OnPressed onActionPressed,
    GtButtonVariant actionVariant = GtButtonVariant.primary,
  }) : this(
         key: key,
         variant: GtStatusStateVariant.other,
         appBarTitle: appBarTitle,
         messageTitle: messageTitle,
         subtitle: subtitle,
         statusIcon: statusIcon,
         actionLabel: actionLabel,
         onActionPressed: onActionPressed,
         actionVariant: actionVariant,
       );

  /// Resolves the status illustration shown above the titles.
  ///
  /// Uses [statusIcon] when provided, otherwise falls back to
  /// the default asset mapped from [variant].
  String _statusIcon() {
    return switch (variant) {
      GtStatusStateVariant.success => GtVectorIllustrations.success,
      GtStatusStateVariant.error => GtVectorIllustrations.failed,
      GtStatusStateVariant.other => statusIcon!,
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
                              color: GtColors.neutral600.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: context.spacingsectionMd),
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
