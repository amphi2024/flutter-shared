import 'package:amphi/models/app_web_channel_core.dart';
import 'package:flutter/material.dart';

import 'login_form.dart';

class LoginDialog extends StatelessWidget {

  final AppWebChannelCore appWebChannel;
  final void Function({required String id, required String token, required String username}) onLoggedIn;
  const LoginDialog({super.key, required this.appWebChannel, required this.onLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
        height: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            SingleChildScrollView(
              child: LoginForm(onLoggedIn: onLoggedIn, appWebChannel: appWebChannel),
            ),
          ],
        ),
      ),
    );
  }
}
