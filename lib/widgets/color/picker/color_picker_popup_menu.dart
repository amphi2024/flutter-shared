import 'package:amphi/widgets/color/picker/color_picker_list.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerPopupMenu extends StatefulWidget {

  final Color color;
  final void Function(Color) onColorChanged;
  final Color? defaultColor; // such as default note's text color
  final List<Color> colors;
  final void Function(Color)? onDefaultColorTap;
  final void Function(Color) onAddColor;
  final void Function(Color) onRemoveColor;
  const ColorPickerPopupMenu({super.key, required this.color, required this.onColorChanged, this.defaultColor, required this.colors, this.onDefaultColorTap, required this.onAddColor, required this.onRemoveColor});

  @override
  State<ColorPickerPopupMenu> createState() => _ColorPickerPopupMenuState();
}

class _ColorPickerPopupMenuState extends State<ColorPickerPopupMenu> {

  late Color pickerColor = widget.color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 650,
      height: 450,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                  if(widget.defaultColor != null) {
                    if(widget.defaultColor!.value != color.value) {
                      widget.onColorChanged(color);
                    }
                    else {
                      widget.onDefaultColorTap!(color);
                    }
                  }
                  else {
                    widget.onColorChanged(color);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 80,
                  child: ColorPickerList(
                    colors: widget.colors,
                    onAddColor: () {
                      setState(() {
                        widget.onAddColor(pickerColor);
                      });
                    },
                    onRemoveColor: (color) {
                      showConfirmationDialog("@dialog_title_delete_color", () {
                        setState(() {
                          widget.onRemoveColor(color);
                        });
                      });
                    },
                    onColorChanged: (color) {
                      setState(() {
                        pickerColor = color;
                        widget.onColorChanged(color);
                      });
                    },
                    onDefaultColorTap: (color) {
                      if(widget.onDefaultColorTap != null) {
                        setState(() {
                          pickerColor  = color;
                          widget.onDefaultColorTap!(color);
                        });
                      }
                    },
                    defaultColor: widget.defaultColor,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
