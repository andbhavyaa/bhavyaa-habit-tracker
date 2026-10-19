import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_remote_datasource.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSource ds;
  HabitRepositoryImpl(this.ds);

  @override
  Stream<Either<Failure, List<Habit>>> watchHabits() => ds
      .watch()
      .map<Either<Failure, List<Habit>>>((h) => right(h))
      .transform(StreamTransformer<Either<Failure, List<Habit>>,
              Either<Failure, List<Habit>>>.fromHandlers(
          handleError: (e, _, sink) =>
              sink.add(left(ServerFailure(e.toString())))));
  Future<Either<Failure, Unit>> _guard(Future<void> Function() f) async {
    try {
      await f();
      return right(unit);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addHabit(String n, String d, int p) =>
      _guard(() => ds.add(n, d, p));
  @override
  Future<Either<Failure, Unit>> setDone(String id, DateTime day, bool done) =>
      _guard(() => ds.setDone(id, dayKey(day), done));
}
