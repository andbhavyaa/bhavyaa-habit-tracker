import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets.dart';
import '../../domain/entities/habit.dart';
import '../cubit/habits_cubit.dart';

const _names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class HabitDetailPage extends StatelessWidget {
  final String id;
  const HabitDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) => PaperBackground(
        child: BlocBuilder<HabitsCubit, HabitsState>(builder: (ctx, s) {
          final h = s.habitsOrNull?.where((e) => e.id == id).firstOrNull;
          if (h == null) {
            return Scaffold(
                appBar: AppBar(backgroundColor: Colors.transparent),
                body: const Center(child: Mascot(size: 90, mood: 0)));
          }
          final done = h.doneOn(DateTime.now());
          final week = h.last7;
          final count = week.where((e) => e.value).length;
          final msg = done
              ? 'Nice work today!'
              : h.streak > 0
                  ? 'Finish today to keep your ${h.streak}-day streak!'
                  : 'Finish it today to start a streak!';
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: ListView(padding: const EdgeInsets.all(20), children: [
              Hero(
                  tag: 'habit-$id',
                  child: Material(
                      color: Colors.transparent,
                      child: Text(h.name,
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w800)))),
              const SizedBox(height: 6),
              Text(h.description.isEmpty ? 'No description' : h.description,
                  style: const TextStyle(color: C.sage, fontSize: 16)),
              const SizedBox(height: 14),
              Appear(
                  child: Row(children: [
                Tooltip(
                    message: 'Points you earn each time you finish this habit',
                    child: Chip(
                        avatar: const Icon(Icons.star_rounded,
                            size: 18, color: C.flame),
                        label: Text('${h.points} points'),
                        backgroundColor: C.peach,
                        side: BorderSide.none)),
                const SizedBox(width: 12),
                Tooltip(
                    message: 'Days in a row you\'ve finished this habit',
                    child: Flame(streak: h.streak, size: 28)),
              ])),
              const SizedBox(height: 16),
              Appear(
                  index: 1,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: C.amber.withValues(alpha: .35),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      Mascot(size: 64, mood: done ? 2 : 1),
                      const SizedBox(width: 12),
                      Expanded(
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(msg,
                                  key: ValueKey(msg),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)))),
                    ]),
                  )),
              const SizedBox(height: 22),
              Row(children: const [
                Text('LAST 7 DAYS',
                    style: TextStyle(letterSpacing: 2, fontSize: 12)),
                SizedBox(width: 6),
                Tooltip(
                    message:
                        'Each circle is a day. Filled means you finished it.',
                    child: Icon(Icons.info_outline, size: 16, color: C.sage)),
              ]),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                    color: C.card, borderRadius: BorderRadius.circular(20)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = 0; i < week.length; i++)
                        Appear(
                            index: i,
                            child:
                                _Day(date: week[i].key, done: week[i].value)),
                    ]),
              ),
              const SizedBox(height: 10),
              Center(
                  child: Text('$count of 7 days done',
                      style: const TextStyle(color: C.sage))),
              const SizedBox(height: 90),
            ]),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: done ? C.sage : C.ink,
                      padding: const EdgeInsets.all(18)),
                  onPressed: () => context.read<HabitsCubit>().toggle(h),
                  icon: Icon(done ? Icons.undo : Icons.check),
                  label: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                          done ? 'Mark today undone' : 'Mark today done',
                          key: ValueKey(done))),
                ),
              ),
            ),
          );
        }),
      );
}

class _Day extends StatelessWidget {
  final DateTime date;
  final bool done;
  const _Day({required this.date, required this.done});
  @override
  Widget build(BuildContext context) {
    final today = dayKey(date) == dayKey(DateTime.now());
    return Tooltip(
      message:
          '${_names[date.weekday - 1]} ${date.day}: ${done ? 'done' : 'not done'}',
      child: Column(children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? C.amber : Colors.transparent,
                border: Border.all(
                    color: today ? C.ink : C.sage.withValues(alpha: .4),
                    width: today ? 2 : 1)),
            child: done ? const Icon(Icons.check, size: 18) : null),
        const SizedBox(height: 6),
        Text(today ? 'Today' : _names[date.weekday - 1],
            style: TextStyle(
                fontSize: 11,
                fontWeight: today ? FontWeight.w700 : FontWeight.w400)),
      ]),
    );
  }
}
