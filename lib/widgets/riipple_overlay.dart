import 'package:flutter/material.dart';

class RippleThemeTransition extends StatefulWidget {
  final Offset position;
  final VoidCallback onCompleted;

  const RippleThemeTransition({
    Key? key,
    required this.position,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<RippleThemeTransition> createState() => _RippleThemeTransitionState();
}

class _RippleThemeTransitionState extends State<RippleThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radius;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Now it's safe to use MediaQuery
    final screenSize = MediaQuery.of(context).size;
    _radius = Tween<double>(
      begin: 0,
      end: screenSize.longestSide * 1.5,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      widget.onCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: RipplePainter(
              widget.position,
              _radius.value,
              Theme.of(context).colorScheme.surface,
              // Theme.of(context).scaffoldBackgroundColor,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RipplePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final Color color;

  RipplePainter(this.center, this.radius, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.color != color;
}
