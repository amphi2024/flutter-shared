import 'dart:convert';

class UpdateEvent {

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

    static const String uploadSongInfo = "upload_song_info";
    static const String uploadSongFile = "upload_song_file";
    static const String uploadArtistInfo = "upload_artist_info";
    static const String uploadArtistFile = "upload_artist_file";
    static const String uploadAlbumInfo = "upload_album_info";
    static const String uploadAlbumCover = "upload_album_cover";
    static const String uploadPlaylist = "upload_playlist";
    static const String uploadPlaylistThumbnail = "upload_playlist_thumbnail";

    static const String deleteSong = "delete_song";
    static const String deleteSongFile = "delete_song_file";
    static const String deleteArtist = "delete_artist";
    static const String deleteArtistFile = "delete_artist_file";
    static const String deleteAlbum = "delete_album";
    static const String deleteAlbumCover = "delete_album_cover";
    static const String deletePlaylist = "delete_playlist";
    static const String deletePlaylistThumbnail = "delete_playlist_thumbnail";

    static const String uploadPhoto = "upload_photo";
    static const String uploadAlbum = "upload_album";
    static const String deletePhoto = "delete_photo";

    static const String renameUser = "rename_user";

    String get action => data["action"];
    get value => data["value"];
    DateTime get timestamp => DateTime.fromMillisecondsSinceEpoch(data["timestamp"]).toLocal();
    DateTime get timestampUTC => DateTime.fromMillisecondsSinceEpoch(data["timestamp"]);
    Map<String, dynamic> data = {};

    UpdateEvent({required String action, required dynamic value, int? timestamp}) {
        data["action"] = action;
        data["value"] = value;
        data["timestamp"] = timestamp ?? DateTime.now().toUtc().millisecondsSinceEpoch;
    }

    UpdateEvent.fromJson(Map<String, dynamic> json) {
        data = json;
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

    @override
    int get hashCode => action.hashCode ^ value.hashCode;

    @override
    bool operator ==(Object other) {
      return identical(this, other) ||
            other is UpdateEvent &&
                runtimeType == other.runtimeType &&
                action == other.action &&
                value == other.value;
    }

}