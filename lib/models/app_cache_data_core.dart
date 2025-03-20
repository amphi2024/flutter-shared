import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../utils/path_utils.dart';

class AppCacheDataCore {

  Map<String, dynamic> data = {
    "windowWidth": 600.0,
    "windowHeight": 400.0,
    "selectedDirectory": null
  };

  double get windowWidth => data["windowWidth"] ?? 600.0;
  set windowWidth(value) => data["windowWidth"] = value;

  double get windowHeight => data["windowHeight"] ?? 400.0;
  set windowHeight(value) => data["windowHeight"] = value;

  String? get selectedDirectory => data["selectedDirectory"] ?? "";
  set selectedDirectory(value) => data["selectedDirectory"] = value;

  void getData() async {
    var directory = await getApplicationSupportDirectory();
    var file = File(PathUtils.join(directory.path, "cached.json"));
    try {
      data = jsonDecode(await file.readAsString());
    }
    catch(e) {
      save();
    }
  }

  void save() async {
    var directory = await getApplicationSupportDirectory();
    var file = File(PathUtils.join(directory.path, "cached.json"));
    await file.writeAsString(jsonEncode(data));
  }
}