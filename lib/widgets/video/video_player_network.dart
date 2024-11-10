import 'package:amphi/widgets/video/controls/video_controls.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerNetwork extends StatefulWidget {
  final String url;
  final Map<String, String>? headers;
  const VideoPlayerNetwork({super.key, required this.url, this.headers});

  @override
  State<VideoPlayerNetwork> createState() => _VideoPlayerNetworkState();
}

class _VideoPlayerNetworkState extends State<VideoPlayerNetwork> {

  late final Player player;
  late final VideoController videoController;

  @override
  void dispose() {
    player.dispose();

    super.dispose();
  }

  @override
  void initState() {
    player = Player();
    videoController = VideoController(player);
    player.open(Media(widget.url, httpHeaders: widget.headers), play: false,);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Video(
      height: width / (16 / 9),
      controller: videoController,
      controls: videoControls,
    );
  }
}
