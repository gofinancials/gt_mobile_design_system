import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAccountDetailSlides<T> extends GtStatelessWidget {
  final GtAccountDataController<T> controller;
  final OnChanged2<int, T?>? onIndexUpdate;
  final GtActionButtonBar? actions;
  final bool hidden;
  final OnPressed onToggleHide;
  final EdgeInsetsGeometry? balancePadding;

  /// Builds the caption shown on the account pill for the selected account.
  ///
  /// Defaults to the account's type and number joined by
  /// [AppStrings.dotSeparator] and uppercased — `SAVINGS • 0123456789`. What a
  /// builder returns is rendered verbatim instead, so it carries its own
  /// casing. Only the caption changes; tapping the pill always copies the bare
  /// [GtAccountData.accountNumber], never what this returns.
  final String Function(GtAccountData<T> account)? accountPillLabelBuilder;

  /// The product colour scheme of the account pill.
  ///
  /// Defaults to [GtAccountCopyPillVariant.personal]. It also decides which
  /// side the copy icon sits on, so it still matters when the colours below
  /// are overridden. Set it to the product the surface belongs to.
  final GtAccountCopyPillVariant accountPillVariant;

  /// Overrides the account pill's text colour.
  ///
  /// Defaults to [GtPalette.primary]'s darker shade, which is also folded into
  /// the default [accountPillStyle].
  final Color? accountPillTextColor;

  /// Overrides the account pill's background colour.
  ///
  /// `null` leaves the [accountPillVariant]'s own tint in place.
  final Color? accountPillBackgroundColor;

  /// Overrides the account pill's border colour.
  ///
  /// `null` leaves the border matching the background, so it stays invisible.
  /// Pair it with [accountPillBorderStyle] to draw an outline.
  final Color? accountPillBorderColor;

  /// Replaces the account pill's text style outright.
  ///
  /// Defaults to [GtTextStyles.subHeadXs] at a 12px line height, tinted with
  /// [accountPillTextColor]. Because [GtAccountCopyPill.style] replaces rather
  /// than merges, a style passed here must carry its own colour.
  final TextStyle? accountPillStyle;

  /// Whether the account pill draws its copy icon.
  ///
  /// Defaults to `false` — the pill reads as a caption under the balance, so
  /// the icon is suppressed. Turn it on where the copy affordance needs to be
  /// visible; the icon takes the resolved [accountPillTextColor].
  final bool showAccountPillIcon;

  /// Whether the account pill draws its product-tinted elevation.
  ///
  /// Defaults to `false` — the caption sits directly on the dashboard
  /// gradient, where the pill's own elevation would read as a stray card.
  /// [GtAccountCopyPill] itself defaults this to `true`.
  final bool showAccountPillShadow;

  /// The account pill's border line style.
  ///
  /// Defaults to [BorderStyle.none] so the caption reads flat. Only visible
  /// once [accountPillBorderColor] differs from the background.
  final BorderStyle accountPillBorderStyle;

  /// Accessibility guidance announced with the account pill.
  ///
  /// The label itself comes from the pill's own fallback chain — the caption
  /// from [accountPillLabelBuilder]. Use this to say what tapping does.
  final String? accountPillSemanticHint;

  const GtAccountDetailSlides({
    required this.controller,
    required this.hidden,
    required this.onToggleHide,
    this.balancePadding,
    this.onIndexUpdate,
    this.actions,
    this.accountPillLabelBuilder,
    this.accountPillVariant = .personal,
    this.accountPillTextColor,
    this.accountPillBackgroundColor,
    this.accountPillBorderColor,
    this.accountPillStyle,
    this.showAccountPillIcon = false,
    this.showAccountPillShadow = false,
    this.accountPillBorderStyle = .none,
    this.accountPillSemanticHint,
    super.key,
  });

  String _getAccountLabel(GtAccountData<T> data) {
    if (accountPillLabelBuilder == null) {
      return "${data.type}${AppStrings.dotSeparator}"
              "${data.accountNumber}"
          .upper;
    }
    return accountPillLabelBuilder!.call(data);
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.insets.symmetricDp(horizontal: 17.px);
    final activeColor = switch (context.isInDarkMode) {
      true => context.palette.primary.base,
      _ => context.palette.primary.dark,
    };
    final textColor = switch (context.isInDarkMode) {
      true => context.palette.primary.base,
      _ => context.palette.primary.darker,
    };
    final pillColor = switch (context.isInDarkMode) {
      true => context.palette.primary.alpha10,
      _ => null,
    };
    final pillTextColor = accountPillTextColor ?? textColor;
    final pillStyle = context.textStyles.subHeadXs(
      color: pillTextColor,
      heightPx: 12,
    );

    return ListenableBuilder(
      listenable: controller,
      child: actions,
      builder: (context, child) {
        final count = controller.count;
        final index = controller.activeIndex;
        final accounts = controller.accounts;
        final account = controller.selectedAccount;

        return Column(
          spacing: context.spacingSectionMd,
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  if (count > 1)
                    GtScaledDots(
                      index,
                      length: count,
                      activeColor: activeColor,
                      inActiveColor: context.palette.primary.alpha24,
                    ),
                  GtSizedBox(
                    height: 76,
                    key: Key("accounts-slider-${accounts.length}"),
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: (value) {
                        controller.activeIndex = value;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          onIndexUpdate?.call(
                            value,
                            controller.selectedAccount?.data,
                          );
                        });
                      },
                      children: [
                        for (final (index, account) in accounts.indexed)
                          Padding(
                            padding: balancePadding ?? padding,
                            child: GtBalanceText(
                              key: ValueKey("gt-account-$index"),
                              amount: account.balance,
                              currencySymbol:
                                  account.currency ?? AppStrings.naira,
                              hidden: hidden,
                              onVisibilityIconTap: onToggleHide,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (account case final data?)
                    GtAccountCopyPill(
                      data.accountNumber,
                      label: _getAccountLabel(data),
                      variant: accountPillVariant,
                      textColor: pillTextColor,
                      backgroundColor: accountPillBackgroundColor ?? pillColor,
                      borderColor: accountPillBorderColor,
                      style: accountPillStyle ?? pillStyle,
                      showIcon: showAccountPillIcon,
                      showShadow: showAccountPillShadow,
                      borderStyle: accountPillBorderStyle,
                      semanticHint: accountPillSemanticHint,
                    ),
                ],
              ),
            ),
            ?child,
          ],
        );
      },
    );
  }
}
