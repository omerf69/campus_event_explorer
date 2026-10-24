import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? eventId;

  const ImageViewerScreen({
    super.key,
    required this.imagePath,
    required this.title,
    this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );

    if (eventId != null) {
      imageWidget = Hero(
        tag: 'event_image_$eventId',
        child: imageWidget,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: imageWidget,
        ),
      ),
    );
  }
}
