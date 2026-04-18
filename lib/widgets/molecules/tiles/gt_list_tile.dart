import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtListTile extends GtStatelessWidget {
  final String text;
  final Widget? leading;
  final Widget? trailing;
  final OnPressed? onTap;

  const GtListTile({
    super.key,
    required this.text,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingMd,
          children: [
            if (leading != null)
              ConstrainedBox(
                constraints: BoxConstraints.tight(Size.square(24)),
                child: leading,
              ),
            Expanded(child: GtText(text, style: context.textStyles.subHeadS())),
            if (trailing != null)
              ConstrainedBox(
                constraints: BoxConstraints.tight(Size.square(20)),
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}

class GtInputListTile extends GtStatelessWidget {
  final String label;
  final String text;
  final Widget? leading;
  final OnPressed? onTap;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final bool _asCard;

  const GtInputListTile(
    this.label, {
    super.key,
    required this.text,
    this.leading,
    this.labelStyle,
    this.textStyle,
    this.onTap,
  }) : _asCard = false;

  const GtInputListTile.asCard(
    this.label, {
    super.key,
    required this.text,
    this.leading,
    this.textStyle,
    this.labelStyle,
    this.onTap,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? context.textStyles.subHeadS();
    final hintStyle = (labelStyle ?? context.textStyles.bodyXs()).copyWith(
      color: context.palette.text.sub,
    );

    Widget child = Column(
      spacing: context.spacingSm,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtText(label, style: hintStyle),
        GtText(text, style: style),
      ],
    );

    if (leading != null) {
      child = Row(
        spacing: context.spacingBase,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.tight(Size.square(20)),
            child: leading,
          ),
          Expanded(child: child),
        ],
      );
    }

    if (_asCard) {
      child = GtCard(borderRadius: context.borderRadiusXl, child: child);
    }

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: child,
    );
  }
}

class GtLimitInfoListTile extends GtStatelessWidget {
  final String label;
  final String value;
  final IconData? leading;

  const GtLimitInfoListTile(
    this.label, {
    super.key,
    this.leading,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.spacingMd,
      children: [
        GtIcon(leading ?? GtIcons.gauge, size: 20),
        Expanded(
          child: Column(
            spacing: context.spacingSm,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GtText(
                label,
                style: context.textStyles.bodyXs(
                  color: context.palette.text.sub,
                ),
              ),
              GtText(value, style: context.textStyles.subHeadM()),
            ],
          ),
        ),
      ],
    );
  }
}

class GtLimitEditListTile extends GtStatelessWidget {
  final String category;
  final num value;
  final num max;
  final OnPressed? onTapInfo;
  final String? editText;
  final OnPressed? onEdit;

  const GtLimitEditListTile(
    this.category, {
    super.key,
    required this.value,
    required this.max,
    this.editText,
    this.onTapInfo,
    this.onEdit,
  });

