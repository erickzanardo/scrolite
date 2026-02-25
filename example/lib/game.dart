import 'package:example/components/components.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:scrolite/scrolite.dart';

class MyGame extends ScroliteGame {
  MyGame({
    required super.stage,
    required super.objectsMapping,
    required super.controllersMapping,
    required super.resolution,
  }) : super(scrollSpeed: 6);

  Vector2? playerTarget;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    world.add(Player());
    world.add(_GameDragArea(size: resolution));
  }
}

class _GameDragArea extends PositionComponent
    with DragCallbacks, HasGameReference<MyGame> {
  _GameDragArea({required super.size}) : super(priority: 20);

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    game.playerTarget = event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    game.playerTarget ??= Vector2.zero();
    game.playerTarget = game.playerTarget! + event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    game.playerTarget = null;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    game.playerTarget = null;
  }
}
