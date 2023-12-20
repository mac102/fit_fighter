import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/components/background_component.dart';
import 'package:fit_fighter/components/dumbbell_component.dart';
import 'package:fit_fighter/components/player_component.dart';
import 'package:fit_fighter/components/protein_component.dart';
import 'package:fit_fighter/components/vaccine_component.dart';
import 'package:fit_fighter/components/virus_component.dart';
import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/inputs/joystick.dart';
import 'package:fit_fighter/screens/game_over_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class FitFighterGame extends FlameGame with HasCollisionDetection {
  int score = 0;
  late Timer _timer;
  int _remainingTime = 30;
  late TextComponent _scoreText;
  late TextComponent _timeText;
  late PlayerComponent _playerComponent;
  final VaccineComponent _vaccineComponent =
      VaccineComponent(startPosition: Vector2(200, 200));
  int _vaccineImmunityTime = 4;
  late Timer vaccineTimer;
  late int _vaccineTimeApperance;

  // Protein Component
  final ProteinComponent _proteinComponent =
      ProteinComponent(startPosition: Vector2(200, 400));
  int _proteinTimeLeft = 4; // Protein will auto disappear after 4 sec
  late Timer proteinTimer;
  late int _proteinTimeApperance; // Random time
  int proteinBonus = 0; // Keep track of any bonus

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _vaccineTimeApperance =
        Random().nextInt(_remainingTime - 20) + 20; //first vaccine to appear

    _proteinTimeApperance = Random().nextInt(_remainingTime - 5) +
        5; // Time should be greater than 5 sec and less than 30 sec

    add(BackgroundComponent());
    _playerComponent = PlayerComponent(joystick: joystick);
    add(_playerComponent);
    add(DumbbellComponent());
    add(joystick);

    FlameAudio.audioCache.loadAll([
      Global.dumbbellSound,
      Global.virusSound,
      Global.vaccineSound,
      Global.proteinSound
    ]);

    add(VirusComponent(startPosition: Vector2(100, 150)));
    add(VirusComponent(startPosition: Vector2(size.x - 50, size.y - 200)));

    // Any collision on the bounds of the view port
    add(ScreenHitbox());

    _timer = Timer(1, repeat: true, onTick: () {
      if (_remainingTime == 0) {
        pauseEngine();
        overlays.add(GameOverMenu.ID);
      } else if (_remainingTime == _vaccineTimeApperance) {
        add(_vaccineComponent);
      } else if (_remainingTime == _proteinTimeApperance) {
        add(_proteinComponent);
        proteinTimer.start();
      }
      _remainingTime -= 1;
    });

    _timer.start();

    proteinTimer = Timer(1, repeat: true, onTick: () {
      if (_proteinTimeLeft == 0) {
        remove(_proteinComponent);
        _proteinTimeLeft = 4;
        proteinTimer.stop();
      } else {
        _proteinTimeLeft -= 1;
      }
    });

    vaccineTimer = Timer(1, repeat: true, onTick: () {
      if (_vaccineImmunityTime == 0) {
        _playerComponent.removeVaccine();
        _vaccineImmunityTime = 4;
        _vaccineTimeApperance = 0;
        vaccineTimer.stop();
      } else {
        _vaccineImmunityTime -= 1;
      }
    });

    _scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(40, 40),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.black.color,
          fontSize: 25,
        ),
      ),
    );

    add(_scoreText);

    _timeText = TextComponent(
      text: 'Time: $_remainingTime sec',
      position: Vector2(size.x - 40, 40),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.black.color,
          fontSize: 25,
        ),
      ),
    );

    add(_timeText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_proteinComponent.isLoaded) {
      proteinTimer.update(dt);
    }
    _timer.update(dt);
    _scoreText.text = "Score: $score";
    _timeText.text = "Time: $_remainingTime sec";

    if (_playerComponent.isVaccinated) {
      vaccineTimer.update(dt);
    } else if (_vaccineTimeApperance == 0) {
      if (_remainingTime > 3) {
        _vaccineTimeApperance = Random().nextInt(_remainingTime - 3) + 3;
      }
    }
  }

  void reset() async {
    score = 0;
    _remainingTime = 30;
    _vaccineImmunityTime = 4;
    _vaccineComponent.removeFromParent();
    _proteinTimeLeft = 4;
    _proteinComponent.removeFromParent();
    _proteinTimeApperance = Random().nextInt(_remainingTime - 5) + 5;
    _playerComponent.sprite = await loadSprite(Global.playerSkinnySprite);
  }
}
