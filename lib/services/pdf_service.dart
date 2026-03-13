import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

String _month(int m) {
  const months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[m];
}

String _pad(int n) => n.toString().padLeft(2, '0');

Future<File> generateVerificationReport({
  required String employeeName,
  required String companyName,
  required String agentName,
  required String address,
  required String managerName,
  required String managerPhone,
  required int photoCount,
  required List<String> photos,
}) async {

  final pdf = pw.Document();
  final now = DateTime.now();

  final evidenceWidgets = <pw.Widget>[];

  int i = 1;
  for (final path in photos) {
    final file = File(path);
    if (!await file.exists()) continue;

    final image = pw.MemoryImage(await file.readAsBytes());

    evidenceWidgets.add(
      pw.Container(
        margin: const pw.EdgeInsets.only(top: 18),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            pw.Text(
              "Evidence $i",
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 8),

            pw.Container(
              width: double.infinity,
              height: 420,
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              padding: const pw.EdgeInsets.all(8),

              child: pw.Image(
                image,
                fit: pw.BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );

    i++;
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),

      build: (context) => [

        /// HEADER
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            pw.Text(
              "VERIFYFIELD",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: pw.BoxDecoration(
                color: PdfColors.green600,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                "OK",
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 6),

        pw.Text(
          "Field Verification Report",
          style: pw.TextStyle(fontSize: 15),
        ),

        pw.Text(
          "${now.day} ${_month(now.month)} ${now.year}",
          style: pw.TextStyle(fontSize: 10),
        ),

        pw.SizedBox(height: 26),

        /// VERIFICATION RESULT
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.grey700,
              width: 1.4,
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Text(
                "VERIFICATION RESULT",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),

              pw.SizedBox(height: 6),

              pw.Text(
                "VERIFIED",
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 22),

        /// VERIFICATION DETAILS
        pw.Text(
          "VERIFICATION DETAILS",
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),

        pw.SizedBox(height: 12),

        pw.Table(
          columnWidths: {
            0: const pw.FixedColumnWidth(130),
          },
          children: [

            _row("Company", companyName),
            _row("Employee", employeeName),
            _row("Address", address),
            _row("Field Agent", agentName),
            _row(
              "Report Date",
              "${_pad(now.day)}/${_pad(now.month)}/${now.year} ${_pad(now.hour)}:${_pad(now.minute)}",
            ),
            _row('Manager Name', managerName),
            _row('Manager Phone', managerPhone),

          ],
        ),


        pw.SizedBox(height: 22),

        /// EVIDENCE PHOTOS
        if (evidenceWidgets.isNotEmpty) ...[

          pw.SizedBox(height: 26),

          pw.Text(
            "EVIDENCE PHOTOS",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
          ),

          pw.SizedBox(height: 12),

          ...evidenceWidgets,
        ],

        pw.SizedBox(height: 30),

        /// FOOTER
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [

            pw.Text(
              "Generated by VerifyField ${_pad(now.day)}/${_pad(now.month)}/${now.year} ${_pad(now.hour)}:${_pad(now.minute)}",
              style: const pw.TextStyle(fontSize: 9),
            ),

            pw.Text(
              "CONFIDENTIAL",
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      ],
    ),
  );

  final dir = await getApplicationDocumentsDirectory();

  final file = File(
    "${dir.path}/verification_report_${now.millisecondsSinceEpoch}.pdf",
  );

  await file.writeAsBytes(await pdf.save());

  return file;
}

/// TABLE ROW
pw.TableRow _row(String label, String value) {

  return pw.TableRow(
    children: [

      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 6),
        child: pw.Text(
          label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),

      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 6),
        child: pw.Text(value),
      ),
    ],
  );
}
