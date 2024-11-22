import 'package:path/path.dart' as path;

abstract class PathUtils {

  static String basename(String filePath) {
    return path.basename(filePath);
  }

  static String basenameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  static String extension(String filePath) {
    return path.extension(filePath);
  }

  static String join(String part1,
      [String? part2,
        String? part3,
        String? part4,
        String? part5,
        String? part6,
        String? part7,
        String? part8,
        String? part9,
        String? part10,
        String? part11,
        String? part12,
        String? part13,
        String? part14,
        String? part15,
        String? part16]) {
    return path.join(part1, part2, part3, part4, part5, part6, part7, part8, part9,
        part10, part11, part12, part13, part14, part15, part16);
  }
}