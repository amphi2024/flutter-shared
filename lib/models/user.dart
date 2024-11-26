import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:amphi/utils/path_utils.dart';
import 'package:amphi/utils/random_color.dart';

class User {
  String id;
  String name;
  String password;
  String storagePath;
  Color color =  RandomColor.generate();

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.storagePath
  });

  static User fromDirectory(Directory directory) {
    File file = File(PathUtils.join(directory.path, "user_info.json"));
    if(file.existsSync()) {
      try {
        Map<String, dynamic> map = jsonDecode(file.readAsStringSync());

        return User(id: map["id"] ?? "", name:map["name"] ?? "", password: "", storagePath: directory.path);
      } on Exception {
        return User(id: "", name: "", password: "", storagePath: directory.path);
      }
    }
    else {
      return User(id: "", name: "", password: "", storagePath: directory.path);
    }
  }

  @override
  String toString() {
    return '''
       id: $id,
      name: $name,
      password: $password,
    ''';
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}