import 'dart:io';
import 'package:flutter/material.dart';
import '../models/verification.dart';
import '../services/pdf_service.dart';
import 'evidence_upload_screen.dart';
import '../services/app_config.dart';
import 'package:share_plus/share_plus.dart';

class VerificationDetailScreen extends StatefulWidget {
  final Verification verification;

  const VerificationDetailScreen({super.key, required this.verification});

  @override
  State<VerificationDetailScreen> createState() =>
      _VerificationDetailScreenState();
}

class _VerificationDetailScreenState extends State<VerificationDetailScreen> {
  List<String> photos = [];

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
      SnackBar(
        content: Text("Report generated: ${file.path}"),
      ),
    );
  }



  @override
  void  initState() {
    super.initState();
    photos = List<String>.from(widget.verification.photos);
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.verification;
    

    return Scaffold(
      appBar: AppBar(title: Text(v.employeeName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Company: ${v.companyName}", style: TextStyle(fontSize: 16)),

            Text("Address: ${v.companyAddress}"),

            const SizedBox(height: 20),

            const Text(
              'Evidence Photos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: GridView.builder(
                itemCount: photos.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Scaffold(
                              backgroundColor: Colors.black,
                              appBar: AppBar(),
                              body: Center(
                                child: InteractiveViewer(
                                  child: Image.file(
                                    File(photos[index]),
                                    fit: BoxFit.cover,
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
                      ),
                    )
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Add Evidence"),
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
            const SizedBox(height: 10,),
            
            ElevatedButton.icon(onPressed: generateReport, label: const Text("Generate Report"), icon: const Icon(Icons.picture_as_pdf),)
          ],
        ),
      ),
    );
  }
}
