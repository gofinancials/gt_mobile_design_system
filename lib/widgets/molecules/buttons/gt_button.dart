import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtButtonSize {
  small(36),
  medium(40),
  large(48);

  const GtButtonSize(this.value);
  final double value;
}

enum GtButtonVariant { primary, destructive, secondary, white }

abstract class GtButtonBase extends GtStatelessWidget {
  final OnPressed onPressed;
  final GtButtonSize size;
  final Size? minSize;
  final bool isDisabled;
  final bool isLoading;
  final Color? color;
  final AlignmentGeometry? alignment;

  const GtButtonBase({
    required this.onPressed,
    this.minSize,
    this.size = .medium,
    this.color,
    this.isDisabled = false,
    this.isLoading = false,
    this.alignment,
    super.key,
  });

  double buttonHeight(BuildContext context) {
    return context.dp(size.value.px);
  }

  Size minimumSize(BuildContext context) {
    final height = buttonHeight(context);
    final width = minSize?.width;
    return switch (size) {
      .small => Size(width ?? context.dp(68.px), height),
      .medium => Size(width ?? context.dp(80.px), height),
      .large => Size(width ?? context.dp(120.px), height),
    };
  }

  Size maximumSize(BuildContext context) {
    final height = buttonHeight(context);
    return Size(double.infinity, height);
  }

  EdgeInsetsGeometry padding(BuildContext context) {
    final i = context.insets;
    return switch (size) {
      .small => i.symmetricDp(vertical: 4.px, horizontal: 8.px),
      .medium => i.symmetricDp(vertical: 8.px, horizontal: 16.px),
      .large => i.symmetricDp(vertical: 10.px, horizontal: 20.px),
    };
  }

  ButtonStyle baseStyle(BuildContext context) {
    final height = buttonHeight(context);
    final minSize = minimumSize(context);
    final maxSize = maximumSize(context);
    final hPadding = padding(context);
    final shape = RoundedRectangleBorder(borderRadius: 10.circularBorderRadius);

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(minSize),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(height)),
      maximumSize: WidgetStatePropertyAll(maxSize),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(shape),
      padding: WidgetStateProperty.all(hPadding),
      alignment: alignment,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}



