# Gallery Widget Catalogue — Overhaul Plan

## Executive Summary

**Current state**: 60 use cases covering ~57 unique widgets out of 219 widget classes in `gt_mobile_ui` (26% coverage). The gallery uses a verbose page template, has no search, no code snippets, and zero `description` fields on `@widgetbook.UseCase` annotations. The colour palette page is a monolithic scroll of 20 identical grid sections. 16 exported files in the barrel are empty stubs.

**Goal**: 100% coverage of all public-facing widget classes with a simplified showcase template, rich documentation, code-snippet toggling, search, combined "recipe" use cases, and a revamped colour palette.

| Metric | Current | Target |
|--------|---------|--------|
| Widget coverage | 57 / 219 (26%) | All public-facing (~185) |
| Use cases | 60 | ~220 (individual + recipes) |
| Code snippets | 0 | All annotated use cases |
| Text descriptions | 0 | All annotated use cases |
| Search | None | `SearchAddon` enabled |
| Page template | Verbose `CustomScrollView` | Minimal `GtGalleryShowcase` wrapper |
| Colour palette | 20 repeated grid sections | Interactive theme-switchable table |

---

## Phase 1 — Infrastructure & Templates *(3 hours)*

### 1.1 New Gallery Showcase Template

Replace the current verbose `Scaffold → Padding → CustomScrollView → SliverToBoxAdapter` pattern with a clean, reusable wrapper.

**Create** `gallery/lib/widgets/gt_gallery_showcase.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtGalleryShowcase extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;
  final List<Widget>? knobs;
  final bool centerChild;
  final EdgeInsets? padding;

  const GtGalleryShowcase({
    required this.title,
    this.description,
    required this.child,
    this.knobs,
    this.centerChild = true,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: padding ?? context.insets.allDp(24.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: context.textStyles.d2()),
              if (description.hasValue) ...[
                const GtGap.ySm(),
                Text(
                  description!,
                  style: context.textStyles.bodyM(
                    color: context.palette.text.sub,
                  ),
                ),
              ],
              if (knobs != null && knobs!.isNotEmpty) ...[
                const GtGap.yMd(),
                Wrap(spacing: 12, runSpacing: 8, children: knobs!),
              ],
              const GtGap.yLg(),
              const GtDivider.none(),
              const GtGap.yLg(),
              Expanded(
                child: centerChild
                    ? Center(child: SingleChildScrollView(child: child))
                    : SingleChildScrollView(child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Impact**: Every new use case drops from ~20 lines of layout boilerplate to ~6. Existing complex use cases like buttons/cards can keep their custom layout where needed. The template provides consistency for 80%+ of use cases.

### 1.2 Search Addon

**Edit** `gallery/lib/main.dart`:

```dart
addons: [
  SearchAddon(),                          // ← ADD
  ViewportAddon(Viewports.all),
  GtThemeAddon(themes: kAllThemes, themeNotifier: themeNotifier),
  InspectorAddon(),
  TextScaleAddon(max: 1.5),
  ZoomAddon(),
],
```

**Impact**: Instant text search across all use cases and folder names via `Cmd+K`.

### 1.3 Fix File Naming Issues

- Rename `gallery/lib/atoms/indicators/gt_indicators.dart.dart` → `gt_indicators.dart`
- Update all imports referencing the file

### 1.4 Align Initial Route to Getting Started

Create `gallery/lib/guides/getting_started.dart` with a `GettingStartedGuide` use case. Change `main.dart` initial route:

```dart
initialRoute: "?path=guides/getting-started",
```

---

## Phase 2 — Colour Palette Overhaul *(2 hours)*

### 2.1 Replace Monolithic Scroll with Tabbed Palette Browser

The current `pallette.dart` repeats the same grid pattern 20 times for each colour category. Replace with an interactive, searchable layout.

**Rewrite** `gallery/lib/atoms/pallette.dart`:

- Add a category name → `context.palette.X.all` map for DRY iteration
- Add a search/filter text field at the top
- Group by semantic role with tabs or expandable sections
- Show hex code + Figma token name (base/baseAlt/weak/etc.) on each swatch
- Add a copy-to-clipboard on tap
- Show the colour applied to sample text and a sample button for context

```dart
@widgetbook.UseCase(
  name: 'Colour Palette',
  type: GtColors,
  description: '''All design system colours organised by semantic role.
Tap any swatch to copy its hex value. Use the search field to filter by name or hex.

**Theme-aware**: Switch themes using the theme addon to see how colours change across products (Personal, Business, etc.).''',
  code: '''// Access colours via context
final primary = context.palette.primary.base;
final textSub = context.palette.text.sub;

// Or via the class directly
final color = GtPaletteX.of(context).success.base;''',
)
```

**Output**: A single page that replaces 264 lines of repetitive grid code with an interactive browser — searchable, copyable, and theme-switchable.

---

## Phase 3 — Per-Widget Use Cases *(15 hours)*

### 3.1 File Organisation Convention

Each widget or small group of tightly-related widgets gets its own use case file:

```
gallery/lib/
  atoms/
    media/
      gt_icon_usecase.dart        ← already exists as gt_icons.dart
      gt_image_usecase.dart       ← rename from gt_images.dart
      gt_svg_usecase.dart         ← NEW
      gt_network_image_usecase.dart ← NEW
      gt_lottie_usecase.dart      ← NEW
    indicators/
      gt_switch_usecase.dart      ← rename from gt_indicators.dart.dart
      gt_checkbox_usecase.dart    ← NEW
      gt_radio_usecase.dart       ← NEW
      gt_progress_usecase.dart    ← NEW (GtProgress, GtSlider, GtAnimatedProgress)
      gt_dots_usecase.dart        ← NEW
      gt_spinner_usecase.dart     ← NEW
      gt_count_indicator_usecase.dart ← NEW
    typography/
      gt_text_usecase.dart        ← rename
      gt_rich_text_usecase.dart   ← rename
      gt_editable_text_usecase.dart ← rename
  molecules/
    inputs/
      gt_input_usecase.dart       ← contains GtTextField, GtEmailField, GtPasswordField etc.
    tiles/
      gt_list_tile_usecase.dart   ← already exists
      gt_checkbox_tile_usecase.dart ← NEW
      gt_switch_tile_usecase.dart ← NEW
      gt_selection_tile_usecase.dart ← NEW
      ...
