import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/failure.dart';
import 'package:habit_tracker/features/habits/data/datasources/habit_remote_datasource.dart';
import 'package:habit_tracker/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:mocktail/mocktail.dart';

class MockDs extends Mock implements HabitRemoteDataSource {}

void main() {
  late MockDs ds;
  late HabitRepositoryImpl repo;
  const habit = Habit(id: '1', name: 'Read', description: '', points: 20);

  setUp(() {
    ds = MockDs();
    repo = HabitRepositoryImpl(ds);
  });

  group('watchHabits', () {
    test('wraps data in Right', () async {
      when(() => ds.watch()).thenAnswer((_) => Stream.value([habit]));
      final r = await repo.watchHabits().first;
      expect(r.isRight(), true);
      expect(r.getOrElse(() => []), [habit]);
    });

    test('turns a stream error into Left(ServerFailure)', () async {
      when(() => ds.watch()).thenAnswer((_) => Stream.error(Exception('boom')));
      final r = await repo.watchHabits().first;
      expect(r.isLeft(), true);
      expect(r.fold((f) => f, (_) => null), isA<ServerFailure>());
    });
  });

  group('addHabit', () {
    test('returns Right(unit) on success', () async {
      when(() => ds.add('n', 'd', 10)).thenAnswer((_) async {});
      expect(await repo.addHabit('n', 'd', 10), right<Failure, Unit>(unit));
      verify(() => ds.add('n', 'd', 10)).called(1);
    });

    test('returns Left(ServerFailure) when the data source throws', () async {
      when(() => ds.add(any(), any(), any())).thenThrow(Exception('offline'));
      final r = await repo.addHabit('n', 'd', 10);
      expect(r.fold((f) => f, (_) => null), isA<ServerFailure>());
    });
  });

  group('setDone', () {
    test('passes the ISO day key to the data source', () async {
      when(() => ds.setDone(any(), any(), any())).thenAnswer((_) async {});
      final r = await repo.setDone('1', DateTime(2026, 10, 19), true);
      expect(r.isRight(), true);
      verify(() => ds.setDone('1', '2026-10-19', true)).called(1);
    });

    test('returns Left when the data source throws', () async {
      when(() => ds.setDone(any(), any(), any())).thenThrow(Exception('x'));
      final r = await repo.setDone('1', DateTime.now(), false);
      expect(r.isLeft(), true);
    });
  });
}
