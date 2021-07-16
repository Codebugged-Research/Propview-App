import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/Types/fullInspectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController cameraController;
  CameraDescription cameraDescription;
  int selectedCamera = 0;
  bool mounted = false;
  bool isFlashOn = false;
  Future<void> cameraValue;
  File croppedFile;

  @override
  void initState() {
    super.initState();
    initialiseCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  initialiseCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
        cameras[selectedCamera], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg);
    cameraValue = cameraController.initialize().then((value) {
      setState(() {
        mounted = true;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  takePicture() async {
    try {
      //Take Picture
      XFile image = (await cameraController.takePicture());
      //Convert XFile to File
      Uint8List imageBytes = await image.readAsBytes();
      File convertedImage = await File(image.path).writeAsBytes(imageBytes);
      //Compressing Image
      var compressedImage = await compressImage(convertedImage);

      WidgetsBinding.instance.removeObserver(this);
      cameraController.dispose();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  compressImage(File originalImage) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final compressedResult = await FlutterImageCompress.compressAndGetFile(
      originalImage.path,
      path.join(dir, "${DateTime.now()}" + ".jpeg"),
      format: CompressFormat.jpeg,
      quality: 40,
    );
    return compressedResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Camera'),
        actions: [
          IconButton(
              onPressed: () async {
                final cameras = await availableCameras();
                setState(() {
                  mounted = false;
                  selectedCamera = selectedCamera == 0 ? 1 : 0;
                });
                cameraController = CameraController(
                    cameras[selectedCamera], ResolutionPreset.high,
                    imageFormatGroup: ImageFormatGroup.jpeg);
                cameraValue = cameraController.initialize().then((value) {
                  setState(() {
                    mounted = true;
                  });
                });
              },
              icon: Icon(Icons.flip_camera_ios_sharp)),
          isFlashOn
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isFlashOn = false;
                      cameraController.setFlashMode(FlashMode.off);
                    });
                  },
                  icon: Icon(Icons.flash_on))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isFlashOn = true;
                      cameraController.setFlashMode(FlashMode.torch);
                    });
                  },
                  icon: Icon(Icons.flash_off)),
        ],
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height - 168,
              width: MediaQuery.of(context).size.width,
              child: !mounted
                  ? circularProgressWidget()
                  : AspectRatio(
                      aspectRatio: cameraController.value.aspectRatio,
                      child: CameraPreview(cameraController))),
          Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await takePicture();
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}