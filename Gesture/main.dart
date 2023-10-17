import 'package:flutter/material.dart';

void main() {
  runApp(ImageZoomApp());
}

class ImageZoomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageZoomScreen(),
    );
  }
}

class ImageZoomScreen extends StatefulWidget {
  @override
  _ImageZoomScreenState createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  TransformationController _controller = TransformationController();
  int _currentImageIndex = 0;
  List<String> _imageList = [
    'assets/cat1.jpg',
    'assets/cat2.jpg',
    'assets/cat3.jpg',
  ];

  void _changeImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % _imageList.length;
      _controller.value =
          Matrix4.identity(); // Reset the transformation when changing image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestures'),
      ),
      body: GestureDetector(
        onTap: _changeImage,
        child: Center(
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 1.0,
            maxScale: 3.0,
            child: Image.asset(
              _imageList[_currentImageIndex],
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
