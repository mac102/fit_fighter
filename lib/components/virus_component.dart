import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/fit_fighter_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class VirusComponent extends SpriteComponent
    with HasGameRef<FitFighterGame>, CollisionCallbacks {
  final double _spriteHeight = 50;
  final Vector2 startPosition;

  VirusComponent({required this.startPosition});

  late Vector2 _velocity;
  double speed = 300;

  Vector2 moveSprite() {
    // Generate a random angle in radians (pl: stopien)
    final randomAngle = Random().nextDouble() * 2 * pi;

    // calc the sinus and cosinus of thr angle
    final sinAngle = sin(randomAngle);
    final cosAngle = cos(randomAngle);

    final double vx = cosAngle * speed;
    final double vy = sinAngle * speed;

    return Vector2(vx, vy);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Global.virusSprite);
    position = startPosition;
    width = height = _spriteHeight;
    anchor = Anchor.center;
    _velocity = moveSprite();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += _velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      final Vector2 collisionpoint = intersectionPoints.first;
      if (collisionpoint.x == 0) {
        // at the very left
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionpoint.x >= gameRef.size.x - 50) {
        // at the very right
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionpoint.y == 0) {
        // at the very top of the screen
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
      if (collisionpoint.y >= gameRef.size.y) {
        // at the very bottom
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
    }
  }
}
