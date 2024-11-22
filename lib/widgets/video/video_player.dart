

import 'package:amphi/widgets/video/controls/video_controls.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayer extends StatefulWidget {

  final String path;
  final Widget Function() errorBuilder;
  const VideoPlayer({super.key, required this.path, required this.errorBuilder});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();

  static void prepare() async {
    WidgetsFlutterBinding.ensureInitialized();
    MediaKit.ensureInitialized();
    // await SystemChrome.setPreferredOrientations(
    //   [
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ],
    // );
  }
}

class _VideoPlayerState extends State<VideoPlayer> {

  late final Player player;
  late final VideoController videoController;
  bool errorCaused = false;

  @override
  void dispose() {
    player.dispose();

    super.dispose();
  }

  @override
  void initState() {
    player = Player();
    videoController = VideoController(player);
    player.open(Media(widget.path), play: false);
    player.stream.error.listen((value) {
      setState(() {
        errorCaused = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(errorCaused) {
      return widget.errorBuilder();
    }
    return Video(
      height: width / (16 / 9),
        controller: videoController,
      controls: videoControls,

    );
  }
}
