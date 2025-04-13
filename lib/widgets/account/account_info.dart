import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_cache_data_core.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/models/app_storage_core.dart';
import 'package:amphi/models/app_web_channel_core.dart';
import 'package:amphi/models/user.dart';
import 'package:amphi/widgets/account/login_dialog.dart';
import 'package:amphi/widgets/account/profile_image.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/path_utils.dart';
import 'account_item.dart';
import 'change_password_dialog.dart';
import 'login_view.dart';

class AccountInfo extends StatefulWidget {
  
  final AppWebChannelCore appWebChannel;
  final AppStorageCore appStorage;
  final AppCacheDataCore appCacheData;
  final void Function() onUserRemoved;
  final void Function() onUserAdded;
  final void Function() onUsernameChanged;
  final void Function(User) onSelectedUserChanged;
  final void Function({required String id, required String token, required String username}) onLoggedIn;
  const AccountInfo({super.key, required this.appWebChannel, required this.appStorage, required this.onUserRemoved, required this.onUserAdded, required this.onUsernameChanged, required this.onLoggedIn, required this.appCacheData, required this.onSelectedUserChanged});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  List<User> unselectedUsers = [];
  late TextEditingController usernameController = TextEditingController(
      text: widget.appWebChannel.token.isNotEmpty ? widget.appStorage.selectedUser.name : AppLocalizations.of(context).get("@guest"));
  bool editingUsername = false;
  bool sendingRequest = false;
  String? errorMessage;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.appWebChannel.userNameUpdateListeners.add((name) {
      setState(() {
        usernameController.text = name;
      });
    });
    for (User user in widget.appStorage.users) {
      if (user.storagePath != widget.appStorage.selectedUser.storagePath) {
        unselectedUsers.add(user);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
              },
              child: ProfileImage(size: 100, fontSize: 50, user: widget.appStorage.selectedUser, token: widget.appWebChannel.token)),
          SizedBox(
            width: 175,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      readOnly: !editingUsername,
                      controller: usernameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: editingUsername ? null : InputBorder.none, focusedBorder: editingUsername ? null : InputBorder.none),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Visibility(
                    visible: widget.appWebChannel.token.isNotEmpty,
                    child: IconButton(
                        icon: Icon(editingUsername ? Icons.check : Icons.edit),
                        onPressed: () {
                          if (editingUsername) {
                            setState(() {
                              sendingRequest = true;
                              errorMessage = null;
                            });
                          } else {
                            setState(() {
                              sendingRequest = false;
                              errorMessage = null;
                            });
                          }
                          if (editingUsername && usernameController.text != widget.appStorage.selectedUser.name) {
                            widget.appWebChannel.changeUsername(
                                name: usernameController.text,
                                onSuccess: () {
                                  // appState.notifySomethingChanged(() {
                                  //   sendingRequest = false;
                                  //   errorMessage = null;
                                  //   widget.appStorage.selectedUser.name = usernameController.text;
                                  //   widget.appStorage.saveSelectedUserInformation();
                                  // });
                                },
                                onFailed: (statusCode) {
                                  if (statusCode == HttpStatus.unauthorized) {
                                    setState(() {
                                      sendingRequest = false;
                                      errorMessage = AppLocalizations.of(context).get("@failed_to_auth");
                                    });
                                  } else if (statusCode == null) {
                                    setState(() {
                                      sendingRequest = false;
                                      errorMessage = AppLocalizations.of(context).get("@failed_to_connect");
                                    });
                                  }
                                });
                          }
                          setState(() {
                            editingUsername = !editingUsername;
                          });
                        }),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: widget.appWebChannel.token.isNotEmpty,
            child: TextButton(
              child: Text(
                AppLocalizations.of(context).get("@change_password"),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ChangePasswordDialog(appWebChannel: widget.appWebChannel, userId: widget.appStorage.selectedUser.id);
                    });
              },
            ),
          ),
          Visibility(
              visible: widget.appWebChannel.token.isEmpty,
              child: TextButton(
                child: Text(
                  AppLocalizations.of(context).get("@login"),
                ),
                onPressed: () {
                  if (App.isWideScreen(context)) {
                    showDialog(context: context, builder: (context) => LoginDialog(appWebChannel: widget.appWebChannel, onLoggedIn: widget.onLoggedIn));
                  } else {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginView(appWebChannel: widget.appWebChannel, onLoggedIn: widget.onLoggedIn)));
                  }
                },
              )),
          Visibility(
            visible: unselectedUsers.isNotEmpty,
            child: TextButton(
              child: Text(
                AppLocalizations.of(context).get("@remove_user"),
              ),
              onPressed: () {
                if (unselectedUsers.isNotEmpty) {
                  showConfirmationDialog("@dialog_title_remove_user", () {
                    Navigator.popUntil(
                      context,
                          (Route<dynamic> route) => route.isFirst,
                    );
                    widget.appStorage.removeUser(() {
                      //widget.appStorage.saveSelectedUser(unselectedUsers[0]);
                      widget.appStorage.users.remove(widget.appStorage.selectedUser);
                      widget.appStorage.selectedUser = unselectedUsers[0];
                      widget.appStorage.initPaths();
                      // appState.notifySomethingChanged(() {
                      //   widget.appStorage.initNotes();
                      // });
                      widget.onUserRemoved();
                    });
                  });
                }
              },
            ),
          ),
          Visibility(visible: sendingRequest, child: const CircularProgressIndicator()),
          Visibility(visible: errorMessage != null, child: Text(errorMessage ?? "", style: TextStyle(color: Theme.of(context).highlightColor))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ListView.separated(
                  itemCount: unselectedUsers.length + 1,
                  shrinkWrap: true,
                  separatorBuilder: (c, d) {
                    return Divider(
                      color: Theme.of(context).dividerColor,
                      height: 0,
                    );
                  },
                  itemBuilder: (context, index) {
                    var borderRadius = BorderRadius.zero;
                    if(index == 0) {
                      borderRadius = const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight:  Radius.circular(0), bottomLeft: Radius.circular(0));
                    }
                    else if(index == unselectedUsers.length - 1) {
                      borderRadius = const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomRight:  Radius.circular(15), bottomLeft: Radius.circular(15));
                    }
                    if(unselectedUsers.length == 1) {
                      borderRadius = BorderRadius.circular(15);
                    }

                    if (index < unselectedUsers.length) {
                      return AccountItem(
                          icon: ProfileImage(size: 30, fontSize: 20, user: unselectedUsers[index], token: widget.appWebChannel.token),
                          borderRadius: borderRadius,
                          title: unselectedUsers[index].name.isEmpty ? AppLocalizations.of(context).get("@guest") : unselectedUsers[index].name,
                          onPressed: () async {
                            Navigator.popUntil(
                              context,
                                  (Route<dynamic> route) => route.isFirst,
                            );
                            widget.appStorage.selectedUser = unselectedUsers[index];
                            widget.appCacheData.selectedDirectory = PathUtils.basename( unselectedUsers[index].storagePath);
                            widget.appCacheData.save();
                            widget.appStorage.initPaths();
                            widget.onSelectedUserChanged(unselectedUsers[index]);
                          });
                    } else {
                      return AccountItem(
                          icon: const Icon(Icons.account_circle, size: 30),
                          borderRadius: borderRadius,
                          title: AppLocalizations.of(context).get("@add_account"),
                          onPressed: () {
                            setState(() {
                              widget.appStorage.addUser(onFinished: (user) async {
                                Navigator.popUntil(
                                  context,
                                      (Route<dynamic> route) => route.isFirst,
                                );
                                widget.appStorage.selectedUser = user;
                                widget.appStorage.users.add(user);
                                widget.appStorage.initPaths();
                                widget.appWebChannel.disconnectWebSocket();
                                widget.onUserAdded();
                              });
                            });
                          });
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}