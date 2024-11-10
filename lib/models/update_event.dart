import 'dart:convert';

import 'package:amphi/models/date_time_parser.dart';

class UpdateEvent {

    //websocket, restapi
    static const String uploadNote = "upload_note";
    static const String uploadImage = "upload_image";
    static const String uploadVideo = "upload_video";
    static const String uploadTheme = "upload_theme";
    static const String uploadColors = "upload_colors";

    static const String deleteNote = "delete_note";
    static const String deleteImage = "delete_image";
    static const String deleteVideo = "delete_video";
    static const String deleteTheme = "delete_theme";
    static const String deleteColors = "delete_colors";
    static const String renameUser = "rename_user";

    // websocket only
    static const String moveNotes = "move_notes";

    final String action;
    final String value;
    final DateTime date;

    const UpdateEvent( {required this.action, required this.value, required this.date});

    String toJson() {
        Map<String, dynamic> map = {
            "action": action,
            "value": value,
            "date": DateTimeParser.toDataString(date)
        };
        return jsonEncode(map);
    }

    @override
  String toString() {
    return """
    action: $action,
    value: $value,
    date: $date
    """;
  }
}