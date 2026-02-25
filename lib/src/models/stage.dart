import 'package:scrolite/src/models/models.dart';

class Stage {
  Stage({
    required this.sections,
    required this.scrollSpeed,
  });

  factory Stage.fromData(String data) {
    final lines = data.split('\n');
    double? scrollSpeed;
    final sections = <Section>[];
    var currentSection = <String, String>{};
    String? currentGroup;

    void parseSection(Map<String, String> sectionData) {
      if (sectionData.isEmpty) return;
      if (sectionData['type'] == 'sprite') {
        final id = sectionData['id'];
        if (id == null) {
          throw ArgumentError('Section is missing required id property');
        }
        sections.add(
          SpriteSection(
            id: id,
            width: double.parse(sectionData['width'] ?? '0'),
            height: double.parse(sectionData['height'] ?? '0'),
            spritePath: sectionData['spritePath'] ?? '',
          ),
        );
      }
    }

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('[') && line.endsWith(']')) {
        // New group
        if (currentGroup == 'section') {
          parseSection(currentSection);
          currentSection = {};
        }
        currentGroup = line.substring(1, line.length - 1);
        continue;
      }
      final parts = line.split('=');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
        if (currentGroup == 'data') {
          if (key == 'speed') {
            scrollSpeed = double.tryParse(value);
          }
        } else if (currentGroup == 'section') {
          currentSection[key] = value;
        }
      }
    }
    // Add last section if any
    if (currentGroup == 'section') {
      parseSection(currentSection);
    }
    if (scrollSpeed == null) {
      throw ArgumentError('Stage data missing scroll speed');
    }
    return Stage(
      sections: sections,
      scrollSpeed: scrollSpeed,
    );
  }

  final List<Section> sections;
  final double scrollSpeed;
}
