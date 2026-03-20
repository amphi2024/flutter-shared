import 'package:flutter/material.dart';
import 'package:linux_csd_buttons/linux_csd_buttons.dart';
import 'package:window_manager/window_manager.dart';

import '../../utils/linux_window_control.dart';

class CsdLinuxWindowButtons extends StatelessWidget {
  final CsdTheme theme;
  final bool windowButtonsOnLeft;
  final Future<void> Function() onClose;

  const CsdLinuxWindowButtons({super.key, required this.theme, this.windowButtonsOnLeft = false, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      CsdButton(
          theme: theme,
          onPressed: () {
            minimize();
          },
          type: CsdButtonType.minimize),
      _MaximizeOrRestoreButton(theme: theme),
      CsdButton(
          theme: theme,
          onPressed: () async {
            await onClose();
            close();
          },
          type: CsdButtonType.close),
    ];
    if (windowButtonsOnLeft) {
      return Row(mainAxisSize: MainAxisSize.min, children: [buttons[2], buttons[0], buttons[1]]);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [buttons[0], buttons[1], buttons[2]],
    );
  }
}

class _MaximizeOrRestoreButton extends StatefulWidget {
  final CsdTheme theme;

  const _MaximizeOrRestoreButton({required this.theme});

  @override
  State<_MaximizeOrRestoreButton> createState() => _MaximizeOrRestoreButtonState();
}

class _MaximizeOrRestoreButtonState extends State<_MaximizeOrRestoreButton> with WindowListener {
  CsdButtonType type = CsdButtonType.maximize;

  // @override
  // void onWindowMaximize() {
  //   setState(() {
  //     type = CsdButtonType.restore;
  //   });
  // }
  //
  // @override
  // void onWindowRestore() {
  //   setState(() {
  //     type = CsdButtonType.maximize;
  //   });
  // }
  //
  // @override
  // void onWindowUnmaximize() {
  //   setState(() {
  //     type = CsdButtonType.maximize;
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   windowManager.removeListener(this);
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   windowManager.addListener(this);
  // }

  @override
  Widget build(BuildContext context) {
    return CsdButton(
        theme: widget.theme,
        onPressed: () async {
          if (!(await windowManager.isMaximizable())) {
            await windowManager.unmaximize();
            setState(() {
              type = CsdButtonType.maximize;
            });
          } else {
            await windowManager.maximize();
            setState(() {
              type = CsdButtonType.restore;
            });
          }
        },
        type: type);
  }
}
