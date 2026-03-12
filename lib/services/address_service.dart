import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/app_config.dart';

Future<String?> getAddress(double lat, double lng) async {

  final url =
      "https://api.mapbox.com/geocoding/v5/mapbox.places/"
      "$lng,$lat.json"
      "?access_token=${AppConfig.mapboxToken}";

  try {

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      if (data["features"] != null && data["features"].isNotEmpty) {
        return data["features"][0]["place_name"];
      }

    }

  } catch (e) {
    print("Reverse geocoding failed: $e");
  }

  return null;
}