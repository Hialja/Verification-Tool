import 'dart:io';
import 'package:flutter/material.dart';
import '../models/verification.dart';
import '../services/pdf_service.dart';
import 'evidence_upload_screen.dart';
import '../services/app_config.dart';
import 'package:share_plus/share_plus.dart';
import 'photo_gallery_screen.dart';

class VerificationDetailScreen extends StatefulWidget {
  final Verification verification;

  const VerificationDetailScreen({super.key, required this.verification});

  @override
  State<VerificationDetailScreen> createState() =>
      _VerificationDetailScreenState();
}

class _VerificationDetailScreenState extends State<VerificationDetailScreen> {
  List<String> photos = [];

  @override
  void initState() {
    super.initState();
    photos = List<String>.from(widget.verification.photos);

  }

  Future<void> addPhotos(List<String> newPhotos) async {
    photos.addAll(newPhotos);

    widget.verification.photos = photos;
    await widget.verification.save();

    setState(() {});
  }

  Future<void> generateReport() async {
    final v = widget.verification;

    final file = await generateVerificationReport(
      employeeName: v.employeeName,
      companyName: v.companyName,
      agentName: AppConfig.agentName,
      photos: photos,
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Verification Report - ${v.employeeName}",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report generated")),
    );
  }

  Widget buildPhotoGrid() {
    if (photos.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: const Center(
          child: Text(
            "No evidence photos yet",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhotoGalleryScreen(
                  photos: photos,
                  initialInedx: index,

                ),
              ),
            );
          },
          child: Hero(
            tag: photos[index],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(photos[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildInfoCard(Verification v) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              v.companyName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(v.employeeName),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(v.companyAddress)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text("Add Evidence"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EvidenceUploadScreen(
                    verification: widget.verification,
                  ),
                ),
              );

              if (result is List<String>) {
                addPhotos(result);
              }
            },
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Generate Report"),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: generateReport,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.verification;

    return Scaffold(
      appBar: AppBar(
        title: Text(v.employeeName),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            buildInfoCard(v),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: buildSectionTitle("Evidence Photos"),
            ),

            buildPhotoGrid(),

            const SizedBox(height: 30),

            buildButtons(),
          ],
        ),
      ),
    );
  }
}