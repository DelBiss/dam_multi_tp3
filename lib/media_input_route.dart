import 'package:dam_multi_tp3/media_button.dart';
import 'package:flutter/material.dart';
import 'camera_controller.dart';

class MediaInputRoute extends StatefulWidget {
  const MediaInputRoute({Key? key}) : super(key: key);

  @override
  State<MediaInputRoute> createState() => _MediaInputRouteState();
}

class _MediaInputRouteState extends State<MediaInputRoute> {
  late ControleCamera _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = ControleCamera();
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo & Video"),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                _controller.preview,
                MediaButton(controller: _controller)
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