```

**Naming convention**: `<widget_name>_usecase.dart` consistently. Existing files get renamed.

### 3.2 Use Case Template

Every new use case follows this pattern:

```dart
@widgetbook.UseCase(
  name: 'GtSpinner',
  type: GtSpinner,
  description: '''
A loading spinner indicator.

**Variants**: soft, sub, strong
**Sizes**: small, medium, large (passed via `size` parameter in logical pixels)

**Usage**: Show during async operations where content is loading but the UI is already visible.
For full-page loading, prefer `GtLoadingState` from the view_state organisms.''',
  code: '''
GtSpinner(
  variant: GtIconVariant.strong,
  size: 32,
)''',
)
Widget playgroundGtSpinnerUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtIconVariant.values,
    initialOption: GtIconVariant.strong,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.double.slider(
    label: 'Size',
    min: 16, max: 64, initialValue: 32,
  );

  return GtGalleryShowcase(
    title: 'GtSpinner',
    description: 'Animated loading indicator with configurable variant and size.',
    knobs: [
      // knobs are rendered inline by the template
    ],
    child: GtSpinner(variant: variant, size: size),
  );
}
```

### 3.3 Priority Sequencing

| Batch | Category | Widgets | Files |
|-------|----------|---------|-------|
| **A** | Missing HIGH-priority atoms | GtSpinner, GtSvg, GtNetworkImage, GtAssetImage | 4 |
| **B** | Missing HIGH-priority inputs | GtEmailField, GtPasswordField, GtPhoneField, GtAmountField, GtDateField, GtDropdownField | 6 |
| **C** | Missing HIGH-priority tiles | GtCheckBoxTile, GtSwitchTile, GtRadioTile, GtTransactionListTile, GtIconListTile, GtSimpleActionListTile, GtSelectionListTile | 7 |
| **D** | Missing HIGH-priority organisms | GtSelectableCard, GtAnimatedSwitcher, GtButtonBottomNavBar, GenericListener | 4 |
| **E** | Missing HIGH-priority templates | GtForm, GtInfiniteListView, GtRootPopScope/GtPopScope | 3 |
| **F** | Missing MEDIUM atoms | GtCheckBox, GtRadio, GtProgress family, GtDots family, GtCountIndicator, GtLottie, etc. | 10 |
| **G** | Missing MEDIUM molecules | Remaining inputs, all pills, all remaining tiles, boxes, data-viz | 45 |
| **H** | Missing MEDIUM organisms | Switchers, listeners, media, menus, slides, tab-bars, remaining cards | 25 |
| **I** | Missing MEDIUM templates | State wrappers, overlay components, nav-aware | 8 |
| **J** | Rename existing | Suffix all existing files with `_usecase` | 31 |

**Total new files**: ~120  
**Total renamed files**: ~31

### 3.4 Files to Skip

The following are internal implementation details or empty stubs — no use cases needed:
- `GtCalendarCell`, `GtCalendarModal`, `GtKeyCell`, `GtDropDownModal`, `GtCountryCodeField` (internal)
- `GtLessonSlideBackground`, `GtLessonSlideMedia`, `GtLessonSlideTitle` (internal)
- `GtBottomNavIcon`, `GtContextMenuTile` (internal)
- `GtViewStateSpacer`, `GtViewStateGapSpacer`, `GtViewStateSizedBoxSpacer`, `GtViewStateFillSpacer` (sealed/internal)
- `GtWelcomeSlide`, `GtLessonSlide` (covered by GtWelcomeSlides/GtLessonSlides use cases)
- All empty stub files with no class definition (16 files — should be deleted from barrel exports or filled)
- Abstract base classes (`GtButton`, `GtStatelessWidget`, `GtStatefulWidget`, `GtBaseWidget`)

---

## Phase 4 — Recipe / Combined Use Cases *(5 hours)*

Create use cases that show **related widgets working together** — the way a developer would actually compose them.

### 4.1 Recipe Structure

```
gallery/lib/recipes/
  forms/
    login_form_usecase.dart
    signup_form_usecase.dart
    transfer_form_usecase.dart
  lists/
    transaction_list_usecase.dart
    settings_list_usecase.dart
  screens/
    dashboard_usecase.dart
    profile_usecase.dart
  cards/
    alert_cards_usecase.dart
