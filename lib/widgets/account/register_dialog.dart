import 'package:amphi/models/app_web_channel_core.dart';
import 'package:amphi/widgets/account/register_form.dart';
import 'package:flutter/material.dart';

class RegisterDialog extends StatelessWidget {

  final AppWebChannelCore appWebChannel;
  const RegisterDialog({super.key, required this.appWebChannel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
        height: 500,
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
              child: RegisterForm(appWebChannel: appWebChannel),
            ),
          ],
        ),
      ),
    );
  }
}
