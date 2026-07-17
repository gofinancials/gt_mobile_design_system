---
name: gt-utilities-extensions
description: Leverage `gt_mobile_foundation` extensions for safe parsing, scaling, localization, and logging. Use whenever formatting data or manipulating primitive types.
metadata:
  last_modified: Mon, 13 Jul 2026 18:39:23 GMT
---

# Foundational Utilities & Extensions

## Contents

- [Structuring Localizations](#structuring-localizations)
- [Writing Data Formats](#writing-data-formats)
- [Executing System Events](#executing-system-events)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring Localizations

- Utilize native string extensions for translations instead of raw localization calls.
- Append `.ctr()` to capitalize translations, `.utr()` for uppercase, or `.ltr()` for lowercase[cite: 2].

## Writing Data Formats

- Format currencies and numbers utilizing `NumExtension` methods like `.formattedCurrency` or `.formattedNumber`[cite: 2].
- Scale hardcoded UI integers or doubles to device-independent pixels by appending the `.dp` property[cite: 2].
- Utilize `StringExtension` safety parsers such as `.asAmount`, `.asCardNumber`, or `.asDate`[cite: 2].

## Executing System Events

- NEVER use the native `print()` function for debugging.
- Utilize `AppLogger().info()`, `.debug()`, or `.severe()` to safely record application flow and catch unhandled system errors[cite: 2].

## Implementation Workflow

- [ ] 1. Replace all raw numeric formatting with `.formattedCurrency` / `.formattedNumber`[cite: 2].
- [ ] 2. Replace all hardcoded pixel sizes with `context.dp(value.px)` extensions[cite: 2].
- [ ] 3. Apply string extensions to `LocaleKeys` for automatic localization[cite: 2].
- [ ] 4. Replace native `print()` statements with `AppLogger` implementations[cite: 2].

## Examples

### String & Numeric Extensions

```dart
void logAndFormatTransaction(double value) {
  // Translate and capitalize
  final String title = LocaleKeys.transactionComplete.ctr();

  // Format as currency implicitly
  final String currencyText = value.formattedCurrency;

  // Log cleanly using AppLogger
  AppLogger.info('Transaction logged: $title ->$currencyText');
}
```
