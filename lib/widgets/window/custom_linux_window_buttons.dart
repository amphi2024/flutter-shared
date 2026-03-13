// import 'package:flutter/widgets.dart';
// import 'package:libadwaita/libadwaita.dart';
// import 'package:modern_titlebar_buttons/modern_titlebar_buttons.dart';
// import 'package:window_manager/window_manager.dart';
//
// const _iconSize = 23.0;
//
// List<Widget> customWindowButtons({bool windowButtonsOnLeft = false, required void Function() maximizeOrRestore, required void Function() minimize, required void Function() close}) {
//   if (windowButtonsOnLeft) {
//     return [
//       Padding(
//         padding: const EdgeInsets.only(left: 5),
//         child: AdwWindowButton(
//             buttonType: WindowButtonType.close,
//             onPressed: () => _close(),
//             nativeControls: false),
//       ),
//       AdwWindowButton(
//           buttonType: WindowButtonType.minimize,
//           onPressed: () => _minimize(),
//           nativeControls: false),
//       AdwWindowButton(
//           buttonType: WindowButtonType.maximize,
//           onPressed: () => _maximizeOrRestore(),
//           nativeControls: false),
//     ];
//   }
//   return [
//     AdwWindowButton(
//         buttonType: WindowButtonType.minimize,
//         onPressed: () => _minimize(),
//         nativeControls: false),
//     AdwWindowButton(
//         buttonType: WindowButtonType.maximize,
//         onPressed: () => _maximizeOrRestore(),
//         nativeControls: false),
//     Padding(
//       padding: const EdgeInsets.only(right: 5),
//       child: AdwWindowButton(
//           buttonType: WindowButtonType.close,
//           onPressed: () => _close(),
//           nativeControls: false),
//     )
//   ];
// }
//
// void _minimize() {
//   windowManager.minimize();
// }
//
// void _maximizeOrRestore() async {
//   if (!(await windowManager.isMaximizable())) {
//     windowManager.unmaximize();
//   } else {
//     windowManager.maximize();
//   }
// }
//
// void _close() async {
//   await saveWindowSize();
//   windowManager.close();
// }