import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../services/app_config.dart';

Future<Uint8List?> downloadMap(double lat, double lng) async {

  final url =
      "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/"
      "pin-s+ff0000($lng,$lat)/"
      "$lng,$lat,17/800x600"
      "?access_token=${AppConfig.mapboxToken}";

  try {

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

  } catch (e) {
    debugPrint("Map download failed: $e");
  }

  return null;
}