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

  DateTime get lastUpdateCheck {
    final value = data["lastUpdateCheck"];
    if(value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value).toLocal();
    }
    return DateTime.now().subtract(const Duration(days: 2));
  }

  set lastUpdateCheck(DateTime value) {
    data["lastUpdateCheck"] = value.toUtc().millisecondsSinceEpoch;
  }

  DateTime get lastServerUpdateCheck {
    final value = data["lastServerUpdateCheck"];
    if(value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value).toLocal();
    }
    return DateTime.now().subtract(const Duration(days: 2));
  }

  set lastServerUpdateCheck(DateTime value) {
    data["lastServerUpdateCheck"] = value.toUtc().millisecondsSinceEpoch;
  }

  Future<void> getData() async {
    var directory = await getApplicationSupportDirectory();
    var file = File(PathUtils.join(directory.path, "cache.json"));
    try {
      data = jsonDecode(await file.readAsString());
    }
    catch(e) {
      data = {
        "windowWidth": 600.0,
        "windowHeight": 400.0,
        "selectedDirectory": null
      };
      await save();
    }
  }

  Future<void> save() async {
    var directory = await getApplicationSupportDirectory();
    var file = File(PathUtils.join(directory.path, "cache.json"));
    await file.writeAsString(jsonEncode(data));
  }
}