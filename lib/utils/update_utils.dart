import 'package:amphi/utils/try_json_decode.dart';
import 'package:http/http.dart';

Future<void> checkForUpdate({required String url, required String currentVersion, void Function()? onSuccess, required void Function(String version) onUpdateFound, void Function()? onFailed}) async {
  try {
    final response = await get(Uri.parse(url)).timeout(const Duration(seconds: 5));
    final body = tryJsonDecode(response.body, defaultValue: {});
    if(response.statusCode == 200) {
      onSuccess?.call();
    }
    final tagName = body['tag_name'];
    if(tagName is String) {
      final latestVersion = tagName.replaceAll("v", "");
      if(latestVersion != currentVersion) {
        onUpdateFound(latestVersion);
      }
    }
  }
  catch(_) {
    onFailed?.call();
  }
}