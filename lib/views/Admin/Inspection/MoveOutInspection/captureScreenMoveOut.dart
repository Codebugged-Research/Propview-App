import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/Types/moveOutInspectionScreen.dart';

class CaptureScreenMoveOut extends StatefulWidget {
  final List<String> imageList;
  final int index1;
  final int index2;
  final PropertyElement propertyElement;
  final List<List<Issue>> rows;
  final List<IssueTableData> issueTableList;
  final Inspection inspection;
  CaptureScreenMoveOut({
    this.imageList,
    this.propertyElement,
    this.index1,
    this.index2,
    this.inspection,
    this.rows,
    this.issueTableList,
  });
  @override
  _CaptureScreenMoveOutState createState() => _CaptureScreenMoveOutState();
}

class _CaptureScreenMoveOutState extends State<CaptureScreenMoveOut>
    with WidgetsBindingObserver {
  CameraController cameraController;
  CameraDescription cameraDescription;
  int selectedCamera = 0;

  bool mounted = false;
  bool isFlashOn = false;
  Future<void> cameraValue;

  List<String> imageList;

  @override
  void initState() {
    super.initState();
    initialiseCamera();
    imageList = widget.imageList;
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
      //Adding Images to List
      setState(() {
        imageList.add(compressedImage.path);
      });
      await Routing.makeRouting(
        context,
        routeMethod: 'pushReplacement',
        newWidget: MoveOutInspectionScreen(
          imageList: imageList,
          index1: widget.index1,
          index2: widget.index2,
          inspection: widget.inspection,
          propertyElement: widget.propertyElement,
          rows: widget.rows,
          issueTableList: widget.issueTableList,
        ),
      );
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
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
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