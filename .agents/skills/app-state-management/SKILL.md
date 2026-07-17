---
name: gt-state-management
description: Manage asynchronous state, fetchable lists, paginated data, and action-only mutations using `StateModel`. Use when writing ViewModel logic to properly cache data or handle fire-and-forget UI actions.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Mon, 14 Jul 2026 12:00:00 GMT
---

# State Management & AsyncData Paradigm

## Contents

- [Structuring State Models](#structuring-state-models)
- [Writing Fetchable States (Lists & Objects)](#writing-fetchable-states-lists--objects)
- [Handling Paginated Data](#handling-paginated-data)
- [Executing Action-Only Mutations](#executing-action-only-mutations)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring State Models

Enforce centralized architectural paradigms for all presentation state logic.

- Inherit from `StateModel` for all state management classes.
- Maintain instances via dependency injection, registered as `LazySingleton` (or `Singleton`).

## Writing Fetchable States (Lists & Objects)

- Use `FutureDataNotifier<T>` for single objects and `FutureListDataNotifier<T>` for fetchable data arrays.
- Initialize all asynchronous state wrappers exclusively using the `.pristine()` method in the constructor.
- Check `currentState.isLoading` before executing tasks to prevent duplication.
- Call `.setLoading()` on the notifier before initiating the service call.

## Handling Paginated Data

- Use `PaginatedDataNotifier<T>` to manage arrays that support pagination.
- Before fetching, evaluate `currentState.hasData` and `!currentState.hasNext` to prevent unnecessary network calls when the end of the list is reached.
- Provide a `force` boolean to handle pull-to-refresh logic. Use `setLoading(data: force ? [] : null)` appropriately.
- When resolving new data, combine it with the existing `PaginatedData` via the `.addData()` method.

## Executing Action-Only Mutations

- **DO NOT** create an `AsyncData` wrapper for fire-and-forget actions (like form submissions or buying airtime).
- Mutate the built-in `isLoading` boolean property inherited directly from `StateModel`.
- Pass `onSuccess` and `onError` callbacks as parameters into the execution function and invoke them based on the `TaskResponse` resolution.
- **Use `executeAction` Extension:** For pure action-only methods (no pre/post-processing),
  prefer the `executeAction<T>()` extension on `StateModel` from
  `lib/app/common/utilities/state_helpers.dart`. It encapsulates the `isLoading` guard,
  state mutation, and callback dispatch:

  ```dart
  Future<void> moveMoney(MoveMoneyParam param, {onSuccess, onError}) async {
    await executeAction(
      () => _service.moveMoney(param),
      onSuccess: onSuccess,
      onError: onError,
    );
  }
  ```

  Keep the inline `isLoading` guard + `if case` pattern for methods with pre-processing
  (e.g., building params from state) or side effects (e.g., caching after success).

## Implementation Workflow

- [ ] 1. Create a class extending `StateModel`.
- [ ] 2. Declare private notifiers (`FutureDataNotifier`, `FutureListDataNotifier`, or `PaginatedDataNotifier`) for fetchables.
- [ ] 3. Initialize notifiers using `.pristine()`.
- [ ] 4. For pagination, implement a `loadNext` function tracking the `next` page variable.
- [ ] 5. For pure mutations, use the `executeAction` extension; for complex mutations with pre/post-processing, use the `isLoading` guard + inline `if case` pattern.
- [ ] 6. Resolve `TaskSuccess` via `.copyWith()` or `.addData()`, and `TaskFailure` via `.setError()`.

## Examples

### 1. Fetchable Data State (Single Object & List)

```dart
class AccountState extends StateModel {
  final DashboardService _dashboardService;

  late FutureDataNotifier<AccountResponse> _account;
  late FutureListDataNotifier<AccountResponse> _accounts;

  AccountState(this._dashboardService) {
    _account = .pristine();
    _accounts = .pristine();
  }

  FutureDataNotifier<AccountResponse> get account {
    if (_account.value.isPristine) getAccount();
    return _account;
  }

  FutureListDataNotifier<AccountResponse> get accounts {
    if (_accounts.value.isPristine) getAccounts();
    return _accounts;
  }

  Future<void> getAccount() async {
    final currentState = _account.value;
    if (currentState.isLoading) return;

    _account.setLoading();
    final response = await _dashboardService.getAccount();

    _account.value = switch (response) {
      TaskSuccess(:final data) => currentState.copyWith(data: data, isLoading: false),
      TaskFailure(:final error) => currentState.copyWith(error: error, isLoading: false),
    };
  }

  Future<void> getAccounts() async {
    final currentState = _accounts.value;
    if (currentState.isLoading) return;

    _accounts.setLoading();
    final response = await _dashboardService.getAllAccounts();

    _accounts.value = switch (response) {
      TaskSuccess(:final data) => currentState.copyWith(data: data, isLoading: false),
      TaskFailure(:final error) => currentState.copyWith(error: error, isLoading: false),
    };
  }
}
```

### 2. Paginated Data State

```dart
class TransactionsState extends StateModel {
  final DashboardService _dashboardService;
  late PaginatedDataNotifier<TransactionResponse> _transactions;

  TransactionsState(this._dashboardService) {
    _transactions = .pristine();
  }

  PaginatedDataNotifier<TransactionResponse> get transactions {
    if (_transactions.value.isPristine) _getTransactions();
    return _transactions;
  }

  Future<void> loadNext(OnPressed? onSuccess, int? page) async {
    _getTransactions(page: page ?? _transactions.value.next, onSuccess: onSuccess);
  }

  Future<void> _getTransactions({bool force = false, OnPressed? onSuccess, int? page}) async {
    final currentState = _transactions.value;
    if (currentState.isLoading) return;

    final hasData = currentState.hasData;
    final hasNext = currentState.hasNext;
    if (!force && (hasData && !hasNext)) return;

    _transactions.setLoading(data: force ? [] : null);
    final param = PageParamm(page: page ?? 0);
    final response = await _dashboardService.getAllTransactions(param);

    if (response case TaskSuccess(:final data)) {
      _resolvePageData(pageData: data, force: force, param: param);
      onSuccess?.call();
    }
    if (response case TaskFailure(:final error)) {
      _transactions.setError(error);
    }
  }

  void _resolvePageData({required List<TransactionResponse> pageData, required bool force, required PageParamm param}) {
    PaginatedData<TransactionResponse> currentState = _transactions.value;
    final page = param.page;
    final data = PaginatedData(
      data: pageData,
      page: page,
      pages: page + (pageData.hasValue ? 1 : 0),
      limit: param.pageSize,
      isLoading: false,
      updatedAt: .now(),
    );

    _transactions.value = (force || !currentState.hasData) ? data : currentState.addData(data);
  }
}
```

### 3. Action-Only Mutation State

````dart
class BillsAirtimeState extends StateModel {
  final BillsService _service;

  BillsAirtimeState(this._service);

  Future<void> buyAirtime(
    BillsArguments arguments, {
    OnChanged<BillsTransactionResponse>? onSuccess,
    OnChanged<TaskError>? onError,
  }) async {
    isLoading = true;
    final response = await _service.buyAirtime(arguments);
    isLoading = false;

    if (response case TaskSuccess(:final data)) {
      onSuccess?.call(data);
    }
    if (response case TaskFailure(:final error)) {
      onError?.call(error);
    }
  }
}```
````
