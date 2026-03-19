import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';

import '../../utils/linux_window_control.dart';

class AdwaitaWindowButtons extends StatelessWidget {
  final bool windowButtonsOnLeft;
  final Future<void> Function() onClose;
  final double padding;

  const AdwaitaWindowButtons({
    super.key,
    this.windowButtonsOnLeft = false,
    required this.onClose,
    this.padding = 0
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _CustomButton(
          onPressed: () {
            minimize();
          },
          icon: "assets/icons/window-minimize.svg"
      ),
      const _MaximizeOrRestoreButton(),
      _CustomButton(
        onPressed: () async {
          await onClose();
          close();
        },
        icon: "assets/icons/window-close.svg",
      ),
    ];
    if (windowButtonsOnLeft) {
      return Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: EdgeInsets.only(left: padding), child: buttons[2]),
        buttons[0],
        buttons[1]
      ]);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buttons[0],
        buttons[1],
        Padding(padding: EdgeInsets.only(right: padding), child: buttons[2]),
      ],
    );
  }
}

class _MaximizeOrRestoreButton extends StatefulWidget{
  const _MaximizeOrRestoreButton();

  @override
  State<_MaximizeOrRestoreButton> createState() => _MaximizeOrRestoreButtonState();
}

class _MaximizeOrRestoreButtonState extends State<_MaximizeOrRestoreButton> with WindowListener {

  String icon = "assets/icons/window-maximize.svg";

  @override
  void onWindowMaximize() {
    setState(() {
      icon = "assets/icons/window-restore.svg";
    });
  }

  @override
  void onWindowRestore() {
    setState(() {
      icon = "assets/icons/window-maximize.svg";
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      icon = "assets/icons/window-restore.svg";
    });
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return _CustomButton(onPressed: () {
      maximizeOrRestore();
    }, icon: icon);
  }
}


class _CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String icon;
  const _CustomButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.5),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Material(
          shape: const CircleBorder(),
          color: isLightMode ? const Color(0xFFEBEBEB) : const Color(0xFF373737),
          child: InkWell(
            highlightColor: isLightMode ? const Color(0xFFF0F0F0) : const Color(0xFF191919),
            mouseCursor: SystemMouseCursors.basic,
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 16,
                height: 16,
                package: 'amphi',
                colorFilter: ColorFilter.mode(
                  isLightMode ? const Color(0xCC000000) : const Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}