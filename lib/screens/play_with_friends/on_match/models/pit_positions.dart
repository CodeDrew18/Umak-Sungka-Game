import 'package:flame/game.dart';

class PitPosition {
  final int index;
  final Vector2 position;
  final double radius;

  PitPosition({
    required this.index,
    required this.position,
    required this.radius,
  });

  bool contains(Vector2 point) {
    return position.distanceTo(point) <= radius;
  }

  double distanceTo(Vector2 point) {
    return position.distanceTo(point);
  }
}
  