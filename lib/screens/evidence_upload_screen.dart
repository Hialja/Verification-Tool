import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verification_tool/services/image_footer_service.dart';
import 'dart:io';
import '../models/verification.dart';
import 'package:verification_tool/services/location_service.dart';
import '../services/address_service.dart';
import '../services/map_service.dart';
import '../services/storage_service.dart';
import '../services/app_config.dart';

class EvidenceUploadScreen extends StatefulWidget {
  final Verification verification;

  const EvidenceUploadScreen({super.key, required this.verification});

  @override
  State<EvidenceUploadScreen> createState() => _EvidenceUploadScreenState();
}

class _EvidenceUploadScreenState extends State<EvidenceUploadScreen> {
  final ImagePicker picker = ImagePicker();

  List<String> photos = [];
  bool isProcessing = false;

  Future<void> _processImage(XFile? image) async {
    if (image == null) return;

    try {
      setState(() {
        isProcessing = true;
      });

      final photoFile = File(image.path);

      /// Get GPS
      final location = await getLocation();

      /// Download map for THIS photo location
      final map = await downloadMap(
        location.latitude,
        location.longitude,
      );

      /// Get human readable address
      final address = await getAddress(
        location.latitude,
        location.longitude,
      );

      /// Add footer
      final newImage = await addFooterToImage(
        photoFile,
        widget.verification.companyName,
        AppConfig.agentName,
        address,
        location.latitude,
        location.longitude,
        map,
      );

      /// Save processed image
      final savedImage = await saveVerificationPhoto(
        newImage,
        widget.verification.id,
      );

      if (!mounted) return;

      setState(() {
        photos.add(savedImage.path);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to process photo")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  Future<void> takePhoto() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      imageQuality: 85,
    );

    await _processImage(image);
  }

  Widget buildPhotoTile(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(backgroundColor: Colors.black),
                      body: Center(
                        child: InteractiveViewer(
                          child: Image.file(
                            File(photos[index]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Image.file(
                File(photos[index]),
                fit: BoxFit.cover,
                cacheWidth: 600,
              ),
            ),
          ),

          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete photo?"),
                    content: const Text("This evidence will be removed."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final file = File(photos[index]);

                  if (await file.exists()) {
                    await file.delete();
                  }

                  setState(() {
                    photos.removeAt(index);
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Evidence')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, photos);
        },
        icon: const Icon(Icons.check),
        label: const Text("Finish"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Evidence Photos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isProcessing ? null : takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                    ),
                  ],
                ),
              ),
            ),

            if (isProcessing) ...[
              const SizedBox(height: 15),
              const CircularProgressIndicator(),
            ],

            const SizedBox(height: 15),

            Expanded(
              child: GridView.builder(
                itemCount: photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return buildPhotoTile(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}