import 'dart:io';

import 'package:flutter/material.dart';


class App {

  late final bool _desktop;

  App._internal() {
    _desktop = Platform.isLinux ||  Platform.isMacOS ||  Platform.isWindows;
  }

  static final App _instance =   App._internal();

  static getInstance() => _instance;

  @Deprecated("DO NOT USE :)")
  static bool isDesktop() {
    return getInstance()._desktop;
  }

  @Deprecated("DO NOT USE :)")
  static bool isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }
}