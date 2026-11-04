import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  final today = DateTime.now().startOfDay;

  /// Returns [date] moved by [days] calendar days.
  DateTime shift(DateTime date, int days) {
    return DateTime(date.year, date.month, date.day + days);
  }

  /// Creates a controller for [minAge] and [maxAge], disposed after the test.
  GtDobController controllerFor(int minAge, int maxAge, [DateTime? dob]) {
    final dobCtrl = GtDobController(minAge: minAge, maxAge: maxAge, dob: dob);
    addTearDown(dobCtrl.dispose);
    return dobCtrl;
  }

  /// Returns the years offered by [controller].
  List<int> yearsOf(GtDobController controller) {
    return controller.yearSuggestions.mapList((it) => it.value);
  }

  group('GtDobController bounds', () {
    test('minDate is the latest date that is minAge years old', () {
      final minDate = controllerFor(6, 18).minDate;
      final dayAfter = shift(minDate, 1);

      expect(minDate.yearsUntil(today), 6);
      expect(dayAfter.yearsUntil(today), 5);
    });

    test('maxDate is the oldest date still under maxAge', () {
      final maxDate = controllerFor(6, 18).maxDate;
      final dayBefore = shift(maxDate, -1);

      expect(maxDate.yearsUntil(today), 17);
      expect(dayBefore.yearsUntil(today), 18);
    });
  });

  group('GtDobController.yearSuggestions', () {
    test('runs through the current year when minAge is 0', () {
      final years = yearsOf(controllerFor(0, 18));
      final oldestYears = [today.year - 18, today.year - 17];

      expect(years.last, today.year);
      expect(oldestYears, contains(years.first));
    });

    test('runs from the oldest to the latest eligible year', () {
      final controller = controllerFor(6, 18);
      final years = yearsOf(controller);
      final expectedCount = years.last - years.first + 1;

      expect(years.first, controller.maxDate.year);
      expect(years.last, today.year - 6);
      expect(years.length, expectedCount);
    });
  });

  group('GtDobController.hasValidDate', () {
    test('accepts a newborn born today and rejects tomorrow', () {
      final tomorrow = shift(today, 1);

      expect(controllerFor(0, 18, today).hasValidDate, isTrue);
      expect(controllerFor(0, 18, tomorrow).hasValidDate, isFalse);
    });

    test('treats maxAge as exclusive', () {
      final oldestDate = controllerFor(0, 18).maxDate;
      final tooOldDate = shift(oldestDate, -1);

      expect(controllerFor(0, 18, oldestDate).hasValidDate, isTrue);
      expect(controllerFor(0, 18, tooOldDate).hasValidDate, isFalse);
    });

    test('treats minAge as inclusive', () {
      final youngestDate = controllerFor(6, 18).minDate;
      final tooYoungDate = shift(youngestDate, 1);

      expect(controllerFor(6, 18, youngestDate).hasValidDate, isTrue);
      expect(controllerFor(6, 18, tooYoungDate).hasValidDate, isFalse);
    });
  });

  group('GtDobController.age', () {
    test('counts calendar years birthday to birthday', () {
      final birthday = DateTime(today.year - 10, 1, 1);
      final notYetBirthday = DateTime(today.year - 10, 12, 31);
      final isNewYearsEve = today.month == 12 && today.day == 31;
      final expectedAge = isNewYearsEve ? 10 : 9;

      expect(controllerFor(0, 18, birthday).age, 10);
      expect(controllerFor(0, 18, notYetBirthday).age, expectedAge);
    });
  });
}
