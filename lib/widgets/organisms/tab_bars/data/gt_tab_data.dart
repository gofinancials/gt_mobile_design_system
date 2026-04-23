import 'package:flutter/material.dart';

class GtTabData<T> {
  final T value;
  final String label;
  final IconData? icon;

  const GtTabData({required this.value, required this.label, this.icon});

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! GtTabData) return false;
    return value == other.value && label == other.label && icon == other.icon;
  }

  @override
  int get hashCode => Object.hash(value, label, icon);
}

class GtTabController<T> extends ChangeNotifier {
  late GtTabData<T>? _value;

  GtTabController({GtTabData<T>? initialValue}) {
    _value = initialValue;
  }

  GtTabData<T>? get value => _value;

  set value(GtTabData<T> newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  bool get hasValue => _value != null;

  @override
  void dispose() {
    _value = null;
    super.dispose();
  }
}
