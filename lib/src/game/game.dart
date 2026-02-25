import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:scrolite/scrolite.dart';

class ScroliteGame extends FlameGame {
  ScroliteGame({
    required this.stage,
    required this.objectsMapping,
    required this.controllersMapping,
    required this.resolution,
    this.scrollSpeed = 60,
  });

  final Stage stage;
  final Vector2 resolution;

  double scrollSpeed;
  final Map<String, GameObject> objectsMapping;
  final Map<String, Component Function()> controllersMapping;

  @internal
  var sectionIndex = 0;

  var _scrollAccumulator = 0.0;

  late final List<(int, int, String)> objectsToSpawn = List.from(stage.objects)
    ..sort((a, b) => a.$2.compareTo(b.$2)); // Sort by y coordinate

  @override
  void update(double dt) {
    super.update(dt);

    _scrollAccumulator += scrollSpeed * dt;

    if (objectsToSpawn.isNotEmpty) {
      final nextObject = objectsToSpawn.first;
      if (nextObject.$2 <= _scrollAccumulator) {
        // Time to spawn this object
        final objectName = nextObject.$3;
        final gameObject = objectsMapping[objectName];

        if (gameObject == null) {
          throw ArgumentError('No GameObject found for name "$objectName"');
        }

        final controllerBuilder = controllersMapping[gameObject.controller];

        if (controllerBuilder == null) {
          throw ArgumentError(
            'No Controller found for name "${gameObject.controller}"',
          );
        }

        RectangleHitbox? hitbox;
        if (gameObject.hitbox != null) {
          final hitboxData = gameObject.hitbox!;
          hitbox = RectangleHitbox(
            size: Vector2(hitboxData.$3.toDouble(), hitboxData.$4.toDouble()),
            position: Vector2(
              hitboxData.$1.toDouble(),
              hitboxData.$2.toDouble(),
            ),
          );
        }

        if (gameObject is SpriteGameObject) {
          _addSpriteObject(
            gameObject: gameObject,
            controller: controllerBuilder(),
            x: nextObject.$1.toDouble(),
            hitbox: hitbox,
          );
        } else {
          throw ArgumentError(
            'Unsupported GameObject type for name "$objectName"',
          );
        }

        objectsToSpawn.removeAt(0); // Remove the spawned object
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera = CameraComponent.withFixedResolution(
      width: resolution.x,
      height: resolution.y,
    )..viewfinder.anchor = Anchor.topLeft;

    final firstSection = stage.sections.first;
    world.add(SectionComponent(section: firstSection, first: true));
  }

  Future<void> _addSpriteObject({
    required SpriteGameObject gameObject,
    required Component controller,
    required double x,
    RectangleHitbox? hitbox,
  }) async {
    final sprite = await loadSprite(
      gameObject.spritePath,
      srcPosition: gameObject.srcPosition,
      srcSize: gameObject.srcSize,
    );
    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: gameObject.srcSize,
    );

    world.add(
      GameObjectComponent(
        position: Vector2(
          x,
          -gameObject.srcSize.y / 2,
        ), // Start above the screen
        size: gameObject.srcSize,
        sprite: spriteComponent,
        controller: controller,
        children: [
          spriteComponent,
          controller,
          ?hitbox,
        ],
      ),
    );
  }
}
