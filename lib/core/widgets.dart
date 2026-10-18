import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

/// Fade + slide in, staggered by [index].
class Appear extends StatelessWidget {
  final int index;
  final Widget child;
  const Appear({super.key, this.index = 0, required this.child});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 450 + index * 90),
        curve: Curves.easeOutCubic,
        builder: (_, v, c) => Opacity(
            opacity: v.clamp(0.0, 1.0),
            child:
                Transform.translate(offset: Offset(0, 22 * (1 - v)), child: c)),
        child: child,
      );
}

/// Small hint banner.
class Tip extends StatelessWidget {
  final IconData icon;
  final String text;
  const Tip({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: C.peach.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Icon(icon, size: 18, color: C.ink),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5))),
        ]),
      );
}

/// Sunny, the mascot. mood: 0 sleepy, 1 happy, 2 celebrating.
class Mascot extends StatefulWidget {
  final double size;
  final int mood;
  const Mascot({super.key, this.size = 80, this.mood = 1});
  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000))
    ..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final t = Curves.easeInOut.transform(_c.value);
          return Transform.translate(
            offset: Offset(0, -6 * t),
            child: CustomPaint(
                size: Size.square(widget.size),
                painter: _MascotPainter(widget.mood, t)),
          );
        },
      );
}

class _MascotPainter extends CustomPainter {
  final int mood;
  final double t;
  _MascotPainter(this.mood, this.t);
  @override
  void paint(Canvas c, Size s) {
    final w = s.width;
    const bodyColor = Color(0xFFFFE066);
    final body = Paint()..color = bodyColor;
    final line = Paint()
      ..color = C.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * .035
      ..strokeCap = StrokeCap.round;
    c.drawOval(
        Rect.fromCenter(
            center: Offset(w / 2, w * .96),
            width: w * .55 - 6 * t,
            height: w * .07),
        Paint()..color = C.ink.withValues(alpha: .12));
    final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .06, w * .08, w * .88, w * .82),
        Radius.circular(w * .42));
    c.drawRRect(r, body);
    c.drawRRect(r, line);
    final blush = Paint()..color = C.blush.withValues(alpha: .7);
    c.drawOval(
        Rect.fromCenter(
            center: Offset(w * .2, w * .6), width: w * .11, height: w * .065),
        blush);
    c.drawOval(
        Rect.fromCenter(
            center: Offset(w * .8, w * .6), width: w * .11, height: w * .065),
        blush);
    final ey = w * .46;
    for (final x in [w * .33, w * .67]) {
      final e = Offset(x, ey);
      if (mood == 2) {
        c.drawArc(Rect.fromCenter(center: e, width: w * .15, height: w * .15),
            math.pi, math.pi, false, line);
      } else {
        c.drawOval(Rect.fromCenter(center: e, width: w * .17, height: w * .21),
            Paint()..color = Colors.white);
        final look =
            mood == 0 ? Offset.zero : Offset(w * .02, -w * .035 - w * .01 * t);
        c.drawOval(
            Rect.fromCenter(center: e + look, width: w * .09, height: w * .11),
            Paint()..color = C.ink);
        if (mood == 0) {
          c.drawRect(
              Rect.fromLTWH(x - w * .1, ey - w * .12, w * .2, w * .12), body);
          c.drawLine(Offset(x - w * .08, ey), Offset(x + w * .08, ey), line);
        }
      }
    }
    final m = Offset(w * .5, w * .62);
    if (mood == 2) {
      c.drawArc(Rect.fromCenter(center: m, width: w * .2, height: w * .16), 0,
          math.pi, true, Paint()..color = C.ink);
    } else if (mood == 1) {
      c.drawArc(Rect.fromCenter(center: m, width: w * .12, height: w * .08), .2,
          math.pi - .4, false, line);
    } else {
      c.drawLine(m - Offset(w * .04, 0), m + Offset(w * .04, 0), line);
    }
  }

  @override
  bool shouldRepaint(_MascotPainter o) => o.mood != mood || o.t != t;
}

