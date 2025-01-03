import 'dart:convert';
import 'package:amphi/extensions/color_extension.dart';
import 'package:flutter/cupertino.dart';

abstract class AppColorsCore {
  void getData();

  late List<Color> themeColors;

  Future<void> save();

  String encodedColorList(List<Color> colors) {
    List<int> list = [];
    for (Color color in colors) {
      list.add(color.toHex());
    }
    return jsonEncode(list);
  }

  List<Color> decodedColorList(String jsonData) {
    List<dynamic> list = jsonDecode(jsonData);
    List<Color> result = [];
    for (int value in list) {
      result.add(Color(value));
    }
    return result;
  }

  Map<String, dynamic> toMap();
}