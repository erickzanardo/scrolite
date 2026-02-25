import 'package:example/game.dart';
import 'package:flame/components.dart';

class ScrollAndShoot extends Component
    with ParentIsA<PositionComponent>, HasGameReference<MyGame> {
  @override
  void update(double dt) {
    super.update(dt);

    parent.y += 10 * dt; // Scroll down at a constant speed
    if (parent.y > game.resolution.y) {
      removeFromParent(); // Remove when it goes off-screen
    }
  }
}
