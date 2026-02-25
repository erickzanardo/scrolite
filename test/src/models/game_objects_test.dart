import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolite/scrolite.dart';

void main() {
  group('GameObject', () {
    test('readObjectMap should parse raw string into GameObject map', () {
      const raw = '''
[minion_1]
type = sprite
imageFile = images/sprites.png
srcSrc = 0, 16
srcSize = 8, 8

[minion_2]
type = sprite
imageFile = images/sprites.png
srcSrc = 8, 16
srcSize = 8, 8
''';

      final map = GameObject.readObjectMap(raw);
      expect(map.length, 2);
      expect(map['minion_1'], isA<SpriteGameObject>());

      final minion1 = map['minion_1']! as SpriteGameObject;
      expect(minion1.spritePath, 'images/sprites.png');
      expect(minion1.srcPosition, Vector2(0, 16));
      expect(minion1.srcSize, Vector2(8, 8));

      expect(map['minion_2'], isA<SpriteGameObject>());
      final minion2 = map['minion_2']! as SpriteGameObject;
      expect(minion2.spritePath, 'images/sprites.png');
      expect(minion2.srcPosition, Vector2(8, 16));
      expect(minion2.srcSize, Vector2(8, 8));
    });
  });
}
