---
name: gt-utilities-extensions
description: Exhaustive guide to leveraging `gt_mobile_foundation` extensions for safe parsing, collection manipulation, scaling, localization, context utilities, and logging. Use whenever formatting data, interacting with the system, or manipulating primitive types.
metadata:
  last_modified: Mon, 14 Jul 2026 12:00:00 GMT
---

# Foundational Utilities & Extensions

## Contents

- [Imports & Dependencies](#imports--dependencies)
- [Theming & Context Extensions](#theming--context-extensions)
- [Widget Construction & Performance](#widget-construction--performance)
- [Writing Syntactic Sugar](#writing-syntactic-sugar)
- [Executing Pattern Matching](#executing-pattern-matching)
- [State Management & Presentation Boundaries](#state-management--presentation-boundaries)
- [Implementation Workflow](#implementation-workflow)
- [String & Localization Extensions](#string--localization-extensions)
- [Number, Currency & Time Extensions](#number-currency--time-extensions)
- [Iterable & List Extensions](#iterable--list-extensions)
- [Date & Duration Extensions](#date--duration-extensions)
- [BuildContext & UI State Extensions](#buildcontext--ui-state-extensions)
- [Core Utilities (Logging & Debouncing)](#core-utilities-logging--debouncing)
- [Examples](#examples)

## Imports & Dependencies

Keep import statements clean, predictable, and encapsulated.

- **Prefer Root Barrels:** Always import barrel files over direct file paths (e.g., use `import 'package:gt_mobile_foundation/foundation.dart';` rather than pointing directly to `src/utilities/...`).
- **Never use path-based imports:** Always use package-based imports (e.g., `import 'package:onebank_pro/...'`) instead of relative/path-based imports (e.g., `import '../../...'`) for workspace files. Package imports keep dependency pathways clean and prevent relative path fragility.

## Theming & Context Extensions

Leverage custom foundation extensions rather than verbose native Flutter lookups to keep the widget tree clean and readable.

- **NEVER use `GtColors` directly:** Hardcoding or referencing `GtColors` directly breaks dynamic theming (Light/Dark modes and app-specific themes). Always extract colors semantically via `context.palette`.
- Use `context.theme` instead of `Theme.of(context)`.
- Use `context.width` instead of `MediaQuery.of(context).size.width`.
- Use `mapList()` over the native `.map(...).toList()` iterable chain.
- Use `includes()` in place of native `contains()` where applicable.

## Widget Construction & Performance

Ensure widgets are optimized for the Flutter rendering engine and testability.

- **Assign Keys:** Developers must endeavor to assign `Key`s (such as `ValueKey`) to widgets—especially custom components, list items, and form fields. This makes frame painting more efficient and heavily aids in automated widget testing.

## Writing Syntactic Sugar

Embrace modern Dart syntax abbreviations to reduce boilerplate, especially regarding enums, static factories, and list generation.

- **Dot Syntax for Enums:** Drop the enum class name when the type is inferred (e.g., use `crossAxisAlignment: .stretch` instead of `CrossAxisAlignment.stretch`, or `type: .error` instead of `GtToastType.error`).
- **Dot Syntax for Static Factories:** Omit the class name for static initializers when the type is heavily inferred (e.g., use `_account = .pristine()` instead of `FutureDataNotifier.pristine()`, or `updatedAt: .now()`).
- **Collection For Loops:** Use `for elem` loops inside list literals (e.g., `[for (final it in data) Model.fromJson(it)]`) rather than `List.generate` or chaining `.map().toList()`.

## Executing Pattern Matching

Strictly utilize Dart 3 pattern matching and destructuring for control flow and state resolution.

- Use `if case` expressions to conditionally unwrap sealed classes or complex states (e.g., `if (response case TaskSuccess(:final data))`).
- Use exhaustive `switch` expressions (returning values directly) rather than imperative `switch` statements when mapping responses or states to variables.

## State Management & Presentation Boundaries

Prevent presentation layer coupling with raw JSON schemas and mock frameworks, and standardize how states are consumed.

- **No Direct MockData in UI:** Presentation layer widgets (UI) must NEVER import or reference static MockData files or classes (e.g., `AuthMockData`, `_mockData`). All data must be exposed via State Notifiers, View Models, or State Models.
- **No Raw Maps/Map Accessors in UI:** UI widgets must NEVER consume raw `Map<String, dynamic>` structures or utilize string-keyed map accessors (e.g., `bank['name']`) for displaying data. All values must be consumed as typed properties.
- **Response Model Deserialization:** All mock and network data must be strictly deserialized into response/model classes before exposure.
- **State-driven Display:** Presentation layer views must consume data exclusively as typed model instances provided by the respective states.
- **Granular Sub-State Listening (`ListenableBuilder`):** Avoid rebuilding the entire widget tree on general StateModel changes. Extract specific sub-state property notifiers (e.g., `FutureListDataNotifier`) and consume them granularly via a `ListenableBuilder`:
  ```dart
  final state = context.watch<PaymentsState>();
  final filteredBanks = state.bankSuccessRates;
  ...
  child: ListenableBuilder(
    listenable: filteredBanks,
    builder: (context, child) {
      final banks = filteredBanks.data;
      // build UI using typed banks list...
    },
  )
  ```
- **State Machine Inspection:** When rendering, inspect lifecycle properties on the notifier state:
  - Loading: `task.isLoading && !task.hasData` $\rightarrow$ Show `GtSpinner()`.
  - Error: `!isLoading && task.hasError` $\rightarrow$ Show `GtStatusState.error(...)`.
  - Empty: `!isLoading && banks.isEmpty` $\rightarrow$ Show `GtEmptyState(...)`.
- **Direct Callback Binding:** Bind state handlers directly to parameters if signatures match (e.g., `onChange: state.filterBankSuccessRates`) instead of wrapping them in anonymous closures.
- **State Caching & Immutability:** Filter actions in the StateModel must populate and clear local cache fields, and always copy lists (e.g., `data: [...result]`) when updating the value notifier to ensure reference changes and proper UI updates.
- **Global vs Local State Registration:**
  - **Global states** consumed by multiple modules (e.g., `ProActivityState`,
    `GtThemeState`, `AuthenticationState`) MUST be registered in
    `GtStateWrapper.providers` in `main.dart` as `ChangeNotifierProvider`
    with `lazy: true`.
  - **Ephemeral/local states** consumed only within a specific screen or widget
    subtree (e.g., `DashboardTransactionsState`, `DashboardBeneficiariesState`)
    MUST be exposed via `GtLocalStateWrapper<T>`:

    ```dart
    GtLocalStateWrapper<DashboardTransactionsState>(
      builder: (state) { ... },
    )
    ```

    Do NOT register ephemeral states in `GtStateWrapper.providers`.
    `GtLocalStateWrapper` handles DI instantiation and disposal when the
    widget subtree is removed.

## String & Localization Extensions

Avoid manual string parsing and raw `easy_localization` calls by utilizing built-in string extensions[cite: 2].

- **Strict Localization Rules:**
  - **No Hardcoded Strings:** NEVER use hardcoded string literals directly in the UI/widgets. All consumer-facing text must be localized.
  - **Define in JSON:** All localization strings must be defined in the translation JSON files under `assets/translations/`.
  - **Generate Keys:** Regenerate the key definitions by running the Makefile command: `make gen_localization`.
  - **Reference via LocaleKeys:** Inject translated strings in the UI exclusively using `LocaleKeys` constants (e.g., `LocaleKeys.someKey.tr()`). We use `easy_localization` for localization.
- **Localization Extensions (`StringExtension`):**
  - `.tr()`: Translates the string.
  - `.ctr()`: Translates the string and capitalizes the first letter of each word.
  - `.utr()`: Translates the string and converts it entirely to uppercase.
  - `.ltr()`: Translates the string and converts it entirely to lowercase.[cite: 2].
- **Parsing (`StringExtension`):**
  - `.asAmount`: Attempts to extract a numeric currency/amount value[cite: 2].
  - `.asInt`: Attempts to parse into an integer[cite: 2].
  - `.asDate`: Attempts to parse into a `DateTime`[cite: 2].
  - `.asCardNumber` / `.asFormattedPhone`: Formats into a standard layout[cite: 2].
- **Formatting & Inspection (`NullableStringExtension` & `StringExtension`):**
  - `.hasValue`: Returns true if non-null and not purely whitespace[cite: 2].
  - `.value`: Returns trimmed string, or empty string if null[cite: 2].
  - `.initials`: Parses initials (e.g., "John Doe" -> "JD")[cite: 2].
  - `.obscuredEmail`: Partially obscures email (e.g., test@example.com -> te\*\*\*)[cite: 2].
  - `.capitalise()`: Capitalizes the first letter[cite: 2].
  - `.equals()`, `.includes()`, `.matches()`: Case-insensitive comparisons[cite: 2].

## Number, Currency & Time Extensions

Always use `NumExtension` or `IntExtension` for conversions and formatted displays rather than `NumberFormat`[cite: 2].

- **Formatting:**
  - `.formattedCurrency`: Returns a standard currency string (e.g., "\$1,000.00")[cite: 2].
  - `.maskedCurrency`: Returns a masked representation (e.g., "\$\*")[cite: 2].
  - `.asCurrencyShort()`: Returns a compact string (e.g., "\$1k")[cite: 2].
  - `.formattedNumber` / `.formattedNumberLong`: Formats with comma separators[cite: 2].
  - `.asPercentage`: Returns a percentage representation[cite: 2].
- **Math Conversions:**
  - `.asCents` / `.asDollars`: Multiplies or divides by 100[cite: 2].
- **Time Scales:**
  - `.days`, `.hours`, `.minutes`, `.seconds`, `.milliseconds`, `.microseconds`: Converts the number into a `Duration`[cite: 2].
  - `.asDurationString`: Returns "HH:MM:SS" or "MM:SS"[cite: 2].

## Iterable & List Extensions

Ensure safe collection manipulation without throwing boundary exceptions[cite: 2].

- **`IterableExtension` (Nullable Iterables):**
  - `.hasValue`: Returns true if not null and not empty[cite: 2].
  - `.tryFirst` / `.tryLast`: Returns the element or null if empty/error[cite: 2].
  - `.tryFirstWhere()` / `.tryLastWhere()`: Safely returns elements matching a condition[cite: 2].
  - `.mapList()`: Safely maps to a List (use instead of native `.map().toList()`)[cite: 2].
  - `.whereList()`: Safely filters to a List[cite: 2].
- **`ListExtension` (Nullable Lists):**
  - `.addUnique()`, `.addOrReplace()`, `.unshiftUnique()`, `.unshiftOrReplace()`: Mutates list safely based on element existence[cite: 2].
  - `.intersperse()`: Inserts an element between each item[cite: 2].

## Date & Duration Extensions

Standardize time comparisons and relative formatting[cite: 2].

- **`DateExtension` (`DateTime`):**
  - `.format()`: Formats the date to a string[cite: 2].
  - `.asAge`, `.asDuration`, `.asTimedDuration`: Human-readable relative strings[cite: 2].
  - `.isAfterToday()`, `.isBeforeToday()`, `.isSameDay()`, `.isSameMonth()`, `.isSameYear()`: Boolean comparisons ignoring time constraints[cite: 2].
  - `.startOfDay`, `.endOfDay`: Normalizes to 00:00:00 or 23:59:59[cite: 2].
- **`DurationExtensions`:**
  - `.inMonths`, `.inYears`, `.inPreciseYears`, `.inWeeks`: Converts duration into larger time units[cite: 2].
- **`TimeExtension` (`TimeOfDay`):**
  - `.formattedTime()`: Formats to "hh:mm a"[cite: 2].
  - `.asDate`: Converts to `DateTime` using today's date[cite: 2].

## BuildContext & UI State Extensions

Simplify context lookups and widget states[cite: 2].

- **`BuildContextExtension`:**
  - `.currentLocale`, `.currentLocaleString`, `.updateLocale()`: Manage app language natively[cite: 2].
  - `.isAndroid`, `.isIos`, `.isWindows`, `.isMacos`: OS detection flags[cite: 2].
  - `.copyTextToClipboard()`, `.getClipboardText()`: System clipboard access[cite: 2].
  - `.launchUrl()`: Safely triggers the `AppUrlHandler`[cite: 2].
  - `.showSnackBar()`: Displays a snackbar notification[cite: 2].
  - `.requestFocus()`, `.resetFocus()`, `.makeVisible()`: Focus node and scroll manipulation[cite: 2].
  - `.shareText()`, `.shareFile()`: Opens the native share sheet[cite: 2].
- **`TextCtrlExtension` & `NotifierExtension`:**
  - `.hasValue`: Checks if `TextEditingController` or `ValueNotifier` has non-null/non-empty data[cite: 2].
  - `.textValue`: Safely returns `TextEditingController` text or null[cite: 2].
- **`SnapshotExtension`:**
  - `.isLoaded`, `.isLoading`, `.isEmpty`: Checks state of `AsyncSnapshot` streams[cite: 2].

## Core Utilities (Logging & Debouncing)

Standardize application logging and throttling[cite: 2].

- **`AppLogger`:**
  - Never use `print()`. Use `AppLogger().info()` (green), `.debug()` (red), or `.severe()` (red with stack trace)[cite: 2].
- **`AppDebouncer`:**
  - Use to throttle rapid events. Call `.run()` to schedule action and `.abort()` to cancel[cite: 2].

## Implementation Workflow

- [ ] 1. Clean up imports to utilize root package barrels and ensure all workspace imports are package-based rather than relative path-based.
- [ ] 2. Ensure all custom widgets and list items are assigned a `Key`.
- [ ] 3. Replace direct `GtColors` references with `context.palette` semantic tokens.
- [ ] 4. Replace verbose `MediaQuery` and `Theme` lookups with `context` extensions.
- [ ] 5. Refactor `List.generate` and `.map().toList()` chains into collection `[for (...)]` loops.
- [ ] 6. Strip redundant enum and static class names using dot syntax (e.g., `.pristine()`, `.stretch`).
- [ ] 7. Replace imperative `if/else` response checking with `if case` pattern matching.
- [ ] 8. Return values directly using exhaustive `switch` expressions.
- [ ] 9. Verify that no UI/widget imports or references MockData classes directly, and that no widgets use string-keyed Map accessors to extract raw mock or API values.
- [ ] 10. Ensure all UI text is localized by adding strings to `assets/translations/` JSON files, running `make gen_localization`, and injecting via `LocaleKeys.someKey.tr()`.
- [ ] 11. Replace raw `easy_localization` method calls with `.ctr()`, `.utr()`, or `.tr()` string extensions.
- [ ] 12. Replace manual string parsing with `.asAmount` and `.asDate`.
- [ ] 13. Format numeric values exclusively via `.formattedCurrency` and `.formattedNumber`.
- [ ] 14. Replace `.map().toList()` on Iterables with the safety extension `.mapList()`.
- [ ] 15. Utilize `.tryFirstWhere()` over `.firstWhere()` to prevent runtime bounds exceptions.
- [ ] 16. Replace custom `Clipboard` platform calls with `context.copyTextToClipboard()`.
- [ ] 17. Strip out native `print()` statements in favor of `AppLogger().debug()`.[cite: 2].

## Examples

### Formatting & Localization (Strings & Numbers)

```dart
void displayTransactionInfo(double amount, String? email) {
  // 1. String Localization Extensions
  final String title = LocaleKeys.transactionComplete.ctr();

  // 2. Number Formatting Extensions
  final String currencyText = amount.formattedCurrency;

  // 3. Nullable String Safety Extensions
  final String maskedEmail = email.obscuredEmail ?? LocaleKeys.noEmailProvided.tr();

  // 4. AppLogger Utility
  AppLogger().info('Success: $title -> $currencyText for$maskedEmail');
}
```

### Complete Widget Example

Demonstrates barrel imports, widget keys, semantic colors, and dot syntax.

```dart
// 1. Prefer Root Barrels
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';

class TransactionList extends GtStatelessWidget {
  final List<Transaction> transactions;

  // 2. Assign Keys for performance and testing
  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // 3. Avoid GtColors directly; use context.palette
    final bgColor = context.palette.surface;

    return Container(
      color: bgColor,
      child: Column(
        // 4. Enum dot syntax
        crossAxisAlignment: .stretch,
        children: [
          // 5. Collection for-loop instead of .map().toList()
          for (final tx in transactions)
            TransactionCard(
              key: ValueKey(tx.id), // Assigning keys to list children
              transaction: tx,
            ),
        ],
      ),
    );
  }
}
```

### Control Flow & Pattern Matching

Demonstrates exhaustive switch expressions and if case destructuring for network responses.

```dart
// Preferred `switch` expression for assignment
_account.value = switch (response) {
  TaskSuccess(:final data) => currentState.copyWith(data: data, isLoading: false),
  TaskFailure(:final error) => currentState.copyWith(error: error, isLoading: false),
};

// Preferred `if case` for executing side-effects
if (response case TaskSuccess(:final data)) {
  _resolvePageData(pageData: data, force: force, param: param);
  onSuccess?.call();
}
if (response case TaskFailure(:final error)) {
  _transactions.setError(error);
}
```

### Iterable Safety & BuildContext Utilities

```dart
void processAccounts(BuildContext context, List<AccountResponse>? accounts) {
  // 1. Iterable Extension Safety
  if (!accounts.hasValue) {
    // 2. BuildContext extension
    context.showSnackBar(LocaleKeys.noAccountsFound.tr());
    return;
  }

  // 3. Safe mapping extension (avoids .map().toList())
  final activeAccounts = accounts.whereList((acct) => acct.isActive);

  // 4. Safe single item retrieval
  final primaryAccount = activeAccounts.tryFirstWhere((acct) => acct.isPrimary);

  if (primaryAccount != null) {
     // 5. System extensions
     context.copyTextToClipboard(primaryAccount.accountNumber);
  }
}
```

### Debouncing & Date Comparisons

```dart
class SearchViewModel {
  // 1. Utility Instantiation
  final _debouncer = AppDebouncer(delay: 500.milliseconds);

  void onSearchQueryChanged(String query) {
    // 2. Throttle calls via AppDebouncer
    _debouncer.run(() {
      AppLogger().debug('Executing search for: $query');
      executeSearch(query);
    });
  }

  bool isTransactionRecent(DateTime transactionDate) {
    // 3. Date Extension Logic
    return transactionDate.isSameMonth(DateTime.now()) && transactionDate.isBeforeToday();
  }
}
```
