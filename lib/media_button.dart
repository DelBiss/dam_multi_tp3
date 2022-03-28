import 'package:flutter/material.dart';

import 'camera_controller.dart';
import 'photo_route.dart';
import 'video_route.dart';

class MediaButton extends StatelessWidget {
  final ControleCamera controller;
  const MediaButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.status,
        builder: (context, AsyncSnapshot<CameraStatus> snapshot) {
      Function()? pictureButton;
      Function()? videoButton;
      Widget pictureTxt = const Text("Photo");
      Widget videoTxt = const Text("Video");

      if (snapshot.hasData) {
        if (snapshot.data == CameraStatus.ready) {
          pictureButton = showPicture(context);
          videoButton = showVideo(context);
        } else if (snapshot.data == CameraStatus.recording) {
          videoTxt = const Text("Pause");
          videoButton = showVideo(context);
        }
      }
      return ButtonBar(alignment: MainAxisAlignment.spaceEvenly, children: [
        ElevatedButton(onPressed: pictureButton, child: pictureTxt),
        ElevatedButton(onPressed: videoButton, child: videoTxt),
      ]);
    });
  }

  Function() navigateRoute(BuildContext context, Widget route) {
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => route));
    };
  }

  Function() showPicture(BuildContext context)  {
    return ()
    async {
        if(await controller.takePicture())
        {
            if (controller.state == CameraStatus.ready && controller.lastCapture != null)
            {
                return navigateRoute(context, PhotoRoute(imagePath: controller.lastCapture!))();
            }
        }
        return (){};
    };
  }

  Function() showVideo(BuildContext context) {
    return () async {
        await controller.recordVideo();
        if (controller.state == CameraStatus.ready && controller.lastCapture != null){
            return navigateRoute(context, VideoRoute(videoPath: controller.lastCapture!))();
        }
    };
  }
}
