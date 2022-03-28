

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum CameraStatus {notReady,ready,recording}
class ControleCamera {
  late CameraController _controller;
  late CameraPreview _preview;
  late Future<void> initFuture;
  final _status = StreamController<CameraStatus>();
  CameraStatus _state = CameraStatus.notReady;

  CameraStatus get state {return _state;}
  set state(CameraStatus newState){
    _state = newState;
    _status.sink.add(_state);
  }

  Stream<CameraStatus> get status{
    return _status.stream;
  }
  String? lastCapture;

  void dispose(){
    _controller.dispose();
  }

  Future<void> initialize() async{
    initFuture =  availableCameras()
      .then((cameras) => cameras.first)
      .then((camera)
      {
        _controller = CameraController(camera,ResolutionPreset.medium,);
        _preview = CameraPreview(_controller);
        return _controller.initialize().then((value){
          state = CameraStatus.ready;
        });
      });
      return initFuture;
  }

  CameraPreview get preview {
    return _preview;
  }

  Future<bool> takePicture() async{
    try {
      await initFuture;
      lastCapture = (await _controller.takePicture()).path;
      return true;
    } catch (e) {
      // If an error occurs, log the error to the console.
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> recordVideo() async {
    debugPrint(state.toString());
    if( state == CameraStatus.recording){
      state = CameraStatus.notReady;
      lastCapture = (await _controller.stopVideoRecording()).path;
      state = CameraStatus.ready;
    }
    else{
      state = CameraStatus.notReady;
      await _controller.prepareForVideoRecording();
      await _controller.startVideoRecording();
      state = CameraStatus.recording;
    }
  }

}