```

### 4.2 Example: Login Form Recipe

```dart
@widgetbook.UseCase(
  name: 'Login Form',
  type: GtForm,
  description: '''
A complete login form composing GtForm, GtEmailField, GtPasswordField, and GtRaisedButton.

**Key patterns demonstrated**:
- Form validation with `context.validateForm(formKey)`
- Input decoration styling
- Button disabled state tied to form validity
- GtGap for consistent vertical spacing''',
  code: '''
GtForm(
  formKey: _formKey,
  child: Column(children: [
    GtEmailField(controller: _emailCtrl, label: "Email"),
    GtGap.yLg(),
    GtPasswordField(controller: _passCtrl, label: "Password"),
    GtGap.yXl(),
    GtRaisedButton(
      text: "LOGIN",
      onPressed: () => context.validateForm(_formKey),
    ),
  ]),
)''',
)
Widget buildLoginFormRecipe(BuildContext context) {
  // ...
  return GtGalleryShowcase(
    title: 'Login Form',
    description: 'Standard email + password login pattern.',
    child: GtForm(formKey: _formKey, child: Column(...)),
  );
}
```

### 4.3 Recipe Inventory

| Recipe | Widgets Combined | Priority |
|--------|-----------------|----------|
| Login Form | GtForm, GtEmailField, GtPasswordField, GtRaisedButton | HIGH |
| Registration Form | GtForm, GtTextField, GtEmailField, GtPhoneField, GtDobField, GtRaisedButton | HIGH |
| Transfer Form | GtForm, GtTransferField, GtRaisedButton | HIGH |
| Search + List | GtSearchField, GtInfiniteListView, GtTransactionListTile | MEDIUM |
| Settings Screen | GtListTile, GtSwitchTile, GtRadioTile, GtSelectionListTile | MEDIUM |
| Card Gallery (simplified) | GtCard, GtBannerCard, GtActionCard, GtTipCard, GtProgressCard | HIGH |
| Alert Patterns | GtAlertBanner, GtAlertCard, GtNotificationCard, GtAlertOverlay | MEDIUM |
| Dashboard Shell | GtDashboardScaffold, GtHomeAppBar, GtBottomNavigationBar | HIGH |
| Empty/Loading/Error States | GtEmptyState, GtStatusState, GtLoadingState, GtViewStateWidget | MEDIUM |
| Bottom Sheet Patterns | GtBottomSheet, GtBottomModal, GtConfirmDialog | MEDIUM |

**Total recipes**: ~12

---

## Phase 5 — Documentation & Code Snippets *(4 hours)*

### 5.1 Add `description` and `code` to All Annotations

For every existing AND new `@widgetbook.UseCase` annotation, populate:

```dart
@widgetbook.UseCase(
  name: '...',
  type: ...,
  description: '''...''',   // ← ADD
  code: '''...''',           // ← ADD
)
```

`description` template:
```
Brief one-liner of what the widget is.

**Variants**: list available variants
**Sizes**: list available sizes
**States**: default, disabled, loading, error, etc.
**Related**: cross-reference to related widgets or recipes

