import 'dart:ui';

extension ColorValues on Color {

  String toHexString() {
    return "#${alpha.toHexString()}${red.toHexString()}${green.toHexString()}${blue.toHexString()}";
  }

  int toHex() {
    String string =  "0x${alpha.toHexString()}${red.toHexString()}${green.toHexString()}${blue.toHexString()}";
    return int.parse(string);
  }

  int get value {
    return toARGB32();
  }

  int get alpha => ((a * 255).round() & 0xff);
  double get opacity => a;
  int get red => ((r * 255).round() & 0xff);
  int get green => ((g * 255).round() & 0xff);
  int get blue => ((b * 255).round() & 0xff);

  Color inverted() {
    if((red + green + blue) <= 150 || (red + green + blue) >= 600) {
      return Color.fromARGB(alpha, 255 - red, 255 - green , 255 - blue );
    }
    else {
      return this;
    }

  }

}

extension RadixExtension on int {
  String toHexString() {
    String string = toRadixString(16).toUpperCase();
    if(string.length == 1) {
      string = "0$string";
    }
    return string;
  }
}