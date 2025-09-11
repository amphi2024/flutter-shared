import 'package:amphi/models/account_info_bottom_sheet.dart';
import 'package:amphi/models/app.dart';
import 'package:amphi/models/user.dart';
import 'package:amphi/widgets/account/account_info.dart';
import 'package:amphi/widgets/account/profile_image.dart';
import 'package:flutter/material.dart';

import '../../models/app_cache_data_core.dart';
import '../../models/app_storage_core.dart';
import '../../models/app_web_channel_core.dart';

class AccountButton extends StatelessWidget {
  final void Function({required String id, required String token, required String username}) onLoggedIn;
  final void Function() onUsernameChanged;
  final double profileIconSize;
  final double iconSize;
  final AppStorageCore appStorage;
  final void Function() onUserAdded;
  final void Function(User) onSelectedUserChanged;
  final double wideScreenIconSize;
  final double wideScreenProfileIconSize;
  final void Function() onUserRemoved;
  final Widget? bottomSheetDragHandle;
  final void Function() setAndroidNavigationBarColor;
  final AppWebChannelCore appWebChannel;
  final AppCacheDataCore appCacheData;

  const AccountButton(
      {super.key, required this.onLoggedIn, required this.iconSize, required this.profileIconSize, required this.wideScreenIconSize, required this.wideScreenProfileIconSize, required this.appWebChannel, required this.appStorage, required this.appCacheData, required this.onUserRemoved, required this.onUserAdded, required this.onUsernameChanged, required this.onSelectedUserChanged, required this.setAndroidNavigationBarColor, this.bottomSheetDragHandle});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = App.isWideScreen(context);

    return IconButton(
        icon: ProfileImage(size: isWideScreen ? wideScreenIconSize : iconSize,
            fontSize: isWideScreen ? wideScreenProfileIconSize : profileIconSize,
            user: appStorage.selectedUser,
            token: appWebChannel.token),
        onPressed: () {
          if (isWideScreen) {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SizedBox(
                      width: 250,
                      height: 500,
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
                          Expanded(
                              child: AccountInfo(
                                appStorage: appStorage,
                                appWebChannel: appWebChannel,
                                appCacheData: appCacheData,
                                onUserRemoved: onUserRemoved,
                                onUserAdded: onUserAdded,
                                onLoggedIn: onLoggedIn,
                                onUsernameChanged: onUsernameChanged,
                                onSelectedUserChanged: onSelectedUserChanged,
                              ))
                        ],
                      ),
                    ),
                  );
                });
          } else {
            setAndroidNavigationBarColor();
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return AccountInfoBottomSheet(
                    appWebChannel: appWebChannel,
                    appStorage: appStorage,
                    appCacheData: appCacheData,
                    onUserRemoved: onUserRemoved,
                    onUserAdded: onUserAdded,
                    onUsernameChanged: onUsernameChanged,
                    onLoggedIn: onLoggedIn,
                    onSelectedUserChanged: onSelectedUserChanged,
                    dragHandle: bottomSheetDragHandle ?? const BottomSheetDragHandle());
              },
            );
          }
        });
  }
}

class BottomSheetDragHandle extends StatelessWidget {

  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                borderRadius: BorderRadius.circular(5)),
          ),
        )
      ],
    );
  }
}