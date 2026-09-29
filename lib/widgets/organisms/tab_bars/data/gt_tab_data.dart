import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// One tab in a [GtTabbar], [GtSelectionTabbar] or [GtTabbarView] — what the
/// tab is, plus how to draw it.
///
/// [value] is the tab's identity: it is what [GtTabbarView] looks its page up
/// by, what [GtSelectionTabbar] reports through `onChangeTab`, and what tells
/// two tabs apart. [label] and [icon] are presentation only — the design
/// system renders them and never reads meaning from them.
///
/// Equality is by [value] alone via [AppEquatable]. A surface that relabels
/// its tabs while they are on screen therefore keeps its selection across the
/// rebuild: a hub serving two account families can draw the same tab as `PAY`
/// on one and `SEND` on the other without the bar losing its selected pill.
/// Give [T] value semantics — a primitive, a record or an [AppEquatable] — as
/// a plain class without `==` falls back to identity, and two tabs naming the
/// same thing will then compare unequal.
class GtTabData<T> extends AppEquatable {
  /// The value identifying this tab.
  ///
  /// Must be unique within a tab list, since it is what the bar and the view
  /// match on. For [GtTabbarView] it doubles as the key into `tabViews` or
  /// `tabBuilders`, so every tab needs an entry under this value.
  final T value;

  /// The text rendered on the tab's pill.
  ///
  /// Shown verbatim, so it must arrive already localised; the pill upper-cases
  /// it for display. Changing it between rebuilds is safe — it takes no part
  /// in equality, so the selection survives.
  final String label;

  /// An optional icon rendered before [label], at size 16.
  ///
  /// Presentation only, like [label], and likewise outside equality.
  final IconData? icon;

  /// Creates a [GtTabData].
  const GtTabData({required this.value, required this.label, this.icon});

  @override
  List<Object?> get props => [value];
}

/// Holds the tab currently selected in a [GtTabbar] and its [GtTabbarView],
/// notifying listeners when it changes.
///
/// A [ChangeNotifier], and the single source of truth for the selection: the
/// bar and the view both read it and write taps and swipes back into it rather
/// than each holding an index of its own, which is what keeps the two in step.
/// Pass one controller to both widgets to pair them.
///
/// Leaving the selection `null` is allowed: the bar and the view each seed the
/// first tab when they mount against an empty controller, and the view
/// re-seeds whenever the selection matches none of the tabs it was given.
///
/// Listeners are notified when the selected tab changes and when the selected
/// tab is redrawn under a new [GtTabData.label] or [GtTabData.icon]. Writing
/// back the tab already held, unchanged, notifies nobody.
///
/// The controller does not refresh itself: a header reading [value] follows a
/// relabel only because [GtSelectionTabbar] writes the incoming tab back when
/// its tab list changes. A view driven without a bar gets no such write-back,
/// and [value] there keeps the label it was last set with.
///
/// Whoever constructs the controller disposes it; the widgets it is passed to
/// only listen.
class GtTabController<T> extends ChangeNotifier {
  late GtTabData<T>? _value;

  /// Creates a [GtTabController], optionally selecting [initialValue].
  ///
  /// [initialValue] need not be an instance from the tab list — tabs match by
  /// [GtTabData.value], so an equivalent tab selects the same pill.
  GtTabController({GtTabData<T>? initialValue}) {
    _value = initialValue;
  }

  /// The selected tab, or `null` before anything has been selected.
  GtTabData<T>? get value => _value;

  /// Selects [newValue], replacing whatever was held, and notifies listeners
  /// if anything about the selection changed.
  ///
  /// The stored instance is always replaced, so [value] reflects the tab as it
  /// was last written — a tab relabelled while it is on screen leaves the
  /// controller holding the new label rather than the one it was seeded with.
  ///
  /// Listeners are notified when a different tab is selected, and when the
  /// same tab arrives under a new [GtTabData.label] or [GtTabData.icon], since
  /// anything drawing from [value] needs to redraw. Writing the tab already
  /// held, unchanged, notifies nobody, which is what keeps taps and swipes
  /// that re-select the current tab from churning the tree.
  set value(GtTabData<T> newValue) {
    final current = _value;
    final isSameTab = current == newValue;
    final isSameLabel = current?.label == newValue.label;
    final isSameIcon = current?.icon == newValue.icon;
    final isUnchanged = isSameTab && isSameLabel && isSameIcon;

    _value = newValue;
    if (isUnchanged) return;
    notifyListeners();
  }

  /// Whether a tab is currently selected.
  bool get hasValue => _value != null;

  @override
  void dispose() {
    _value = null;
    super.dispose();
  }
}
