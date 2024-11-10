import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

abstract class AppThemeCore {

  String title = "";
  String filename;
  String path;
  DateTime created;
  DateTime modified;

  AppThemeCore(
      {
        this.title = "",
        this.filename = "!DEFAULT",
        required this.created,
        required this.modified,
        this.path = ""
      });

  // static AppThemeCore fromFile(File file) {
  //
  //     String jsonString = file.readAsStringSync();
  //     Map<String, dynamic> jsonData = jsonDecode(jsonString);
  //
  //     AppThemeCore appTheme = AppThemeCore(
  //         created: parsedDateTime(jsonData["created"]),
  //         modified: parsedDateTime(jsonData["modified"]),
  //         path: file.path,
  //         filename: file.path
  //             .split("/")
  //             .last
  //     );
  //
  //     return appTheme;
  // }

  Future<void> saveFile(void Function(String) upload) async {

    File file = File(path);
    if(!file.existsSync()) {
      created = DateTime.now();
    }
    modified = DateTime.now();
String fileContent = jsonEncode(toMap());
    await file.writeAsString(fileContent);
    upload(fileContent);
  }

  Future<void> deleteFile() async {
      File file = File(path);
      await file.delete();
  }

  Map<String, dynamic> toMap() {
    return {};
  }
}

extension CheckColor on Color {

  String toHexString() {
    return "#${alpha.toHexString()}${red.toHexString()}${green.toHexString()}${blue.toHexString()}";
  }

  int toHex() {
    String string =  "0x${alpha.toHexString()}${red.toHexString()}${green.toHexString()}${blue.toHexString()}";
    return int.parse(string);
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