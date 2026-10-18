import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets.dart';
import '../../domain/entities/habit.dart';
import '../cubit/habits_cubit.dart';

String _greeting() {
  final h = DateTime.now().hour;
  return h < 12
      ? 'Good morning'
      : h < 18
          ? 'Good afternoon'
          : 'Good evening';
}

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});
  @override
  Widget build(BuildContext context) => PaperBackground(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              tooltip: 'Create a new habit',
              backgroundColor: C.ink,
              foregroundColor: C.cream,
              onPressed: () => context.push('/add'),
              icon: const Icon(Icons.add),
              label: const Text('New habit')),
          body: SafeArea(
            child: BlocBuilder<HabitsCubit, HabitsState>(
              builder: (ctx, s) {
                if (s.isLoading)
                  return const Center(child: Mascot(size: 90, mood: 0));
                final err = s.errorMessage;
                if (err != null) return Center(child: Text(err));
                final habits = s.habitsOrNull ?? const <Habit>[];
                final done =
                    habits.where((h) => h.doneOn(DateTime.now())).toList();
                final pts = done.fold<int>(0, (a, h) => a + h.points);
                final total = habits.fold<int>(0, (a, h) => a + h.points);
                return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    children: [
                      Row(children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(_greeting(),
                                  style: const TextStyle(
                                      color: C.sage, fontSize: 14)),
                              const Text('Today',
                                  style: TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800)),
                            ])),
                        IconButton(
                            tooltip: 'Settings',
                            icon: const Icon(Icons.settings_outlined),
                            onPressed: () => context.push('/settings')),
                      ]),
                      const SizedBox(height: 12),
                      Appear(
                          child: _Header(
                              pts: pts,
                              total: total,
                              done: done.length,
                              count: habits.length)),
                      const SizedBox(height: 16),
                      if (habits.isEmpty)
                        const Appear(index: 1, child: _Empty())
                      else ...[
                        const Appear(
                            index: 1,
                            child: Tip(
                                icon: Icons.touch_app_outlined,
                                text:
                                    'Tap the circle to check a habit off. Tap the card to see its streak.')),
                        const SizedBox(height: 14),
                        for (var i = 0; i < habits.length; i++)
                          Appear(
                              key: ValueKey(habits[i].id),
                              index: i + 2,
                              child: _HabitTile(habit: habits[i])),
                      ],
                    ]);
              },
            ),
          ),
        ),
      );
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(children: [
          Mascot(size: 110, mood: 0),
          SizedBox(height: 12),
          Text('No habits yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 4),
          Text('Tap New habit and I\'ll cheer you on.',
              style: TextStyle(color: C.sage)),
        ]),
      );
}

class _Header extends StatelessWidget {
  final int pts, total, done, count;
  const _Header(
      {required this.pts,
      required this.total,
      required this.done,
      required this.count});

  String get _msg {
    if (count == 0) return 'Add a habit to get started!';
    if (done == 0) return 'Ready when you are!';
    if (done == count) return 'All done. You\'re on fire!';
    return '${count - done} to go. Nice progress!';
  }

  int get _mood => count == 0 ? 0 : (done == count ? 2 : 1);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: C.amber, borderRadius: BorderRadius.circular(28)),
        child: Column(children: [
          Row(children: [
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
                              fontSize: 48, fontWeight: FontWeight.w800))),
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(_msg,
                          key: ValueKey(_msg),
                          style: const TextStyle(fontWeight: FontWeight.w500))),
                ])),
            Mascot(size: 92, mood: _mood),
          ]),
          const SizedBox(height: 14),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                  tween: Tween(end: total == 0 ? 0 : pts / total),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => LinearProgressIndicator(
                      value: v,
                      minHeight: 10,
                      backgroundColor: Colors.white54,
                      color: C.ink))),
          const SizedBox(height: 6),
          Align(
              alignment: Alignment.centerRight,
              child: Text('$done of $count done',
                  style: const TextStyle(fontSize: 12))),
        ]),
      );
}

class _HabitTile extends StatelessWidget {
  final Habit habit;
  const _HabitTile({required this.habit});
  @override
  Widget build(BuildContext context) {
    final done = habit.doneOn(DateTime.now());
    return Tooltip(
      message: 'Open details and 7-day streak',
      child: GestureDetector(
        onTap: () => context.push('/habit/${habit.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
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
            CheckButton(
                done: done,
                onTap: () => context.read<HabitsCubit>().toggle(habit)),
            const SizedBox(width: 8),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Hero(
                      tag: 'habit-${habit.id}',
                      child: Material(
                          color: Colors.transparent,
                          child: Text(habit.name,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  decoration: done
                                      ? TextDecoration.lineThrough
                                      : null)))),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 16, color: C.flame),
                    const SizedBox(width: 3),
                    Text('${habit.points} pts',
                        style: const TextStyle(color: C.sage, fontSize: 13)),
                    if (habit.streak > 0) ...[
                      const SizedBox(width: 12),
                      Flame(streak: habit.streak, size: 16),
                    ],
                  ]),
                ])),
            const Icon(Icons.chevron_right, color: C.sage),
          ]),
        ),
      ),
    );
  }
}
