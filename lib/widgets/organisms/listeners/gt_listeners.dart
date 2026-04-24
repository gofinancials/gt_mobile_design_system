import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A convenience widget that listens to a [ValueListenable] of type [bool].
///
/// Rebuilds its child using the [builder] function whenever the boolean value changes.
class BoolListener extends GtStatelessWidget {
  /// The builder function called when the boolean value changes.
  final ValueBuilder<bool> builder;

  /// The boolean listenable to observe.
  final ValueListenable<bool> valueListenable;

  /// Creates a [BoolListener].
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

/// A convenience widget that listens to a [ValueListenable] of a generic type [T].
///
/// Rebuilds its child using the [builder] function whenever the value of type [T] changes.
class GenericListener<T> extends GtStatelessWidget {
  /// The builder function called when the value changes.
  final ValueBuilder<T> builder;

  /// The generic listenable to observe.
  final ValueListenable<T> valueListenable;

  /// Creates a [GenericListener].
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

/// A convenience widget that listens to a nullable [ValueListenable] of a [List] of type [T].
///
/// Rebuilds its child using the [builder] function whenever the list changes.
/// Guarantees that a non-null list is passed to the [builder], defaulting to an
/// empty list if the current value is null.
class ListListener<T> extends GtStatelessWidget {
  /// The builder function called when the list changes.
  ///
  /// Receives an empty list `[]` if the underlying listenable value is null.
  final ValueBuilder<List<T>> builder;

  /// The list listenable to observe.
  final ValueListenable<List<T>?> valueListenable;

  /// Creates a [ListListener].
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

/// A convenience widget that listens to a nullable [ValueListenable] of a [num] type.
///
/// Rebuilds its child using the [builder] function whenever the number changes.
class NumberListener<T extends num> extends GtStatelessWidget {
  /// The builder function called when the number changes.
  final ValueBuilder<T?> builder;

  /// The number listenable to observe.
  final ValueListenable<T?> valueListenable;

  /// Creates a [NumberListener].
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

/// A convenience widget that listens to a nullable [ValueListenable] of type [String].
///
/// Rebuilds its child using the [builder] function whenever the string changes.
class StringListener extends GtStatelessWidget {
  /// The builder function called when the string changes.
  final ValueBuilder<String?> builder;

  /// The string listenable to observe.
  final ValueListenable<String?> valueListenable;

  /// Creates a [StringListener].
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
