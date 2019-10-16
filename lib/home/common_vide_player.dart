import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CommonVideoPlayer extends StatefulWidget {
  String videoUrl;

  CommonVideoPlayer({this.videoUrl}) : super();

  @override
  _CommonVideoPlayerState createState() => _CommonVideoPlayerState();
}

class _CommonVideoPlayerState extends State<CommonVideoPlayer>
    with SingleTickerProviderStateMixin {
  var chewieController;
  var videoPlayerController2;

  @override
  void initState() {
    String _video_url = widget.videoUrl;
    videoPlayerController2 = VideoPlayerController.network(widget.videoUrl);
    chewieController = ChewieController(
      showControls: false,
      startAt: _video_url.contains("pear-user-video")
          ? new Duration(seconds: 5)
          : new Duration(seconds: 0),
      videoPlayerController: videoPlayerController2,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController2.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: new Center(
        child: Chewie(
          controller: chewieController,
        ),
      ),
    );
  }
}
