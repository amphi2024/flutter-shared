import 'dart:convert';

class UpdateEvent {

    //websocket, restapi
    static const String uploadNote = "upload_note";
    static const String uploadImage = "upload_image";
    static const String uploadVideo = "upload_video";
    static const String uploadTheme = "upload_theme";
    static const String uploadColors = "upload_colors";
    static const String uploadFile = "upload_file";

    static const String deleteNote = "delete_note";
    static const String deleteImage = "delete_image";
    static const String deleteVideo = "delete_video";
    static const String deleteTheme = "delete_theme";
    static const String deleteColors = "delete_colors";
    static const String deleteFile = "delete_file";
    static const String renameUser = "rename_user";

    // websocket only
    static const String moveNotes = "move_notes";

    final String action;
    final String value;
    final DateTime timestamp;

    const UpdateEvent( {required this.action, required this.value, required this.timestamp});

    static UpdateEvent fromJson(Map<String, dynamic> jsonData) {
        return UpdateEvent(action: jsonData["action"] ?? "", value: jsonData["value"] ?? "", timestamp: DateTime.fromMillisecondsSinceEpoch(jsonData["timestamp"]).toLocal());
    }

    String toWebSocketMessage() {
        Map<String, dynamic> map = {
            "action": action,
            "value": value,
            "timestamp": timestamp.toUtc().millisecondsSinceEpoch
        };
        return jsonEncode(map);
    }

    @override
  String toString() {
    return """
    action: $action,
    value: $value,
    timestamp: $timestamp
    """;
  }
}