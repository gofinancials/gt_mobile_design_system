import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtStepScaffold', type: GtStepScaffold)
Widget playgroundGtStepScaffoldUseCase(BuildContext context) {
  return const _StepScaffoldDoc();
}

@widgetbook.UseCase(name: 'GtStepScaffold Gallery', type: GtStepScaffold)
Widget playgroundGtStepScaffoldGalleryUseCase(BuildContext context) {
  return const _StepScaffoldPreview();
}

/// The presets, named for the family of step each one reproduces.
const _presets = ['Form', 'Chevron List', 'Long Form'];

class _StepKnobs {
  final String title;
  final String subtitle;
  final String actionLabel;
  final String preset;
  final double progress;
  final bool showSubtitle;
  final bool showProgress;
  final bool showHelp;
  final bool showBackButton;
  final bool showBottomAction;
  final bool tightBodySpacing;

  const _StepKnobs({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.preset,
    required this.progress,
    required this.showSubtitle,
    required this.showProgress,
    required this.showHelp,
    required this.showBackButton,
    required this.showBottomAction,
    required this.tightBodySpacing,
  });

  factory _StepKnobs.of(BuildContext context) {
    return _StepKnobs(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'What is your BVN?',
      ),
      showSubtitle: context.knobs.boolean(
        label: 'Show Subtitle',
        initialValue: true,
      ),
      subtitle: context.knobs.string(
        label: 'Subtitle',
        initialValue: 'We use it to confirm your identity. It takes a moment.',
      ),
      preset: context.knobs.object.dropdown<String>(
        label: 'Body Preset',
        options: _presets,
        initialOption: 'Form',
      ),
      showProgress: context.knobs.boolean(
        label: 'Show Progress Ring',
        initialValue: true,
      ),
      progress: context.knobs.double.slider(
        label: 'Progress',
        initialValue: .4,
        min: 0,
        max: 1,
        divisions: 10,
      ),
      showHelp: context.knobs.boolean(
        label: 'Show Help Pill',
        initialValue: true,
      ),
      showBackButton: context.knobs.boolean(
        label: 'Show Back Button',
        initialValue: true,
      ),
      showBottomAction: context.knobs.boolean(
        label: 'Show Bottom Action',
        initialValue: true,
      ),
      actionLabel: context.knobs.string(
        label: 'Action Label',
        initialValue: 'Continue',
      ),
      tightBodySpacing: context.knobs.boolean(
        label: 'Tight Body Spacing (16)',
        initialValue: false,
      ),
    );
  }

  double? get bodySpacingPx => tightBodySpacing ? 16 : null;
}

/// The doc entry, which points at the full-screen use case.
///
/// A step is a pushed screen with a pinned action, so it is shown full-bleed in
/// its own use case rather than inlined in a card here.
class _StepScaffoldDoc extends StatelessWidget {
  const _StepScaffoldDoc();

  @override
  Widget build(BuildContext context) {
    final knobs = _StepKnobs.of(context);

    return GtWidgetDocPage(
      title: 'GtStepScaffold',
      description:
          'A full-screen template for one step of a guided journey — the '
          'question or short form a customer sees over and over through '
          'account opening, KYC or a product application. A fixed header over '
          'a scrolling body, an optional progress ring and help pill in the '
          'app bar, and an optional action pinned to the foot of the screen. '
          'Every chrome element is opt-in, because the designs do not agree on '
          'them: some steps carry a ring, some a pill, some both, and the '
          'chevron-list steps carry no bottom action at all.',
      code:
          '''
GtStepScaffold(
  title: "${knobs.title}",${knobs.showSubtitle ? '\n  subtitle: "${knobs.subtitle}",' : ''}${knobs.showProgress ? '\n  progress: ${knobs.progress},' : ''}${knobs.showHelp ? '\n  onHelp: () => openSupportSheet(),' : ''}${knobs.showBackButton ? '' : '\n  showBackButton: false,'}${knobs.bodySpacingPx == null ? '' : '\n  bodySpacingPx: 16,'}${knobs.showBottomAction ? '\n  bottomAction: GtRaisedButton(\n    text: "${knobs.actionLabel}",\n    onPressed: goToNextStep,\n  ),' : ''}
  body: GtTextField(label: "BVN", controller: bvnController),
);''',
      child: const GtEmptyStateCard(
        description:
            'Select "GtStepScaffold Gallery" in the sidebar to view the step '
            'screen full screen.',
        icon: GtIcons.clipboardCheck,
      ),
    );
  }
}

class _StepScaffoldPreview extends StatefulWidget {
  const _StepScaffoldPreview();

  @override
  State<_StepScaffoldPreview> createState() => _StepScaffoldPreviewState();
}

class _StepScaffoldPreviewState extends State<_StepScaffoldPreview> {
  final _bvnController = GtInputController();
  final _phoneController = GtInputController();

  @override
  void dispose() {
    _bvnController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildBody(String preset) {
    return switch (preset) {
      'Chevron List' => Column(
        crossAxisAlignment: .stretch,
        spacing: context.spacingBase,
        children: [
          for (final entry in const [
            ('Nigerian passport', 'Issued by the NIS'),
            ("Driver's licence", 'Issued by the FRSC'),
            ('National ID card', 'Issued by NIMC'),
            ('Voter card', 'Issued by INEC'),
          ])
            GtCard(
              padding: context.insets.symmetricDp(
                horizontal: 16.px,
                vertical: 8.px,
              ),
              child: GtIconListTile(
                entry.$1,
                subtitle: entry.$2,
                icon: GtIcons.user,
                onTap: () => GtToast.of(context).show("${entry.$1} tapped"),
              ),
            ),
        ],
      ),
      'Long Form' => Column(
        crossAxisAlignment: .stretch,
        spacing: context.spacingLg,
        children: [
          GtTextField(controller: _bvnController, label: 'BVN'),
          GtTextField(controller: _phoneController, label: 'Phone number'),
          for (var index = 0; index < 6; index++)
            GtCard(
              padding: context.insets.allDp(16.px),
              child: GtText(
                'A block of supporting content, so the body outruns the '
                'viewport and the pinned action holds its place.',
              ),
            ),
        ],
      ),
      _ => GtTextField(controller: _bvnController, label: 'BVN'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final knobs = _StepKnobs.of(context);

    return GtStepScaffold(
      title: knobs.title,
      subtitle: knobs.showSubtitle ? knobs.subtitle : null,
      progress: knobs.showProgress ? knobs.progress : null,
      onHelp: knobs.showHelp
          ? () => GtToast.of(context).show("Help tapped")
          : null,
      showBackButton: knobs.showBackButton,
      bodySpacingPx: knobs.bodySpacingPx,
      bottomAction: knobs.showBottomAction
          ? GtRaisedButton(
              text: knobs.actionLabel,
              onPressed: () =>
                  GtToast.of(context).show("${knobs.actionLabel} tapped"),
            )
          : null,
      body: _buildBody(knobs.preset),
    );
  }
}
