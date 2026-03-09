import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:gallery_saver_plus/gallery_saver.dart';

Future<Directory> getVerificationFolder(String verificationId) async {

  final baseDir = await getExternalStorageDirectory();

  final picturesDir = Directory(
    path.join(baseDir!.parent.parent.parent.parent.path, "Pictures", "VerificationTool", verificationId),
  );

  if (!await picturesDir.exists()) {
    await picturesDir.create(recursive: true);
  }


  return picturesDir;
}

Future<File> saveVerificationPhoto(File image, String verificationId) async {

  final folder = await getVerificationFolder(verificationId);

  final fileName = "photo_${DateTime.now().millisecondsSinceEpoch}.jpg";

  final newPath = path.join(folder.path, fileName);

  final savedFile = await image.copy(newPath);

  // Notify gallery
  await GallerySaver.saveImage(savedFile.path);

  return savedFile;
}