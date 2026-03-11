# Scrolite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A Shmup engine built on top of Flame

## Installation 💻

**❗ In order to start using Scrolite you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
dart pub add scrolite
```

---

## File Formats 📄

Scrolite uses two main file formats to define game content:

### 1. Stage Files (`.scrolite`)

Stage files define the level layout, scrolling sections, and object placement. They use an INI-like syntax with sections marked by brackets.

#### Structure

```ini
[data]
speed = 6

[objects]
(2, 32) = minion_1
(2, 40) = minion_1
(54, 16) = minion_2

[section]
id = #1
type = sprite
spritePath = level1/s1.png
width = 64
height = 128

[section]
id = #2
type = sprite
spritePath = level1/s2.png
width = 64
height = 128
```

#### Sections

**[data]** - Global stage configuration
- `speed` (double): The scroll speed of the stage

**[objects]** - Object spawn definitions
- Format: `(x, y) = object_name`
- `x`: Horizontal position (integer)
- `y`: Vertical position/scroll distance (integer) - objects spawn when the stage scrolls past this Y coordinate
- `object_name`: Reference to a game object defined in the objects file

**[section]** - Background sections (multiple allowed)
- `id` (string): Unique identifier for the section
- `type` (string): Section type (currently only "sprite" is supported)
- `spritePath` (string): Path to the background image asset
- `width` (double): Section width in pixels
- `height` (double): Section height in pixels

### 2. Object Definition Files (`.scrolite`)

Object files define reusable game objects that can be spawned in stages.

#### Structure

```ini
[minion_1]
tag = enemy
type = sprite
imageFile = sprites.png
srcSrc = 0, 16
srcSize = 8, 8
controller = minion_1
hitbox = 2, 1, 4, 4

[player_bullet]
tag = bullet
type = sprite
imageFile = sprites.png
srcSrc = 16, 0
srcSize = 4, 4
controller = bullet_controller
```

#### Properties

Each object is defined in its own `[object_name]` section:

- `type` (string): Object type (currently only "sprite" is supported) - **required**
- `imageFile` (string): Path to the sprite sheet image - **required**
- `srcSrc` (string): `x, y` coordinates of the sprite in the sprite sheet - **required**
- `srcSize` (string): `width, height` of the sprite in pixels - **required**
- `controller` (string): Name of the controller class that will handle this object's behavior - **required**
- `tag` (string): Optional tag for collision filtering (e.g., "enemy", "bullet")
- `hitbox` (string): `x, y, width, height` defining the collision hitbox (optional)

---

## Dart API 🎯

### Stage Parsing

```dart
import 'package:flame/flame.dart';
import 'package:scrolite/scrolite.dart';

// Load and parse a stage file
final stageData = await Flame.assets.readFile('level_data/level_1.scrolite');
final stage = Stage.fromData(stageData);

// Access stage properties
print(stage.scrollSpeed);  // 6.0
print(stage.sections.length);  // Number of sections
print(stage.objects.length);   // Number of objects to spawn
```

#### Stage Class

**`Stage.fromData(String data)`** - Factory constructor that parses stage data

**Properties:**
- `sections`: `List<Section>` - Background sections that scroll vertically
- `scrollSpeed`: `double` - The base scroll speed
- `objects`: `List<(int x, int y, String name)>` - Objects to spawn with their positions

#### Section Classes

**`Section`** (abstract base class)
- `id`: `String` - Section identifier
- `width`: `double` - Section width
- `height`: `double` - Section height

**`SpriteSection`** (concrete implementation)
- `spritePath`: `String` - Path to the background image
- `build(FlameGame game)`: Builds a `SpriteComponent` from the section definition

### Object Parsing

```dart
// Load and parse object definitions
final objectsData = await Flame.assets.readFile('objects.scrolite');
final objectsMapping = GameObject.readObjectMap(objectsData);

// Access parsed objects
final minion = objectsMapping['minion_1'];
print(minion.controller);  // "minion_1"
print(minion.hitbox);      // (2, 1, 4, 4)
```

#### GameObject Classes

**`GameObject.readObjectMap(String raw)`** - Static method that parses object definitions

Returns: `Map<String, GameObject>` - Map of object names to their definitions

**`GameObject`** (abstract base class)
- `controller`: `String` - Controller name for behavior
- `tag`: `String?` - Optional collision tag
- `hitbox`: `(int, int, int, int)?` - Optional hitbox as `(x, y, width, height)`

**`SpriteGameObject`** (concrete implementation)
- `spritePath`: `String` - Path to sprite sheet
- `srcPosition`: `Vector2` - Sprite position in sheet (from `srcSrc`)
- `srcSize`: `Vector2` - Sprite size (from `srcSize`)

### Creating a Game

```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:scrolite/scrolite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Parse stage and objects
  final stageData = await Flame.assets.readFile('level_data/level_1.scrolite');
  final stage = Stage.fromData(stageData);
  
  final objectsData = await Flame.assets.readFile('objects.scrolite');
  final objectsMapping = GameObject.readObjectMap(objectsData);
  
  runApp(
    GameWidget(
      game: MyGame(
        stage: stage,
        objectsMapping: objectsMapping,
        controllersMapping: {
          'minion_1': MinionController.new,
          'bullet': BulletController.new,
        },
        resolution: Vector2(64, 128),
      ),
    ),
  );
}

class MyGame extends ScroliteGame {
  MyGame({
    required super.stage,
    required super.objectsMapping,
    required super.controllersMapping,
    required super.resolution,
  }) : super(scrollSpeed: 6);
}
```

#### ScroliteGame

**Constructor:**
- `stage`: `Stage` - Parsed stage data
- `objectsMapping`: `Map<String, GameObject>` - Parsed object definitions
- `controllersMapping`: `Map<String, Component Function()>` - Factory functions for controllers
- `resolution`: `Vector2` - Game resolution
- `scrollSpeed`: `double` - Initial scroll speed (optional, defaults to 60)

The engine automatically:
- Scrolls background sections vertically
- Spawns objects at their defined Y positions based on scroll distance
- Attaches controllers to spawned objects
- Handles collision detection with hitboxes

### Creating Controllers

Controllers are Flame components that define object behavior:

```dart
class MinionController extends Component
    with ParentIsA<PositionComponent>, HasGameReference<MyGame> {
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Move down with the scroll plus extra speed
    parent.y += 10 * dt;
    
    // Remove when off-screen
    if (parent.y > game.resolution.y) {
      removeFromParent();
    }
  }
  
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    // Handle collisions
  }
}
```

Controllers receive collision callbacks automatically via `GameObjectComponent`.

---

## Continuous Integration 🤖

Scrolite comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

For first time users, install the [very_good_cli][very_good_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
