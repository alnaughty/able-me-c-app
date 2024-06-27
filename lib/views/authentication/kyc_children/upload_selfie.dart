import 'dart:convert';
import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:camera/camera.dart';
// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:face_camera/face_camera.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class SelfieKYCPage extends StatefulWidget {
  const SelfieKYCPage({super.key, required this.imageCallback});
  final ValueChanged<String> imageCallback;
  @override
  State<SelfieKYCPage> createState() => _SelfieKYCPageState();
}

class _SelfieKYCPageState extends State<SelfieKYCPage> with ColorPalette {
  late CameraController controller;
  File? _capturedImage;

  @override
  void initState() {
    _initializeCamera();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String?> _takePicture() async {
    try {
      final XFile file = await controller.takePicture();

      return base64.encode(await file.readAsBytes());
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  bool _cameraReady = false;
  Future<void> _initializeCamera() async {
    final List<CameraDescription> cameras = await availableCameras();

    await Future.delayed(const Duration(milliseconds: 400));

    final CameraDescription camera = cameras
        .where((element) => element.lensDirection == CameraLensDirection.front)
        .first;

    setState(() {
      controller = CameraController(camera, ResolutionPreset.max);
    });
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraReady = true;
      });
    }).catchError((Object e) {
      setState(() {
        _cameraReady = false;
      });
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            Fluttertoast.showToast(msg: "Camera access denied");
            break;
          default:
            Fluttertoast.showToast(msg: "Unable to access camera");
            // Handle other errors here.
            break;
        }
      }
    });
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double overlaySize = size.width * 0.85;
    return Center(
      child: _cameraReady
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Transform.scale(
                scale: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: CameraPreview(
                    controller,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FloatingActionButton(
                          onPressed: () async {
                            final String? img = await _takePicture();
                            if (img == null) return;
                            widget.imageCallback(img);
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // child: SizedBox(
                    //   width: size.width,
                    // ),
                    // child: Text("asdasdas"),
                  ),
                ),
              ),
            )
          : const CircularProgressIndicator.adaptive(),
    );
    // return SizedBox(
    //   height: overlaySize,
    //   child: Scaffold(
    //     body: Center(
    //       child: SmartFaceCamera(
    //         autoCapture: true,
    //         showCameraLensControl: false,
    //         showControls: false,
    //         defaultCameraLens: CameraLens.back,
    //         onCapture: (File? image) async {
    //           setState(() => _capturedImage = image);
    //           if (image == null) return;
    //           widget.imageCallback(await image.readAsString());
    //         },
    //         onFaceDetected: (Face? face) {
    //           //Do something
    //           if (face == null) return;
    //
    //         },
    //         messageBuilder: (context, face) {
    //           if (face == null) {
    //             return Text('Place your face in the camera');
    //           }
    //           if (!face.wellPositioned) {
    //             return Text('Center your face in the square');
    //           }
    //           return const SizedBox.shrink();
    //         },
    //       ),
    //       // : Column(
    //       //     children: [
    //       //       const SizedBox(
    //       //         height: 30,
    //       //       ),
    //       //       // ClipOval(
    //       //       //   child: SizedBox(
    //       //       //     width: overlaySize,
    //       //       //     height: overlaySize,
    //       //       //     child: CameraPreview(controller),
    //       //       //   ),
    //       //       // ),
    //       //       const SizedBox(
    //       //         height: 20,
    //       //       ),
    //       //       Padding(
    //       //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //       //         child: Column(
    //       //           crossAxisAlignment: CrossAxisAlignment.center,
    //       //           children: [
    //       //             Text(
    //       //               "Center your face".toUpperCase(),
    //       //               textAlign: TextAlign.center,
    //       //               style: TextStyle(
    //       //                 color: Colors.grey.shade800,
    //       //                 fontWeight: FontWeight.w600,
    //       //                 fontSize: 17,
    //       //               ),
    //       //             ),
    //       //             const SizedBox(
    //       //               height: 5,
    //       //             ),
    //       //             Text(
    //       //               "Align your face to the center of the selfie area and then take a photo.",
    //       //               textAlign: TextAlign.center,
    //       //               style: TextStyle(
    //       //                 color: Colors.black.withOpacity(.5),
    //       //               ),
    //       //             )
    //       //           ],
    //       //         ),
    //       //       ),
    //       //       const SizedBox(
    //       //         height: 20,
    //       //       ),
    //       //       MaterialButton(
    //       //         shape: RoundedRectangleBorder(
    //       //           borderRadius: BorderRadius.circular(5),
    //       //         ),
    //       //         height: 60,
    //       //         color: _colors.top,
    //       //         onPressed: () async {
    //       //           await _takePicture().then((value) async {
    //       //             if (value == null) {
    //       //               Navigator.of(context).pop();
    //       //               Fluttertoast.showToast(
    //       //                 msg: "Unable to upload image",
    //       //               );
    //       //               return;
    //       //             }
    //       //             widget.imageCallback(value);
    //       //             // Navigator.of(context).pop();
    //       //             // await _api.uploadSelfie(value);
    //       //           });
    //       //         },
    //       //         child: const Center(
    //       //           child: Row(
    //       //             mainAxisAlignment: MainAxisAlignment.center,
    //       //             children: [
    //       //               Icon(
    //       //                 Icons.add_a_photo_rounded,
    //       //                 color: Colors.white,
    //       //               ),
    //       //               SizedBox(
    //       //                 width: 10,
    //       //               ),
    //       //               Text(
    //       //                 "Capture",
    //       //                 style: TextStyle(
    //       //                   color: Colors.white,
    //       //                   fontSize: 16,
    //       //                   fontWeight: FontWeight.w500,
    //       //                 ),
    //       //               )
    //       //             ],
    //       //           ),
    //       //         ),
    //       //       ),
    //       //       const SafeArea(
    //       //         child: SizedBox(
    //       //           height: 30,
    //       //         ),
    //       //       ),
    //       //     ],
    //       //   ),
    //     ),
    //   ),
    // );
  }
}
