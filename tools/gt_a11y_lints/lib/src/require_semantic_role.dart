import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Flags a tappable `GtInkWell` that never declares what it is.
///
/// `GtInkWell` defaults to announcing itself as a button. That is right for a
/// button and wrong for everything else: a checkbox announced as a button
/// gives the user no way to hear whether it is checked, and a tab announced as
/// a button loses its position in the set.
///
/// Only surfaces that actually respond to activation are flagged. A
/// `GtInkWell` used purely for its ink splash has nothing to declare.
class RequireSemanticRole extends DartLintRule {
  const RequireSemanticRole() : super(code: _code);

  static const _code = LintCode(
    name: 'require_semantic_role',
    problemMessage:
        'GtInkWell defaults to announcing itself as a button, which is wrong '
        'for checkboxes, radios, toggles, tabs, and links.',
    correctionMessage:
        'Pass role: GtSemanticRole.button to confirm it is a button, or the '
        'role that actually describes this surface.',
  );

  static const _activatingCallbacks = {
    'onTap',
    'onDoubleTap',
    'onLongPress',
    'onSecondaryTap',
  };

  /// Restricted to shipped UI.
  ///
  /// Tests deliberately construct bare widgets to exercise defaults, and
  /// flagging those adds noise without protecting any user.
  @override
  List<String> get filesToAnalyze => const ['lib/**.dart'];

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name.lexeme != 'GtInkWell') return;

      final named = node.argumentList.arguments.whereType<NamedExpression>();
      final declared = named.map((a) => a.name.label.name).toSet();

      if (declared.contains('role')) return;

      // The deprecated flag is still an explicit statement of intent, so it
      // suppresses the lint until it is removed.
      if (declared.contains('isSemanticButton')) return;

      final isActivating = declared.any(_activatingCallbacks.contains);
      if (!isActivating) return;

      reporter.atNode(node.constructorName, code);
    });
  }
}
