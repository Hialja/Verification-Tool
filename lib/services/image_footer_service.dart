import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

Future<File> addFooterToImage(
    File file,
    String companyName,
    String agentName,
    double lat,
    double lng,
    Uint8List? mapBytes,
    ) async {

  final bytes = await file.readAsBytes();
  final original = img.decodeImage(bytes);

  if (original == null) {
    throw Exception("Failed to decode image");
  }

  final timestamp = DateFormat("dd MMM yyyy  HH:mm").format(DateTime.now());

  const footerHeight = 320;

  final newImage = img.Image(
    width: original.width,
    height: original.height + footerHeight,
  );

  // copy original photo
  img.compositeImage(newImage, original);

  // footer background
  img.fillRect(
    newImage,
    x1: 0,
    y1: original.height,
    x2: original.width,
    y2: original.height + footerHeight,
    color: img.ColorRgba8(0, 0, 0, 200),
  );

  int startY = original.height + 40;

  // COMPANY
  img.drawString(
    newImage,
    "COMPANY: $companyName",
    x: 40,
    y: startY,
    font: img.arial48,
    color: img.ColorRgb8(255, 255, 255),
  );

  // AGENT
  img.drawString(
    newImage,
    "AGENT: $agentName",
    x: 40,
    y: startY + 60,
    font: img.arial24,
    color: img.ColorRgb8(255, 255, 255),
  );

  // GPS
  img.drawString(
    newImage,
    "GPS: ${lat.toStringAsFixed(6)} , ${lng.toStringAsFixed(6)}",
    x: 40,
    y: startY + 110,
    font: img.arial24,
    color: img.ColorRgb8(255, 255, 255),
  );

  // TIME
  img.drawString(
    newImage,
    "TIME: $timestamp",
    x: 40,
    y: startY + 160,
    font: img.arial24,
    color: img.ColorRgb8(255, 255, 255),
  );

  // MAP SECTION
  if (mapBytes != null) {

    final mapImage = img.decodeImage(mapBytes);

    if (mapImage != null) {

      final resizedMap = img.copyResize(
        mapImage,
        width: 250,
      );

      final mapX = original.width - resizedMap.width - 30;
      final mapY = original.height + 40;

      // draw map
      img.compositeImage(
        newImage,
        resizedMap,
        dstX: mapX,
        dstY: mapY,
      );

      // map border
      img.drawRect(
        newImage,
        x1: mapX - 2,
        y1: mapY - 2,
        x2: mapX + resizedMap.width + 2,
        y2: mapY + resizedMap.height + 2,
        color: img.ColorRgb8(255, 255, 255),
      );
    }
  }

  final newFile = File(
    file.path.replaceAll(".jpg", "_verified.jpg"),
  );

  await newFile.writeAsBytes(img.encodeJpg(newImage));

  return newFile;
}