import 'package:amphi/models/app_web_channel_core.dart';
import 'package:flutter/material.dart';
import 'package:amphi/models/app_localizations.dart';

import 'login_form.dart';

class LoginView extends StatelessWidget {

  final AppWebChannelCore appWebChannel;
  final void Function({required String id, required String token, required String username}) onLoggedIn;
  const LoginView({super.key, required this.appWebChannel, required this.onLoggedIn});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppLocalizations.of(context).get("@login").length * 20 + 50,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back_ios_new,
                    size: 25,
                  ),
                  Text(AppLocalizations.of(context).get("@login"))
                ],
              ),
            ),
          ],
        ),
      ),
      body: LoginForm(appWebChannel: appWebChannel, onLoggedIn: onLoggedIn),
    );
  }
}