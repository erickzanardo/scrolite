import 'package:flame/game.dart';

abstract class GameObject {
  GameObject({required this.controller, this.tag, this.hitbox});

  final String? tag;
  final String controller;
  final (int, int, int, int)? hitbox;

  static Map<String, GameObject> readObjectMap(String raw) {
    final lines = raw.split('\n');

    final objectMap = <String, GameObject>{};
    while (lines.isNotEmpty) {
      final line = lines.removeAt(0).trim();
      if (line.isEmpty) continue;

      if (line.startsWith('[') && line.endsWith(']')) {
        final name = line.substring(1, line.length - 1);
        final properties = <String, String>{};

        while (lines.isNotEmpty && !lines.first.trim().startsWith('[')) {
          final propLine = lines.removeAt(0).trim();
          if (propLine.isEmpty) continue;

          final parts = propLine.split('=');
          if (parts.length == 2) {
            properties[parts[0].trim()] = parts[1].trim();
          }
        }

        if (properties['type'] == 'sprite') {
          final spritePath = properties['imageFile']!;
          final controller = properties['controller']!;
          final srcSrcParts = properties['srcSrc']!
              .split(',')
              .map((s) => s.trim())
              .toList();
          final srcSizeParts = properties['srcSize']!
              .split(',')
              .map((s) => s.trim())
              .toList();

          final srcPosition = Vector2(
            double.parse(srcSrcParts[0]),
            double.parse(srcSrcParts[1]),
          );
          final srcSize = Vector2(
            double.parse(srcSizeParts[0]),
            double.parse(srcSizeParts[1]),
          );

          (int, int, int, int)? hitbox;
          if (properties.containsKey('hitbox')) {
            final hitboxParts = properties['hitbox']!
                .split(',')
                .map((s) => s.trim())
                .toList();
            if (hitboxParts.length == 4) {
              hitbox = (
                int.parse(hitboxParts[0]),
                int.parse(hitboxParts[1]),
                int.parse(hitboxParts[2]),
                int.parse(hitboxParts[3]),
              );
            }
          }

          final tag = properties['tag'];

          objectMap[name] = SpriteGameObject(
            spritePath: spritePath,
            srcPosition: srcPosition,
            srcSize: srcSize,
            controller: controller,
            hitbox: hitbox,
            tag: tag,
          );
        }
      }
    }

    return objectMap;
  }
}

class SpriteGameObject extends GameObject {
  SpriteGameObject({
    required this.spritePath,
    required this.srcPosition,
    required this.srcSize,
    required super.controller,
    super.hitbox,
    super.tag,
  });

  final String spritePath;
  final Vector2 srcPosition;
  final Vector2 srcSize;
}
