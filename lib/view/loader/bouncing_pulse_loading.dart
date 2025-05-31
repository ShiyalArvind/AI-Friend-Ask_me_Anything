import 'package:flutter/material.dart';

import 'dart:math' as math show pi, sin;

import '../../utils/color_file.dart';

class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class BouncingPulseLoading extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;

  const BouncingPulseLoading({
    super.key,
    this.color = ColorFile.primaryColor,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<BouncingPulseLoading> createState() => _BouncingPulseLoadingState();
}

class _BouncingPulseLoadingState extends State<BouncingPulseLoading> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Animation<double>> _scaleAnimations = [];
  final List<Animation<double>> _translateAnimations = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();

    for (int i = 0; i < 3; i++) {
      final delay = i * 0.2;
      _scaleAnimations.add(DelayTween(begin: 0.8, end: 1.4, delay: delay).animate(_controller));
      _translateAnimations.add(
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -5.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0), weight: 1),
        ]).animate(CurvedAnimation(parent: _controller, curve: Interval(delay, delay + 0.6, curve: Curves.easeInOut))),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.translate(
                offset: Offset(0, _translateAnimations[i].value),
                child: Transform.scale(scale: _scaleAnimations[i].value, child: child),
              );
            },
            child: Container(
              width: widget.size * 0.3,
              height: widget.size * 0.3,
              decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
            ),
          );
        }),
      ),
    );
  }
}
