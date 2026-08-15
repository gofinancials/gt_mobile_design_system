/// Describes the accessibility role a widget exposes to assistive technologies
/// such as TalkBack and VoiceOver.
///
/// The role determines which semantic flags are attached to the underlying
/// [Semantics] node. Picking the correct role matters: a checkbox announced as
/// a plain button gives the user no way to know whether it is currently
/// checked, and a radio announced as a button loses its "1 of 3" position
/// within the group.
enum GtSemanticRole {
  /// No interactive role.
  ///
  /// Only the supplied label, hint, and value are exposed. Use this for
  /// non-interactive containers that still need an accessible name.
  none,

  /// The wrapped child already declares its own role and state.
  ///
  /// Contributes an accessible name and hint only. Use this when the child is a
  /// framework control that annotates itself — [CupertinoSwitch], for instance,
  /// publishes its own toggled *and* enabled state, but nothing gives it a
  /// name.
  ///
  /// Declaring a flag the child already sets makes the two configurations
  /// conflict, and Flutter then refuses to merge them, announcing one control
  /// as two separate nodes. Where a delegated child owns its enabled state,
  /// drive that state through the child's own API — passing a null callback,
  /// typically — rather than annotating around it.
  delegated,

  /// A control that performs an action when activated.
  button,

  /// A control that navigates elsewhere when activated.
  link,

  /// A control with an independent checked/unchecked state.
  ///
  /// Requires a checked state to be supplied.
  checkbox,

  /// A control that selects one option from a mutually exclusive group.
  ///
  /// Requires a checked state to be supplied.
  radio,

  /// A control with an on/off state, such as a switch.
  ///
  /// Requires a toggled state to be supplied.
  toggle,

  /// A control that selects one view from a set of sibling views.
  ///
  /// Requires a selected state to be supplied.
  tab,

  /// A control that expands or collapses associated content.
  ///
  /// Requires an expanded state to be supplied.
  disclosure,

  /// Meaningful graphical content.
  ///
  /// Only use this where the image carries information the surrounding text
  /// does not. Decorative imagery should be excluded from the semantics tree
  /// entirely rather than announced as an unlabelled "image".
  image,

  /// A structural heading.
  ///
  /// Screen readers offer heading-by-heading navigation as a primary way to
  /// skim a screen. Text that merely *looks* like a heading gives none of
  /// that: the user has to swipe through every element in order instead.
  ///
  /// Reserve this for structural headings — a screen title, a section title.
  /// Marking every large-looking label as a heading is as unhelpful as marking
  /// none of them, because the navigation then lands on things that are not
  /// landmarks.
  heading;

  /// Whether this role should publish an enabled/disabled state.
  ///
  /// Non-interactive roles must not, because a bare "enabled" announcement on
  /// static content is noise rather than information. [delegated] is excluded
  /// as well: its child owns that state, and annotating it twice would split
  /// the control into two nodes.
  bool get isInteractive {
    return switch (this) {
      .none || .delegated || .image || .heading => false,
      _ => true,
    };
  }

  /// Whether this role represents graphical content.
  bool get isImage => this == .image;

  /// Whether this role represents a structural heading.
  bool get isHeading => this == .heading;

  /// Whether this role carries a checked state.
  bool get hasCheckedState {
    return this == .checkbox || this == .radio;
  }

  /// Whether this role belongs to a mutually exclusive group.
  bool get isMutuallyExclusive => this == .radio;

  /// Whether this role carries a toggled state.
  bool get hasToggledState => this == .toggle;

  /// Whether this role carries a selected state.
  bool get hasSelectedState => this == .tab;

  /// Whether this role carries an expanded state.
  bool get hasExpandedState => this == .disclosure;

  /// Whether assistive technologies should treat this role as a button.
  ///
  /// Checkboxes, radios, toggles, and tabs deliberately do not report as
  /// buttons; their own flags describe them more precisely.
  bool get isSemanticButton {
    return this == .button || this == .disclosure;
  }
}
