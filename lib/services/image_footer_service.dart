import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

Future<File> addFooterToImage(
    File file,
    String companyName,
    String agentName,
    String? address,
    double lat,
    double lng,
    Uint8List? mapBytes,
    ) async {

  final bytes = await file.readAsBytes();
  final original = img.decodeImage(bytes);

  if (original == null) {
    throw Exception("Failed to decode image");
  }

  final timestamp =
  DateFormat("dd MMM yyyy  HH:mm").format(DateTime.now());

  const footerHeight = 500;

  final newImage = img.Image(
    width: original.width,
    height: original.height + footerHeight,
  );

  img.compositeImage(newImage, original);

  img.fillRect(
    newImage,
    x1: 0,
    y1: original.height,
    x2: original.width,
    y2: original.height + footerHeight,
    color: img.ColorRgba8(0, 0, 0, 210),
  );

  final startY = original.height + 40;

  final shortAddress = address != null && address.length > 60
      ? address.substring(0, 60)
      : address;

  /// COMPANY
  img.drawString(
    newImage,
    "COMPANY: $companyName",
    x: 40,
    y: startY,
    font: img.arial48,
    color: img.ColorRgb8(255, 255, 255),
  );

  /// AGENT
  img.drawString(
    newImage,
    "AGENT: $agentName",
    x: 40,
    y: startY + 70,
    font: img.arial24,
    color: img.ColorRgb8(255, 255, 255),
  );

  /// ADDRESS
  if (shortAddress != null) {
    img.drawString(
      newImage,
      "ADDRESS: $shortAddress",
      x: 40,
      y: startY + 110,
      font: img.arial24,
      color: img.ColorRgb8(255, 255, 255),
    );
  }

  /// GPS
  img.drawString(
    newImage,
    "LAT: ${lat.toStringAsFixed(6)}",
    x: 40,
    y: startY + 150,
    font: img.arial24,
    color: img.ColorRgb8(255, 255, 255),
  );

  img.drawString(
    newImage,
    "LNG: ${lng.toStringAsFixed(6)}",
    x: 40,
    y: startY + 180,
    font: img.arial24,
    color: img.ColorRgb8(255, 255, 255),
  );

  /// TIME
  img.drawString(
    newImage,
    "TIME: $timestamp",
    x: 40,
    y: startY + 220,
    font: img.arial24,
    color: img.ColorRgb8(255, 255, 255),
  );

  /// separator
  img.drawLine(
    newImage,
    x1: 40,
    y1: startY + 260,
    x2: original.width - 40,
    y2: startY + 260,
    color: img.ColorRgb8(255, 255, 255),
  );

  /// MAP
  if (mapBytes != null) {

    final mapImage = img.decodeImage(mapBytes);

    if (mapImage != null) {

      final mapWidth = original.width ~/ 2;

      final resizedMap = img.copyResize(
        mapImage,
        width: mapWidth,
      );

      final mapX = ((original.width - resizedMap.width) / 2).toInt();
      final mapY = startY + 280;

      img.compositeImage(
        newImage,
        resizedMap,
        dstX: mapX,
        dstY: mapY,
      );

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

  final newFile =
  File(file.path.replaceAll(".jpg", "_verified.jpg"));

  await newFile.writeAsBytes(
    img.encodeJpg(newImage, quality: 90),
  );

  return newFile;
}