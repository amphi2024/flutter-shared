import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/color/picker/color_picker_list.dart';
import 'package:amphi/widgets/color/picker/color_picker_popup_menu.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void showAdaptiveColorPicker(
    {required BuildContext context, required Color color,
    required void Function(Color) onColorChanged,
    Color? defaultColor,
    void Function(Color)? onDefaultColorTap,
    required List<Color> colors,
    required void Function(Color) onAddColor,
    required void Function(Color) onRemoveColor}) {

  if(App.isWideScreen(context)) {
    showCustomPopupMenu(context, ColorPickerPopupMenu(color: color, onColorChanged: onColorChanged, colors: colors, onAddColor: onAddColor, onRemoveColor: onRemoveColor, defaultColor: defaultColor, onDefaultColorTap: onDefaultColorTap));
  }
  else {
    showDialog(context: context, builder: (context) {
     return ColorPickerDialog(color: color, onColorChanged: onColorChanged, colors: colors, onAddColor: onAddColor, onRemoveColor: onRemoveColor, defaultColor: defaultColor, onDefaultColorTap: onDefaultColorTap,);
    });
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color color;
  final void Function(Color) onColorChanged;
  final Color? defaultColor; // such as default note's text color
  final List<Color> colors;
  final void Function(Color)? onDefaultColorTap;
  final void Function(Color) onAddColor;
  final void Function(Color) onRemoveColor;

  const ColorPickerDialog(
      {super.key,
      required this.color,
      required this.onColorChanged,
      this.defaultColor,
      this.onDefaultColorTap,
      required this.colors,
      required this.onAddColor,
      required this.onRemoveColor});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color pickerColor = widget.color;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 20,
                      ))
                ],
              ),
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
                        showConfirmationDialog("@dialog_title_delete_color",
                            () {
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
                        if (widget.onDefaultColorTap != null) {
                          setState(() {
                            pickerColor = color;
                            widget.onDefaultColorTap!(color);
                          });
                        }
                      },
                      defaultColor: widget.defaultColor,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
