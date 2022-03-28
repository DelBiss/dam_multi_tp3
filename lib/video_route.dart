import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoRoute extends StatefulWidget {
  final String videoPath;
  const VideoRoute ({Key? key, required this.videoPath}) : super(key: key);
  @override
  _VideoRouteState createState() => _VideoRouteState();
}

class _VideoRouteState extends State<VideoRoute > {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }
  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video"),),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            );
          } else {
            return const Center( child: CircularProgressIndicator(), );
          }},),
      floatingActionButton: FloatingActionButton(
        onPressed: () { setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });},
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),);}
}
