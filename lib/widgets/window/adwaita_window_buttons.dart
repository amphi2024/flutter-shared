import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<Widget> adwaitaWindowButtons({bool windowButtonsOnLeft = false, required void Function() maximizeOrRestore, required void Function() minimize, required void Function() close, double leftPadding = 0, double rightPadding = 0, bool maximized = false}) {
  if (windowButtonsOnLeft) {
    return [
      Padding(
        padding: EdgeInsets.only(left: leftPadding),
        child: _CustomButton(onPressed: close, icon: "assets/icons/window-close.svg"),
      ),
      _CustomButton(onPressed: minimize, icon: "assets/icons/window-minimize.svg"),
      _CustomButton(onPressed: maximizeOrRestore, icon: maximized ? "assets/icons/window-restore.svg" : "assets/icons/window-maximize.svg")
    ];
  }
  return [
    _CustomButton(onPressed: minimize, icon: "assets/icons/window-minimize.svg"),
    _CustomButton(onPressed: maximizeOrRestore, icon: maximized ? "assets/icons/window-restore.svg" : "assets/icons/window-maximize.svg"),
    Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: _CustomButton(onPressed: close, icon: "assets/icons/window-close.svg"),
    )
  ];
}

class _CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String icon;
  const _CustomButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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