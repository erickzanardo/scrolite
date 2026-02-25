import 'dart:async';

import 'package:example/components/components.dart';
import 'package:example/components/enemy_bullet.dart';
import 'package:example/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:scrolite/scrolite.dart';

class Player extends SpriteComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  Player({this.speed = 100}) : super(priority: 20);

  final double speed;

  late final TimerComponent _shootTimer;

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

    add(RectangleHitbox(size: Vector2(4, 4), position: Vector2(2, 2)));

    add(
      _shootTimer = TimerComponent(
        period: 0.5,
        repeat: true,
        autoStart: false,
        onTick: () {
          game.world.add(
            PlayerBullet(
              direction: Vector2(0, -1),
              speed: 50,
              position: position.clone() + Vector2(0, -size.y / 2),
            ),
          );
        },
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.playerTarget != null && !_shootTimer.timer.isRunning()) {
      _shootTimer.timer.start();
    } else if (game.playerTarget == null && _shootTimer.timer.isRunning()) {
      _shootTimer.timer.stop();
    }

    if (game.playerTarget != null) {
      final distance = (game.playerTarget! - position).length;
      if (distance > 1) {
        final direction = (game.playerTarget! - position).normalized();
        final newPosition = position + direction * speed * dt;
        if (newPosition.x < 0 ||
            newPosition.x > game.resolution.x ||
            newPosition.y < 0 ||
            newPosition.y > game.resolution.y) {
          // Don't move outside the game bounds
          return;
        }
        position = newPosition;
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is IsEnemyBullet) {
      other.removeFromParent();
      game.world.add(Boom(position: position.clone()));
      removeFromParent();
    } else if (other is GameObjectComponent &&
        other.gameObject.tag == 'enemy') {
      game.world.add(Boom(position: position.clone()));
      other.removeFromParent();
      removeFromParent();
    }
  }
}
