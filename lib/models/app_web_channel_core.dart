import 'dart:convert';
import 'dart:io';

import 'package:amphi/models/update_event.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class AppWebChannelCore {

  bool connected = false;
  WebSocketChannel? webSocketChannel;
  late String deviceName;

  String get serverAddress => "";
  String get token => "";
  String get appType => "";

  List<void Function(String)> userNameUpdateListeners = [];

  void getUserIds({required void Function(List<String>) onResponse, required void Function() onFailed}) async {
    try {
      final response = await get(Uri.parse("$serverAddress/users"));
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(body);
      List<String> result = [];
      for (dynamic data in list) {
        if (data is String) {
          result.add(data);
        }
      }
      onResponse(result);
    } catch (e) {
      onFailed();
    }
  }

  Future<void> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo android = await deviceInfoPlugin.androidInfo;
      deviceName = android.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
      deviceName = ios.model;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windows = await deviceInfoPlugin.windowsInfo;
      deviceName = windows.computerName;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo mac = await deviceInfoPlugin.macOsInfo;
      deviceName = mac.model;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linux = await deviceInfoPlugin.linuxInfo;
      deviceName = linux.name;
    }
  }

  void disconnectWebSocket() {
    webSocketChannel?.sink.close();
  }

  Future<void> connectWebSocket() async {
    try {
      if (serverAddress.startsWith("https://")) {
        setupWebsocketChannel("wss://${serverAddress.split("https://").last}/$appType/sync");
      } else if (serverAddress.startsWith("http://")) {
        setupWebsocketChannel("ws://${serverAddress.split("http://").last}/$appType/sync");
      }
    } on WebSocketChannelException {
      connected = false;
    }
  }

  void setupWebsocketChannel(String serverAddress);

  void postWebSocketMessage(String message) {
    if (webSocketChannel != null) {
      webSocketChannel?.sink.add(message);
    } else {
      connectWebSocket();
      webSocketChannel?.sink.add(message);
    }
  }

  void logout({required void Function() onLoggedOut, required void Function() onFailed}) async {
    try {
      final response = await get(
        Uri.parse("$serverAddress/users/logout"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );
      if (response.statusCode == 200) {
        onLoggedOut();
      } else {
        onFailed();
      }
    } catch (e) {
      onFailed();
    }
  }

  void login({required String id, required String password, required void Function(String, String) onLoggedIn, required void Function(int? ) onFailed}) async {
    Map<String, dynamic> data = {'id': id, 'password': password};

    String postData = json.encode(data);

    try {
      final response = await post(
        Uri.parse("$serverAddress/users/login"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Device-Name": deviceName},
        body: postData,
      );
      String responseBody = utf8.decode(response.bodyBytes);
      String token = responseBody.split(";").first;
      String username = responseBody.split(";").last;
      if (token.isNotEmpty && response.statusCode == 200) {
        onLoggedIn(username, token);
      } else {
        onFailed(HttpStatus.unauthorized);
      }
    } catch (e) {
      onFailed(null);
    }
  }

  void register(
      {required String id,
        required String name,
        required String password,
        required void Function() onRegistered,
        required void Function(int? ) onFailed}) async {
    Map<String, dynamic> data = {'id': id, 'password': password, "name": name};

    String postData = json.encode(data);

    try {
      final response = await post(
        Uri.parse("$serverAddress/users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: postData,
      );
      String token = response.body;
      if (token.isNotEmpty && response.statusCode == 200) {
        onRegistered();
      } else {
        onFailed(HttpStatus.unauthorized);
      }
    } catch (e) {
      onFailed(null);
    }
  }

  void changePassword(
      {required String id,
        required String password,
        required String oldPassword,
        required void Function() onSuccess,
        required void Function(int? ) onFailed}) async {
    Map<String, dynamic> data = {"id": id, "password": password, "old_password": oldPassword};

    String postData = json.encode(data);

    try {
      final response = await patch(
        Uri.parse("$serverAddress/users/$id/password"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: postData,
      );
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onFailed(HttpStatus.unauthorized);
      }
    } catch (e) {
      onFailed(null);
    }
  }


  void changeUsername({required String name, required void Function() onSuccess, required void Function(int?) onFailed}) async {
    Map<String, dynamic> data = {"name": name};

    String postData = json.encode(data);

    try {
      final response = await patch(
        Uri.parse("$serverAddress/users/name"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
        body: postData,
      );
      if (response.statusCode == 200) {
        onSuccess();

        UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.renameUser, value: name);
        postWebSocketMessage(updateEvent.toWebSocketMessage());
      } else {
        onFailed(response.statusCode);
      }
    } catch (e) {
      onFailed(null);
    }
  }

  void getStorageInfo({required void Function(Map<String, dynamic>) onSuccess, required void Function() onFailed}) async {
    try {
      final response = await get(Uri.parse("$serverAddress/storage")).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        onSuccess(jsonDecode(response.body));
      } else {
        onFailed();
      }
    } catch (e) {
      onFailed();
    }
  }

  Future<void> uploadJson(
      {required String url,
        required String jsonBody,
        void Function()? onSuccess,
        void Function(int?)? onFailed,
        required UpdateEvent updateEvent}) async {
    try {
      final response = await post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token}, body: jsonBody);
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess();
        }
        postWebSocketMessage(updateEvent.toWebSocketMessage());
      } else {
        if (onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed(null);
      }
    }
  }

  Future<void> uploadFile(
      {required String url,
        required String filePath,
        void Function()? onSuccess,
        void Function(int?)? onFailed}) async {
    try {
      MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
      MultipartFile multipartFile = await MultipartFile.fromPath("file", filePath);

      request.headers.addAll({"Authorization": token});
      request.files.add(multipartFile);
      var response = await request.send();

      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        if (onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed(null);
      }
    }
  }

  Future<void> downloadLargeFile({required String url,
    required String filePath,
    void Function()? onSuccess,
    void Function(int?)? onFailed}) async {
    try {
      final request = Request('GET', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json; charset=UTF-8', "Authorization": token});
      final response = await Client().send(request);
      final file = File(filePath);
      final sink = file.openWrite();

      await response.stream.pipe(sink);
      await sink.close();

      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess();
        }
      } else if (onFailed != null) {
        onFailed(response.statusCode);
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed(null);
      }
    }
  }

  Future<void> downloadJson({required String url, required void Function(Map<String, dynamic>) onSuccess, void Function()? onFailed}) async {
    try {
      final response = await get(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );
      if (response.statusCode == 200) {
        onSuccess(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  Future<void> simpleDelete({required String url, void Function()? onSuccess, void Function(int?)? onFailed}) async {
    final response = await delete(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
    );
    if (response.statusCode == 200) {
      if (onSuccess != null) {
        onSuccess();
      }
    } else if (onFailed != null) {
      onFailed(response.statusCode);
    }
  }

}