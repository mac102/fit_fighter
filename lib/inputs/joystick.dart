import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

JoystickComponent joystick = JoystickComponent(
  knob: CircleComponent(
    radius: 30,
    paint: BasicPalette.red.withAlpha(200).paint(),
  ),
  background: CircleComponent(
      radius: 80, paint: BasicPalette.red.withAlpha(100).paint()),
  margin: const EdgeInsets.only(left: 40, bottom: 40),
);
