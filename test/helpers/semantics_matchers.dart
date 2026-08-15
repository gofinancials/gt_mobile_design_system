import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helpers for asserting what a widget actually announces to a screen reader.
///
/// Writing these assertions by hand means enabling the semantics handle,
/// walking the semantics tree, and comparing flag bitfields — verbose enough
/// that the tests tend not to get written. These wrappers keep a semantics
/// assertion to roughly one line.
///
/// Every helper needs semantics to be switched on for the test. Use
/// [withSemantics] to scope that:
///
/// ```dart
/// testWidgets('announces as a checkbox', (tester) async {
///   await withSemantics(tester, () async {
///     await tester.pumpWidget(...);
///     expectSemantics(
///       tester,
///       find.byType(GtCheckBox),
///       role: SemanticsRole.checkBox,
///       isChecked: true,
///     );
///   });
/// });
/// ```
Future<void> withSemantics(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  final handle = tester.ensureSemantics();
  try {
    await body();
  } finally {
    handle.dispose();
  }
}

/// Returns the semantics node belonging to the widget found by [finder].
///
/// [WidgetTester.getSemantics] walks *up* from the finder looking for a node,
/// which is wrong for design-system widgets: their outermost render object is
/// usually a [RepaintBoundary] or similar that owns no node, so the search
/// escapes the widget entirely and returns the enclosing route. This searches
/// the widget's own render subtree first and only falls back to the enclosing
/// node when the subtree owns none.
///
/// When a subtree owns several independent nodes — a card containing two
/// buttons, say — the first in paint order is returned. Target the specific
/// control instead of the container in that case.
SemanticsNode semanticsNodeOf(WidgetTester tester, Finder finder) {
  final root = finder.evaluate().single.findRenderObject();
  final owned = root == null ? null : _ownedSemanticsOf(root);
  return owned ?? tester.getSemantics(finder);
}

/// Returns the merged [SemanticsData] for the widget found by [finder].
///
/// Merged data is what the user actually hears: a control's own flags combined
/// with the labels of its merged descendants.
SemanticsData semanticsDataOf(WidgetTester tester, Finder finder) {
  return semanticsNodeOf(tester, finder).getSemanticsData();
}

SemanticsNode? _ownedSemanticsOf(RenderObject node) {
  final own = node.debugSemantics;
  if (own != null && !own.isMergedIntoParent) return own;

  SemanticsNode? found;
  node.visitChildren((child) {
    found ??= _ownedSemanticsOf(child);
  });
  return found;
}

/// Asserts the semantics of the node enclosing [finder].
///
/// Only the supplied expectations are checked, so a test can assert the one
/// property it cares about without restating the whole node. [label] and
/// [hint] accept either a [String] or a [Matcher].
void expectSemantics(
  WidgetTester tester,
  Finder finder, {
  Object? label,
  Object? hint,
  Object? value,
  bool? isButton,
  bool? isLink,
  bool? isChecked,
  bool? isToggled,
  bool? isSelected,
  bool? isEnabled,
  bool? isInMutuallyExclusiveGroup,
  bool? isLiveRegion,
  bool? isTextField,
  bool? hasTapAction,
}) {
  final data = semanticsDataOf(tester, finder);

  if (label != null) {
    expect(data.label, wrapMatcher(label), reason: 'semantic label');
  }
  if (hint != null) {
    expect(data.hint, wrapMatcher(hint), reason: 'semantic hint');
  }
  if (value != null) {
    expect(data.value, wrapMatcher(value), reason: 'semantic value');
  }
  if (isButton != null) {
    expect(
      data.flagsCollection.isButton,
      isButton,
      reason: 'should ${isButton ? '' : 'not '}announce as a button',
    );
  }
  if (isLink != null) {
    expect(
      data.flagsCollection.isLink,
      isLink,
      reason: 'should ${isLink ? '' : 'not '}announce as a link',
    );
  }
  if (isChecked != null) {
    final state = data.flagsCollection.isChecked;
    expect(
      state,
      isNot(CheckedState.none),
      reason: 'should expose a checked state at all',
    );
    expect(
      state,
      isChecked ? CheckedState.isTrue : CheckedState.isFalse,
      reason: 'should be ${isChecked ? 'checked' : 'unchecked'}',
    );
  }
  if (isToggled != null) {
    final state = data.flagsCollection.isToggled;
    expect(
      state,
      isNot(Tristate.none),
      reason: 'should expose a toggled state at all',
    );
    expect(
      state.toBoolOrNull(),
      isToggled,
      reason: 'should be toggled ${isToggled ? 'on' : 'off'}',
    );
  }
  if (isSelected != null) {
    expect(
      data.flagsCollection.isSelected.toBoolOrNull(),
      isSelected,
      reason: 'should be ${isSelected ? 'selected' : 'unselected'}',
    );
  }
  if (isEnabled != null) {
    final state = data.flagsCollection.isEnabled;
    expect(
      state,
      isNot(Tristate.none),
      reason: 'should expose an enabled state at all',
    );
    expect(
      state.toBoolOrNull(),
      isEnabled,
      reason: 'should be ${isEnabled ? 'enabled' : 'disabled'}',
    );
  }
  if (isInMutuallyExclusiveGroup != null) {
    expect(
      data.flagsCollection.isInMutuallyExclusiveGroup,
      isInMutuallyExclusiveGroup,
      reason: 'mutually exclusive group membership',
    );
  }
  if (isLiveRegion != null) {
    expect(
      data.flagsCollection.isLiveRegion,
      isLiveRegion,
      reason: 'should ${isLiveRegion ? '' : 'not '}be a live region',
    );
  }
  if (isTextField != null) {
    expect(
      data.flagsCollection.isTextField,
      isTextField,
      reason: 'should ${isTextField ? '' : 'not '}announce as a text field',
    );
  }
  if (hasTapAction != null) {
    expect(
      data.hasAction(SemanticsAction.tap),
      hasTapAction,
      reason: 'should ${hasTapAction ? '' : 'not '}expose a tap action',
    );
  }
}

