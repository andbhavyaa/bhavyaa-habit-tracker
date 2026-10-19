import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/failure.dart';
import 'package:habit_tracker/core/widgets.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:habit_tracker/features/habits/domain/usecases/usecases.dart';
import 'package:habit_tracker/features/habits/presentation/cubit/habits_cubit.dart';
import 'package:habit_tracker/features/habits/presentation/pages/today_page.dart';
import 'package:mocktail/mocktail.dart';

class MockWatch extends Mock implements WatchHabits {}

class MockAdd extends Mock implements AddHabit {}

class MockSet extends Mock implements SetHabitDone {}

void main() {
  late MockWatch watch;
  late MockAdd add;
  late MockSet set;
  const habit =
      Habit(id: '1', name: 'Drink water', description: '', points: 10);

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    watch = MockWatch();
    add = MockAdd();
    set = MockSet();
    when(() => set(any(), any(), any()))
        .thenAnswer((_) async => right<Failure, Unit>(unit));
  });

  Future<void> pumpPage(WidgetTester t,
      [Either<Failure, List<Habit>>? first]) async {
    final ctrl = StreamController<Either<Failure, List<Habit>>>();
    when(() => watch()).thenAnswer((_) => ctrl.stream);
    final cubit = HabitsCubit(watch, add, set);
    addTearDown(() async {
      await cubit.close();
      await ctrl.close();
    });
    await t.pumpWidget(MaterialApp(
      home: BlocProvider<HabitsCubit>.value(
          value: cubit, child: const TodayPage()),
    ));
    if (first != null) ctrl.add(first);
    // The mascot animates forever, so pumpAndSettle would never finish.
    await t.pump(const Duration(seconds: 1));
  }

  testWidgets('shows the mascot while loading', (t) async {
    await pumpPage(t);
    expect(find.byType(Mascot), findsOneWidget);
    expect(find.text('Drink water'), findsNothing);
  });

  testWidgets('shows the empty state with no habits', (t) async {
    await pumpPage(t, right([]));
    expect(find.text('No habits yet'), findsOneWidget);
  });

  testWidgets('lists habits with their points', (t) async {
    await pumpPage(t, right([habit]));
    expect(find.text('Drink water'), findsOneWidget);
    expect(find.text('10 pts'), findsOneWidget);
    expect(find.text('0 of 1 done'), findsOneWidget);
  });

  testWidgets('tapping the check circle toggles the habit', (t) async {
    await pumpPage(t, right([habit]));
    await t.tap(find.byType(CheckButton));
    await t.pump();
    verify(() => set('1', any(), true)).called(1);
  });

  testWidgets('shows the error message', (t) async {
    await pumpPage(t, left(const ServerFailure('Something broke')));
    expect(find.text('Something broke'), findsOneWidget);
  });
}
