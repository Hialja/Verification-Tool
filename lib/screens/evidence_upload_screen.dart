import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verification_tool/services/image_footer_service.dart';
import 'dart:io';
import '../models/verification.dart';

import 'package:verification_tool/services/location_service.dart';

import '../services/map_service.dart';
import '../services/storage_service.dart';
import '../services/app_config.dart';
import 'dart:typed_data';

class EvidenceUploadScreen extends StatefulWidget {
  final Verification verification;

  const EvidenceUploadScreen({super.key, required this.verification});

  @override
  State<EvidenceUploadScreen> createState() => _EvidenceUploadScreenState();
}

class _EvidenceUploadScreenState extends State<EvidenceUploadScreen> {

  final ImagePicker picker = ImagePicker();
  List<String> photos = [];
  Uint8List? verificationMap;

  Future<void> takePhoto() async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      imageQuality: 85,
    );

    if (image == null) return;

    final location = await getLocation();

    final newImage = await addFooterToImage(
      File(image.path),
      widget.verification.companyName,
      AppConfig.agentName,
      location.latitude,
      location.longitude,
      verificationMap,
    );

    final savedImage = await saveVerificationPhoto(
      newImage,
      widget.verification.id,
    );

    setState(() {
      photos.add(savedImage.path);
    });
  }

  @override
  void initState() {
    super.initState();
    loadMap();
  }

  Future<void> loadMap() async {

    final location = await getLocation();

    verificationMap =
    await downloadMap(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Evidence'),
      ),
      body:Column(
        children: [
          ElevatedButton(onPressed: takePhoto, child: const Text("Take Photo")),

          Expanded(child: GridView.builder(
            itemCount: photos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Image.file(
                  File(photos[index]),
                  fit: BoxFit.cover,
                ),
              );
            },
          )),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, photos);
            },
            child: const Text("Finish"),
          )
        ],
      ),
    );
  }
}
