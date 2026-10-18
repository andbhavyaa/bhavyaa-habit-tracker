import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';

String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

@freezed
abstract class Habit with _$Habit {
  const Habit._();
  const factory Habit({
    required String id,
    required String name,
    required String description,
    required int points,
    @Default([]) List<String> completedDates,
  }) = _Habit;
  bool doneOn(DateTime d) => completedDates.contains(dayKey(d));

  /// Oldest -> today, last 7 days.
  List<MapEntry<DateTime, bool>> get last7 {
    final t = DateTime.now();
    return List.generate(7, (i) {
      final d = DateTime(t.year, t.month, t.day - (6 - i));
      return MapEntry(d, doneOn(d));
    });
  }

  /// Consecutive days done, counting back from today (or yesterday if today isn't done yet).
  int get streak {
    var d = DateTime.now();
    if (!doneOn(d)) d = DateTime(d.year, d.month, d.day - 1);
    var n = 0;
    while (doneOn(d)) {
      n++;
      d = DateTime(d.year, d.month, d.day - 1);
    }
    return n;
  }
}
