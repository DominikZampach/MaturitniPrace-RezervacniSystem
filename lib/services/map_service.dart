import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapService {
  static Future<LatLng?> getGeocode(
    String adress,
    String city,
    String psc,
  ) async {
    final query = Uri.encodeComponent("$adress $city $psc");
    //? Využití API Nominatim pro získání GeoCode adresy
    final Uri url = Uri.parse(
      "https://nominatim.openstreetmap.org/search"
      "?format=json&q=$query&limit=1",
    );

    final response = await http.get(
      url,
      headers: {
        "User-Agent": "FlutterBookMyCut/1.0 (dominik.zampach@seznam.cz)",
        "Accept": "application/json",
      },
    );

    final List data = jsonDecode(response.body);

    if (data.isEmpty) {
      print("Chyba při hledání adresy - adresa nenalezena!");
      return null;
    }

    final double lat = double.parse(data[0]["lat"]);
    final double lon = double.parse(data[0]["lon"]);

    LatLng latLng = LatLng(lat, lon);
    return LatLng(lat, lon);
  }
}
