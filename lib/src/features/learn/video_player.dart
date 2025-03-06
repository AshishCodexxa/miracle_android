import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/video.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.video}) : super(key: key);
  final Video video;
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chew;

  @override
  void initState() {
    super.initState();
    _controller = /* VideoPlayerController.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4') */
        VideoPlayerController.network('${kBaseUrl}video/${widget.video.video}')
          ..addListener(() {
            setState(() {});
          })
          ..initialize();

    _chew = ChewieController(
        videoPlayerController: _controller,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        showControls: true);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor,
        title: Text(widget.video.title,
        style: const TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black54,
        child: _controller.value.isInitialized
            ? Chewie(
                controller: _chew,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chew.dispose();
    super.dispose();
  }
}
