import 'dart:io';

import 'package:flutter/material.dart';

class PhotoRoute extends StatelessWidget {
  final String imagePath;
  const PhotoRoute({ Key? key, required this.imagePath }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photo"),),
      body: Image.file(File(imagePath)),

    );
  }
}