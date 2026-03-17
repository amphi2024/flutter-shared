import 'package:window_manager/window_manager.dart';

void minimize() {
  windowManager.minimize();
}

void maximizeOrRestore() async {
  if (!(await windowManager.isMaximizable())) {
    windowManager.unmaximize();
  } else {
    windowManager.maximize();
  }
}

void close() {
  windowManager.close();
}