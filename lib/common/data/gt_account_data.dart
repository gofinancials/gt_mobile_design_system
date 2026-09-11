import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// One account in an account switcher or balance carousel — the shape
/// [GtAccountDetailSlides] renders a slide from.
///
/// Carries only what the design system needs to draw the account: an
/// identifier, its [type], the masked-or-full [accountNumber], and the
/// [balance] to display. Anything the host app needs to act on the selection —
/// a domain model, a route argument, an API handle — rides along in [data],
/// which is why the class is generic. Nothing here is fetched or refreshed;
/// the caller owns the values and rebuilds with new ones.
///
/// Equality is by value via [AppEquatable], so two instances describing the
/// same account compare equal and list diffing behaves. That holds only as far
/// as [T] does — see [data].
class GtAccountData<T> extends AppEquatable {
  /// Stable identifier for the account.
  ///
  /// Used to tell accounts apart across rebuilds; it is never displayed. Must
  /// be unique within the list held by a [GtAccountDataController].
  final String id;

  /// The kind of account, as display copy — "Savings", "Current".
  ///
  /// A free-form string: the design system neither validates it nor varies
  /// styling from it, so it is shown verbatim and must arrive already
  /// localised and cased for display.
  final String type;

  /// The account number as it should appear.
  ///
  /// Rendered verbatim, so mask it before constructing this if the surface
  /// calls for a partial number — nothing downstream truncates it.
  final String accountNumber;

  /// The account's balance, unformatted.
  ///
  /// Pass the raw number; the widgets that display it handle grouping and
  /// decimals. Hiding a balance is a presentation concern held by the widget,
  /// not a property of the account.
  final num balance;

  /// An optional subtitle
  /// 
  /// Useful slot for additional balances (e.g Overdraft Balance: $2000)
  final String? subTitle;

  /// The currency to display the [balance] in.
  ///
  /// When `null`, the rendering widget falls back to its own default, which is
  /// the Naira glyph (`₦`). Supply the **symbol** rather than an ISO code —
  /// this is passed to text widgets as the glyph to draw, not resolved through
  /// a currency table.
  final String? currency;

  /// The caller's own payload for this account, passed back untouched.
  ///
  /// The design system never reads it; it exists so a selection callback can
  /// hand the host app something it can act on without a lookup by [id].
  ///
  /// It participates in equality, so give [T] value semantics — a record, an
  /// [AppEquatable], or a primitive. A plain class without `==` falls back to
  /// identity, and two otherwise-identical accounts will then compare unequal.
  final T data;

  /// Creates a [GtAccountData].
  const GtAccountData({
    required this.id,
    required this.type,
    required this.accountNumber,
    required this.balance,
    required this.data,
    this.subTitle,
    this.currency,
  });

  @override
  List<Object?> get props => [id, type, accountNumber, balance, data, currency];
}

/// Holds a list of [GtAccountData] and which one is currently selected,
/// notifying listeners when either changes.
///
/// A [ChangeNotifier], so drive a switcher with a [ListenableBuilder] (or
/// `AnimatedBuilder`) and read [selectedAccount] inside the builder. The
/// controller is the single source of truth for the selection; widgets report
/// taps back into it rather than holding an index of their own.
///
/// [activeIndex] is clamped as it is written, so it is always a valid index
/// into a non-empty list and reads back exactly what was written. The list may
/// be empty — at construction or once [removeAccount] takes the last entry — in
/// which case [selectedAccount] is `null`, [count] is `0` and [activeIndex]
/// reads `0`. Guard on `selectedAccount != null` rather than assuming an
/// account exists.
///
/// The controller owns its [pageController] and disposes it in [dispose], so
/// whoever builds the controller must dispose it in turn.
class GtAccountDataController<T> extends ChangeNotifier {
  /// Clamps [index] into `0..length - 1`, collapsing to `0` for an empty list.
  ///
  /// `num.clamp` throws when handed an upper bound below its lower bound, which
  /// `length - 1` becomes at zero length; this is the guard against that.
  static int _clampIndex(int index, int length) =>
      length == 0 ? 0 : index.clamp(0, length - 1);

  List<GtAccountData<T>> _accounts;

  int _activeIndex;

  /// Drives the [PageView] that renders the accounts, kept here so the page
  /// position and [activeIndex] cannot drift apart.
  ///
  /// Created with the constructor's `activeIndex` as its initial page, owned by
  /// this controller and disposed in [dispose].
  ///
  /// *Note: a [PageController] may only be attached to one [PageView] at a
  /// time, which ties this controller's lifetime to a single paged view. Two
  /// slide widgets sharing one controller — or an old one still mounted during
  /// a route transition — will trip Flutter's attach assertion.*
  final PageController pageController;

