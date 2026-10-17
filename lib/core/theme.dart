import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class C {
  static const cream = Color(0xFFFFF4DE), peach = Color(0xFFFFDDA6), amber = Color(0xFFFFBE5C),
      sage = Color(0xFF8C8C74), ink = Color(0xFF2B2622), card = Color(0xFFFFFBF2);
}
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.transparent,
  colorScheme: ColorScheme.fromSeed(seedColor: C.amber, surface: C.cream),
  fontFamily: 'Poppins',
  textTheme: ThemeData.light().textTheme.apply(bodyColor: C.ink, displayColor: C.ink),
);

enum PaperMode { plain, grid, dots }
final paperMode = ValueNotifier<PaperMode>(PaperMode.grid);

/// Cream paper background; style switchable from settings.
class PaperBackground extends StatelessWidget {
  final Widget child;
  const PaperBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<PaperMode>(
        valueListenable: paperMode,
        builder: (_, m, __) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: CustomPaint(key: ValueKey(m), painter: _Paper(m), child: SizedBox.expand(child: child)),
        ),
      );
}
class _Paper extends CustomPainter {
  final PaperMode m;
  _Paper(this.m);
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = C.cream);
    final p = Paint()..color = C.sage.withOpacity(.25)..strokeWidth = 1;
    const g = 24.0;
    if (m == PaperMode.grid) {
      for (double x = 0; x < s.width; x += g) c.drawLine(Offset(x, 0), Offset(x, s.height), p);
      for (double y = 0; y < s.height; y += g) c.drawLine(Offset(0, y), Offset(s.width, y), p);
    } else if (m == PaperMode.dots) {
      for (double x = g / 2; x < s.width; x += g) for (double y = g / 2; y < s.height; y += g) c.drawCircle(Offset(x, y), 1.2, p);
    }
  }
  @override
  bool shouldRepaint(_Paper o) => o.m != m;
}
