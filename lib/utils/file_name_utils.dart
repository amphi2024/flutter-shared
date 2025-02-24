import 'dart:io';
import 'dart:math';

import 'package:amphi/utils/path_utils.dart';
import 'package:amphi/utils/random_string.dart';

abstract class FilenameUtils {
    static String nameOnly(String filename) {
      return filename.split(".").first;
    }

    static String extensionName(String filename) {
      return filename.split(".").last;
    }

    static String generatedFileName(String type, String path) {
      String result = randomString(9);
      result += type;

      if(File(PathUtils.join(path, result)).existsSync()) {
        return generatedFileName(type, path);
      }
      else {
        return result;
      }

    }

    static  String generatedDirectoryName(String path) {
      int length = Random().nextInt(5) + 10;

      const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

      String result = '';
      for (int i = 0; i < length; i++) {
        result += chars[Random().nextInt(chars.length)];
      }

      if(Directory(PathUtils.join(path, result)).existsSync()) {
        return generatedDirectoryName(path);
      }
      else {
        return result;
      }
    }
}