import 'package:flutter/material.dart';
import 'package:amphi/models/user.dart';

class ProfileImage extends StatelessWidget {

  final double size;
  final double fontSize;
  final User user;
  const ProfileImage({super.key, this.size = 30, this.fontSize = 20, required this.user});

  @override
  Widget build(BuildContext context) {

    if( user.token.isNotEmpty && user.name.isNotEmpty ) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: user.color,
            borderRadius: BorderRadius.circular(size)
        ),
        child: Center(
          child: Text(
            user.name.substring(0, 1),
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.white
            ),
          ),
        ),
      );
    }
    else {
      return Icon(
          Icons.account_circle,
          color: user.color,
          size: size);
    }

  }
}