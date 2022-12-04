import 'package:flutter/gestures.dart' show Offset;
import 'package:rive/math.dart' show Vec2D;
import 'package:rive/rive.dart';

/// Helpers, that are not yet available in [StateMachineController].
extension StateMachineControllerX on StateMachineController {
  void pointerMoveFromOffset(Offset pointerOffset) {
    pointerMove(Vec2D.fromValues(pointerOffset.dx, pointerOffset.dy));
  }

  SMITrigger? findTrigger(String name) {
    final trigger = findInput<bool>(name);
    return trigger is SMITrigger? ? trigger : null;
  }
}