**When to use**: brief guidance
```

`code` template:
```
A minimal but complete code snippet showing the widget with its most common parameters.
```

### 5.2 Regenerate Directories

```bash
cd gallery
dart run build_runner build --delete-conflicting-outputs
```

Verify `main.directories.g.dart` now contains `description:` and `code:` fields on every `WidgetbookUseCase`.

---

## Phase 6 — Cleanup *(2 hours)*

### 6.1 Remove or Fill Empty Stub Files

The following files are exported from barrel files but contain no class definitions. Either fill them with the intended widget or remove from exports:

| File | Action |
|------|--------|
| `gallery/lib/organisms/view_state/gt_loading_state.dart` | Fill with `GtLoadingState` use case |
| `gallery/lib/templates/adaptive/gt_adaptive_container.dart` | Fill or delete |
| `gallery/lib/templates/adaptive/gt_max_width_container.dart` | Fill or delete |
| `gallery/lib/templates/carousels/gt_carousel.dart` | Fill or delete |
| `gallery/lib/templates/widget_base/gt_form_widget.dart` | Fill or delete |
| `gallery/lib/templates/scroll_physics/gt_marquee_scroll.dart` | Fill or delete |
| `gallery/lib/templates/shimmers/gt_generic_shimmer.dart` | Fill or delete |
| `gallery/lib/templates/shimmers/gt_image_shimmer.dart` | Fill or delete |
| `gallery/lib/templates/web/gt_web_view.dart` | Fill or delete |
| `gallery/lib/molecules/media/gt_logo.dart` | Fill or delete |
| `gallery/lib/molecules/text/gt_url_text.dart` | Fill or delete |
| `gallery/lib/organisms/headers/gt_form_header.dart` | Fill or delete |
| `gallery/lib/organisms/list_item/gt_selection_item.dart` | Fill or delete |
| `gallery/lib/templates/modals/gt_selection_modal.dart` | Fill or delete |
| `gallery/lib/templates/overlays/gt_loader_overlay.dart` | Fill or delete |
| `gallery/lib/templates/gt_style_guide.dart` | Fill or delete |

### 6.2 Rename Barrel-Only Use Case Files

Files that exist in the gallery but are only referenced from barrel files and don't follow the `_usecase` convention should be renamed:

```bash
# In gallery/lib/atoms/
mv media/gt_icons.dart → media/gt_icon_usecase.dart
mv media/gt_images.dart → media/gt_image_usecase.dart
mv spacers/gt_gap.dart → spacers/gt_gap_usecase.dart
mv spacers/gt_divider.dart → spacers/gt_divider_usecase.dart
mv indicators/gt_indicators.dart.dart → indicators/gt_indicators_usecase.dart

# etc. for molecules/, organisms/, templates/
```

Update the barrel file imports accordingly and re-run the generator.

---

## Phase 7 — Validation *(1 hour)*

### 7.1 Automated Checks

```bash
# All @UseCase annotations have description and code
cd gallery
grep -r "@widgetbook.UseCase" lib/ --include="*.dart" -A 2 | \
  grep -c "description:"  # should equal total use case count
grep -r "@widgetbook.UseCase" lib/ --include="*.dart" -A 2 | \
  grep -c "code:"  # should equal total use case count

# No empty stub files reference widget classes
find lib/ -name "*.dart" -empty

# Build succeeds
dart run build_runner build --delete-conflicting-outputs
flutter analyze lib/
```

### 7.2 Manual Review Checklist

- [ ] `Cmd+K` search finds widgets by name, category, and keyword
- [ ] Inspector panel toggles to show code for every use case
- [ ] Colour palette shows all colour tokens with copy-on-tap
- [ ] Getting Started guide renders as first page
- [ ] Recipe use cases compose multiple widgets correctly
- [ ] Theme switching works across all use cases
- [ ] No widget classes are missing from the catalogue (cross-reference audit list)

---

## Total Time Estimate

| Phase | Hours |
|-------|-------|
| 1. Infrastructure & Templates | 3 |
| 2. Colour Palette Overhaul | 2 |
| 3. Per-Widget Use Cases | 15 |
| 4. Recipe Use Cases | 5 |
| 5. Documentation & Code Snippets | 4 |
| 6. Cleanup | 2 |
| 7. Validation | 1 |
| **Total** | **32 hours** |

---

## Files Index

### New Files (key ones)

| File | Purpose |
|------|---------|
| `gallery/lib/widgets/gt_gallery_showcase.dart` | Simplified use case wrapper template |
| `gallery/lib/guides/getting_started.dart` | Onboarding guide as first page |
| `gallery/lib/recipes/forms/login_form_usecase.dart` | Recipe example |
| `gallery/lib/recipes/cards/alert_cards_usecase.dart` | Recipe example |
| `gallery/lib/atoms/media/gt_svg_usecase.dart` | New per-widget use case |
| `gallery/lib/atoms/indicators/gt_spinner_usecase.dart` | New per-widget use case |
| ~120 additional `*_usecase.dart` files | One per uncovered widget |

### Modified Files

| File | Change |
|------|--------|
| `gallery/lib/main.dart` | Add `SearchAddon`, change `initialRoute` |
| `gallery/lib/main.directories.g.dart` | Regenerated with `description`/`code` fields |
| `gallery/lib/atoms/pallette.dart` | Full rewrite with interactive layout |
| All existing use case files | Add `description:` and `code:` to annotations |
| All barrel files | Updated imports after file renames |
