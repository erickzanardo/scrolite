import 'package:flame/components.dart';
import 'package:flame/game.dart';

abstract class Section {
  const Section({
    required this.id,
    required this.width,
    required this.height,
  });

  final String id;
  final double width;
  final double height;

  Future<PositionComponent> build(FlameGame game);
}

class SpriteSection extends Section {
  const SpriteSection({
    required super.id,
    required super.width,
    required super.height,
    required this.spritePath,
  });

  final String spritePath;

  @override
  Future<PositionComponent> build(FlameGame game) async {
    final sprite = await game.loadSprite(spritePath);
    return SpriteComponent(
      sprite: sprite,
      size: Vector2(width, height),
      bleed: 1,
    );
  }
}
