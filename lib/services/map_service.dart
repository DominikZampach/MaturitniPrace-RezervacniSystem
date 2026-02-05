import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapService {
  static Future<LatLng?> getGeocodeMapyCZ(String address, String psc) async {
    final String query = "$address, $psc".trim();

    //? Využití API Nominatim pro získání GeoCode adresy
    final String apiKey = dotenv.get('MAPY_API_KEY', fallback: '');
    final uri = Uri.https('api.mapy.cz', '/v1/geocode', {
      'query': query,
      'lang': 'cs',
      'limit': '1',
      'type': 'regional',
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          //"User-Agent": "FlutterBookMyCut/1.0 (dominik.zampach@seznam.cz)",
          "X-Mapy-Api-Key": apiKey,
        },
      );

      print('Url request: $uri');
      print('Mapy.cz Status: ${response.statusCode}');
      print('Mapy.cz Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        //? Mapy.cz vrací seznam výsledků v poli 'items'
        if (data['items'] != null && data['items'].isNotEmpty) {
          final firstResult = data['items'][0]['position'];
          LatLng latLong = LatLng(
            firstResult['lat'].toDouble(),
            firstResult['lon'].toDouble(),
          );
          print(latLong);
          return latLong;
        }
      } else {
        print('Chyba API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Chyba při komunikaci s Mapy.cz: $e');
      return null;
    }
    return null;
  }
}
