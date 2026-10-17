import 'package:dartz/dartz.dart';
import '../../../../core/failure.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class WatchHabits { final HabitRepository r; WatchHabits(this.r); Stream<Either<Failure, List<Habit>>> call() => r.watchHabits(); }
class AddHabit { final HabitRepository r; AddHabit(this.r); Future<Either<Failure, Unit>> call(String n, String d, int p) => r.addHabit(n, d, p); }
class SetHabitDone { final HabitRepository r; SetHabitDone(this.r); Future<Either<Failure, Unit>> call(String id, DateTime day, bool done) => r.setDone(id, day, done); }
