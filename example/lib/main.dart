import 'package:example/components/components.dart';
import 'package:example/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:scrolite/scrolite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final resolution = Vector2(64, 128);

  final stageData = await Flame.assets.readFile('level_data/level_1.scrolite');
  final stage = Stage.fromData(stageData);

  final objectsData = await Flame.assets.readFile('objects.scrolite');
  final objectsMapping = GameObject.readObjectMap(objectsData);

  runApp(
    GameWidget(
      game: MyGame(
        stage: stage,
        objectsMapping: objectsMapping,
        controllersMapping: {'minion_1': Mininon1Controller.new},
        resolution: resolution,
      ),
    ),
  );
}
