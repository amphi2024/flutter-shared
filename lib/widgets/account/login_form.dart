import 'dart:io';
import 'dart:math';

import 'package:amphi/models/app_web_channel_core.dart';
import 'package:amphi/widgets/account/register_dialog.dart';
import 'package:amphi/widgets/account/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amphi/models/app_localizations.dart';

import '../../models/app.dart';
import 'login_input.dart';

class LoginForm extends StatefulWidget {

  final void Function({required String id, required String token, required String username}) onLoggedIn;
  final AppWebChannelCore appWebChannel;
  const LoginForm({super.key, required this.onLoggedIn, required this.appWebChannel});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late int randomIndex;
  late String title;
  late List<String> titles;
  String? errorMessage;
  bool sendingRequest = false;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    Random random = Random();
    randomIndex = random.nextInt(3); // 3 is length of titles

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(
                builder: (context) {
                  titles = [
                    AppLocalizations.of(context).get("@who_are_you"),
                    AppLocalizations.of(context).get("@hello"),
                    AppLocalizations.of(context).get("@welcome"),
                  ];
                  String title = titles[randomIndex];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: LoginInput(
                textEditingController: idController,
                hint: AppLocalizations.of(context).get("@hint_id"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: LoginInput(
                textEditingController: passwordController,
                hint: AppLocalizations.of(context).get("@hint_password"),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                  elevation: 5,
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              child: Text(
                AppLocalizations.of(context).get("@login"),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                if(idController.text.isEmpty) {
                  setState(() {
                    errorMessage = AppLocalizations.of(context).get("@hint_input_id");
                    sendingRequest = false;
                  });
                }
                else if(passwordController.text.isEmpty) {
                  setState(() {
                    errorMessage = AppLocalizations.of(context).get("@hint_input_password");
                    sendingRequest = false;
                  });
                }
                else {
                  setState(() {
                    sendingRequest = true;
                  });
                  widget.appWebChannel.login(
                      id: idController.text,
                      password: passwordController.text,
                      onLoggedIn: (username, token) {
                        widget.onLoggedIn(id: idController.text, username: username, token: token);
                      },
                      onFailed: (statusCode) {
                        if(statusCode == HttpStatus.unauthorized) {
                          setState(() {
                            sendingRequest = false;
                            errorMessage = AppLocalizations.of(context).get("@failed_to_auth");
                          });
                        }
                        else if(statusCode == null) {
                          setState(() {
                            sendingRequest = false;
                            errorMessage = AppLocalizations.of(context).get("@connection_failed");
                          });
                        }
                      }
                  );
                }

              },
            ),
            TextButton(onPressed: () {
              if(App.isWideScreen(context)) {
                showDialog(context: context, builder: (context) {
                  return RegisterDialog(appWebChannel: widget.appWebChannel);
                });
              }
              else {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return RegisterView(appWebChannel: widget.appWebChannel);
                }));
              }
            }, child: Text(AppLocalizations.of(context).get("@register"))),
            Visibility(
                visible: sendingRequest,
                child: const CircularProgressIndicator()),
            Visibility(
                visible: errorMessage != null,
                child: Text(errorMessage ?? "", style: TextStyle(color: Theme.of(context).primaryColor))),
            Visibility(
                visible: widget.appWebChannel.serverAddress.isEmpty,
                child: Text(AppLocalizations.of(context).get("@please_set_server_address"), style: TextStyle(color: Theme.of(context).primaryColor), maxLines: 3,)),
          ]

      ),
    );
  }
}