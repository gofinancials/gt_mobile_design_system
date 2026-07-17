---
name: widgetbook
description: Author, configure, and maintain Widgetbook use-cases and preview components in the design system gallery. Use when adding new widgets, editing interactive previews, or configuring Widgetbook addons.
metadata:
  model: models/gemini-3.5-flash
  last_modified: Wed, 15 Jul 2026 12:25:00 GMT
---

# Widgetbook Interactive Component Previews

Use this skill to author, register, and run interactive Widgetbook components within the design system's gallery (`/gallery`) based on industry-standard Flutter practices.

## Contents

- [Core Principles](#core-principles)
- [Annotations & Cataloging](#annotations--cataloging)
- [Interactive Knobs](#interactive-knobs)
- [Mocking Dependencies & State](#mocking-dependencies--state)
- [Standard Addons](#standard-addons)
- [Workflows](#workflows)
- [Troubleshooting & Limitations](#troubleshooting--limitations)
- [Full Showcase Examples](#full-showcase-examples)

---

## Core Principles

Widgetbook is an open-source storybook tool for Flutter that allows developers to catalog and preview widgets in isolation. To get the most out of Widgetbook:

1. **Isolation by Design**: Previews should load independently of full-app architecture. Avoid importing global services or repositories directly.
2. **Constructor Injection**: Inject data and callbacks (e.g. `onPressed`) directly into widgets. This makes components highly reusable and trivially easy to showcase in Widgetbook without complex mock setups.
3. **Single Source of Truth**: Utilize the `designLink` property to link Figma designs directly to Widgetbook use-cases.

---

## Annotations & Cataloging

Widgetbook uses code generation via `widgetbook_generator` to compile your catalog.

### `@widgetbook.App`

Marks the entry point of your Widgetbook application (typically located in [gallery/lib/main.dart](file:///Users/macpro/Documents/Code/Dart/Flutter/Sterling/gt_mobile_ui/gallery/lib/main.dart)).

### `@widgetbook.UseCase`

Applied to builder functions that return a `Widget` representing a specific component variant.

- **`name`**: The display name for the specific variant (e.g., `'Primary'`, `'Loading'`, `'Disabled'`).
- **`type`**: The component class type being cataloged. This groups all variants under that component in the navigation tree.
- **`designLink`** (Optional): A direct Figma URL to bridge the gap between design and code.

```dart
@widgetbook.UseCase(
  name: 'Default',
  type: GtButton,
  designLink: 'https://www.figma.com/file/xyz123/Design-System?node-id=45-67',
)
Widget playgroundGtButtonUseCase(BuildContext context) {
  return GtButton(label: 'Click Me');
}
```

---

## Interactive Knobs

Knobs allow users to adjust a widget's parameters dynamically through the Widgetbook sidebar. Expose properties using `context.knobs`:

- **Boolean**: Ideal for toggling loading or disabled states.
  ```dart
  final isLoading = context.knobs.boolean(label: 'LoadingState', initialValue: false);
  ```
- **Text / String**: Customizes label texts, headers, or body texts.
  ```dart
  final text = context.knobs.string(label: 'Label', initialValue: 'Submit');
  ```
- **Numbers / Sliders**: Adjust numeric values like ratings, sizes, margins, or percentages.
  ```dart
  final elevation = context.knobs.double.slider(
    label: 'Elevation',
    initialValue: 2.0,
    min: 0.0,
    max: 10.0,
  );
  ```
- **Dropdown Options (Object)**: Select from list options or enum values.
  ```dart
  final color = context.knobs.object.dropdown<Color>(
    label: 'Button Color',
    initialOption: Colors.blue,
    options: [Colors.blue, Colors.red, Colors.green],
  );
  ```

---

## Mocking Dependencies & State

If a component depends on state management (Provider, Riverpod, BLoC), wrap the return widget in the usecase function with mock providers:

### 1. Mocking BLoC (with `bloc_test` / `mocktail`)

Provide a stubbed BLoC state via a nested provider:

```dart
@widgetbook.UseCase(name: 'Success State', type: ProfileCard)
Widget successProfileCard(BuildContext context) {
  final mockBloc = MockProfileBloc();
  when(() => mockBloc.state).thenReturn(ProfileState.success(name: 'Jane Doe'));

  return BlocProvider<ProfileBloc>.value(
    value: mockBloc,
    child: const ProfileCard(),
  );
}
```

### 2. Mocking Riverpod

Wrap the preview in a `ProviderScope` to override real providers:

```dart
@widgetbook.UseCase(name: 'Default', type: CartBadge)
Widget cartBadgeUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      cartItemCountProvider.overrideWith((ref) => 5),
    ],
    child: const CartBadge(),
  );
}
```

---

## Standard Addons

Addons add global config configurations to the preview frame. Configure these inside the `@widgetbook.App` widget:

- **`ViewportAddon` / Device Frames**: Simulates mobile screen resolutions (e.g. iPhone, Android, Tablet).
- **Theme Addon**: Allows toggle between Light Mode, Dark Mode, or custom themes.
- **`TextScaleAddon`**: Simulates accessibility text settings (e.g., 0.8x up to 2.0x font scaling).
- **`LocalizationAddon`**: Switches languages dynamically to verify translations and layout overflows.

---

## Workflows

### 1. Creating Use Cases

1. Create a file inside [gallery/lib/](file:///Users/macpro/Documents/Code/Dart/Flutter/Sterling/gt_mobile_ui/gallery/lib/) matching the feature path (e.g. `gallery/lib/atoms/gt_badge_gallery.dart`).
2. Write a function annotated with `@widgetbook.UseCase`.
3. Use `context.knobs` to parameterize inputs.

### 2. Code Generation

Run the build runner to generate the new directory structure `main.directories.g.dart`.

> [!IMPORTANT]
> Always execute build runner from the `gallery/` subdirectory.

```bash
cd gallery
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Launching Widgetbook

Run the gallery application targeting the web:

```bash
cd gallery
flutter run -d chrome
```

---

## Troubleshooting & Limitations

- **State Leaks**: Avoid sharing mock instances across multiple use-case builder functions, which could leak state changes. Instantiate mock objects inside each usecase builder function scope.
- **Missing Code-Gen Previews**: If your previews aren't appearing, verify that:
  - Your builder function is public and annotated with `@widgetbook.UseCase`.
  - You ran the generator inside the `/gallery` directory, not the main project root.
- **Platform Incompatibilities**: Widgetbook runs on Flutter Web. Avoid using libraries containing native implementations (e.g., `dart:io` or `path_provider`). Instead, mock these dependencies inside the preview.

---

## Full Showcase Examples

### Example: Typography Catalog with Interactive Controls

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(
  name: 'Typography Play',
  type: GtText,
)
Widget playgroundGtTextUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text Value',
    initialValue: 'The quick brown fox jumps over the lazy dog.',
  );

  final size = context.knobs.double.slider(
    label: 'Font Size',
    initialValue: 16.0,
    min: 10.0,
    max: 40.0,
  );

  return Scaffold(
    body: Center(
      child: GtText(
        text,
        style: TextStyle(fontSize: size),
      ),
    ),
  );
}
```
