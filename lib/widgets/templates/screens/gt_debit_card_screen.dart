import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template screen for debit-card related entry states.
///
/// This layout intentionally omits a textual app-bar title and keeps a
/// close ("X") action at the top-right, followed by vertically stacked content:
/// illustration, title, subtitle, and a primary action button.
///
/// {@category Templates}
class GtDebitCardScreen extends GtStatelessWidget {
  /// The top illustration displayed above text content.
  ///
  /// When `null` or without a resolvable source, the hero image and its trailing
  /// gap are omitted.
  final AppImageData? image;

  /// The main heading shown beneath the [image].
  final String title;

  /// Supporting description shown below [title].
  final String subtitle;

  /// Primary call-to-action button rendered at the bottom of the content stack.
  final GtButton button;

  /// Optional callback for the top-right close action.
  ///
  /// If omitted, [GtCancelButton] falls back to default pop behavior.
  final OnPressed? onClose;

  /// Background color of the screen surface.
  ///
  /// Defaults to the semantic white background from the active palette.
  final Color? backgroundColor;

  /// Creates a [GtDebitCardScreen].
  const GtDebitCardScreen({
    super.key,
    this.image,
    required this.title,
    required this.subtitle,
    required this.button,
    this.onClose,
    this.backgroundColor,
  });

  /// Whether [image] has a non-empty URL, asset path, or file to render.
  static bool _hasImage(AppImageData? data) {
    if (data == null) return false;
    if (data.isUrl && (data.fileUrl?.trim().isNotEmpty ?? false)) return true;
    if (data.isString && (data.filePath?.trim().isNotEmpty ?? false)) {
      return true;
    }
    if (data.isFile && data.file != null) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.palette.primary.darker;
    final textColor = context.palette.text.white;

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: GtActionAppBar(
        implyLeading: false,
        trailing: GtOptionalWidgetPair(
          tail: GtCancelButton(
            onTap: onClose,
            color: context.palette.text.white,
          ),
        ),
      ),
      body: Container(
        color: bgColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              const GtGap.ySectionMd(),
              Expanded(
                child: Column(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .stretch,
                  children: [
                    if (_hasImage(image)) ...[
                      GtImage(
                        image: image,
                        width: context.dp(300.px),
                        height: context.dp(300.px),
                        alignment: Alignment.centerRight,
                        fit: BoxFit.contain,
                      ),
                      // GtGap.ySectionLg(),
                    ],
                    // Title block.
                    Padding(
                      padding: context.insets.defaultHorizontalInsets,
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          GtText(
                            title.upper,
                            textAlign: .start,
                            style: context.textStyles.d1(color: textColor),
                          ),
                          GtGap.yMd(),
                          // Subtitle block.
                          GtText(
                            subtitle.capitalise(),
                            textAlign: .start,
                            style: context.textStyles.bodyS(color: textColor),
                          ),
                          GtGap.yXl(),
                          button,
                          GtGap.ySectionSm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
