import 'dart:math';
import 'dart:ui';

abstract class RandomColor {
  static Color generate() {
    return Color.fromARGB(255, Random().nextInt(245), Random().nextInt(245), Random().nextInt(245));
  }
}