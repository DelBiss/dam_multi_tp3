import 'dart:io';

import 'package:flutter/material.dart';

class PhotoRoute extends StatelessWidget {
  final String imagePath;
  const PhotoRoute({ Key? key, required this.imagePath }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var img = Image.file(File(imagePath));
    
    return Scaffold(
      appBar: AppBar(title: const Text("Photo"),),
      body: AspectRatio(
        aspectRatio: ((img.width??1)/(img.height??1)),
        child: img,
      ),

    );
  }
}