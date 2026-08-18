# Tray: Next Steps

## Goal

Introduce a reusable tray component with fluid, interruptible motion while
preserving the existing responsibilities of `GtBottomSheet` and
`GtBottomModal`.

The tray should feel attached to its host surface rather than presented as a
separate route. It should support compact, expanded, and dismissed positions,
direct manipulation, accessible navigation, and reduced-motion preferences.

## Architectural constraints

- Build every reusable UI section as a widget class. Do not add helper
  functions that return widgets.
- Extend `GtStatelessWidget` or `GtStatefulWidget` for design-system widgets.
- Use design-system colors, spacing, radii, typography, shadows, and motion
  tokens.
- Keep presentation, motion state, and tray content separate.
- Reuse `GtInkWell`, `GtTapTarget`, `GtSemantics`, and existing modal primitives
  where their behavior matches the tray.
- Do not duplicate haptic feedback already provided by interaction primitives.
- Respect `MediaQuery.disableAnimations` throughout.

## 1. Audit and define the boundary

Review the existing implementation before introducing a new public API:

- `lib/widgets/templates/modals/gt_bottom_sheet.dart`
- `lib/widgets/templates/modals/gt_bottom_modal.dart`
- `lib/widgets/templates/modals/mixins/gt_modals_mixins.dart`
- `lib/widgets/organisms/app_bars/gt_modal_app_bar.dart`
- Existing draggable sheet consumers and Widgetbook use cases

Confirm that the tray is an in-page anchored surface and not another name for a
modal bottom sheet. Document which behavior remains owned by each component:

| Component | Responsibility |
| --- | --- |
| `GtBottomModal` | Blocking task, status, success, and failure flows |
| `GtBottomSheet` | Route-level modal content and long scrollable forms |
| `GtTray` | Host-attached, draggable supplementary content with snap states |

## 2. Finalize the public API

Start with the smallest API that supports the intended use cases:

```dart
GtTray(
  controller: controller,
  collapsedExtent: collapsedExtent,
  expandedExtent: expandedExtent,
  header: const TrayHeader(),
  child: const TrayContent(),
)
```

Proposed supporting types:

- `GtTrayController`
- `GtTrayState.collapsed`
- `GtTrayState.expanded`
- `GtTrayState.dismissed`, only when dismissal is enabled
- `GtTraySnapPoint`, if more than two positions are required
- `GtTrayBehavior` for dismissibility, initial state, and drag configuration

API decisions to settle before implementation:

- Whether the tray can be dismissed or only collapsed
- Whether arbitrary snap points are required in version one
- Whether content scroll and tray drag hand off automatically
- Whether a scrim is optional or part of the default expanded state
- Whether the controller reports normalized progress

## 3. Implement motion and gesture behavior

- Use one normalized animation value as the source of truth for translation,
  scrim opacity, elevation, and corner-radius changes.
- Use a design-system spring curve for settling after a drag.
- Keep programmatic open/close duration tokenized through `GtMotion`.
- Make drag movement follow the pointer without an easing curve.
- Select the destination using both drag distance and release velocity.
- Clamp animation input before passing it into Flutter curves.
- Allow an in-progress animation to be interrupted by a new drag.
- Avoid `AnimatedSwitcher` for the tray shell; the surface should transform in
  place rather than replace itself.

Recommended initial behavior:

- Slow upward drag past the midpoint expands the tray.
- Slow downward drag past the midpoint collapses it.
- A sufficiently fast fling wins regardless of the midpoint.
- Reduced motion jumps to the destination while preserving gesture behavior.

## 4. Coordinate scrolling

- Give the tray a dedicated scroll controller when its content can scroll.
- Drag the tray until expanded, then hand upward movement to the content.
- When content is at its top, hand downward movement back to the tray.
- Avoid nested gesture recognizers that compete for the same vertical drag.
- Verify behavior with short, long, and dynamically changing content.

## 5. Accessibility and platform behavior

- Expose expanded/collapsed state through semantics.
- Give the drag handle an accessible action and label; do not require dragging
  as the only way to operate the tray.
- Move focus into the tray when it becomes modal-like and restore focus when it
  collapses or dismisses.
- Define Android back-button and Escape-key behavior.
- Prevent hidden tray content from remaining focusable or discoverable.
- Respect text scaling, safe areas, keyboard insets, and orientation changes.
- Ensure interactive controls retain a minimum 44dp tap target.

## 6. Visual treatment

- Use palette-derived surface and scrim colors.
- Use existing radius and shadow tokens for collapsed and expanded states.
- Animate radius, elevation, and scrim from the same progress value.
- Keep the drag handle optional and tokenized.
- Avoid backdrop filters in the moving foreground surface. If background blur
  is required, isolate it with `ImageFiltered` and a repaint boundary.

## 7. Widgetbook coverage

Add a dedicated tray use case with controls for:

- Initial state
- Dismissible versus non-dismissible behavior
- Compact and expanded extents
- Short versus scrollable content
- Scrim visibility
- Keyboard visibility
- Light and dark themes
- Reduced motion
- Programmatic expand, collapse, and dismiss actions

Use reusable preview widget classes rather than widget-returning helper
functions for the use-case body.

## 8. Test coverage

Add focused widget tests for:

- Initial collapsed and expanded positions
- Programmatic state changes
- Slow drags across and below the threshold
- High-velocity flings in both directions
- Interrupted settle animations
- Scroll-to-drag handoff
- Scrim opacity and hit testing
- Outside-tap, back-button, and Escape dismissal
- Focus restoration and semantics state
- Keyboard and safe-area layout
- Reduced-motion behavior
- Controller disposal and unmounting during animation

Add golden tests only after the interaction and layout API stabilizes.

## 9. Rollout sequence

1. Land the controller, state model, and non-scrollable tray shell.
2. Add gesture settling and reduced-motion handling.
3. Add scrolling coordination.
4. Add accessibility and keyboard behavior.
5. Add Widgetbook coverage and documentation.
6. Migrate one low-risk consumer as a real-world validation.
7. Review motion on a physical iOS and Android device before broader adoption.

## Acceptance criteria

- Dragging tracks the pointer without visible lag.
- Settling has no jump, overshoot assertion, or dropped layout frame.
- Foreground content remains sharp throughout the transition.
- Content height changes do not cause a post-animation drop.
- Scroll and tray gestures hand off predictably.
- The tray is fully operable without a drag gesture.
- Reduced-motion mode removes nonessential animation.
- Static analysis and the complete test suite pass.
- The component is documented and usable from Widgetbook.
