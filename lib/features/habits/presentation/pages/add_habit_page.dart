import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets.dart';
import '../cubit/habits_cubit.dart';

class _Tier {
  final String label, hint;
  final int pts;
  final IconData icon;
  const _Tier(this.label, this.pts, this.icon, this.hint);
}

const _tiers = [
  _Tier('Easy', 5, Icons.eco_outlined, 'A quick win'),
  _Tier('Medium', 10, Icons.directions_walk, 'Takes some effort'),
  _Tier('Hard', 20, Icons.fitness_center, 'Real commitment'),
  _Tier('Epic', 30, Icons.emoji_events_outlined, 'Go big'),
];
const _ideas = [
  'Drink water',
  'Read 20 pages',
  'Walk 30 min',
  'Stretch',
  'Meditate'
];

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});
  @override
  State<AddHabitPage> createState() => _S();
}

class _S extends State<AddHabitPage> {
  final _key = GlobalKey<FormState>();
  final _n = TextEditingController(), _d = TextEditingController();
  int _p = 10;
  bool _saving = false;

  @override
  void dispose() {
    _n.dispose();
    _d.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, String hint) => InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: C.card,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none));

  Widget _tile(_Tier t) {
    final sel = _p == t.pts;
    return Tooltip(
      message: '${t.hint}. Earn ${t.pts} points.',
      child: GestureDetector(
        onTap: () => setState(() => _p = t.pts),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
              color: sel ? C.amber : C.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: sel ? C.ink : C.sage.withValues(alpha: .3),
                  width: sel ? 2 : 1)),
          child: Row(children: [
            Icon(t.icon, color: C.ink),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(t.label,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('${t.pts} pts', style: const TextStyle(fontSize: 12)),
                ])),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PaperBackground(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('New habit')),
          body: Form(
            key: _key,
            child: ListView(padding: const EdgeInsets.all(20), children: [
              const Appear(
                  child: Row(children: [
                Mascot(size: 64, mood: 1),
                SizedBox(width: 12),
                Expanded(
                    child: Text('What habit do you want to build?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700))),
              ])),
              const SizedBox(height: 16),
              Appear(
                  index: 1,
                  child: TextFormField(
                      controller: _n,
                      decoration: _dec('Name', 'Drink 2L water'),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? 'Give your habit a name'
                          : null)),
              const SizedBox(height: 8),
              Appear(
                  index: 2,
                  child: Wrap(spacing: 8, children: [
                    for (final i in _ideas)
                      ActionChip(
                          label: Text(i),
                          backgroundColor: C.peach,
                          side: BorderSide.none,
                          onPressed: () => setState(() => _n.text = i)),
                  ])),
              const SizedBox(height: 12),
              Appear(
                  index: 3,
                  child: TextFormField(
                      controller: _d,
                      maxLines: 2,
                      decoration: _dec('Description (optional)',
                          'Why does it matter to you?'))),
              const SizedBox(height: 22),
              const Appear(
                  index: 4,
                  child: Text('How hard is it?',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700))),
              const SizedBox(height: 2),
              const Text('Harder habits earn more points when you finish them.',
                  style: TextStyle(color: C.sage, fontSize: 13)),
              const SizedBox(height: 12),
              Appear(
                  index: 5,
                  child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [for (final t in _tiers) _tile(t)])),
              const SizedBox(height: 12),
              Center(
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text('Finish it and earn $_p points',
                          key: ValueKey(_p),
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)))),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: C.ink, padding: const EdgeInsets.all(16)),
                onPressed: _saving
                    ? null
                    : () async {
                        if (!_key.currentState!.validate()) return;
                        setState(() => _saving = true);
                        final ok = await context
                            .read<HabitsCubit>()
                            .add(_n.text.trim(), _d.text.trim(), _p);
                        if (!mounted) return;
                        if (ok) {
                          context.pop();
                        } else {
                          setState(() => _saving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Couldn\'t save your habit. Try again.')));
                        }
                      },
                child: const Text('Save habit'),
              ),
            ]),
          ),
        ),
      );
}
