import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Flags `GestureDetector` used to build an interactive surface.
///
/// A raw [GestureDetector] responds to touch and nothing else: it takes no
/// focus, exposes no semantics, and is invisible to keyboard and switch
/// control. `GtInkWell` provides the same gestures plus a focus node, a
/// visible press state, and a declared accessibility role.
///
/// Detectors that only handle non-activating gestures — drags, scales, and
/// pans — are left alone. Those genuinely have no button-like equivalent, and
/// the right fix there is an alternative control rather than a different
/// wrapper.
class AvoidRawGestureDetector extends DartLintRule {
  const AvoidRawGestureDetector() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_raw_gesture_detector',
    problemMessage:
        'GestureDetector is invisible to screen readers, keyboards, and '
        'switch control.',
    correctionMessage:
        'Use GtInkWell with an explicit role, or set excludeFromSemantics on '
        'a detector that is genuinely not a control.',
    url: 'https://api.flutter.dev/flutter/widgets/Semantics-class.html',
  );

  /// Gestures that make the widget behave as a control.
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
    // ErrorReporter in the base signature is a typedef for this type.
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name.lexeme != 'GestureDetector') return;

      final arguments = node.argumentList.arguments;

      final isActivating = arguments.whereType<NamedExpression>().any(
        (argument) => _activatingCallbacks.contains(argument.name.label.name),
      );
      if (!isActivating) return;

      // An author who has already opted out of semantics has made the call
      // deliberately; the lint has nothing to add.
      final optsOut = arguments.whereType<NamedExpression>().any(
        (argument) =>
            argument.name.label.name == 'excludeFromSemantics' &&
            argument.expression is BooleanLiteral &&
            (argument.expression as BooleanLiteral).value,
      );
      if (optsOut) return;

      reporter.atNode(node.constructorName, code);
    });
  }
}
