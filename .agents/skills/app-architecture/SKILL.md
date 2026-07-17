---
name: gt-architecture-di
description: Set up feature modules and dependency injection using `get_it`. Use when scaffolding new domains to ensure strict layer isolation and correct object lifecycles.
metadata:
  last_modified: Mon, 13 Jul 2026 18:39:23 GMT
---

# Architecture and Dependency Injection

## Contents

- [Structuring Feature Modules](#structuring-feature-modules)
- [Writing Dependency Injection](#writing-dependency-injection)
- [Execution Rules](#execution-rules)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring Feature Modules

Organize feature modules strictly into isolated domains to enforce a clean separation of concerns.

- Place request payloads, network responses, and pure data objects in the `data/` directory[cite: 2].
- Place mixins, routes, state models, and UI components in the `presentation/` directory.
- Place network implementations and mock interceptors in the `services/` directory.
- Ensure all request payload classes implement the `Codable` interface[cite: 2].
- Ensure all API response objects implement a `fromJson` factory constructor.

## Writing Dependency Injection

Utilize the `get_it` locator for all dependency injection to prevent direct object instantiation[cite: 2].

- Maintain a dedicated DI file (e.g., `feature_di.dart`) for every feature module to enforce domain isolation.
- Register all state management classes strictly as `LazySingleton` (or `Singleton`).
- Register all service classes strictly as `Factory`.

## Execution Rules

Ensure the execution flow follows the rigid sequence before rendering the UI.

- Aggregate all Global State Singletons using `ChangeNotifierProvider` with `lazy: true` inside the `GtStateWrapper`.
- Bind `AppConfig` as a `LazySingleton` and global services as `Factory` in the global `app_di.dart` setup.

## Implementation Workflow

- [ ] 1. Scaffold the feature directory with `data/`, `presentation/`, and `services/` folders.
- [ ] 2. Create the `[feature]_di.dart` file.
- [ ] 3. Register service implementations as `Factory` using `locator.registerFactory()`.
- [ ] 4. Register state models as `LazySingleton` using `locator.registerLazySingleton()`.
- [ ] 5. Ensure payload objects use the `Codable` interface[cite: 2].

## Examples

### Module DI Setup

```dart
void registerFeatureDI(AppConfig config) {
  // SERVICES -> FACTORY
  locator.registerFactory<FeatureService>(
    () => FeatureHttpService(locator<AppHttpService>()),
  );

  // STATES -> SINGLETON
  locator.registerLazySingleton<FeatureState>(
    () => FeatureState(locator<FeatureService>()),
  );
}
```
