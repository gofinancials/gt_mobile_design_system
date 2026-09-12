import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A swipeable balance carousel: one [GtBalanceText] per account, with the
/// selected account's details beneath it.
///
/// From top to bottom it draws [GtScaledDots] — only once there is more than
/// one account — then a fixed 76dp [PageView] of balances, the selected
/// account's [GtAccountData.subTitle] when it has one, a [GtAccountCopyPill]
/// captioned with the account's type and number, and finally [actions],
/// separated from the rest by the section spacing.
///
/// The widget holds no state. [controller] owns the account list, the
/// selection and the [PageController], so a swipe and a programmatic
/// selection move the same state, and the slides rebuild whenever it
/// notifies. Masking is controlled the same way: [hidden] masks every balance
/// at once, and the caller flips it from [onToggleHide].
///
/// The pill is tuned to read as a flat caption rather than a badge — primary
/// tinted, with no icon, shadow or border — and each of those choices can be
/// undone through the `accountPill*` fields. Whatever the caption shows,
/// tapping the pill copies the bare [GtAccountData.accountNumber].
///
/// With an empty [controller] only the empty 76dp row and [actions] render;
/// the subtitle and the pill need a selected account.
///
/// @category Organisms
class GtAccountDetailSlides<T> extends GtStatelessWidget {
  /// The accounts to page through and which one is selected.
  ///
  /// The slides listen to it, render from it and write swipes back into
  /// [GtAccountDataController.activeIndex], but never dispose it — the [State]
  /// that builds it does. Its [GtAccountDataController.pageController] can
  /// attach to only one [PageView] at a time, so give each mounted slides
  /// widget its own controller.
  final GtAccountDataController<T> controller;

  /// Called when the page in view changes, with the new index and the
  /// selected account's [GtAccountData.data].
  ///
  /// Driven by [PageView.onPageChanged], so it fires as soon as a page is more
  /// than halfway into view rather than when the swipe settles, and again if
  /// the swipe is dragged back. It is not swipe-only either: setting
  /// [GtAccountDataController.activeIndex] animates the page view and fires
  /// this once for every page crossed. Each call is deferred to a post-frame
  /// callback, so it is safe to call `setState` or navigate from it.
  ///
  /// Neither the page view nor the dots announce the new position, so this is
  /// also where to announce which account came into view.
  final OnChanged2<int, T?>? onIndexUpdate;

  /// An optional action bar drawn below the account details.
  ///
  /// It is handed to the [ListenableBuilder] as its `child`, so it is not
  /// rebuilt when the selection changes. Read
  /// [GtAccountDataController.selectedAccount] inside the buttons' callbacks
  /// rather than capturing an account when building them.
  final GtActionButtonBar? actions;

  /// Whether every balance is masked.
  ///
  /// One flag for the whole carousel: each [GtBalanceText] swaps its digits
  /// for a fixed run of asterisks, so paging to another account never reveals
  /// it. This is a controlled property — the slides never flip it on their
  /// own, so update it from [onToggleHide].
  final bool hidden;

  /// Called when any balance line is tapped.
  ///
  /// The whole line is the tap target, not just the eye icon. Flip [hidden] in
  /// response.
  final OnPressed onToggleHide;

  /// Padding around each balance inside its slide.
  ///
  /// Defaults to 17dp on either side. Each [GtBalanceText] scales itself down
  /// to fit the width that remains, so widening this shrinks long balances
  /// rather than wrapping them.
  final EdgeInsetsGeometry? balancePadding;

  /// Overrides the style of the selected account's [GtAccountData.subTitle].
  ///
  /// Defaults to [GtTextStyles.subHeadXs]. The line is centred, capped at one
  /// line, and left out entirely for accounts without a subtitle.
  final TextStyle? subtitleStyle;

