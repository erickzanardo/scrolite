import 'dart:async';

import 'package:example/game.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameReference<MyGame> {

  Player({
    this.speed = 100,
  }) : super(priority: 20);

  final double speed;

  @override
  void update(double dt) {
    super.update(dt);

    if (game.playerTarget != null) {
      final distance = (game.playerTarget! - position).length;
      if (distance > 1) {
        final direction = (game.playerTarget! - position).normalized();
        final newPosition = position + direction * speed * dt;
        if (newPosition.x < 0 || newPosition.x > game.resolution.x || newPosition.y < 0 || newPosition.y > game.resolution.y) {
          // Don't move outside the game bounds
          return;
        }
        position = newPosition;
      }
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite(
      'sprites.png',
      srcSize: Vector2.all(8),
      srcPosition: Vector2.zero(),
    );

    size = Vector2.all(8);

    position = game.resolution / 2;
    anchor = Anchor.center;
  }
}
