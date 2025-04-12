import 'package:amphi/models/app_web_channel_core.dart';
import 'package:flutter/material.dart';
import 'package:amphi/models/app_localizations.dart';

import 'register_form.dart';

class RegisterView extends StatelessWidget {

  final AppWebChannelCore appWebChannel;
  const RegisterView({super.key, required this.appWebChannel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leadingWidth: AppLocalizations.of(context).get("@register").length * 20 + 50,
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
                  Text(AppLocalizations.of(context).get("@register"))
                ],
              ),
            ),
          ],
        ),
      ),
      body: RegisterForm(appWebChannel: appWebChannel),
    );
  }
}