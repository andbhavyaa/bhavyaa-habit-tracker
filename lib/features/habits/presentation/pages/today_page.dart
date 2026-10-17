import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme.dart';
import '../../domain/entities/habit.dart';
import '../cubit/habits_cubit.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});
  @override
  Widget build(BuildContext context) => PaperBackground(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: C.amber,
              foregroundColor: C.ink,
              onPressed: () => context.push('/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add habit')),
          body: SafeArea(
            child: BlocBuilder<HabitsCubit, HabitsState>(
              builder: (ctx, s) => s.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: C.amber)),
                error: (m) => Center(child: Text(m)),
                loaded: (habits) {
                  final done =
                      habits.where((h) => h.doneOn(DateTime.now())).toList();
                  final pts = done.fold<int>(0, (a, h) => a + h.points);
                  final total = habits.fold<int>(0, (a, h) => a + h.points);
                  return ListView(padding: const EdgeInsets.all(20), children: [
                    Row(children: [
                      const Expanded(
                          child: Text('Today',
                              style: TextStyle(
                                  fontSize: 38, fontWeight: FontWeight.w700))),
                      IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () => _settings(ctx)),
                    ]),
                    const SizedBox(height: 12),
                    _Header(
                        pts: pts,
                        total: total,
                        done: done.length,
                        count: habits.length),
                    const SizedBox(height: 16),
                    if (habits.isEmpty)
                      const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                              child: Text(
                                  'No habits yet — add your first one ☀️'))),
                    for (var i = 0; i < habits.length; i++)
                      TweenAnimationBuilder<double>(
                        key: ValueKey(habits[i].id),
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + i * 80),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, child) => Opacity(
                            opacity: v,
                            child: Transform.translate(
                                offset: Offset(0, 24 * (1 - v)), child: child)),
                        child: _HabitTile(habit: habits[i]),
                      ),
                    const SizedBox(height: 80),
                  ]);
                },
              ),
            ),
          ),
        ),
      );

  void _settings(BuildContext context) => showModalBottomSheet(
        context: context,
        backgroundColor: C.card,
        builder: (_) => Padding(
            padding: const EdgeInsets.all(24),
            child: ValueListenableBuilder<PaperMode>(
              valueListenable: paperMode,
              builder: (_, m, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Background',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    SegmentedButton<PaperMode>(segments: const [
                      ButtonSegment(
                          value: PaperMode.plain, label: Text('Plain')),
                      ButtonSegment(value: PaperMode.grid, label: Text('Grid')),
                      ButtonSegment(value: PaperMode.dots, label: Text('Dots')),
                    ], selected: {
                      m
                    }, onSelectionChanged: (s) => paperMode.value = s.first),
                  ]),
            )),
      );
}

class _Header extends StatelessWidget {
  final int pts, total, done, count;
  const _Header(
      {required this.pts,
      required this.total,
      required this.done,
      required this.count});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: C.amber, borderRadius: BorderRadius.circular(28)),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('POINTS TODAY',
                    style: TextStyle(letterSpacing: 2, fontSize: 12)),
                TweenAnimationBuilder<double>(
                    tween: Tween(end: pts.toDouble()),
                    duration: const Duration(milliseconds: 600),
                    builder: (_, v, __) => Text('${v.round()}',
                        style: const TextStyle(
                            fontSize: 44, fontWeight: FontWeight.w800))),
                Text('$done of $count habits done'),
              ])),
          SizedBox(
              width: 72,
              height: 72,
              child: TweenAnimationBuilder<double>(
                  tween: Tween(end: total == 0 ? 0 : pts / total),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => CircularProgressIndicator(
                      value: v,
                      strokeWidth: 9,
                      backgroundColor: Colors.white54,
                      color: C.ink))),
        ]),
      );
}

class _HabitTile extends StatelessWidget {
  final Habit habit;
  const _HabitTile({required this.habit});
  @override
  Widget build(BuildContext context) {
    final done = habit.doneOn(DateTime.now());
    return Hero(
      tag: 'habit-${habit.id}',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => context.push('/habit/${habit.id}'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: done ? C.peach : C.card,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                      color: C.amber.withValues(alpha: .25),
                      blurRadius: 14,
                      offset: const Offset(0, 6))
                ]),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(habit.name,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            decoration:
                                done ? TextDecoration.lineThrough : null)),
                    Text('${habit.points} pts',
                        style: const TextStyle(color: C.sage)),
                  ])),
              GestureDetector(
                onTap: () => context.read<HabitsCubit>().toggle(habit),
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (c, a) =>
                        ScaleTransition(scale: a, child: c),
                    child: Icon(
                        done ? Icons.check_circle : Icons.circle_outlined,
                        key: ValueKey(done),
                        size: 34,
                        color: done ? C.ink : C.sage)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
