import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> generateVerificationReport({
  required String employeeName,
  required String companyName,
  required String agentName,
  required List<String> photos,
}) async {
  final pdf = pw.Document();

  final imageWidgets = <pw.Widget>[];

  int index = 1;

  for (final path in photos) {

    final image = pw.MemoryImage(File(path).readAsBytesSync());

    imageWidgets.addAll([
      pw.Text("Evidence $index",
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Container(
        constraints: const pw.BoxConstraints(maxHeight: 500),
        child: pw.Image(image, fit: pw.BoxFit.contain),
      ),
      pw.SizedBox(height: 20),
    ]);

    index++;
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Text(
          "Verification Report",
          style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
        ),

        pw.SizedBox(height: 20),

        pw.Text("Employee: $employeeName"),
        pw.Text("Company: $companyName"),
        pw.Text("Agent: $agentName"),

        pw.SizedBox(height: 20),

        pw.Text("Evidence Photos", style: pw.TextStyle(fontSize: 18)),

        pw.SizedBox(height: 10),

        ...imageWidgets,
      ],
    ),
  );

  final dir = await getApplicationDocumentsDirectory();

  final file = File("${dir.path}/verification_report.pdf");

  await file.writeAsBytes(await pdf.save());

  return file;
}
