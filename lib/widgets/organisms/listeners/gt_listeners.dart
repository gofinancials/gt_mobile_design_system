import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class BoolListener extends GtStatelessWidget {
  final ValueBuilder<bool> builder;
  final ValueListenable<bool> valueListenable;

  const BoolListener({
    super.key,
    required this.valueListenable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueListenable,
      builder: (context, activeOption, _) => builder(activeOption),
    );
  }
}

class GenericListener<T> extends GtStatelessWidget {
  final ValueBuilder<T> builder;
  final ValueListenable<T> valueListenable;

  const GenericListener({
    super.key,
    required this.valueListenable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: valueListenable,
      builder: (context, activeOption, _) => builder(activeOption),
    );
  }
}

class ListListener<T> extends GtStatelessWidget {
  final ValueBuilder<List<T>> builder;
  final ValueListenable<List<T>?> valueListenable;

  const ListListener({
    super.key,
    required this.valueListenable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>?>(
      valueListenable: valueListenable,
      builder: (context, values, _) => builder(values ?? []),
    );
  }
}

class NumberListener<T extends num> extends GtStatelessWidget {
  final ValueBuilder<T?> builder;
  final ValueListenable<T?> valueListenable;

  const NumberListener({
    super.key,
    required this.valueListenable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: valueListenable,
      builder: (context, activeOption, _) => builder(activeOption),
    );
  }
}

class StringListener extends GtStatelessWidget {
  final ValueBuilder<String?> builder;
  final ValueListenable<String?> valueListenable;

  const StringListener({
    super.key,
    required this.valueListenable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: valueListenable,
      builder: (context, activeOption, _) => builder(activeOption),
    );
  }
}