/// Duolingo-style streak flame with a count.
class Flame extends StatefulWidget {
  final int streak;
  final double size;
  const Flame({super.key, required this.streak, this.size = 20});
  @override
  State<Flame> createState() => _FlameState();
}

class _FlameState extends State<Flame> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.streak > 0;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Transform.scale(
          scale: active ? 1 + .08 * _c.value : 1,
          alignment: Alignment.bottomCenter,
          child: CustomPaint(
              size: Size(widget.size * .8, widget.size),
              painter: _FlamePainter(active)),
        ),
      ),
      const SizedBox(width: 4),
      Text('${widget.streak}',
          style: TextStyle(
              fontSize: widget.size * .8,
              fontWeight: FontWeight.w800,
              color: active ? C.flame : C.sage)),
    ]);
  }
}

class _FlamePainter extends CustomPainter {
  final bool active;
  _FlamePainter(this.active);
  Path _p(double w, double h) => Path()
    ..moveTo(w * .5, 0)
    ..cubicTo(w * .58, h * .22, w * .95, h * .38, w * .9, h * .68)
    ..cubicTo(w * .86, h * .92, w * .64, h, w * .5, h)
    ..cubicTo(w * .36, h, w * .14, h * .92, w * .1, h * .68)
    ..cubicTo(w * .07, h * .5, w * .28, h * .4, w * .36, h * .2)
    ..cubicTo(w * .4, h * .1, w * .45, h * .05, w * .5, 0)
    ..close();
  @override
  void paint(Canvas c, Size s) {
    c.drawPath(_p(s.width, s.height),
        Paint()..color = active ? C.flame : C.sage.withValues(alpha: .4));
    c.save();
    c.translate(s.width * .5, s.height);
    c.scale(.55);
    c.translate(-s.width * .5, -s.height);
    c.drawPath(_p(s.width, s.height),
        Paint()..color = active ? C.flameCore : C.sage.withValues(alpha: .25));
    c.restore();
  }

  @override
  bool shouldRepaint(_FlamePainter o) => o.active != active;
}

/// Check circle with a pixel-burst when a habit gets completed.
class CheckButton extends StatefulWidget {
  final bool done;
  final VoidCallback onTap;
  const CheckButton({super.key, required this.done, required this.onTap});
  @override
  State<CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 650));
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Tooltip(
        message: widget.done ? 'Done! Tap to undo' : 'Tap to mark done',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!widget.done) _c.forward(from: 0);
            widget.onTap();
          },
          child: SizedBox(
            width: 44,
            height: 44,
            child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                      size: const Size(44, 44), painter: _BurstPainter(_c)),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.done ? C.amber : Colors.transparent,
                        border: Border.all(
                            color: widget.done ? C.ink : C.sage, width: 2)),
                    child: AnimatedScale(
                        scale: widget.done ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutBack,
                        child: const Icon(Icons.check, size: 20, color: C.ink)),
                  ),
                ]),
          ),
        ),
      );
}

class _BurstPainter extends CustomPainter {
  final Animation<double> a;
  _BurstPainter(this.a) : super(repaint: a);
  @override
  void paint(Canvas c, Size s) {
    if (a.value == 0 || a.value == 1) return;
    final t = Curves.easeOut.transform(a.value);
    final center = s.center(Offset.zero);
    final colors = <Color>[C.amber, C.flame, C.peach, C.ink];
    for (var i = 0; i < 10; i++) {
      final ang = i * math.pi * 2 / 10;
      final d = 10 + 26 * t;
      final px = 8 * (1 - a.value);
      c.drawRect(
          Rect.fromCenter(
              center: center + Offset(math.cos(ang) * d, math.sin(ang) * d),
              width: px,
              height: px),
          Paint()..color = colors[i % 4]);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter o) => true;
}
