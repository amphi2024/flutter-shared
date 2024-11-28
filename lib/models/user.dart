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
  String token;
  Color color =  RandomColor.generate();

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.storagePath,
    required this.token
  });

  static User fromDirectory(Directory directory) {
    File file = File(PathUtils.join(directory.path, "user_info.json"));
    if(file.existsSync()) {
      try {
        Map<String, dynamic> map = jsonDecode(file.readAsStringSync());

        return User(id: map["id"] ?? "", name:map["name"] ?? "", token: map["token"] ?? "", password: "", storagePath: directory.path);
      } on Exception {
        return User(id: "", name: "", password: "", token: "",storagePath: directory.path);
      }
    }
    else {
      return User(id: "", name: "", password: "",token: "", storagePath: directory.path);
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
      "token": token
    };
  }
}