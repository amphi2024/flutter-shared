import 'package:flutter/material.dart';

void showMenuByRelative({required BuildContext context, required List<PopupMenuEntry<dynamic>> items}) {
  final RenderBox widget = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
  Overlay.of(context).context.findRenderObject() as RenderBox;
  widget.localToGlobal(Offset.zero, ancestor: overlay);

  Offset offset = Offset.zero;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      widget.localToGlobal(offset, ancestor: overlay),
      widget.localToGlobal(
          widget.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  showMenu(context: context, position: position, items: items);
}