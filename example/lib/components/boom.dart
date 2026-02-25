import 'dart:async';

import 'package:example/game.dart';
import 'package:flame/components.dart';

class Boom extends SpriteAnimationComponent with HasGameReference<MyGame> {
  Boom({super.position})
    : super(priority: 30, size: Vector2.all(24), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'sprites.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .08,
        textureSize: Vector2.all(24),
        texturePosition: Vector2(88, 0),
        loop: false,
      ),
    );

    removeOnFinish = true;
  }
}
