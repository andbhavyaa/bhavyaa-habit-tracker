import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/habit.dart';
import '../../domain/usecases/usecases.dart';

part 'habits_cubit.freezed.dart';

@freezed
class HabitsState with _$HabitsState {
  const factory HabitsState.loading() = _Loading;
  const factory HabitsState.loaded(List<Habit> habits) = _Loaded;
  const factory HabitsState.error(String message) = _Error;
}

class HabitsCubit extends Cubit<HabitsState> {
  final WatchHabits _watch;
  final AddHabit _add;
  final SetHabitDone _set;
  StreamSubscription? _sub;
  HabitsCubit(this._watch, this._add, this._set)
      : super(const HabitsState.loading()) {
    _sub = _watch().listen((r) => r.fold(
        (f) => emit(HabitsState.error(f.message)),
        (h) => emit(HabitsState.loaded(h))));
  }
  Future<bool> add(String n, String d, int p) async =>
      (await _add(n, d, p)).isRight();
  Future<void> toggle(Habit h, [DateTime? day]) {
    final d = day ?? DateTime.now();
    return _set(h.id, d, !h.doneOn(d));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
