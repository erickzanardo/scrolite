import 'package:example/components/components.dart';
import 'package:example/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Mininon1Controller extends Component
    with
        ParentIsA<PositionComponent>,
        HasGameReference<MyGame>,
        CollisionCallbacks {
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