  /// Creates a [GtAccountDataController] over [accounts], selecting
  /// [activeIndex] (the first account by default).
  ///
  /// [accounts] is copied, so later changes to the list passed in do not reach
  /// the controller. [activeIndex] is clamped into range, so a value past the
  /// end selects the last account rather than failing later.
  GtAccountDataController({
    required List<GtAccountData<T>> accounts,
    int activeIndex = 0,
  }) : _accounts = List.of(accounts),
       _activeIndex = _clampIndex(activeIndex, accounts.length),
       pageController = PageController(
         initialPage: _clampIndex(activeIndex, accounts.length),
       );

  /// The accounts being switched between, in display order.
  ///
  /// An unmodifiable view: mutating it throws, and the only ways to change the
  /// list are [addAccount], [addAccounts] and [removeAccount], each of which
  /// notifies listeners.
  List<GtAccountData<T>> get accounts => UnmodifiableListView(_accounts);

  /// Index into [accounts] of the current selection.
  ///
  /// Always a valid index while [accounts] is non-empty, and `0` while it is
  /// empty. Because writes are clamped, this reads back exactly what was
  /// written, adjusted only if the list has since shrunk past it.
  int get activeIndex => _clampIndex(_activeIndex, count);

  /// Selects the account at [index], moving the page view to match, and
  /// notifies listeners.
  ///
  /// [index] is clamped into range, so values past either end select the first
  /// or last account. Setting the index that is already selected does nothing —
  /// no page animation and no notification.
  set activeIndex(int index) {
    final next = _clampIndex(index, count);
    if (next == _activeIndex) return;
    _activeIndex = next;
    _syncPage(animate: true);
    notifyListeners();
  }

  /// Brings the [pageController] to [_activeIndex].
  ///
  /// A no-op while the controller has no attached [PageView], or while it is
  /// already on that page — which is what keeps a swipe from animating back
  /// over itself when the [PageView] reports the page it just settled on.
  void _syncPage({required bool animate}) {
    final controller = pageController;
    if (!controller.hasClients) return;
    if (!controller.position.hasContentDimensions) return;
    if (controller.page?.round() == _activeIndex) return;

    if (animate) {
      controller.animateToPage(
        _activeIndex,
        duration: GtMotion.normal,
        curve: Curves.easeInOut,
      );
    } else {
      controller.jumpToPage(_activeIndex);
    }
  }

  /// Appends [data] to the end of [accounts] and notifies listeners.
  ///
  /// The selection is untouched: appending never displaces an existing entry.
  /// Passing an empty list does nothing and does not notify.
  void addAccounts(List<GtAccountData<T>> data) {
    if (data.isEmpty) return;
    _accounts = [..._accounts, ...data];
    notifyListeners();
  }

  /// Appends a single account to the end of [accounts] and notifies listeners.
  ///
  /// The single-entry form of [addAccounts].
  void addAccount(GtAccountData<T> data) => addAccounts([data]);

  /// Removes the account whose [GtAccountData.id] matches [data]'s and notifies
  /// listeners.
  ///
  /// Matched on `id` alone, so a copy carrying a stale balance still removes the
  /// right entry. Does nothing — and does not notify — when no account matches.
  ///
  /// The selection follows the account it was on: removing an entry ahead of it
  /// keeps the same account selected rather than letting the list shift beneath
  /// the index. Removing the selected account itself selects whichever entry
  /// takes its place, or the new last entry if it was at the end. Removing the
  /// final account leaves the controller empty, after which [selectedAccount]
  /// is `null`.
  void removeAccount(GtAccountData<T> data) {
    final next = [..._accounts]..removeWhere((item) => item.id == data.id);
    if (next.length == _accounts.length) return;

    final selected = selectedAccount;
    _accounts = next;

    final restored = selected == null
        ? _activeIndex
        : next.indexWhere((item) => item.id == selected.id);
    _activeIndex = _clampIndex(restored < 0 ? _activeIndex : restored, count);

    _syncPage(animate: false);
    notifyListeners();
  }

  /// The currently selected account, or `null` while [accounts] is empty.
  ///
  /// Never throws: the empty case returns `null`, and [activeIndex] is always
  /// in range otherwise.
  GtAccountData<T>? get selectedAccount {
    if (_accounts.isEmpty) return null;
    return _accounts[activeIndex];
  }

  /// How many accounts are being switched between.
  ///
  /// May be `0`. Useful for a page indicator.
  int get count => _accounts.length;

  /// Releases the [pageController] and tears down the notifier.
  ///
  /// This controller owns its [pageController], so the object that created the
  /// controller must call this — typically from the `dispose` of the [State]
  /// that built it. Skipping it leaks the page controller's scroll position and
  /// leaves listeners attached.
  ///
  /// Using the controller after this throws; a [ChangeNotifier] rejects both
  /// listener registration and [notifyListeners] once disposed, so any setter
  /// or mutator here will fail too.
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