  double get _fraction => min((value / max), 1);
  num get _remainder => max - value;
  String get _formattedValue => AppTextFormatter.formatCurrency(value);
  String get _formattedRemainder => AppTextFormatter.formatCurrency(_remainder);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.spacingSm,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.spacingBase,
                children: [
                  Text.rich(
                    TextSpan(
                      text: category,
                      children: [
                        TextSpan(text: " "),
                        WidgetSpan(
                          child: GtIcon(GtIcons.info, size: 18, variant: .soft),
                        ),
                      ],
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (onTapInfo == null) return;
                          HapticFeedback.lightImpact();
                          onTapInfo?.call();
                        },
                    ),
                    style: context.textStyles.subHeadM(),
                  ),
                  GtText(
                    _formattedValue,
                    style: context.textStyles.body2Xs(
                      color: context.palette.text.darkerSub,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              GtButton(
                onPressed: () {
                  onEdit?.call();
                },
                text: editText ?? "edit".tr(),
                variant: .neutral,
                size: .small,
                leading: GtIcons.pencil,
              ),
          ],
        ),
        const GtGap.ySm(),
        GtAnimatedProgress(
          value: _fraction,
          valueColor: context.palette.verified.base,
        ),
        const GtGap.ySm(),
        Align(
          alignment: Alignment.centerRight,
          child: GtText(
            "$_formattedRemainder ${"remaining".tr()}",
            style: context.textStyles.subHead2xs(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class GtAccountListTile extends GtStatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget? trailing;
  final OnPressed? onTap;
  final bool hasBoldSubtitle;

  const GtAccountListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.leading,
    this.trailing,
    this.onTap,
    this.hasBoldSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final subStyle = switch (hasBoldSubtitle) {
      true => context.textStyles.subHeadXs(color: palette.text.sub),
      _ => context.textStyles.bodyXs(color: palette.text.sub),
    };

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingMd,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(36)),
              child: leading,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GtText(title, style: context.textStyles.subHeadS()),
                  GtText(subtitle, style: subStyle),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class GtContactListTile extends GtStatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final OnPressed onTap;

  const GtContactListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final subStyle = context.textStyles.bodyXs(color: palette.text.sub);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(36)),
              child: leading,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GtText(title, style: context.textStyles.subHeadS()),
                  GtText(subtitle, style: subStyle),
                ],
              ),
            ),
            GtIcon(
              GtIcons.chevronRight,
              size: 18,
              alignment: Alignment.centerRight,
              variant: .soft,
            ),
          ],
        ),
      ),
    );
  }
}

class GtExportListTile extends GtStatelessWidget {
  final String title;
  final String? subtitle;
  final OnPressed onTap;

  const GtExportListTile(
    this.title, {
    super.key,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    TextStyle titleStyle = context.textStyles.subHeadM();
    TextStyle? subStyle;

    if (subtitle != null) {
      titleStyle = context.textStyles.subHeadS();
      subStyle = context.textStyles.bodyXs(color: palette.text.soft);
    }

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.spacingXs,
                children: [
                  GtText(title, style: titleStyle),
                  if (subtitle != null) GtText(subtitle, style: subStyle),
                ],
              ),
            ),
            GtIcon(
              GtIcons.shareIos,
              size: 20,
              alignment: Alignment.centerRight,
              variant: .soft,
            ),
          ],
        ),
      ),
    );
  }
}

class GtIllustratedStepTile extends GtStatelessWidget {
  final String illustrationPath;
  final String title;
  final String subtitle;
  final bool isDone;
  final bool _asCard;

  const GtIllustratedStepTile({
    super.key,
    required this.illustrationPath,
    required this.title,
    required this.subtitle,
    this.isDone = false,
  }) : _asCard = false;

  const GtIllustratedStepTile.card({
    super.key,
    required this.illustrationPath,
    required this.title,
    required this.subtitle,
    this.isDone = false,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final textColors = context.palette.text;

    Widget child = Row(
      spacing: context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtSvg(illustrationPath, height: 36, width: 36),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GtText(title, style: context.textStyles.subHeadM()),
              GtText(
                subtitle,
                style: context.textStyles.subHeadXs(color: textColors.sub),
              ),
            ],
          ),
        ),
      ],
    );

    child = Row(
      spacing: context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: child),
        Visibility(
          visible: isDone,
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          child: GtCheckBox(
            value: true,
            onChanged: (_) {},
            isActive: true,
            shape: GtCheckBoxShape.circle,
            activeColor: context.palette.success.base,
          ),
        ),
      ],
    );

    if (_asCard) {
      child = GtCard(
        padding: context.insets.symmetricDp(horizontal: 12.px, vertical: 16.px),
        child: child,
      );
    }

    return GtDisabledOverlay(isDone, child: child);
  }
}

