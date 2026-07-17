---
name: gt-global-routing
description: Configure navigation pathways and route guarding using `RootRouteRegistry` and module-specific `RouteRegistry`. Use when adding new screens or modifying deep links.
metadata:
  last_modified: Mon, 13 Jul 2026 18:39:23 GMT
---

# Global Routing & Delegation

## Contents

- [Structuring Module Routes](#structuring-module-routes)
- [Writing Root Delegation](#writing-root-delegation)
- [Execution Rules](#execution-rules)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring Module Routes

Delegate specific screen building entirely to the isolated module boundaries.

- Implement `RouteRegistry` in the feature module[cite: 2].
- Define a static `basePath` (e.g., `/bills`) for the module.
- Use Dart 3 `switch` syntax in the module's `dynamicRoutes` method to resolve arguments and return `MaterialPageRoute`[cite: 2].

## Writing Root Delegation

Manage traffic natively via the central `RootRouteRegistry`[cite: 2].

- Guard routes using `canActivateRoute(settings, isLoggedIn)` to intercept unauthorized access[cite: 2].
- Do NOT define screen builders directly in the root registry.
- Delegate routes to the respective module's `RouteRegistry` via string prefix matching (e.g., `startsWith(basePath)`)[cite: 2].

## Execution Rules

- You must invoke `registerRoute()` at the root level when a valid route is requested. This natively executes `trackNavigation()` for analytics and closes existing overlays natively[cite: 2].

## Implementation Workflow

- [ ] 1. Create a `[feature]_routes.dart` file implementing `RouteRegistry`.
- [ ] 2. Define the static `basePath` and route constants.
- [ ] 3. Implement the `switch` statement returning `MaterialPageRoute` inside `dynamicRoutes`.
- [ ] 4. Register the module route delegation in `app_routes.dart` inside `RootRouteRegistry`.
- [ ] 5. Apply `canActivateRoute` guarding where necessary[cite: 2].

## Examples

### Module Route Registry

```dart
class BillsRoutes implements RouteRegistry {
  static const basePath = "/bills";
  static const String airtime = '$basePath/airtime';

  @override
  Route dynamicRoutes(RouteSettings settings, Route fallbackRoute) {
    return switch (settings.name) {
      airtime => MaterialPageRoute(
        builder: (context) => BillsAirtimeScreen(
          arguments: settings.arguments as BillsArguments,
        ),
        settings: settings
      ),
      _ => fallbackRoute,
    };
  }
}
```
