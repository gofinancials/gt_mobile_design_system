import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/widgets/molecules/tiles/gt_info_tiles.dart';

void main() {
  group('GtDoubleColumnListTile assertions', () {
    test('allows creation when highlightValue is true and styles are null', () {
      expect(
        () => GtDoubleColumnListTile(
          'Label',
          value: 'Value',
          highlightValue: true,
          valueTextStyle: null,
          labelTextStyle: null,
        ),
        returnsNormally,
      );
    });

    test(
      'allows creation when highlightValue is true and styles are not null',
      () {
        expect(
          () => GtDoubleColumnListTile(
            'Label',
            value: 'Value',
            highlightValue: true,
            valueTextStyle: const TextStyle(fontSize: 12),
            labelTextStyle: const TextStyle(fontSize: 12),
          ),
          returnsNormally,
        );
      },
    );

    test(
      'allows creation when highlightValue is false and styles are null',
      () {
        expect(
          () => GtDoubleColumnListTile(
            'Label',
            value: 'Value',
            highlightValue: false,
            valueTextStyle: null,
            labelTextStyle: null,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'throws AssertionError when highlightValue is false and valueTextStyle is not null',
      () {
        expect(
          () => GtDoubleColumnListTile(
            'Label',
            value: 'Value',
            highlightValue: false,
            valueTextStyle: const TextStyle(fontSize: 12),
            labelTextStyle: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      'throws AssertionError when highlightValue is false and labelTextStyle is not null',
      () {
        expect(
          () => GtDoubleColumnListTile(
            'Label',
            value: 'Value',
            highlightValue: false,
            valueTextStyle: null,
            labelTextStyle: const TextStyle(fontSize: 12),
          ),
          throwsAssertionError,
        );
      },
    );
  });
}
