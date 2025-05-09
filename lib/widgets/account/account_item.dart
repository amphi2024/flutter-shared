import 'package:flutter/material.dart';

class AccountItem extends StatelessWidget {

  final Widget icon;
  final BorderRadiusGeometry borderRadius;
  final String title;
  final void Function() onPressed;
  const AccountItem({super.key, required this.icon, required this.title, required this.onPressed, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(title, overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ));
  }
}
