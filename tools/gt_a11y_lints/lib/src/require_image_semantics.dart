import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Flags design-system imagery that declares neither a label nor decorative
/// intent.
///
/// An image is either meaningful, in which case it needs a description, or it
/// is decoration, in which case it should stay out of the semantics tree. What
/// it must not be is unlabelled and announced, which is a stop the user swipes
/// past to learn nothing.
///
/// The design system defaults an unlabelled image to decorative, so this rule
/// is about making the choice explicit rather than about a crash. It is the
/// authoring-time half of a change that will eventually make the decision
/// mandatory.
class RequireImageSemantics extends DartLintRule {
  const RequireImageSemantics() : super(code: _code);

  static const _code = LintCode(
    name: 'require_image_semantics',
    problemMessage:
        '{0} declares neither semanticsLabel nor isDecorative, so it is '
        'silently treated as decoration.',
    correctionMessage:
        'Pass semanticsLabel when the image carries meaning, or '
        'isDecorative: true when it does not.',
  );

  static const _imageWidgets = {
    'GtImage',
    'GtAssetImage',
    'GtNetworkImage',
    'GtMemoryImage',
    'GtFileImage',
    'GtSvg',
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
      final name = node.constructorName.type.name.lexeme;
      if (!_imageWidgets.contains(name)) return;

      final declared = node.argumentList.arguments
          .whereType<NamedExpression>()
          .map((argument) => argument.name.label.name)
          .toSet();

      if (declared.contains('semanticsLabel')) return;
      if (declared.contains('isDecorative')) return;

      reporter.atNode(node.constructorName, code, arguments: [name]);
    });
  }
}
