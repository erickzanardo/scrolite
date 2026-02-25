import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:scrolite/scrolite.dart';

class SectionComponent extends PositionComponent
    with HasGameReference<ScroliteGame> {
  SectionComponent({
    required this.section,
    this.first = false,
  });

  final Section section;
  final bool first;

  late final int sectionIndex;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final child = await section.build(game);

    size = child.size;

    sectionIndex = game.stage.sections.indexOf(section);

    add(child);

    if (first) {
      _loadNext();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    y += game.scrollSpeed * dt;

    if (y > size.y) {
      _loadNext();
      removeFromParent();
    }
  }

  void _loadNext() {
    game.sectionIndex++;
    final idx = math.min(
      game.sectionIndex,
      game.stage.sections.length - 1,
    );
    final nextSection = game.stage.sections[idx];
    final component = SectionComponent(section: nextSection)
      ..y = -nextSection.height;
    game.world.add(component);
  }
}
