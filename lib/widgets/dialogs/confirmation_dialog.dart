import 'package:flutter/material.dart';
import 'package:amphi/models/app_localizations.dart';

extension ConfirmationDialogExtension on State {
  void showConfirmationDialog(String titleKey, void Function() onConfirmed) {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            title:
            AppLocalizations.of(context).get(titleKey),
            onConfirmed: onConfirmed,
          );});
  }
}



class ConfirmationDialog extends StatelessWidget {

  final String title;
  final Function onConfirmed;
  const ConfirmationDialog({super.key, required this.title, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text(
        title,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      actions: [
        TextButton(
          child: Text(
            AppLocalizations.of(context).get("@dialog_action_no"),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            AppLocalizations.of(context).get("@dialog_action_yes"),
            style:  TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirmed();
          },
        )
      ],
    );
  }
}