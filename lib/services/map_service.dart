
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Future<Uint8List?> downloadMap(double lat, double lng) async {

  const apiKey = "pk.3600b64910dcc10980627f85eafb7852";

  final url =
      "https://maps.locationiq.com/v3/staticmap"
      "?key=$apiKey"
      "&center=$lat,$lng"
      "&zoom=16"
      "&size=1920x1080"
      "&style=osm-bright"
      "&markers=icon:large-red-cutout|$lat,$lng";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

  } catch (e) {
    debugPrint("Map download failed: $e");
  }

  return null;
}