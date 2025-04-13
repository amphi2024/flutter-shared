import 'dart:math';

import 'package:amphi/models/user.dart';
import 'package:flutter/material.dart';

import '../widgets/account/account_info.dart';
import 'app_cache_data_core.dart';
import 'app_storage_core.dart';
import 'app_web_channel_core.dart';

class AccountInfoBottomSheet extends StatefulWidget {

  final Widget dragHandle;
  final AppWebChannelCore appWebChannel;
  final AppStorageCore appStorage;
  final AppCacheDataCore appCacheData;
  final void Function() onUserRemoved;
  final void Function() onUserAdded;
  final void Function() onUsernameChanged;
  final void Function(User) onSelectedUserChanged;
  final void Function({required String id, required String token, required String username}) onLoggedIn;
  const AccountInfoBottomSheet({super.key, required this.appWebChannel, required this.appStorage, required this.onUserRemoved, required this.onUserAdded, required this.onUsernameChanged, required this.onLoggedIn, required this.dragHandle, required this.appCacheData, required this.onSelectedUserChanged});

  @override
  State<AccountInfoBottomSheet> createState() => _AccountInfoBottomSheetState();
}

class _AccountInfoBottomSheetState extends State<AccountInfoBottomSheet> {

  late Color profileColor = Color.fromARGB(255, Random().nextInt(245), Random().nextInt(245), Random().nextInt(245));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        children: [
          widget.dragHandle,
          AccountInfo(
            appWebChannel: widget.appWebChannel,
            onLoggedIn: widget.onLoggedIn,
            appStorage: widget.appStorage,
            onUserAdded: widget.onUserAdded,
            onUserRemoved: widget.onUserRemoved,
            onUsernameChanged: widget.onUsernameChanged,
            appCacheData: widget.appCacheData,
            onSelectedUserChanged: widget.onSelectedUserChanged,
          )
        ],
      ),
    );
  }
}
