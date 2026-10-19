import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/failure.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:habit_tracker/features/habits/domain/usecases/usecases.dart';
import 'package:habit_tracker/features/habits/presentation/cubit/habits_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockWatch extends Mock implements WatchHabits {}

class MockAdd extends Mock implements AddHabit {}

class MockSet extends Mock implements SetHabitDone {}

void main() {
  late MockWatch watch;
  late MockAdd add;
  late MockSet set;
  late StreamController<Either<Failure, List<Habit>>> ctrl;
  late HabitsCubit cubit;

  const habit = Habit(id: '1', name: 'Read', description: '', points: 20);
  final doneToday = Habit(
      id: '2',
      name: 'Run',
      description: '',
      points: 10,
      completedDates: [dayKey(DateTime.now())]);

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    watch = MockWatch();
    add = MockAdd();
    set = MockSet();
    ctrl = StreamController<Either<Failure, List<Habit>>>();
    when(() => watch()).thenAnswer((_) => ctrl.stream);
    when(() => set(any(), any(), any()))
        .thenAnswer((_) async => right<Failure, Unit>(unit));
    cubit = HabitsCubit(watch, add, set);
  });

  tearDown(() async {
    await cubit.close();
    await ctrl.close();
  });

  test('starts in loading', () {
    expect(cubit.state, const HabitsState.loading());
    expect(cubit.state.isLoading, true);
  });

  test('emits loaded when the stream emits habits', () async {
    final states = <HabitsState>[];
    final sub = cubit.stream.listen(states.add);
    ctrl.add(right([habit]));
    await flush();
    expect(states, [
      const HabitsState.loaded([habit])
    ]);
    expect(cubit.state.habitsOrNull, [habit]);
    await sub.cancel();
  });

  test('emits error when the stream emits a failure', () async {
    final states = <HabitsState>[];
    final sub = cubit.stream.listen(states.add);
    ctrl.add(left(const ServerFailure('nope')));
    await flush();
    expect(states, [const HabitsState.error('nope')]);
    expect(cubit.state.errorMessage, 'nope');
    await sub.cancel();
  });

  test('keeps updating when new data arrives', () async {
    ctrl.add(right([habit]));
    await flush();
    ctrl.add(right([habit, doneToday]));
    await flush();
    expect(cubit.state.habitsOrNull, [habit, doneToday]);
  });

  group('add', () {
    test('returns true on success', () async {
      when(() => add('n', 'd', 10))
          .thenAnswer((_) async => right<Failure, Unit>(unit));
      expect(await cubit.add('n', 'd', 10), true);
    });

    test('returns false on failure', () async {
      when(() => add(any(), any(), any())).thenAnswer(
          (_) async => left<Failure, Unit>(const ServerFailure('x')));
      expect(await cubit.add('n', 'd', 10), false);
    });
  });

  group('toggle', () {
    test('marks an undone habit as done', () async {
      await cubit.toggle(habit);
      verify(() => set('1', any(), true)).called(1);
    });

    test('marks a done habit as undone', () async {
      await cubit.toggle(doneToday);
      verify(() => set('2', any(), false)).called(1);
    });

    test('uses the given day when provided', () async {
      final day = DateTime(2026, 1, 5);
      await cubit.toggle(habit, day);
      verify(() => set('1', day, true)).called(1);
    });
  });
}
