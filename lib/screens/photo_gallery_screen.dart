import 'package:flutter/material.dart';
import 'dart:io';

class PhotoGalleryScreen extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const PhotoGalleryScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  late PageController controller;
  late int currentIndex;


  @override
  void initState(){
    super.initState();
    currentIndex = widget.initialIndex;
    controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${currentIndex + 1} / ${widget.photos.length}', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: widget.photos.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(child: Image.file(File(widget.photos[index]),fit: BoxFit.contain,)),
          );
        },
      ),
    );
  }
}
