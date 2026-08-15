import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Applies design-system accessibility semantics to [child].
///
/// This is the single place where a [GtSemanticRole] is translated into
/// Flutter's [Semantics] flags, so every Go Tech control describes itself to
/// TalkBack and VoiceOver the same way. Prefer this over hand-rolling
/// [Semantics] inside individual widgets.
///
/// ```dart
/// GtSemantics(
///   role: GtSemanticRole.checkbox,
///   label: 'Remember me',
///   isChecked: isActive,
///   enabled: !disabled,
///   child: someBox,
/// )
/// ```
class GtSemantics extends StatelessWidget {
  /// The accessibility role exposed to assistive technologies.
  final GtSemanticRole role;

  /// The accessible name of the control.
  final String? label;

  /// A description of what happens when the control is activated.
  final String? hint;

  /// The current value of the control, spoken after the label.
  final String? value;

  /// Whether the control is checked.
  ///
  /// Only applied when [role] carries a checked state.
  final bool? isChecked;

  /// Whether the control is toggled on.
  ///
  /// Only applied when [role] carries a toggled state.
  final bool? isToggled;

  /// Whether the control is selected.
  ///
  /// Only applied when [role] carries a selected state.
  final bool? isSelected;

  /// Whether the control is expanded.
  ///
  /// Only applied when [role] carries an expanded state.
  final bool? isExpanded;

  /// Where this heading sits in the screen's structure, from 1 to 6.
  ///
  /// Level 1 is the screen's own title, level 2 a section within it, and so on.
  /// Supplying a level marks the node as a heading, so [role] does not also
  /// need to be [GtSemanticRole.heading].
  ///
  /// Levels let a screen reader user move through structure rather than
  /// content. Keep them ordered and do not skip levels for visual reasons.
  final int? headingLevel;

  /// Whether the control can currently be operated.
  ///
  /// Only applied when [role] is interactive. Disabled controls remain visible
  /// to assistive technologies but are announced as unavailable, which is why
  /// this is preferred over removing them from the semantics tree entirely.
  final bool enabled;

  /// Whether to drop the semantics of everything below this node.
  ///
  /// Useful when the descendants are decorative or when their labels would
  /// duplicate [label].
  final bool excludeDescendants;

  /// Whether changes to this subtree should be announced as they happen.
  final bool isLiveRegion;

  /// Whether this node introduces its own semantics boundary.
  final bool container;

  /// Whether descendant nodes should be merged into this one.
  ///
  /// Use this when the child owns a node that will not fold into this
  /// annotation by itself — a focusable framework control, typically. Without
  /// it the user meets the name and the control as two separate stops.
  ///
  /// Prefer [excludeDescendants] when the descendants are decoration; merging
  /// keeps their information, excluding discards it.
  final bool mergeDescendants;

  /// Called when an assistive technology activates this control.
  final VoidCallback? onTap;

  /// The widget to annotate.
  final Widget child;

  /// Creates a [GtSemantics] annotation.
  const GtSemantics({
    required this.child,
    this.role = .none,
    this.label,
    this.hint,
    this.value,
    this.isChecked,
    this.isToggled,
    this.isSelected,
    this.isExpanded,
    this.headingLevel,
    this.enabled = true,
    this.excludeDescendants = false,
    this.isLiveRegion = false,
    this.container = false,
    this.mergeDescendants = false,
    this.onTap,
    super.key,
  });

  /// Whether this annotation would contribute anything at all.
  ///
  /// When nothing is set, callers can skip wrapping entirely rather than
  /// inserting an empty node into the semantics tree.
  bool _isEmpty({required bool effectiveEnabled}) {
    return role == .none &&
        label == null &&
        hint == null &&
        value == null &&
        headingLevel == null &&
        effectiveEnabled &&
        !excludeDescendants &&
        !mergeDescendants &&
        !isLiveRegion &&
        !container &&
        onTap == null;
  }

  /// Whether this node should be announced as a structural heading.
  ///
  /// Supplying a level is enough on its own; the role does not have to be set
  /// as well.
  bool get _isHeading => role.isHeading || headingLevel != null;

  @override
  Widget build(BuildContext context) {
    // An enclosing GtDisabledScope wins over a locally enabled control: the
    // subtree really is inert, whatever this widget was told.
    final effectiveEnabled = enabled && !GtDisabledScope.of(context);

    if (_isEmpty(effectiveEnabled: effectiveEnabled)) return child;

    final annotated = Semantics(
      container: container,
      label: label,
      hint: hint,
      value: value,
      button: role.isSemanticButton ? true : null,
      image: role.isImage ? true : null,
      link: role == .link ? true : null,
      checked: role.hasCheckedState ? (isChecked ?? false) : null,
      toggled: role.hasToggledState ? (isToggled ?? false) : null,
      selected: role.hasSelectedState ? (isSelected ?? false) : null,
      expanded: role.hasExpandedState ? isExpanded : null,
      inMutuallyExclusiveGroup: role.isMutuallyExclusive ? true : null,
      header: _isHeading ? true : null,
      headingLevel: headingLevel,
      enabled: role.isInteractive ? effectiveEnabled : null,
      liveRegion: isLiveRegion ? true : null,
      excludeSemantics: excludeDescendants,
      onTap: effectiveEnabled ? onTap : null,
      child: child,
    );

    if (!mergeDescendants) return annotated;

    return MergeSemantics(child: annotated);
  }
}