class GtStatusListTile extends GtStatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final GtStatusPill? footer;
  final bool isDone;
  final OnPressed onPressed;
  final bool _asCard;

  const GtStatusListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.footer,
    this.isDone = false,
  }) : _asCard = false;

  const GtStatusListTile.card({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.footer,
    this.isDone = false,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      spacing: context.spacingBase,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtIcon(icon, size: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GtText(title.upper, style: context.textStyles.h7()),
              GtText(subtitle),
              if (footer != null) ...[GtGap.yBase(), ?footer],
            ],
          ),
        ),
      ],
    );

    child = Row(
      spacing: context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: child),
        if (isDone)
          GtCheckBox(
            value: true,
            onChanged: (_) {},
            isActive: true,
            shape: GtCheckBoxShape.circle,
            activeColor: context.palette.success.base,
          )
        else
          GtIcon(
            GtIcons.chevronRight,
            size: 20,
            alignment: Alignment.centerRight,
            variant: .soft,
          ),
      ],
    );

    if (_asCard) {
      child = GtCard(padding: context.insets.allDp(16.px), child: child);
    }

    return GtDisabledOverlay(
      isDone,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        child: child,
      ),
    );
  }
}

class GtCopyTile extends GtStatelessWidget {
  final IconData leading;
  final String label;
  final String value;
  final OnPressed? onCopied;

