---
name: gt-forms-validation
description: Implement secure input forms and localized validation rules. Use when building data entry screens, login forms, or input fields.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Mon, 13 Jul 2026 18:39:23 GMT
---

# Form Handling & Validation

## Contents

- [Structuring Forms](#structuring-forms)
- [Writing Inputs](#writing-inputs)
- [Executing Validation](#executing-validation)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring Forms

Keep the widget's `build()` method declarative by orchestrating form interactions via mixins.

- Mix in `FormMixin` on the state class to track validity[cite: 2].
- Attach the `formKey` property inherited from the mixin to the parent `Form` widget[cite: 2].
- Maintain a `formStateEmitter` `ValueNotifier` to track the validity status of the form[cite: 2].

## Writing Inputs

- Always use `GtInputController` instead of Flutter's native `TextEditingController`[cite: 1].
- Utilize semantic input molecules like `GtAmountField`, `GtEmailField`, `GtPhoneField`, or `GtPinInput` rather than raw text fields[cite: 1].

## Executing Validation

- Utilize `AppValidators` for standardized checks (e.g., `amountValidator`, `bvnValidator`, `emailValidator`)[cite: 2].
- Before execution, explicitly call `context.validateForm(formKey)` to ensure inputs are correct[cite: 2].

## Implementation Workflow

- [ ] 1. Apply `FormMixin` to the stateful widget's state class[cite: 2].
- [ ] 2. Create `GtInputController` instances in `initState`[cite: 1].
- [ ] 3. Initialize `formStateEmitter` and register listeners via `_trackValidity()`[cite: 2].
- [ ] 4. Wrap inputs in a `Form` widget bound to `formKey`[cite: 2].
- [ ] 5. Validate the form natively before triggering state mutations.

## Examples

### Form Mixin Integration

```dart
mixin BillsAirtimeMixin<T BillsAirtimeScreen extends> on State<T>, FormMixin {
  late final GtInputController phoneCtrl;

  @override
  void initState() {
    super.initState();
    phoneCtrl = GtInputController();
    formStateEmitter = ValueNotifier(formValidityStatus());
    trackValidity();
  }

  @override
  bool formValidityStatus() {
    return phoneCtrl.text.isNotEmpty && phoneCtrl.text.length >= 10;
  }

  @override
  void trackValidity() {
    phoneCtrl.addListener(() {
      formStateEmitter.value = formValidityStatus();
    });
  }

  @override
  void submit() {
    if (!context.validateForm(formKey)) return;
    // Proceed to state execution
  }
}
```
