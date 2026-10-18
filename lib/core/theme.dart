import 'package:flutter/material.dart';

class C {
  static const cream = Color(0xFFFFF4DE),
      peach = Color(0xFFFFDDA6),
      amber = Color(0xFFFFBE5C),
      sage = Color(0xFF8C8C74),
      ink = Color(0xFF2B2622),
      card = Color(0xFFFFFBF2),
      flame = Color(0xFFFF8A1F),
      flameCore = Color(0xFFFFD34E),
      blush = Color(0xFFFFB199);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.transparent,
  colorScheme: ColorScheme.fromSeed(seedColor: C.amber, surface: C.cream),
  textTheme:
      ThemeData.light().textTheme.apply(bodyColor: C.ink, displayColor: C.ink),
  tooltipTheme: TooltipThemeData(
    decoration:
        BoxDecoration(color: C.ink, borderRadius: BorderRadius.circular(10)),
    textStyle: const TextStyle(color: C.cream, fontSize: 12),
    waitDuration: const Duration(milliseconds: 400),
  ),
);

enum PaperMode { plain, grid, dots }

final paperMode = ValueNotifier<PaperMode>(PaperMode.grid);

/// Cream paper background; keeps content in a phone-width column on wide screens.
class PaperBackground extends StatelessWidget {
  final Widget child;
  const PaperBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<PaperMode>(
        valueListenable: paperMode,
        builder: (_, m, __) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: CustomPaint(
            key: ValueKey(m),
            painter: PaperPainter(m),
            child: SizedBox.expand(
              child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: child),
              ),
            ),
          ),
        ),
      );
}

class PaperPainter extends CustomPainter {
  final PaperMode m;
  final double gap;
  PaperPainter(this.m, {this.gap = 24});
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = C.cream);
    final p = Paint()
      ..color = C.sage.withValues(alpha: .25)
      ..strokeWidth = 1;
    if (m == PaperMode.grid) {
      for (double x = 0; x < s.width; x += gap) {
        c.drawLine(Offset(x, 0), Offset(x, s.height), p);
      }
      for (double y = 0; y < s.height; y += gap) {
        c.drawLine(Offset(0, y), Offset(s.width, y), p);
      }
    } else if (m == PaperMode.dots) {
      for (double x = gap / 2; x < s.width; x += gap) {
        for (double y = gap / 2; y < s.height; y += gap) {
          c.drawCircle(Offset(x, y), 1.4, p);
        }
      }
    }
  }

  @override
  bool shouldRepaint(PaperPainter o) => o.m != m || o.gap != gap;
}
