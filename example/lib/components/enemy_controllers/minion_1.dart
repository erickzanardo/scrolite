import 'dart:async';

import 'package:example/components/components.dart';
import 'package:example/components/enemy_bullet.dart';
import 'package:example/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Mininon1Controller extends Component
    with
        ParentIsA<PositionComponent>,
        HasGameReference<MyGame>,
        CollisionCallbacks {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(
      TimerComponent(
        period: 4,
        repeat: true,
        tickWhenLoaded: true,
        autoStart: true,
        onTick: () {
          // calculate the direction based on the player's position
          final playerPos = game.player.position;
          final direction = (playerPos - (parent.position + parent.size / 2))
              .normalized();

          game.world.add(
            EnemyBullet(
              direction: direction,
              speed: 10,
              position:
                  parent.position.clone() + Vector2(0, -parent.size.y / 2),
            ),
          );
        },
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    parent.y += 10 * dt; // Scroll down at a constant speed
    if (parent.y > game.resolution.y) {
      removeFromParent(); // Remove when it goes off-screen
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerBullet) {
      parent.removeFromParent();
      other.removeFromParent();
      game.world.add(Boom(position: parent.position + parent.size / 2));
    }
  }
}
