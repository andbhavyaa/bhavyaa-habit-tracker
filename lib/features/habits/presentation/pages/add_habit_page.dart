import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../cubit/habits_cubit.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});
  @override
  State<AddHabitPage> createState() => _S();
}
class _S extends State<AddHabitPage> {
  final _key = GlobalKey<FormState>(); final _n = TextEditingController(), _d = TextEditingController();
  double _p = 10;
  @override
  Widget build(BuildContext context) => PaperBackground(
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('New habit')),
          body: Form(key: _key, child: ListView(padding: const EdgeInsets.all(20), children: [
            TextFormField(controller: _n, decoration: const InputDecoration(labelText: 'Name', filled: true, fillColor: C.card),
                validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 14),
            TextFormField(controller: _d, maxLines: 3, decoration: const InputDecoration(labelText: 'Description', filled: true, fillColor: C.card)),
            const SizedBox(height: 20),
            Text('Points: ${_p.round()}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(value: _p, min: 5, max: 50, divisions: 9, activeColor: C.amber, onChanged: (v) => setState(() => _p = v)),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: C.ink, padding: const EdgeInsets.all(16)),
              onPressed: () async {
                if (!_key.currentState!.validate()) return;
                final ok = await context.read<HabitsCubit>().add(_n.text.trim(), _d.text.trim(), _p.round());
                if (ok && mounted) context.pop();
              },
              child: const Text('Save habit')),
          ])),
        ),
      );
}
