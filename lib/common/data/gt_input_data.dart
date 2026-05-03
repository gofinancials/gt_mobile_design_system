import 'package:flutter/material.dart';

/// A data class that groups together a [TextEditingController] and a [FocusNode]
/// for an input field.
///
/// This provides a convenient way to pass both commonly used controllers together.
class GtInputValue {
  /// The controller that manages the text being edited.
  final TextEditingController controller;

  /// The focus node that controls the focus state of the input.
  final FocusNode focusNode;

  /// Creates a [GtInputValue] with the provided [controller] and [focusNode].
  GtInputValue({required this.controller, required this.focusNode});

  /// Whether the input currently has focus.
  bool get hasFocus => focusNode.hasFocus;

  /// The current text value of the input.
  String get text => controller.text;

  /// The current editing state, including text, selection, and composing range.
  TextEditingValue get editingValue => controller.value;

  /// Creates a copy of this value but with the given fields replaced with the new values.
  GtInputValue copyWith({
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return GtInputValue(
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GtInputValue &&
        other.controller == controller &&
        other.focusNode == focusNode;
  }

  @override
  int get hashCode => Object.hash(controller, focusNode);
}

/// A controller wrapper for input widgets that manages both text editing and focus state.
///
/// This encapsulates a [GtInputValue] to simplify input field management.
class GtInputController {
  late final GtInputValue _value;

  /// Creates a [GtInputController].
  ///
  /// If [value] is not provided, a new [TextEditingController] and [FocusNode] are created automatically.
  GtInputController([GtInputValue? value]) {
    if (value != null) {
      _value = value;
      return;
    }
    _value = GtInputValue(
      controller: TextEditingController(),
      focusNode: FocusNode(),
    );
  }

  /// Gets the underlying [TextEditingController].
  TextEditingController get controller => _value.controller;

  /// Gets the underlying [FocusNode].
  FocusNode get focusNode => _value.focusNode;

  /// Whether the input currently has focus.
  bool get hasFocus => _value.hasFocus;

  /// Gets the current text from the controller.
  String get text => _value.text;

  /// Gets the current editing state from the controller.
  TextEditingValue get editingValue => _value.editingValue;

  /// Sets the current text of the controller.
  set text(String text) => controller.text = text;

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
