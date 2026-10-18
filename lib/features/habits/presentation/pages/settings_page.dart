import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => PaperBackground(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('Settings')),
          body: ListView(padding: const EdgeInsets.all(20), children: [
            const Appear(
                child: Row(children: [
              Mascot(size: 64, mood: 1),
              SizedBox(width: 12),
              Expanded(
                  child: Text('How do you want to journal your habits today?',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
            ])),
            const SizedBox(height: 10),
            const Text(
                'Pick the page you like writing on. You can switch any time.',
                style: TextStyle(color: C.sage)),
            const SizedBox(height: 22),
            ValueListenableBuilder<PaperMode>(
              valueListenable: paperMode,
              builder: (_, m, __) => Row(children: [
                for (final mode in PaperMode.values)
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _Option(mode: mode, selected: m == mode))),
              ]),
            ),
          ]),
        ),
      );
}

class _Option extends StatelessWidget {
  final PaperMode mode;
  final bool selected;
  const _Option({required this.mode, required this.selected});

  String get _label => switch (mode) {
        PaperMode.plain => 'Plain page',
        PaperMode.grid => 'Square grid',
        PaperMode.dots => 'Dot grid',
      };
  String get _sub => switch (mode) {
        PaperMode.plain => 'Clean and calm',
        PaperMode.grid => 'Neat and tidy',
        PaperMode.dots => 'Free-flowing',
      };

  @override
  Widget build(BuildContext context) => Tooltip(
        message: 'Use a $_label background',
        child: GestureDetector(
          onTap: () => paperMode.value = mode,
          child: AnimatedScale(
            scale: selected ? 1.04 : 1,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: C.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: selected ? C.ink : C.sage.withValues(alpha: .3),
                      width: selected ? 2.5 : 1)),
              child: Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                        height: 110,
                        width: double.infinity,
                        child:
                            CustomPaint(painter: PaperPainter(mode, gap: 12)))),
                const SizedBox(height: 8),
                Text(_label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
                Text(_sub, style: const TextStyle(color: C.sage, fontSize: 11)),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        key: ValueKey(selected),
                        size: 20,
                        color: selected ? C.ink : C.sage)),
              ]),
            ),
          ),
        ),
      );
}
