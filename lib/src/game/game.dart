import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:scrolite/scrolite.dart';

class ScroliteGame extends FlameGame {
  ScroliteGame({
    required this.stage,
    required this.resolution,
    this.scrollSpeed = 60,
  });

  final Stage stage;
  final Vector2 resolution;

  double scrollSpeed;

  @internal
  var sectionIndex = 0;

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
}
