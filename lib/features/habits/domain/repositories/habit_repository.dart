import 'package:dartz/dartz.dart';
import '../../../../core/failure.dart';
import '../entities/habit.dart';

abstract class HabitRepository {
  Stream<Either<Failure, List<Habit>>> watchHabits();
  Future<Either<Failure, Unit>> addHabit(String name, String description, int points);
  Future<Either<Failure, Unit>> setDone(String id, DateTime day, bool done);
}
