import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme.dart';
import '../cubit/habits_cubit.dart';

class HabitDetailPage extends StatelessWidget {
  final String id;
  const HabitDetailPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) => PaperBackground(
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: BlocBuilder<HabitsCubit, HabitsState>(builder: (ctx, s) {
            final h = s.maybeWhen(loaded: (l) => l.where((e) => e.id == id).firstOrNull, orElse: () => null);
            if (h == null) return const Center(child: CircularProgressIndicator(color: C.amber));
            final done = h.doneOn(DateTime.now());
            return Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Hero(tag: 'habit-$id', child: Material(color: Colors.transparent,
                  child: Text(h.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700)))),
              const SizedBox(height: 8),
              Text(h.description.isEmpty ? 'No description' : h.description, style: const TextStyle(color: C.sage, fontSize: 16)),
              const SizedBox(height: 8),
              Chip(label: Text('${h.points} points'), backgroundColor: C.peach),
              const SizedBox(height: 28),
              const Text('LAST 7 DAYS', style: TextStyle(letterSpacing: 2, fontSize: 12)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                for (final e in h.last7) _Day(date: e.key, done: e.value),
              ]),
              const Spacer(),
              SizedBox(width: double.infinity, child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: done ? C.sage : C.ink, padding: const EdgeInsets.all(18)),
                onPressed: () => context.read<HabitsCubit>().toggle(h),
                child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: Text(done ? 'Mark today undone' : 'Mark today done', key: ValueKey(done))))),
            ]));
          }),
        ),
      );
}
class _Day extends StatelessWidget {
  final DateTime date; final bool done;
  const _Day({required this.date, required this.done});
  @override
  Widget build(BuildContext context) => Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400), curve: Curves.easeOutBack, width: 40, height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: done ? C.amber : C.card, border: Border.all(color: C.sage.withOpacity(.4))),
          child: done ? const Icon(Icons.check, size: 20) : null),
        const SizedBox(height: 6),
        Text('MTWTFSS'[date.weekday - 1], style: const TextStyle(fontSize: 12)),
      ]);
}
