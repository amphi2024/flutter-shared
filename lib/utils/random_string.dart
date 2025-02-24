import 'dart:math';

randomString(int maxLength, int minLength) {
    int length = Random().nextInt(maxLength) + minLength;

    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    String string = '';
    for (int i = 0; i < length; i++) {
      string += chars[Random().nextInt(chars.length)];
    }

    return string;
  }
