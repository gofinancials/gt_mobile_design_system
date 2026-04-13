import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: Text)
Widget buildRootUseCase(BuildContext context) {
  return const Text('Gt Mobile Design System');
}