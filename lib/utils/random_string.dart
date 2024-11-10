import 'dart:math';

randomString(int maxLength) {
    int length = Random().nextInt(maxLength) + 1;

    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    String string = '';
    for (int i = 0; i < length; i++) {
      string += chars[Random().nextInt(chars.length)];
    }

    return string;
  }
