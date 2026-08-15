import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/avoid_raw_gesture_detector.dart';
import 'src/require_image_semantics.dart';
import 'src/require_semantic_role.dart';

/// Entry point invoked by `custom_lint`.
PluginBase createPlugin() => _GtA11yLints();

class _GtA11yLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return const [
      AvoidRawGestureDetector(),
      RequireImageSemantics(),
      RequireSemanticRole(),
    ];
  }
}
