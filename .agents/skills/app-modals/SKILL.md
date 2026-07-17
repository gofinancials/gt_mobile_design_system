---
name: gt-decoupled-modals
description: Orchestrate blocking async operations using loading overlays and bottom sheets. Use when submitting forms or fetching data that requires a physical screen block.
metadata:
  last_modified: Mon, 13 Jul 2026 18:39:23 GMT
---

# Decoupled Modals & Blocking Tasks

## Contents

- [Structuring Overlay Logic](#structuring-overlay-logic)
- [Writing Modal Controllers](#writing-modal-controllers)
- [Executing State Resolution](#executing-state-resolution)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring Overlay Logic

Ensure UI navigation remains strictly decoupled from business state execution.

- Never navigate directly from the `StateModel`.
- Ensure the `State` class utilizes `GtBottomModalMixin` and/or `GtBottomSheetMixin`[cite: 1].

## Writing Modal Controllers

- Instantiate a `GtBottomModalController` containing `GtBottomModalData` inside the submission method[cite: 1].
- Define the `onComplete` behavior directly within the controller's setup (e.g., navigating or showing a receipt)[cite: 1].

## Executing State Resolution

- Physically block the UI by calling `showTaskBottomModal` and passing the instantiated controller[cite: 1].
- Invoke the business action on your `StateModel`[cite: 2].
- Explicitly resolve the modal within injected `onSuccess`/`onError` or `onComplete` callbacks using `modalController.complete(TaskSuccess/TaskFailure)`[cite: 1].

## Implementation Workflow

- [ ] 1. Add `GtBottomModalMixin` to the UI State class[cite: 1].
- [ ] 2. Instantiate `GtBottomModalController` with processing text[cite: 1].
- [ ] 3. Call `widget.showTaskBottomModal(context, controller: modalController)`[cite: 1].
- [ ] 4. Trigger the `StateModel` mutation method[cite: 2].
- [ ] 5. Call `modalController.complete()` inside the state callbacks[cite: 1].

## Examples

### Blocking Async Submission

```dart
void _executeSubmission() async {
   final modalController = GtBottomModalController(
       data: GtBottomModalData(title: LocaleKeys.processing.ctr()),
       onComplete: (response) {
          widget.showSheet(
             context,
             isScrollable: true,
             canDragToClose: false,
             child: FeatureReceiptSheet(response.data),
          );
       },
   );

   widget.showTaskBottomModal(context, controller: modalController);

   context.read<FeatureActionState>().executeTask(
      FeatureArguments(email: emailCtrl.text, password: passwordCtrl.text),
      onSuccess: (value) => modalController.complete(TaskSuccess(data: value)),
      onError: (error) {
        context.showToast(error.message, type: GtToastType.error);
        modalController.complete(TaskFailure(error: error));
      },
   );
}
```

```dart
void _executeSubmissionUniform() async {
   final modalController = GtBottomModalController(
       data: GtBottomModalData(title: LocaleKeys.processing.ctr()),
       onComplete: (response) {
          widget.showSheet(
             context,
             isScrollable: true,
             canDragToClose: false,
             child: FeatureReceiptSheet(response.data),
          );
       },
   );

   widget.showTaskBottomModal(context, controller: modalController);

   context.read<FeatureActionState>().executeTask(
      FeatureArguments(email: emailCtrl.text, password: passwordCtrl.text),
      onComplete: modalController.complete,
   );
}
```
