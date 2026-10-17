import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'features/habits/data/datasources/habit_remote_datasource.dart';
import 'features/habits/data/repositories/habit_repository_impl.dart';
import 'features/habits/domain/repositories/habit_repository.dart';
import 'features/habits/domain/usecases/usecases.dart';
import 'features/habits/presentation/cubit/habits_cubit.dart';

final sl = GetIt.instance;
void initDi() {
  sl.registerLazySingleton(() => HabitRemoteDataSource(FirebaseFirestore.instance));
  sl.registerLazySingleton<HabitRepository>(() => HabitRepositoryImpl(sl()));
  sl.registerLazySingleton(() => WatchHabits(sl()));
  sl.registerLazySingleton(() => AddHabit(sl()));
  sl.registerLazySingleton(() => SetHabitDone(sl()));
  sl.registerLazySingleton(() => HabitsCubit(sl(), sl(), sl()));
}
