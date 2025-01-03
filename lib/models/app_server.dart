import 'dart:ui';
import 'package:amphi/utils/random_color.dart';

class AppServer {
  String name;
  String address;
  Color color;

  AppServer({required this.name, required this.address, required this.color});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "address": address,
      "color": color.value
    };
  }

  static AppServer fromMap(Map<String, dynamic> map) {
    Color color =  RandomColor.generate();
    return AppServer(name: map["name"] ?? "", address: map["address"] ?? "", color: color);
  }
}