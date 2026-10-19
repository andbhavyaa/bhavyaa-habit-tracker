import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';

String _ago(int n) {
  final t = DateTime.now();
  return dayKey(DateTime(t.year, t.month, t.day - n));
}

Habit _habit([List<int> daysAgo = const []]) => Habit(
    id: '1',
    name: 'Read',
    description: '',
    points: 20,
    completedDates: daysAgo.map(_ago).toList());

void main() {
  group('dayKey', () {
    test('zero-pads month and day', () {
      expect(dayKey(DateTime(2026, 3, 5)), '2026-03-05');
    });
    test('does not pad two-digit values', () {
      expect(dayKey(DateTime(2026, 12, 25)), '2026-12-25');
    });
  });

  group('doneOn', () {
    test('true only for dates in completedDates', () {
      final h = _habit([0]);
      expect(h.doneOn(DateTime.now()), true);
      expect(h.doneOn(DateTime.now().subtract(const Duration(days: 1))), false);
    });
  });

  group('last7', () {
    test('has 7 entries, oldest first, ending today', () {
      final w = _habit().last7;
      expect(w.length, 7);
      expect(dayKey(w.last.key), dayKey(DateTime.now()));
      for (var i = 1; i < w.length; i++) {
        expect(w[i].key.isAfter(w[i - 1].key), true);
      }
    });
    test('marks completed days', () {
      final w = _habit([0, 2]).last7;
      expect(w[6].value, true); // today
      expect(w[5].value, false); // yesterday
      expect(w[4].value, true); // 2 days ago
    });
    test('ignores completions older than 7 days', () {
      expect(_habit([10]).last7.every((e) => !e.value), true);
    });
  });

  group('streak', () {
    test('is 0 with no completions', () => expect(_habit().streak, 0));
    test('counts consecutive days including today',
        () => expect(_habit([0, 1, 2]).streak, 3));
    test('keeps the streak alive if only today is missing',
        () => expect(_habit([1, 2, 3]).streak, 3));
    test('breaks on a gap', () => expect(_habit([0, 1, 3, 4]).streak, 2));
    test('is 0 if both today and yesterday are missing',
        () => expect(_habit([2, 3]).streak, 0));
    test('works across long runs', () {
      expect(_habit(List.generate(40, (i) => i)).streak, 40);
    });
  });
}
