import 'package:flutter/material.dart';

class ColorPickerList extends StatelessWidget {

  final Color? defaultColor; // such as default note's text color
  final List<Color> colors;
  final void Function(Color) onDefaultColorTap;
  final void Function() onAddColor;
  final void Function(Color) onRemoveColor;
  final void Function(Color) onColorChanged;
  const ColorPickerList({super.key, this.defaultColor, required this.colors, required this.onDefaultColorTap, required this.onAddColor, required this.onRemoveColor, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
      if(defaultColor != null) {
        if(colors.isNotEmpty) {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length + 2,
              itemBuilder: (context, index) {
                if(index == 0) {
                  return _ColorItem(
                    color: defaultColor!,
                    onTap: () {
                      onDefaultColorTap(defaultColor!);
                    },
                    onLongPress: () {},
                  );
                }
                else if(index == colors.length + 1) {
                  return _AddColorButton(onTap: onAddColor);
                }
                else {
                  return _ColorItem(
                    color: colors[index - 1],
                    onTap: () {
                      onColorChanged(colors[index - 1]);
                    },
                    onLongPress: () {
                      onRemoveColor(colors[index - 1]);
                    },
                  );
                }
              });
        }
        else {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length + 2,
              itemBuilder: (context, index) {
                if(index == 0) {
                  return _ColorItem(
                    color: defaultColor!,
                    onTap: () {
                      onDefaultColorTap(defaultColor!);
                    },
                    onLongPress: () {},
                  );
                }
                else {
                  return _AddColorButton(onTap: onAddColor);
                }
              });
        }

      }
      else {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length + 1,
            itemBuilder: (context, index) {
          if(index == colors.length ) {
            return _AddColorButton(onTap: onAddColor);
          }
          else {
            return _ColorItem(
              color: colors[index],
              onTap: () {
                onColorChanged(colors[index]);
              },
              onLongPress: () {
                onRemoveColor(colors[index]);
              },
            );
          }
            });
      }
  }
}

class _AddColorButton extends StatelessWidget {

  final void Function() onTap;
  const _AddColorButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.add_circle_outline_outlined,
        size: 40,
      ),
    );
  }
}


class _ColorItem extends StatelessWidget {

  final void Function() onTap;
  final void Function() onLongPress;
  final Color color;
  const _ColorItem({required this.onTap, required this.onLongPress, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Icon(
        Icons.circle,
        size: 40,
        color: color,
      ),
    );
  }
}

