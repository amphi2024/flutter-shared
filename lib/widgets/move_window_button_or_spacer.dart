import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class MoveWindowOrSpacer extends StatelessWidget {
  const MoveWindowOrSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    if(Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return MoveWindow();
    }
    return const SizedBox.shrink();
  }
}