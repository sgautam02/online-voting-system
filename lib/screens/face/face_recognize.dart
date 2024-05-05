import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:vote_secure/screens/face/pointers/face_detector_pointer.dart';

class FaceRecognize extends StatefulWidget {
  const FaceRecognize({Key? key}) : super(key: key);

  @override
  State<FaceRecognize> createState() => _FaceRecognizeState();
}

class _FaceRecognizeState extends State<FaceRecognize> {
    FaceDetector _faceDetector =FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );

    CameraController? _controller;
    bool _canProcess = true;
    bool _isBusy = false;
    CustomPaint? _customPaint;
    String? _text;
    var _cameraLensDirection = CameraLensDirection.front;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

    Future<void> _initializeCamera() async {
      final cameras = await availableCameras();

      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.max, // Adjust the preset as needed
      );

      await _controller?.initialize();

      if (!mounted) return;

      // Start the image stream
      _controller?.startImageStream((CameraImage cameraImage) {
        final format = InputImageFormatValue.fromRawValue(cameraImage.format.raw);
        final plane = cameraImage.planes.first;
        if (_canProcess) {
          // Convert CameraImage to InputImage
          InputImage inputImage = InputImage.fromBytes(
            bytes: cameraImage.planes[0].bytes,
            metadata: InputImageMetadata(
              size: Size(
                cameraImage.width.toDouble(),
                cameraImage.height.toDouble(),
              ),
              rotation: InputImageRotation.rotation0deg, // used only in Android
              format: format!,
              bytesPerRow: plane.bytesPerRow, // used only in iOS
            ),
          );

          // Process the image for face detection
          _processImage(inputImage);
        }
      });

      setState(() {});
    }

    @override
    void dispose() {
      _controller?.stopImageStream();
      _controller?.dispose();
      _faceDetector.close();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      if (_controller == null || !_controller!.value.isInitialized) {
        return Container(); // or any other loading indicator
      } else {
        return Scaffold(
          body:  Center(
            child: Stack(
              children: [
                CameraPreview(_controller!,
                   child:  _customPaint
                ),
                // _customPaint ?? Container(),
              ],
            ),
          ),
        );
      }
    }

    Future<void> _processImage(InputImage inputImage) async {
      if (!_canProcess) return;
      if (_isBusy) return;
      _isBusy = true;
      setState(() {
        _text = '';
      });
      final faces = await _faceDetector.processImage(inputImage);
      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null) {
        final painter = FaceDetectorPainter(
          faces,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
        );
        _customPaint = CustomPaint(painter: painter);
      } else {
        String text = 'Faces found: ${faces.length}\n\n';
        for (final face in faces) {
          text += 'face: ${face.boundingBox}\n\n';
        }
        _text = text;
        // TODO: set _customPaint to draw boundingRect on top of image
        _customPaint = null;
      }
      _isBusy = false;
      if (mounted) {
        setState(() {});
      }
    }
}
