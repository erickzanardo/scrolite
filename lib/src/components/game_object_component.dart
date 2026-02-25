import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class GameObjectComponent extends PositionComponent with CollisionCallbacks {
  GameObjectComponent({
    required this.sprite,
    required this.controller,
    super.position,
    super.size,
    super.anchor,
    super.children,
  });

  final PositionComponent sprite;
  final Component controller;

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (controller is CollisionCallbacks) {
      (controller as CollisionCallbacks).onCollisionStart(
        intersectionPoints,
        other,
      );
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (controller is CollisionCallbacks) {
      (controller as CollisionCallbacks).onCollisionEnd(other);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (controller is CollisionCallbacks) {
      (controller as CollisionCallbacks).onCollision(intersectionPoints, other);
    }
  }
}
