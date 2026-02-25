import 'dart:async';

import 'package:example/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlayerBullet extends SpriteAnimationComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  PlayerBullet({required this.direction, required this.speed, super.position})
    : super(size: Vector2.all(8), anchor: Anchor.center, priority: 15);

  final Vector2 direction;
  final double speed;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'sprites.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: .1,
        textureSize: Vector2.all(8),
        texturePosition: Vector2(32, 0),
      ),
    );

    add(RectangleHitbox(size: Vector2.all(4), position: Vector2.all(2)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;

    // Remove bullet if it goes off-screen
    if (position.x < 0 ||
        position.x > game.resolution.x ||
        position.y < 0 ||
        position.y > game.resolution.y) {
      removeFromParent();
    }
  }
}
