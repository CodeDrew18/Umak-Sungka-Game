import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedPebbleWidget extends StatelessWidget {
  final AnimatingPebble pebble;
  final double pitSize;

  const AnimatedPebbleWidget({
    Key? key,
    required this.pebble,
    required this.pitSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = pebble.progress;
    final heightCurve = sin(progress * 3.14159265);
    final verticalOffset = -heightCurve * pitSize * 0.8;

    return Positioned(
      left: 0,
      top: verticalOffset,
      child: Container(
        width: pitSize,
        height: pitSize,
        alignment: Alignment.center,
        child: Container(
          width: pitSize * 0.6,
          height: pitSize * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber[600],
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatingPebble {
  final int startPit;
  final int endPit;
  final DateTime startTime;
  final Duration duration;

  AnimatingPebble({
    required this.startPit,
    required this.endPit,
    required this.duration,
  }) : startTime = DateTime.now();

  double get progress {
    final elapsed = DateTime.now().difference(startTime);
    return (elapsed.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  bool get isComplete => progress >= 1.0;
}
