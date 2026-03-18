import 'package:amphi/widgets/window/adwaita_window_buttons.dart';
import 'package:amphi/widgets/window/csd_linux_window_buttons.dart';
import 'package:flutter/material.dart';
import 'package:linux_csd_buttons/linux_csd_buttons.dart';

class AdaptiveLinuxWindowButtons extends StatelessWidget {
  final CsdTheme? theme;
  final bool windowButtonsOnLeft;
  final Future<void> Function() onClose;
  final double padding;
  const AdaptiveLinuxWindowButtons({super.key, this.theme, required this.windowButtonsOnLeft, required this.onClose, required this.padding});

  @override
  Widget build(BuildContext context) {
    final theme = this.theme;
    if (theme != null) {
      return CsdLinuxWindowButtons(
        theme: theme,
        onClose: onClose,
        windowButtonsOnLeft: windowButtonsOnLeft,
      );
    }

    return AdwaitaWindowButtons(
      onClose: onClose,
      windowButtonsOnLeft: windowButtonsOnLeft,
      padding: padding,
    );
  }
}
