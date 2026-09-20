import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum _TaskState {
  pristine,
  loading,
  refreshingOverData,
  error,
  errorOverData,
  empty,
  data,
}

class _Txn extends Identifiable {
  final String label;
  final String amount;

  const _Txn(String id, this.label, this.amount) : super(uuid: id);

  @override
  List<Object?> get props => [uuid, label, amount];
}

const _items = [
  _Txn('1', 'Airtime top-up', '₦2,000.00'),
  _Txn('2', 'Transfer to Ada', '₦15,500.00'),
  _Txn('3', 'Electricity bill', '₦8,250.00'),
];

const _failure = TaskError(message: 'We could not reach the server.');

FutureListData<_Txn> _taskFor(_TaskState state) {
  return switch (state) {
    .pristine => const FutureListData<_Txn>.pristine(),
    .loading => const FutureListData<_Txn>.pristine(isLoading: true),
    .refreshingOverData => FutureListData<_Txn>(
      data: _items,
      isLoading: true,
      updatedAt: DateTime.now(),
    ),
    .error => FutureListData<_Txn>(error: _failure, updatedAt: DateTime.now()),
    .errorOverData => FutureListData<_Txn>(
      data: _items,
      error: _failure,
      updatedAt: DateTime.now(),
    ),
    .empty => FutureListData<_Txn>(updatedAt: DateTime.now()),
    .data => FutureListData<_Txn>(data: _items, updatedAt: DateTime.now()),
  };
}

@widgetbook.UseCase(name: 'GtAsyncStateBody', type: GtAsyncStateBody)
Widget playgroundGtAsyncStateBodyUseCase(BuildContext context) {
  final state = context.knobs.object.dropdown<_TaskState>(
    label: 'Task State',
    options: _TaskState.values,
    initialOption: _TaskState.pristine,
    labelBuilder: (v) => v.name,
  );
  final hasRetry = context.knobs.boolean(
    label: 'Has Retry Action',
    initialValue: true,
  );
  final useSkeleton = context.knobs.boolean(
    label: 'Use Skeleton Loading',
    initialValue: false,
  );
  final hasPadding = context.knobs.boolean(
    label: 'Default Padding',
    initialValue: true,
  );
  final emptyDescription = context.knobs.string(
    label: 'Empty Description',
    initialValue: 'No transactions yet',
  );
  final errorTitle = context.knobs.string(
    label: 'Error Title',
    initialValue: 'Something went wrong',
  );

  final task = _taskFor(state);
  final arm = GtAsyncStateArm.of(task);

  return GtWidgetDocPage(
    title: 'GtAsyncStateBody',
    description:
        'Picks the loading, error, empty or data arm of an asynchronous task so every screen resolves it the same way.',
    code:
        '''
GtAsyncStateBody(
  task: controller.transactions,
  emptyDescription: '$emptyDescription',
  emptyIcon: GtIcons.file,
  errorTitle: '$errorTitle',
  ${hasRetry ? "retryLabel: 'Try again'," : ''}
  ${hasRetry ? 'onRetry: controller.load,' : ''}
  ${useSkeleton ? 'loading: const _TransactionsSkeleton(),' : ''}
  ${hasPadding ? '' : 'padding: EdgeInsets.zero,'}
  builder: (context) => ListView(children: [...]),
)''',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GtText(
          'Resolved arm: ${arm.name}',
          style: context.textStyles.subHeadXs(color: context.palette.text.sub),
        ),
        const GtGap.yMd(),
        GtCard(
          padding: context.insets.allDp(8.px),
          child: GtSizedBox(
            height: 320,
            child: GtAsyncStateBody(
              task: task,
              padding: hasPadding ? null : EdgeInsets.zero,
              emptyDescription: emptyDescription,
              emptyIcon: GtIcons.file,
              errorTitle: errorTitle,
              errorIconSize: 96,
              retryLabel: hasRetry ? 'Try again' : null,
              onRetry: hasRetry ? () {} : null,
              loading: useSkeleton ? const _TransactionsSkeleton() : null,
              builder: (context) => ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, _) => const GtGap.ySm(),
                itemBuilder: (_, i) =>
                    GtInfoListTile(_items[i].label, text: _items[i].amount),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _TransactionsSkeleton extends StatelessWidget {
  const _TransactionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < 4; i++) ...[
          GtCard(
            padding: context.insets.allDp(16.px),
            child: const GtSizedBox(height: 16),
          ),
          const GtGap.ySm(),
        ],
      ],
    );
  }
}