  const GtCopyTile(
    this.label, {
    super.key,
    required this.value,
    required this.leading,
    this.onCopied,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final textColors = context.palette.text;

    return InkWell(
      onTap: () {
        context.copyTextToClipboard(value);
        onCopied?.call();
      },
      child: Row(
        spacing: context.spacingBase,
        children: [
          GtIcon(leading, size: 20, alignment: Alignment.centerLeft),
          Expanded(
            child: GtText(
              label,
              textAlign: TextAlign.start,
              style: styles.subHeadXs(color: textColors.sub),
            ),
          ),
          Expanded(
            child: GtText(
              value,
              textAlign: TextAlign.end,
              style: styles.subHeadXs(),
            ),
          ),
          GtIcon(
            GtIcons.copyFilled,
            size: 16,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}

class GtIconListTile extends GtStatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final CrossAxisAlignment? crossAxisAlignment;
  final OnPressed? onTap;

  const GtIconListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.icon,
    this.crossAxisAlignment,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: context.spacingMd,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          children: [
            Align(
              child: GtIcon.withColor(
                icon,
                size: context.dp(24.px),
                color: iconColor,
              ),
            ),
            Expanded(
              child: Column(
                spacing: context.spacingSm,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GtText(title, style: context.textStyles.subHeadS()),
                  GtText(
                    subtitle,
                    style: context.textStyles.bodyXs(color: palette.text.sub),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GtDeviceListTile extends GtStatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final OnPressed? _onRemove;
  final String? _buttonText;

  const GtDeviceListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.icon,
  }) : _onRemove = null,
       _buttonText = null;

  const GtDeviceListTile.removable(
    this.title, {
    super.key,
    required this.subtitle,
    required this.icon,
    required OnPressed onRemove,
    required String buttonText,
  }) : _onRemove = onRemove,
       _buttonText = buttonText;

  @override
  Widget build(BuildContext context) {
    Widget child = GtIconListTile(title, subtitle: subtitle, icon: icon);

    if (_onRemove != null) {
      child = Row(
        spacing: context.spacingMd,
        children: [
          Expanded(child: child),
          GtButton(
            onPressed: _onRemove,
            text: _buttonText,
            variant: .destructiveAlt,
            size: .pill,
            alignment: Alignment.centerRight,
          ),
        ],
      );
    }

    return child;
  }
}

class GtInstructionListTile extends GtStatelessWidget {
  final String text;
  final IconData icon;
  final GtIconVariant? iconVariant;
  final Color? textColor;
  final OnPressed? onTap;

  const GtInstructionListTile(
    this.text, {
    super.key,
    required this.icon,
    this.onTap,
    this.iconVariant,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Row(
        spacing: context.spacingBase,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GtIcon(
            icon,
            size: context.dp(24.px),
            alignment: Alignment.topLeft,
            variant: iconVariant ?? GtIconVariant.soft,
          ),
          Expanded(
            child: GtText(
              text,
              style: context.textStyles.bodyS(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class GtSimpleActionListTile extends GtStatelessWidget {
  final String title;
  final String subtitle;
  final IconData trailing;
  final OnPressed? onTap;

  const GtSimpleActionListTile(
    this.title, {
    super.key,
    required this.subtitle,
    this.trailing = GtIcons.chevronRight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: context.spacingMd,
          children: [
            Expanded(child: GtText(title, style: context.textStyles.h6())),
            GtIcon(
              trailing,
              size: context.dp(24.px),
              variant: .soft,
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
    );
  }
}

class GtTransactionListTile extends GtStatelessWidget {
  final Widget leading;
  final String name;
  final String subtitle;
  final num amount;
  final bool isDebit;
  final OnPressed? onTap;

  const GtTransactionListTile(
    this.name, {
    super.key,
    required this.subtitle,
    required this.amount,
    required this.isDebit,
    required this.leading,
    this.onTap,
  });

  String get _formattedAmount {
    return AppTextFormatter.formatCurrency(amount, symbol: "N");
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final amountColor = switch (isDebit) {
      true => palette.text.soft,
      _ => palette.primary.base,
    };

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(36)),
              child: leading,
            ),
            Expanded(
              child: Column(
                spacing: context.spacingSm,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: context.spacingSm,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GtText(
                          name,
                          style: context.textStyles.subHeadM(),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      GtText(
                        _formattedAmount,
                        style: context.textStyles.subHeadM(color: amountColor),
                      ),
                    ],
                  ),
                  GtText(
                    subtitle,
                    style: context.textStyles.bodyXs(color: palette.text.sub),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GtMenuListTile<T> extends StatelessWidget {
  final String text;
  final IconData icon;
  final T value;
  final OnChanged<T> onSelect;

  const GtMenuListTile(
    this.text, {
    super.key,
    required this.icon,
    required this.value,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onSelect(value);
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 4.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: GtText(text, style: context.textStyles.subHeadS())),
            GtIcon.withColor(
              icon,
              size: 20,
              color: context.palette.primary.dark,
            ),
          ],
        ),
      ),
    );
  }
}

class GtIndicatorTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final OnPressed? onTap;
  final Widget? trailing;
  final Widget? footer;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  const GtIndicatorTile(
    this.title, {
    this.trailing,
    super.key,
    this.subtitle,
    this.icon,
    this.footer,
    this.onTap,
    this.titleStyle,
    this.subTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textStyles = context.textStyles;

    final text = GtText(
      title,
      style: titleStyle ?? context.textStyles.subHeadS(),
      maxLines: 1,
      textAlign: TextAlign.start,
    );

    Widget leading = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 24),
      child: text,
    );

    if (subtitle != null) {
      leading = Column(
        spacing: context.spacingXs,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,
          GtText(
            subtitle,
            style: subTitleStyle ?? textStyles.bodyXs(color: palette.text.soft),
          ),
          if (footer != null) ...[GtGap.ySm(), ?footer],
        ],
      );
    }

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Row(
        crossAxisAlignment: switch (footer == null) {
          false => CrossAxisAlignment.start,
          _ => CrossAxisAlignment.center,
        },
        spacing: context.spacingLg,
        children: [
          ?icon,
          Expanded(child: leading),
          ?trailing,
        ],
      ),
    );
  }
}

class GtStakeHolderListTile extends GtStatelessWidget {
  final String name;
  final String position;
  final String footer;
  final OnPressed onTap;

  const GtStakeHolderListTile(
    this.name, {
    super.key,
    required this.position,
    required this.footer,
    required this.onTap,
  });

  String get initials => AppHelpers.getInitials(name) ?? "";

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final leading = Row(
      crossAxisAlignment: .start,
      spacing: context.spacingBase,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tight(Size.square(36)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: .circle,
              color: palette.primary.alpha10,
            ),
            child: Center(
              child: GtText(
                initials.upper,
                style: context.textStyles.h7(color: palette.primary.base),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            spacing: context.spacingSm,
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            children: [
              GtText(name.upper, style: context.textStyles.h7()),
              GtText(
                position,
                style: context.textStyles.bodyS(color: palette.text.sub),
              ),
              GtText(
                footer,
                style: context.textStyles.bodyXs(color: palette.primary.dark),
              ),
            ],
          ),
        ),
      ],
    );

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            Expanded(child: leading),
            GtIcon(GtIcons.chevronRight, size: 16, variant: .soft),
          ],
        ),
      ),
    );
  }
}

class GtStakeHolderStatusListTile extends GtStatelessWidget {
  final String name;
  final String position;
  final Widget trailing;
  final bool isVerified;

  const GtStakeHolderStatusListTile(
    this.name, {
    super.key,
    required this.position,
    required this.trailing,
    this.isVerified = false,
  });

  String get initials => AppHelpers.getInitials(name) ?? "";

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GtDisabledOverlay(
      isVerified,
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(36)),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: .circle,
                  color: palette.primary.alpha10,
                ),
                child: Center(
                  child: GtText(
                    initials.upper,
                    style: context.textStyles.h7(color: palette.primary.base),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: context.spacingSm,
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  GtText(name.upper, style: context.textStyles.h7()),
                  GtText(
                    position,
                    style: context.textStyles.bodyS(color: palette.text.sub),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class GtTransactionParticipantListTile extends GtStatelessWidget {
  final String title;
  final String? subtitle;
  final String superscript;
  final Widget? leading;
  final CrossAxisAlignment crossAxisAlignment;

  const GtTransactionParticipantListTile(
    this.title, {
    super.key,
    this.subtitle,
    this.leading,
    this.crossAxisAlignment = CrossAxisAlignment.end,
    required this.superscript,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      spacing: context.spacingMd,
      children: [
        if (leading != null)
          ConstrainedBox(
            constraints: BoxConstraints.tight(Size.square(32)),
            child: leading,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: switch (crossAxisAlignment) {
              .center => MainAxisAlignment.center,
              .start => MainAxisAlignment.start,
              _ => MainAxisAlignment.end,
            },
            children: [
              GtText(
                superscript.upper,
                style: context.textStyles.titleXs(color: palette.text.disabled),
              ),
              GtText(title, style: context.textStyles.h7()),
              if (subtitle != null) ...[
                const GtGap.ySm(),
                GtText(
                  subtitle,
                  style: context.textStyles.subHead2xs(
                    color: palette.text.soft,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class GtDoubleColumnListTile extends GtStatelessWidget {
  final String label;
  final String value;
  final Widget? valuePrefix;
  final Widget? valueSuffix;
  final bool highlightValue;

  const GtDoubleColumnListTile(
    this.label, {
    super.key,
    required this.value,
    this.valuePrefix,
    this.valueSuffix,
    this.highlightValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textStyles = context.textStyles;
    TextStyle labelStyle = textStyles.bodyS(color: palette.text.sub);
    TextStyle valueStyle = textStyles.subHeadS();

    if (!highlightValue) {
      labelStyle = labelStyle.copyWith(color: palette.text.strong);
      valueStyle = valueStyle.copyWith(color: palette.text.soft);
    }

    return Row(
      spacing: context.spacingBase,
      children: [
        Expanded(child: GtText(label, style: labelStyle)),
        ?valuePrefix,
        Text(value, style: valueStyle, textAlign: TextAlign.end),
        ?valueSuffix,
      ],
    );
  }
}