/// Asserts that the widget found by [finder] has a non-empty accessible name.
///
/// An unlabelled control is the single most common accessibility defect: it is
/// reachable, focusable, and activatable, but announced as nothing at all.
void expectHasAccessibleName(WidgetTester tester, Finder finder) {
  final data = semanticsDataOf(tester, finder);
  final name = data.label.trim().isNotEmpty ? data.label : data.tooltip.trim();

  expect(
    name,
    isNotEmpty,
    reason: 'control has no accessible name; screen readers announce nothing',
  );
}

/// Asserts that the widget found by [finder] contributes no semantics of its
/// own.
///
/// Use for decoration — background art, an icon duplicating an adjacent text
/// label — which should not add nodes for the user to swipe past.
void expectNoSemantics(WidgetTester tester, Finder finder) {
  final root = finder.evaluate().single.findRenderObject();
  final owned = root == null ? null : _ownedSemanticsOf(root);

  expect(
    owned,
    isNull,
    reason:
        'expected decorative content, but this widget contributes a semantics '
        'node the user has to swipe past: ${owned?.getSemanticsData()}',
  );
}

/// Asserts that the widget found by [finder] responds to touch across at least
/// [minSize] logical pixels in each dimension.
///
/// Pass the finder for the *interactive* widget. The check is a real hit test
/// at the edges of the expected region, so it also covers hit slop added by
/// `GtTapTarget`, which deliberately does not change the widget's own size.
void expectMinimumTapTarget(
  WidgetTester tester,
  Finder finder, {
  Size minSize = const Size(44, 44),
}) {
  final center = tester.getCenter(finder);
  final dx = minSize.width / 2 - 1;
  final dy = minSize.height / 2 - 1;

  final probes = <String, Offset>{
    'left edge': center + Offset(-dx, 0),
    'right edge': center + Offset(dx, 0),
    'top edge': center + Offset(0, -dy),
    'bottom edge': center + Offset(0, dy),
  };

  // Match against the whole subtree rather than the single render object the
  // finder resolves to. Hit slop is implemented by forwarding the touch to a
  // descendant, and a widget that renders through children may not contribute
  // a render object of its own to the hit path at all.
  final subtree = _renderSubtreeOf(tester.renderObject(finder));

  for (final probe in probes.entries) {
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(
      result,
      probe.value,
      tester.view.viewId,
    );

    final hit = result.path.any((entry) => subtree.contains(entry.target));
    expect(
      hit,
      isTrue,
      reason:
          'tap target is smaller than ${minSize.width}x${minSize.height}: '
          'a touch at its ${probe.key} does not reach the control',
    );
  }
}

Set<RenderObject> _renderSubtreeOf(RenderObject root) {
  final nodes = <RenderObject>{root};

  void visit(RenderObject node) {
    node.visitChildren((child) {
      if (!nodes.add(child)) return;
      visit(child);
    });
  }

  visit(root);
  return nodes;
}
