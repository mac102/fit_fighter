import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/components/player_component.dart';
import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/fit_fighter_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class DumbbellComponent extends SpriteComponent
    with HasGameRef<FitFighterGame>, CollisionCallbacks {
  final double _spriteHeight = 60;

  final Random _random = Random();

  Vector2 _getRandomPosition() {
    double x = _random.nextInt(gameRef.size.x.toInt()).toDouble();
    double y = _random.nextInt(gameRef.size.y.toInt()).toDouble();

    return Vector2(x, y);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Global.dumbbellSprite);
    height = width = _spriteHeight;
    position = _getRandomPosition();
    anchor = Anchor.center;
    add(RectangleHitbox());
    //debugMode = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerComponent) {
      FlameAudio.play(Global.dumbbellSound);
      removeFromParent();
      gameRef.score += 1;
      gameRef.add(DumbbellComponent());
    }
  }
}
