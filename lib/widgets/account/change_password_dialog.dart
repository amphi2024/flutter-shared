import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/models/app_web_channel_core.dart';
import 'package:flutter/material.dart';

import 'login_input.dart';

class ChangePasswordDialog extends StatefulWidget {

  final String userId;
  final AppWebChannelCore appWebChannel;
  const ChangePasswordDialog({super.key, required this.userId, required this.appWebChannel});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  String? errorMessage;
  bool pending = false;

  void textListener() {
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    passwordController.removeListener(textListener);
    passwordConfirmController.removeListener(textListener);
    oldPasswordController.removeListener(textListener);
    passwordController.dispose();
    passwordConfirmController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    passwordController.addListener(textListener);
    passwordConfirmController.addListener(textListener);
    oldPasswordController.addListener(textListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 250,
          height: MediaQuery.of(context).size.height >= 375 ? 350 : null,
          child: Column(children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 7.5, bottom: 7.5),
              child:
              LoginInput(textEditingController: passwordController, hint: AppLocalizations.of(context).get("@hint_password"), obscureText: true),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 7.5, bottom: 7.5),
              child: LoginInput(
                  textEditingController: passwordConfirmController,
                  hint: AppLocalizations.of(context).get("@hint_confirm_password"),
                  obscureText: true),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 7.5, bottom: 7.5),
              child: LoginInput(
                  textEditingController: oldPasswordController, hint: AppLocalizations.of(context).get("@hint_old_password"), obscureText: true),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                    elevation: 5,
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: Text(
                  AppLocalizations.of(context).get("@change_password"),
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () {
                  if (passwordController.text != passwordConfirmController.text) {
                    setState(() {
                      errorMessage = AppLocalizations.of(context).get("@hint_password_different");
                    });
                  } else {
                    setState(() {
                      errorMessage = null;
                      pending = true;
                    });
                    widget.appWebChannel.changePassword(
                        id: widget.userId,
                        password: passwordController.text,
                        oldPassword: oldPasswordController.text,
                        onSuccess: () {
                          Navigator.pop(context);
                        },
                        onFailed: (statusCode) {
                          if (statusCode == HttpStatus.unauthorized) {
                            setState(() {
                              pending = false;
                              errorMessage = AppLocalizations.of(context).get("@hint_old_password_different");
                            });
                          } else if (statusCode == null) {
                            setState(() {
                              pending = false;
                              errorMessage = AppLocalizations.of(context).get("@failed_to_connect");
                            });
                          }
                        });
                  }
                },
              ),
            ),
            Visibility(visible: pending, child: const CircularProgressIndicator()),
            Visibility(
                visible: errorMessage != null,
                child: Padding(
                  padding: const EdgeInsets.all(7.5),
                  child: Text(errorMessage ?? "", style: TextStyle(color: Theme.of(context).primaryColor)),
                ))
          ]),
        ),
      ),
    );
  }
}