  /// Builds the caption shown on the account pill for the selected account.
  ///
  /// Defaults to the account's type and number joined by
  /// [AppStrings.dotSeparator] and uppercased — `SAVINGS • 0123456789`. What a
  /// builder returns is rendered verbatim instead, so it carries its own
  /// casing. Only the caption changes; tapping the pill always copies the bare
  /// [GtAccountData.accountNumber], never what this returns.
  final String Function(GtAccountData<T> account)? accountPillLabelBuilder;

  /// The product variant handed to the account pill.
  ///
  /// Defaults to [GtAccountCopyPillVariant.personal]. The slides always give
  /// the pill a text and a background colour of their own, so the variant's
  /// colours never show — it decides only which side the copy icon sits on and
  /// the tint of the pill's elevation, should [showAccountPillIcon] or
  /// [showAccountPillShadow] be turned on. Set it to the product the surface
  /// belongs to.
  final GtAccountCopyPillVariant accountPillVariant;

  /// Overrides the account pill's text and copy-icon colour.
  ///
  /// Defaults to the theme's primary colour: [GtPalette.primary]'s darker
  /// shade in light mode and its base shade in dark mode. The resolved colour
  /// is also folded into the default [accountPillStyle].
  final Color? accountPillTextColor;

  /// Overrides the account pill's background colour.
  ///
  /// Defaults to [GtPalette.primary]'s 10% alpha tint, not the
  /// [accountPillVariant]'s own tint, which the slides always replace.
  final Color? accountPillBackgroundColor;

  /// Overrides the account pill's border colour.
  ///
  /// `null` leaves the border matching the background, so it stays invisible.
  /// Pair it with [accountPillBorderStyle] to draw an outline.
  final Color? accountPillBorderColor;

  /// Replaces the account pill's text style outright.
  ///
  /// Defaults to [GtTextStyles.subHeadXs] at a 12px line height, tinted with
  /// the resolved [accountPillTextColor]. Because [GtAccountCopyPill.style]
  /// replaces rather than merges, a style passed here must carry its own
  /// colour — [accountPillTextColor] then reaches only the copy icon.
  final TextStyle? accountPillStyle;

  /// Whether the account pill draws its copy icon.
  ///
  /// Defaults to `false` — the pill reads as a caption under the balance, so
  /// the icon is suppressed. Turn it on where the copy affordance needs to be
  /// visible; the icon takes the resolved [accountPillTextColor] and sits on
  /// the side [accountPillVariant] picks.
  final bool showAccountPillIcon;

  /// Whether the account pill draws its product-tinted elevation.
  ///
  /// Defaults to `false` — the caption sits directly on the surface behind the
  /// balance, where the pill's own elevation would read as a stray card. The
  /// tint comes from [accountPillVariant]. [GtAccountCopyPill] itself defaults
  /// this to `true`.
  final bool showAccountPillShadow;

  /// The account pill's border line style.
  ///
  /// Defaults to [BorderStyle.none] so the caption reads flat. Only visible
  /// once [accountPillBorderColor] differs from the background.
  final BorderStyle accountPillBorderStyle;

  /// Accessibility guidance announced with the account pill.
  ///
  /// The slides pass the pill no semantics label, so it announces its caption
  /// — the default composite, or whatever [accountPillLabelBuilder] returns. A
  /// caption of the bare number announces a run of digits, so use this to say
  /// what the pill is and that tapping copies it.
  final String? accountPillSemanticHint;

  /// Creates a [GtAccountDetailSlides].
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
    this.subtitleStyle,
    super.key,
  });

  /// The account pill's caption for [data]: what [accountPillLabelBuilder]
  /// returns when one is supplied, otherwise the uppercased type and number.
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
    final pillColor = context.palette.primary.alpha10;
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
                  Padding(
                    padding: context.insets.symmetricDp(vertical: 8.px),
                    child: GtSizedBox(
                      height: 48,
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
                  ),
                  if (account?.subTitle case String subTitle) ...[
                    GtText(
                      subTitle,
                      textAlign: .center,
                      maxLines: 1,
                      style: subtitleStyle ?? context.textStyles.subHeadXs(),
                    ),
                    const GtGap.yLg(),
                  ],
                  if (account case GtAccountData<T> data?)
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
