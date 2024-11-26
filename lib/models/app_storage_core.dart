import 'dart:convert';
import 'dart:io';
import 'package:amphi/models/app_server.dart';
import 'package:amphi/models/update_event.dart';
import 'package:amphi/models/user.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:path_provider/path_provider.dart';

abstract class AppStorageCore  {

  late User selectedUser;

  late String settingsPath;
  late String colorsPath;

  List<User> users = [];
  List<AppServer> servers = [];

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> list = [];
   for(AppServer appServer in servers) {
     list.add(appServer.toMap());
   }
    return {
      "selectedDirectory": selectedUser.storagePath,
      "servers": jsonEncode(list)
    };
  }

  Future<void> saveSelectedUser(User user) async {
   // String storagePath = await methodChannel.invokeMethod("get_storage_path");
    Directory directory = await getApplicationSupportDirectory();
    String storagePath = directory.path;
    File file = File(PathUtils.join(storagePath, "configuration.json"));
    selectedUser = user;
    
    await file.writeAsString(jsonEncode(toMap()));
  }

  Future<void> addUser({required void Function(User) onFinished}) async {
   // String storagePath = await methodChannel.invokeMethod("get_storage_path");
    String storagePath = (await getApplicationSupportDirectory() ).path;

    Directory directory = Directory(PathUtils.join(storagePath, FilenameUtils.generatedDirectoryName(storagePath)));
    await directory.create();
    User user = User(id: "", name: "", password: "", storagePath: directory.path);

    onFinished(user);
  }

  void removeUser(void Function() onFinished) async{
    Directory directory = Directory(selectedUser.storagePath);
    await directory.delete(recursive: true);
    onFinished();
  }

  Future<void> saveSelectedUserInformation({UpdateEvent? updateEvent}) async {
    File file = File(PathUtils.join(selectedUser.storagePath, "user_info.json"));
    if(updateEvent != null) {
      if(updateEvent.timestamp.isAfter(file.lastModifiedSync())) {
       await file.writeAsString(jsonEncode(selectedUser.toMap()));
      }
    }
    else {
      await file.writeAsString(jsonEncode(selectedUser.toMap()));
    }
  }

  void initPaths() {
    settingsPath = PathUtils.join(selectedUser.storagePath, "settings.json");
    colorsPath = PathUtils.join(selectedUser.storagePath, "colors.json");
    createDirectoryIfNotExists(selectedUser.storagePath);
  }

  void initialize(void Function() onInitialize) async {
    // String storagePath = await methodChannel.invokeMethod("get_storage_path");
    Directory directory = await getApplicationSupportDirectory();
    String storagePath = directory.path;
    List<FileSystemEntity> userDirectories = Directory(storagePath).listSync();
    File configFile = File(PathUtils.join(storagePath, "configuration.json"));

    users = [];
    for(FileSystemEntity directory in userDirectories) {
      if(directory is Directory) {
        User user = User.fromDirectory(directory);
        users.add(user);

      }
    }


    bool selectedUserFounded = false;
    try {
      Map<String, dynamic> map = jsonDecode(await configFile.readAsString());


     for(User user in users) {
       if(map["selectedDirectory"] == user.storagePath) {
         selectedUser = user;
         selectedUserFounded = true;
       }
     }
      if(!selectedUserFounded) {
        if(users.isNotEmpty) {
          selectedUser = users.first;
        }
        else {
          Directory directory = Directory(PathUtils.join(storagePath, FilenameUtils.generatedDirectoryName(storagePath)));
          directory.createSync();
          selectedUser = User.fromDirectory(directory);
        }
      }

      List<dynamic> serverList = map["servers"] ?? [];

      for(dynamic data in serverList) {
        if(data is Map<String, dynamic>) {
          servers.add(AppServer.fromMap(data));
        }
      }

    }
    catch(e) {
      if(!selectedUserFounded) {
        if(users.isNotEmpty) {
          selectedUser = users.first;
        }
        else {
          Directory directory = Directory(PathUtils.join(storagePath, FilenameUtils.generatedDirectoryName(storagePath)));
          directory.createSync();
          selectedUser = User.fromDirectory(directory);
        }
      }
    }

    initPaths();

    onInitialize();
  }

  void createDirectoryIfNotExists(String path) {
    Directory directory = Directory(path);
    if(!directory.existsSync()) {
      directory.createSync();
    }
  }

}