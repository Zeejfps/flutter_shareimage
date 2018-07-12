import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shareimage/shareimage.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  cameras = await availableCameras();
  runApp(MaterialApp(home: new CameraApp()));
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => new _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = new CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }
    return Scaffold(
      body: new AspectRatio(
          aspectRatio:
          controller.value.aspectRatio,
          child: new CameraPreview(controller)),
      floatingActionButton: new FloatingActionButton(onPressed: (){
        getApplicationDocumentsDirectory().then((dir){
          File picture = new File(dir.path+"/test.jpeg");
          if (picture.existsSync())
            picture.deleteSync();
          controller.takePicture(picture.path).then((_){
            Share.share(picture.path);
          });
        });
      }),
    );
  }
}