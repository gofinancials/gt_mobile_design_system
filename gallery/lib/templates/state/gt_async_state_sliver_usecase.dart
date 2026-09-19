import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum _SliverTaskState {
  pristine,
  refreshingOverData,
  error,
  errorOverData,
  empty,
  data,
}

class _Row extends Identifiable {
  final String label;

  const _Row(String id, this.label) : super(uuid: id);

  @override
  List<Object?> get props => [uuid, label];
}

final _rows = [for (var i = 1; i <= 200; i++) _Row('$i', 'Statement #$i')];

const _failure = TaskError(message: 'We could not reach the server.');

FutureListData<_Row> _taskFor(_SliverTaskState state) {
  return switch (state) {
    .pristine => const FutureListData<_Row>.pristine(),
    .refreshingOverData => FutureListData<_Row>(
      data: _rows,
      isLoading: true,
      updatedAt: DateTime.now(),
    ),
    .error => FutureListData<_Row>(error: _failure, updatedAt: DateTime.now()),
    .errorOverData => FutureListData<_Row>(
      data: _rows,
      error: _failure,
      updatedAt: DateTime.now(),
    ),
    .empty => FutureListData<_Row>(updatedAt: DateTime.now()),
    .data => FutureListData<_Row>(data: _rows, updatedAt: DateTime.now()),
  };
}

@widgetbook.UseCase(name: 'GtAsyncStateSliver', type: GtAsyncStateSliver)
Widget playgroundGtAsyncStateSliverUseCase(BuildContext context) {
  final state = context.knobs.object.dropdown<_SliverTaskState>(
    label: 'Task State',
    options: _SliverTaskState.values,
    initialOption: _SliverTaskState.pristine,
    labelBuilder: (v) => v.name,
  );
  final hasRetry = context.knobs.boolean(
    label: 'Has Retry Action',
    initialValue: true,
  );
  final showHeaderSliver = context.knobs.boolean(
    label: 'Show Header Sliver',
    initialValue: true,
  );

  final task = _taskFor(state);
  final arm = GtAsyncStateArm.of(task);

  return GtWidgetDocPage(
    title: 'GtAsyncStateSliver',
    description:
        'A SingleChildRenderObjectWidget over a RenderSliverPadding that switches between sliver arms. Every arm is a sliver the caller supplies, so a 200-row list — or a skeleton — stays lazy instead of being boxed.',
    code:
        '''
GtAsyncStateSliver(
  task: controller.statements,
  // Lazy: only the rows in view are built.
  sliver: SliverList.builder(
    itemCount: controller.statements.data.length,
    itemBuilder: (context, i) => GtInfoListTile(...),
  ),
  loading: const SliverFillRemaining(hasScrollBody: false, child: Center(child: GtSpinner())),
  // The package's box visuals are opt-in: compose them yourself.
  empty: const SliverFillRemaining(
    hasScrollBody: false,
    child: GtEmptyStateCard(icon: GtIcons.file, description: 'No statements yet'),
  ),
  error: SliverFillRemaining(
    hasScrollBody: false,
    child: GtStatusState.error(
      title: 'Something went wrong',
      subtitle: controller.statements.errorMessage,
      ${hasRetry ? "actionLabel: 'Try again'," : ''}
      ${hasRetry ? 'onActionPressed: controller.load,' : ''}
    ),
  ),
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
            height: 360,
            child: CustomScrollView(
              slivers: [
                if (showHeaderSliver)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.insets.allDp(8.px),
                      child: GtText(
                        'Statements',
                        style: context.textStyles.subHeadS(),
                      ),
                    ),
                  ),
                GtAsyncStateSliver(
                  task: task,
                  padding: EdgeInsets.zero,
                  sliver: SliverList.builder(
                    itemCount: _rows.length,
                    itemBuilder: (_, i) =>
                        GtInfoListTile(_rows[i].label, text: 'Ready'),
                  ),
                  loading: const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: GtSpinner()),
                  ),
                  empty: const SliverFillRemaining(
                    hasScrollBody: false,
                    child: GtEmptyStateCard(
                      icon: GtIcons.file,
                      description: 'No statements yet',
                    ),
                  ),
                  error: SliverFillRemaining(
                    hasScrollBody: false,
                    child: GtStatusState.error(
                      title: 'Something went wrong',
                      subtitle: task.errorMessage,
                      iconSize: 96,
                      actionLabel: hasRetry ? 'Try again' : null,
                      onActionPressed: hasRetry ? () {} : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
