import 'dart:ui';
int _floatToInt8(double x) {
  return (x * 255.0).round() & 0xff;
}
extension ColorExtension on Color {

  String toHexString() {
    return "#${alpha.toHexString()}${red.toHexString()}${green.toHexString()}${blue.toHexString()}";
  }

  int toHex() {
    String string =  "0x${alpha.toHexString()}${red.toHexString()}${green.toHexString()}${blue.toHexString()}";
    return int.parse(string);
  }

  // SHUT UP GOOGLE. I will still use this
  int get value {
    return _floatToInt8(a) << 24 |
    _floatToInt8(r) << 16 |
    _floatToInt8(g) << 8 |
    _floatToInt8(b) << 0;
  }

  int get alpha => (0xff000000 & value) >> 24;

  int get red => (0x00ff0000 & value) >> 24;
  int get green => (0x0000ff00 & value) >> 24;
  int get blue => (0x000000ff & value) >> 24;

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