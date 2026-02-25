import 'package:flutter_test/flutter_test.dart';
import 'package:scrolite/scrolite.dart';

void main() {
  group('Stage', () {
    test('Stage.fromData return a correctly parsed data', () {
      const data = '''
[data]
speed = 6

[objects]
(2, 32) = minion_1
(2, 40) = minion_1
(2, 48) = minion_1
(2, 56) = minion_1

[section]
id = #1
type = sprite
spritePath = images/s1.png
width = 64
height = 128

[section]
id = #2
type = sprite
spritePath = images/s2.png
width = 64
height = 128

[section]
id = #3
type = sprite
spritePath = images/s3.png
width = 64
height = 128

[section]
id = #4
type = sprite
spritePath = images/s4.png
width = 64
height = 128

[section]
id = #5
type = sprite
spritePath = images/s5.png
width = 64
height = 128

[section]
id = #6
type = sprite
spritePath = images/s6.png
width = 64
height = 128
''';

      final stage = Stage.fromData(data);

      expect(stage.scrollSpeed, 6);
      expect(stage.sections.length, 6);

      expect(stage.objects.length, 4);
      expect(stage.objects[0].$1, 2);
      expect(stage.objects[0].$2, 32);
      expect(stage.objects[0].$3, 'minion_1');

      expect(stage.objects[1].$1, 2);
      expect(stage.objects[1].$2, 40);
      expect(stage.objects[1].$3, 'minion_1');

      expect(stage.objects[2].$1, 2);
      expect(stage.objects[2].$2, 48);
      expect(stage.objects[2].$3, 'minion_1');

      expect(stage.objects[3].$1, 2);
      expect(stage.objects[3].$2, 56);
      expect(stage.objects[3].$3, 'minion_1');

      expect(stage.sections[0], isA<SpriteSection>());
      expect((stage.sections[0] as SpriteSection).spritePath, 'images/s1.png');
      expect((stage.sections[0] as SpriteSection).id, '#1');
      expect((stage.sections[0] as SpriteSection).width, 64);
      expect((stage.sections[0] as SpriteSection).height, 128);
      expect(stage.sections[1], isA<SpriteSection>());
      expect((stage.sections[1] as SpriteSection).spritePath, 'images/s2.png');
      expect((stage.sections[1] as SpriteSection).id, '#2');
      expect((stage.sections[1] as SpriteSection).width, 64);
      expect((stage.sections[1] as SpriteSection).height, 128);
      expect(stage.sections[2], isA<SpriteSection>());
      expect((stage.sections[2] as SpriteSection).spritePath, 'images/s3.png');
      expect((stage.sections[2] as SpriteSection).id, '#3');
      expect((stage.sections[2] as SpriteSection).width, 64);
      expect((stage.sections[2] as SpriteSection).height, 128);
      expect(stage.sections[3], isA<SpriteSection>());
      expect((stage.sections[3] as SpriteSection).spritePath, 'images/s4.png');
      expect((stage.sections[3] as SpriteSection).id, '#4');
      expect((stage.sections[3] as SpriteSection).width, 64);
      expect((stage.sections[3] as SpriteSection).height, 128);
      expect(stage.sections[4], isA<SpriteSection>());
      expect((stage.sections[4] as SpriteSection).spritePath, 'images/s5.png');
      expect((stage.sections[4] as SpriteSection).id, '#5');
      expect((stage.sections[4] as SpriteSection).width, 64);
      expect((stage.sections[4] as SpriteSection).height, 128);
      expect(stage.sections[5], isA<SpriteSection>());
      expect((stage.sections[5] as SpriteSection).spritePath, 'images/s6.png');
      expect((stage.sections[5] as SpriteSection).id, '#6');
      expect((stage.sections[5] as SpriteSection).width, 64);
      expect((stage.sections[5] as SpriteSection).height, 128);
    });
  });
}
